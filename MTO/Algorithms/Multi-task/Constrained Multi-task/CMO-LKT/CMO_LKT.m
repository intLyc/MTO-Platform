classdef CMO_LKT < Algorithm
% <Multi-task> <Single-objective> <Constrained>

%------------------------------- Reference --------------------------------
% @Article{Ban2025CMO-LKT,
%   title   = {A Local Knowledge Transfer-Based Evolutionary Algorithm for Constrained Multitask Optimization},
%   author  = {Ban, Xuanxuan and Liang, Jing and Yu, Kunjie and Wang, Yaonan and Qiao, Kangjia and Peng, Jinzhu and Gong, Dunwei and Dai, Canyun},
%   journal = {IEEE Transactions on Systems, Man, and Cybernetics: Systems},
%   year    = {2025},
%   number  = {3},
%   pages   = {2183-2195},
%   volume  = {55},
%   doi     = {10.1109/TSMC.2024.3520322},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

%%%%在另一任务变好时，完全学习他。随机学习自己是邻域学习，随机学习其他是种群。学习自己最好是邻域Niche最好，其他是随机NIche最好。
%%%%变异策略，是每个小生境找到最差和最好的个体，将最好的随机选择几维替换掉最近的相应的维度，然后与最近的比较
properties (SetAccess = private)
    F = [0.6, 0.8, 1.0]
    CR = [0.1, 0.2, 1.0]
end

methods
    function Parameter = getParameter(obj)
        Parameter = {'F: Mutation Factor', num2str(obj.F), ...
                'CR: Crossover Rate', num2str(obj.CR)};
    end

    function obj = setParameter(obj, Parameter)
        i = 1;
        obj.F = str2double(Parameter{i}); i = i + 1;
        obj.CR = str2double(Parameter{i}); i = i + 1;
    end

    function run(obj, Prob)
        m1 = 0; m2 = 0;
        % Initialization
        population = Initialization(obj, Prob, Individual);
        con1 = [population{1}.CV];
        con2 = [population{2}.CV];
        % con = [con1,con2];
        epsilon1 = max(con1);
        epsilon2 = max(con2);
        epsilon0 = [epsilon1 epsilon2];
        % epsilon0 = [0 0];
        %% 划分小生境
        population1 = population{1};
        population2 = population{2};

        NC = 5;
        NS = Prob.N / NC;

        for i = 1:NC
            xianxing = randperm(length(population1), 1);
            Dec1 = reshape([population1.Dec], Prob.D(1), Prob.N - NS * (i - 1))';
            Distance = pdist2([population1(xianxing).Dec], Dec1);
            [~, Dis_index] = sort(Distance);
            Niche1(i, :) = population1(Dis_index(1:NS));
            population1(Dis_index(1:NS)) = [];
            xinxing12_obj(obj.Gen, i) = obj.Evaluation(Niche1(i, 1), Prob, 2); % %先行个体固定不变
        end
        % population{1} = Niche1;

        for i = 1:NC
            xianxing = randperm(length(population2), 1);
            Dec2 = reshape([population2.Dec], Prob.D(2), Prob.N - NS * (i - 1))';
            Distance = pdist2([population2(xianxing).Dec], Dec2);
            [~, Dis_index] = sort(Distance);
            Niche2(i, :) = population2(Dis_index(1:NS));
            population2(Dis_index(1:NS)) = [];
            xinxing21_obj(obj.Gen, i) = obj.Evaluation(Niche2(i, 1), Prob, 1); % %先行个体固定不变
        end

        %% 找到每个小生境中最好的个体，并在另外一个任务上进行评价
        for j = 1:NC
            if isempty(find([Niche1(j, :).CV] <= epsilon1))
                [~, min_Niche11_index] = min([Niche1(j, :).CV]);
            else
                index = find([Niche1(j, :).CV] <= epsilon1);
                [~, r] = min([Niche1(j, index).Obj]);
                min_Niche11_index = index(r);
            end
            min_Niche12_Obj(obj.Gen, j) = obj.Evaluation(Niche1(j, min_Niche11_index), Prob, 2);
            min_Niche1_index(obj.Gen, j) = min_Niche11_index;

            if isempty(find([Niche2(j, :).CV] <= epsilon2))
                [~, min_Niche22_index] = min([Niche2(j, :).CV]);
            else
                index = find([Niche2(j, :).CV] <= epsilon2);
                [~, r] = min([Niche2(j, index).Obj]);
                min_Niche22_index = index(r);
            end
            min_Niche21_Obj(obj.Gen, j) = obj.Evaluation(Niche2(j, min_Niche22_index), Prob, 1);
            min_Niche2_index(obj.Gen, j) = min_Niche22_index;
        end

        %% 划分小生境，然后最好的那个个体是否在另一个任务上更好，则这个小生境可以向另一个任务学习
        %
        while obj.notTerminated(Prob)

            cp = (-log(epsilon0) - 6) / log(1 - 0.5);
            if obj.FE < 1/2 * Prob.maxFE
                epsilon = epsilon0 .* (1 - obj.FE / Prob.maxFE).^cp;
            else
                epsilon = [0 0];
            end
            %% 评价这一代
            for j = 1:NC
                if isempty(find([Niche1(j, :).CV] <= epsilon1))
                    [~, min_Niche11_index] = min([Niche1(j, :).CV]);
                else
                    index = find([Niche1(j, :).CV] <= epsilon1);
                    [~, r] = min([Niche1(j, index).Obj]);
                    min_Niche11_index = index(r);
                end
                min_Niche1_index(obj.Gen, j) = min_Niche11_index;
                best_N1(obj.Gen, j) = Niche1(j, min_Niche11_index);
                xinxing12_obj(obj.Gen, j) = obj.Evaluation(Niche1(j, 1), Prob, 2); % %先行个体固定不变

                if isempty(find([Niche2(j, :).CV] <= epsilon2))
                    [~, min_Niche22_index] = min([Niche2(j, :).CV]);
                else
                    index = find([Niche2(j, :).CV] <= epsilon2);
                    [~, r] = min([Niche2(j, index).Obj]);
                    min_Niche22_index = index(r);
                end

                min_Niche2_index(obj.Gen, j) = min_Niche22_index;
                best_N2(obj.Gen, j) = Niche2(j, min_Niche22_index);
                xinxing21_obj(obj.Gen, j) = obj.Evaluation(Niche2(j, 1), Prob, 1); % %先行个体固定不变
            end
            % xinxing12_obj = min_Niche12_Obj;
            % xinxing21_obj = min_Niche21_Obj;
            %% 判断是否变好
            % alpha1(obj.Gen,:) = Em_bijiao12_jin(obj, min_Niche12_Obj, epsilon(2));%%比较的是lbest
            alpha1(obj.Gen, :) = Em_bijiao12_tasks_all_best(obj, xinxing12_obj, epsilon(2)); % %比较的是固定的先行个体
            alpha2(obj.Gen, :) = Em_bijiao21_tasks_all_best(obj, xinxing21_obj, epsilon(1));
            % save('alpha1','alpha1')
            % Generation
            offspring1 = Generation1_tasks_all_best(obj, Niche1, Niche2, best_N1(obj.Gen, :), best_N2(obj.Gen, :), population{1}, population{2}, epsilon(1), epsilon(2), alpha2(obj.Gen, :));
            % Evaluation
            offspring1 = obj.Evaluation(offspring1, Prob, 1);

            % Generation
            offspring2 = Generation2_tasks_all_best(obj, Niche1, Niche2, best_N1(obj.Gen, :), best_N2(obj.Gen, :), population{2}, population{1}, epsilon(2), epsilon(1), alpha1(obj.Gen, :));
            % Evaluation
            offspring2 = obj.Evaluation(offspring2, Prob, 2);

            % Selection
            population{1} = reshape(Niche1', 1, Prob.N);
            for i = 1:length(population{1})
                if offspring1(i).CV < epsilon(1) && population{1}(i).CV < epsilon(1)
                    if offspring1(i).Obj < population{1}(i).Obj
                        population{1}(i) = offspring1(i);
                    end

                elseif offspring1(i).CV == population{1}(i).CV
                    if offspring1(i).Obj < population{1}(i).Obj
                        population{1}(i) = offspring1(i);
                    end

                elseif offspring1(i).CV < population{1}(i).CV
                    population{1}(i) = offspring1(i);
                end

            end

            population{2} = reshape(Niche2', 1, Prob.N);
            for i = 1:length(population{2})
                if offspring2(i).CV < epsilon(2) && population{2}(i).CV < epsilon(2)
                    if offspring2(i).Obj < population{2}(i).Obj
                        population{2}(i) = offspring2(i);
                    end

                elseif offspring2(i).CV == population{2}(i).CV
                    if offspring2(i).Obj < population{2}(i).Obj
                        population{2}(i) = offspring2(i);
                    end

                elseif offspring2(i).CV < population{2}(i).CV
                    population{2}(i) = offspring2(i);
                end

            end

            Niche1 = reshape(population{1}, NS, NC)';
            Niche2 = reshape(population{2}, NS, NC)';

            [mm1, Niche1] = mutation1_tasks_all_best(Prob, obj, Niche1, epsilon(1));
            [mm2, Niche1] = mutation2_tasks_all_best(Prob, obj, Niche1, epsilon(2));

            m1 = mm1 + m1; m2 = mm2 + m2;

            population{1} = reshape(Niche1', 1, Prob.N);
            population{2} = reshape(Niche2', 1, Prob.N);

        end
    end
end
end
