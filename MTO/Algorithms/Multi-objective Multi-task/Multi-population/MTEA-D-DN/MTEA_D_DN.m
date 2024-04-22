classdef MTEA_D_DN < Algorithm
% <Multi-task> <Multi-objective> <None>

%------------------------------- Reference --------------------------------
% @Article{Wang2023MTEA-D-DN,
%   title    = {Multiobjective Multitask Optimization - Neighborhood as a Bridge for Knowledge Transfer},
%   author   = {Wang, Xianpeng and Dong, Zhiming and Tang, Lixin and Zhang, Qingfu},
%   journal  = {IEEE Transactions on Evolutionary Computation},
%   year     = {2023},
%   number   = {1},
%   pages    = {155-169},
%   volume   = {27},
%   doi      = {10.1109/TEVC.2022.3154416},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties (SetAccess = private)
    Beta = 0.2
    F = 0.5
    CR = 0.9
    MuM = 20
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'Beta: Probability of choosing parents locally', num2str(Algo.Beta), ...
                'F:Mutation Factor', num2str(Algo.F), ...
                'CR: Crossover Rate', num2str(Algo.CR), ...
                'MuM: Polynomial Mutation', num2str(Algo.MuM)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.Beta = str2double(Parameter{i}); i = i + 1;
        Algo.F = str2double(Parameter{i}); i = i + 1;
        Algo.CR = str2double(Parameter{i}); i = i + 1;
        Algo.MuM = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialize
        for t = 1:Prob.T
            % Generate the weight vectors
            [W{t}, N{t}] = UniformPoint(Prob.N, Prob.M(t));
            DT{t} = ceil(N{t} / 20);

            % Detect the neighbours of each solution
            B{t} = pdist2(W{t}, W{t});
            [~, B{t}] = sort(B{t}, 2);
            B{t} = B{t}(:, 1:DT{t});
            population{t} = Initialization_One(Algo, Prob, t, Individual, N{t});

            Z{t} = min(population{t}.Objs, [], 1);
        end
        for t = 1:Prob.T
            % Detect the second neighbours of each solution
            tar_pool = 1:Prob.T; tar_pool(t) = [];
            for i = 1:size(B{t}, 1)
                B2k{t}(i) = tar_pool(randi(Prob.T - 1));
                B2{t, i} = randperm(size(W{B2k{t}(i)}, 1), DT{t});
            end
        end

        while Algo.notTerminated(Prob, population)
            % Generation
            for t = 1:Prob.T
                for i = 1:N{t}
                    % Choose the parents
                    if rand() < Algo.Beta
                        P1 = B{t}(i, :);
                        P2 = B2{t, i};
                        tasks = [t * ones(1, length(P1)), B2k{t}(i) * ones(1, length(P2))];
                        P = [P1, P2];
                        rndpm = randperm(length(tasks));
                        tasks = tasks(rndpm);
                        P = P(rndpm);

                        % Generate an offspring
                        parent = [population{t}(i), population{tasks(1)}(P(1)), population{tasks(2)}(P(2))];
                        offspring = Algo.Generation(parent);

                        if rand() < 0.5
                            % Knowledge transfer
                            k = B2k{t}(i);
                            offspring = Algo.Evaluation(offspring, Prob, k);
                            Z{k} = min(Z{k}, offspring.Obj);
                            g_old = max(abs(population{k}(P2).Objs - repmat(Z{k}, length(P2), 1)) .* W{k}(P2, :), [], 2);
                            g_new = max(repmat(abs(offspring.Obj - Z{k}), length(P2), 1) .* W{k}(P2, :), [], 2);
                            population{k}(P2(g_old >= g_new)) = offspring;

                            if all(g_old < g_new)
                                tar_pool = 1:Prob.T; tar_pool(t) = [];
                                B2k{t}(i) = tar_pool(randi(Prob.T - 1));
                                B2{t, i} = randperm(size(W{B2k{t}(i)}, 1), DT{t});
                            elseif any (g_old >= g_new)
                                B2{t, i} = B2{t, i}(g_old >= g_new);
                            end
                        else
                            offspring = Algo.Evaluation(offspring, Prob, t);
                            Z{t} = min(Z{t}, offspring.Obj);
                            g_old = max(abs(population{t}(P1).Objs - repmat(Z{t}, length(P1), 1)) .* W{t}(P1, :), [], 2);
                            g_new = max(repmat(abs(offspring.Obj - Z{t}), length(P1), 1) .* W{t}(P1, :), [], 2);
                            population{t}(P1(g_old >= g_new)) = offspring;
                        end
                    else
                        P = randperm(N{t});
                        offspring = Algo.Generation(population{t}([i, P(1:2)]));
                        offspring = Algo.Evaluation(offspring, Prob, t);
                        Z{t} = min(Z{t}, offspring.Obj);
                        g_old = max(abs(population{t}(P).Objs - repmat(Z{t}, length(P), 1)) .* W{t}(P, :), [], 2);
                        g_new = max(repmat(abs(offspring.Obj - Z{t}), length(P), 1) .* W{t}(P, :), [], 2);
                        population{t}(P(g_old >= g_new)) = offspring;
                    end
                end
            end

            if Algo.FE >= Prob.maxFE
                for t = 1:Prob.T
                    if N{t} < Prob.N % Fill population
                        population{t}(N{t} + 1:Prob.N) = population{t}(1:Prob.N - N{t});
                    end
                end
            end
        end
    end

    function offspring = Generation(Algo, population)
        offspring = population(1);

        offspring.Dec = population(1).Dec + Algo.F * (population(2).Dec - population(3).Dec);
        offspring.Dec = DE_Crossover(offspring.Dec, population(1).Dec, Algo.CR);
        offspring.Dec = GA_Mutation(offspring.Dec, Algo.MuM);

        offspring.Dec(offspring.Dec > 1) = 1;
        offspring.Dec(offspring.Dec < 0) = 0;
    end
end
end
