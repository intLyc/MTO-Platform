classdef EMaTO_MKT < Algorithm
    % <MaT-SO> <None>

    %------------------------------- Reference --------------------------------
    % @Article{Liang2021EMaTO-MKT,
    %   title    = {Evolutionary Many-task Optimization Based on Multi-source Knowledge Transfer},
    %   author   = {Liang, Zhengping and Xu, Xiuju and Liu, Ling and Tu, Yaofeng and Zhu, Zexuan},
    %   journal  = {IEEE Transactions on Evolutionary Computation},
    %   year     = {2021},
    %   pages    = {1-1},
    %   doi      = {10.1109/TEVC.2021.3101697},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        MuC = 2
        MuM = 5
        AMP0 = 0.9
        Sigma = 1
        K = 10
        KTN = 5
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'MuC: Simulated Binary Crossover', num2str(obj.MuC), ...
                        'MuM: Polynomial Mutation', num2str(obj.MuM), ...
                        'AMP0: Initial AMP', num2str(obj.AMP0), ...
                        'Sigma', num2str(obj.Sigma), ...
                        'K: Cluster Num', num2str(obj.K), ...
                        'KTN: Knowledge Transfer Tasks Num', num2str(obj.KTN)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.MuC = str2double(Parameter{i}); i = i + 1;
            obj.MuM = str2double(Parameter{i}); i = i + 1;
            obj.AMP0 = str2double(Parameter{i}); i = i + 1;
            obj.Sigma = str2double(Parameter{i}); i = i + 1;
            obj.K = str2double(Parameter{i}); i = i + 1;
            obj.KTN = str2double(Parameter{i}); i = i + 1;
        end

        function run(obj, Prob)
            % Initialization
            population = Initialization(obj, Prob, Individual_MKT);

            while obj.notTerminated(Prob)
                % AMP
                if obj.Gen < 4
                    AMP(1:Prob.T) = obj.AMP0;
                else
                    x1 = [obj.Result(:, obj.Gen - 1).Obj];
                    x2 = [obj.Result(:, obj.Gen - 2).Obj];
                    x3 = [obj.Result(:, obj.Gen - 3).Obj];
                    temp1 = x2 - x1;
                    temp2 = x3 - x2;
                    AMP = temp1 ./ (temp1 + temp2);
                    AMP(isnan(AMP)) = obj.AMP0;
                end

                % Calculate MMD
                difference = inf .* ones(Prob.T);
                for t = 1:Prob.T - 1
                    dec_t = reshape([population{t}.Dec], length(population{t}(1).Dec), length(population{t}));
                    for k = t + 1:Prob.T
                        dec_k = reshape([population{k}.Dec], length(population{k}(1).Dec), length(population{k}));
                        difference(t, k) = obj.mmd(dec_t, dec_k, obj.Sigma);
                        difference(k, t) = difference(t, k);
                    end
                end

                % Clustering in LEKT
                [cluster_model, population] = obj.LEKT(population, Prob.T, difference);

                % Generation
                offspring = obj.Generation(population, AMP, cluster_model);

                for t = 1:Prob.T
                    % Evaluation
                    offspring{t} = obj.Evaluation(offspring{t}, Prob, t);
                    population{t} = [population{t}, offspring{t}];
                    [~, rank] = sort([population{t}.Obj]);
                    population{t} = population{t}(rank(1:Prob.N));
                end
            end
        end

        function offspring = Generation(obj, population, AMP, cluster_model)
            for t = 1:length(population)
                indorder = randperm(length(population{t}));
                count = 1;
                for i = 1:ceil(length(population{t}) / 2)
                    p1 = indorder(i);
                    p2 = indorder(i + fix(length(population{t}) / 2));
                    offspring{t}(count) = population{t}(p1);
                    offspring{t}(count + 1) = population{t}(p2);

                    if rand() < AMP(t)
                        [offspring{t}(count).Dec, offspring{t}(count + 1).Dec] = GA_Crossover(population{t}(p1).Dec, population{t}(p2).Dec, obj.MuC);
                        offspring{t}(count).Dec = GA_Mutation(offspring{t}(count).Dec, obj.MuM);
                        offspring{t}(count + 1).Dec = GA_Mutation(offspring{t}(count + 1).Dec, obj.MuM);
                    else
                        % Knowledge Tansfer
                        current_mean = cluster_model(t).Nich_mean(population{t}(p1).ClusterNum, :);
                        current_std = cluster_model(t).Nich_std(population{t}(p1).ClusterNum, :);
                        offspring{t}(count).Dec = normrnd(current_mean, current_std);
                        offspring{t}(count + 1).Dec = normrnd(current_mean, current_std);
                    end

                    for x = count:count + 1
                        offspring{t}(x).Dec(offspring{t}(x).Dec > 1) = 1;
                        offspring{t}(x).Dec(offspring{t}(x).Dec < 0) = 0;
                    end
                    count = count + 2;
                end
            end
        end

        function [clusterModel, population] = LEKT(obj, population, task_num, difference)
            clusterModel = struct;
            K = obj.K; %cluster numbers
            knowledge_task_num = obj.KTN; %number of tasks involved in knowledge transfer
            TempPopulation = population;
            dim = length(TempPopulation{1}(1).Dec);
            for i = 1:task_num
                clusterModel(i).Nich_mean = zeros(K, dim);
                clusterModel(i).Nich_std = zeros(K, dim);
                Subpop = TempPopulation{i};
                SubpopRnvec = reshape([Subpop.Dec], length(Subpop(1).Dec), length(Subpop))';
                temp_difference = difference(i, :);
                [~, index] = sort(temp_difference);
                %--------------Generate clusters by k-means--------------------------
                for j = 1:knowledge_task_num
                    Selected_population = population{index(j)};
                    Selected_matrix = reshape([Selected_population.Dec], length(Selected_population(1).Dec), length(Selected_population))';
                    SubpopRnvec = [SubpopRnvec; Selected_matrix];
                end
                [idx, ~] = kmeans(SubpopRnvec, K, 'Distance', 'cityblock', 'MaxIter', 30);
                for ii = 1:length(Subpop)
                    Subpop(ii).ClusterNum = idx(ii);
                end
                population{i} = Subpop;
                %Generate mean and std for each cluster
                for k = 1:K
                    k_th_clu = SubpopRnvec(find(idx == k), :);
                    k_th_clu_Mean = mean(k_th_clu);
                    k_th_clu_Std = std(k_th_clu);
                    clusterModel(i).Nich_mean(k, :) = k_th_clu_Mean;
                    clusterModel(i).Nich_std(k, :) = k_th_clu_Std;
                end
            end
        end

        function mmd_XY = mmd(obj, X, Y, Sigma)
            % Author：kailugaji
            % Maximum Mean Discrepancy 最大均值差异 越小说明X与Y越相似
            % X与Y数据维度必须一致, X, Y为无标签数据，源域数据，目标域数据
            % mmd_XY=mmd(X, Y, 4)
            % Sigma is kernel size, 高斯核的sigma
            [N_X, ~] = size(X);
            [N_Y, ~] = size(Y);
            K = obj.rbf_dot(X, X, Sigma); %N_X*N_X
            L = obj.rbf_dot(Y, Y, Sigma); %N_Y*N_Y
            KL = obj.rbf_dot(X, Y, Sigma); %N_X*N_Y
            c_K = 1 / (N_X^2);
            c_L = 1 / (N_Y^2);
            c_KL = 2 / (N_X * N_Y);
            mmd_XY = sum(sum(c_K .* K)) + sum(sum(c_L .* L)) - sum(sum(c_KL .* KL));
            mmd_XY = sqrt(mmd_XY);
        end

        function H = rbf_dot(obj, X, Y, deg)
            % Author：kailugaji
            % 高斯核函数/径向基函数 K(x, y)=exp(-d^2/Sigma), d=(x-y)^2, 假设X与Y维度一样
            % Deg is kernel size,高斯核的sigma
            [N_X, ~] = size(X);
            [N_Y, ~] = size(Y);
            G = sum((X .* X), 2);
            H = sum((Y .* Y), 2);
            Q = repmat(G, 1, N_Y(1));
            R = repmat(H', N_X(1), 1);
            H = Q + R - 2 * X * Y';
            H = exp(-H / 2 / deg^2); %N_X*N_Y
        end
    end
end
