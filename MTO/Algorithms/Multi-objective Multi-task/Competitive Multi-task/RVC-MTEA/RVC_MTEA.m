classdef RVC_MTEA < Algorithm
% <Multi-task> <Multi-objective> <Competitive/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Li2025CMO-MTO,
%   title    = {Evolutionary Competitive Multiobjective Multitasking: One-Pass Optimization of Heterogeneous Pareto Solutions},
%   author   = {Li, Yanchi and Wu, Xinyi and Gong, Wenyin and Xu, Meng and Wang, Yubo and Gu, Qiong},
%   journal  = {IEEE Transactions on Evolutionary Computation},
%   year     = {2024},
%   doi      = {10.1109/TEVC.2024.3524508},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and P. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties (SetAccess = private)
    TR = 0.3
    UR = 0.2
    Type = 1
    Delta = 0.9
    NR = 2
    MuC = 20
    MuM = 15
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'TR: Transfer rate', num2str(Algo.TR), ...
                'UR: Update rate', num2str(Algo.UR), ...
                '1: Tchebycheff. 2: Normalized Tchebycheff', num2str(Algo.Type), ...
                'Delta: Probability of choosing parents locally', num2str(Algo.Delta), ...
                'NR: Maximum number of solutions replaced by each offspring', num2str(Algo.NR), ...
                'MuC: Simulated Binary Crossover', num2str(Algo.MuC), ...
                'MuM: Polynomial Mutation', num2str(Algo.MuM)};
    end

    function Algo = setParameter(Algo, Parameter)
        Algo.TR = str2double(Parameter{1});
        Algo.UR = str2double(Parameter{2});
        Algo.Type = str2double(Parameter{3});
        Algo.Delta = str2double(Parameter{4});
        Algo.NR = str2double(Parameter{5});
        Algo.MuC = str2double(Parameter{6});
        Algo.MuM = str2double(Parameter{7});
    end

    function run(Algo, Prob)
        % Generate the weight vectors
        W = UniformPoint(Prob.N, max(Prob.M));
        N = size(W, 1);
        DT = ceil(N / 10);

        % Detect the neighbours of each solution
        B = pdist2(W, W);
        [~, B] = sort(B, 2);
        B = B(:, 1:DT);

        % Initialization
        Zall = Inf * ones(1, max(Prob.M));
        population = Initialization(Algo, Prob, Individual_RVC, N);
        archive = population;
        for t = 1:Prob.T
            Z{t} = min(population{t}.Objs, [], 1);
            Zall = min(Zall, Z{t});
            for i = 1:N
                population{t}(i).SD = -0.05 + 0.1 * rand(1, max(Prob.D));
            end
        end
        Contributed = true(Prob.T, N); % contributed to global

        while Algo.notTerminated(Prob, archive)
            % Calculate contribution
            allPop = [population{:}];
            FrontNo = NDSort(allPop.Objs, inf);
            Next = FrontNo <= median(FrontNo);
            for t = 1:Prob.T
                Contributed(t, :) = Next(N * (t - 1) + 1:N * t);
            end

            % Generation
            old_pop = population;
            for t = 1:Prob.T
                rand_idx = randi(N);
                for i = 1:N
                    % Choose the parents
                    if rand() < Algo.Delta
                        P = B(i, randperm(size(B, 2)));
                    else
                        P = randperm(N);
                    end
                    offspring = Algo.Generation(population{t}(P(1:2)));
                    if rand_idx == i
                        source_task = randi(Prob.T); while source_task == t; source_task = randi(Prob.T); end
                        offspring = Algo.Generation([population{t}(P(1)), population{source_task}(randi(N))]);
                    end

                    if Contributed(t, i)
                        k = randi(Prob.T); j = randi(N);
                    else
                        k = t; j = P(randi(end));
                    end

                    % Knowledge transfer
                    if rand() < Algo.TR
                        if Prob.D(t) < Prob.D(k)
                            search_dir = population{k}(j).SD(1:Prob.D(t)) ./ ...
                                norm(population{k}(j).SD(1:Prob.D(t))) .* norm(population{t}(i).SD(1:Prob.D(t)));
                            search_dir(Prob.D(t) + 1:max(Prob.D)) = zeros(1, max(Prob.D) - Prob.D(t));
                        elseif Prob.D(t) > Prob.D(k)
                            search_dir = population{k}(j).SD(1:Prob.D(k));
                            search_dir(Prob.D(k) + 1:Prob.D(t)) = population{t}(i).SD(Prob.D(k) + 1:Prob.D(t));
                            search_dir = search_dir ./ norm(search_dir) .* norm(population{t}(i).SD);
                            search_dir(Prob.D(t) + 1:max(Prob.D)) = zeros(1, max(Prob.D) - Prob.D(t));
                        else
                            search_dir = population{k}(j).SD ./ norm(population{k}(j).SD) .* norm(population{t}(i).SD);
                        end
                        offspring.Dec = offspring.Dec + 2 * rand() * search_dir;
                        offspring.Dec = max(0, min(1, offspring.Dec));
                    end
                    offspring = Algo.Evaluation(offspring, Prob, t);
                    % Update the ideal point
                    Z{t} = min(Z{t}, offspring.Obj);

                    % Update the neighbours
                    switch Algo.Type
                        case 1
                            % Tchebycheff approach
                            g_old = max(abs(population{t}(P).Objs - repmat(Z{t}, length(P), 1)) .* W(P, :), [], 2);
                            g_new = max(repmat(abs(offspring.Obj - Z{t}), length(P), 1) .* W(P, :), [], 2);
                        case 2
                            % Tchebycheff approach with normalization
                            Zmax = max(population{t}.Objs, [], 1);
                            g_old = max(abs(population{t}(P).Objs - repmat(Z{t}, length(P), 1)) ./ repmat(Zmax - Z{t}, length(P), 1) .* W(P, :), [], 2);
                            g_new = max(repmat(abs(offspring.Obj - Z{t}) ./ (Zmax - Z{t}), length(P), 1) .* W(P, :), [], 2);
                    end
                    CVO = offspring.CV;
                    CVP = population{t}(P).CVs;
                    population{t}(P(find(g_old >= g_new & CVP == CVO | CVP > CVO, Algo.NR))) = offspring;
                    archive{t} = [archive{t}, offspring];
                end
            end

            % Update success search direction
            for t = 1:Prob.T
                for i = 1:N
                    variation = population{t}(i).Dec - old_pop{t}(i).Dec;
                    if ~all(variation == 0)
                        population{t}(i).SD = (1 - Algo.UR) * population{t}(i).SD + ...
                            Algo.UR * variation;
                    end
                end
            end

            % Update archive using non-dominated sorting and truncation
            allArc = [archive{:}];
            tempN = length(allArc) / Prob.T;
            FrontNo = NDSort(allArc.Objs, allArc.CVs, inf);
            for t = 1:Prob.T
                FrontNo_t = FrontNo((t - 1) * tempN + (1:tempN));
                next = FrontNo_t == 1;
                if sum(next) < Prob.N
                    [~, rank] = sort(FrontNo_t);
                    next(rank(1:Prob.N)) = true;
                elseif sum(next) > Prob.N
                    del = Algo.Truncation(archive{t}(next).Objs, sum(next) - Prob.N);
                    temp = find(next);
                    next(temp(del)) = false;
                end
                archive{t} = archive{t}(next);
            end
        end
    end

    function offspring = Generation(Algo, population)
        offspring = population(1);
        offspring.Dec = GA_Crossover(population(1).Dec, population(2).Dec, Algo.MuC);
        offspring.Dec = GA_Mutation(offspring.Dec, Algo.MuM);
        offspring.Dec = max(0, min(1, offspring.Dec));
    end

    function Del = Truncation(Algo, PopObj, K)
        % Select part of the solutions by truncation
        Distance = pdist2(PopObj, PopObj);
        Distance(logical(eye(length(Distance)))) = inf;
        Del = false(1, size(PopObj, 1));
        while sum(Del) < K
            Remain = find(~Del);
            Temp = sort(Distance(Remain, Remain), 2);
            [~, Rank] = sortrows(Temp);
            Del(Remain(Rank(1))) = true;
        end
    end
end
end
