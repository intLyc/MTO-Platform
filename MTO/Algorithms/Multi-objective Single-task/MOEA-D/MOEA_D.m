classdef MOEA_D < Algorithm
    % <Single-task> <Multi-objective> <None>

    % The code implementation is referenced from PlatEMO(https://github.com/BIMK/PlatEMO).

    %------------------------------- Reference --------------------------------
    % @article{Zhang2007MOEAD,
    %   title      = {MOEA/D: A Multiobjective Evolutionary Algorithm Based on Decomposition},
    %   author     = {Zhang, Qingfu and Li, Hui},
    %   journal    = {IEEE Transactions on Evolutionary Computation},
    %   number     = {6},
    %   pages      = {712-731},
    %   volume     = {11},
    %   year       = {2007}
    %   doi        = {10.1109/TEVC.2007.892759},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        Type = 1
        MuC = 20
        MuM = 15
    end

    methods
        function Parameter = getParameter(Algo)
            Parameter = {'Decomposition Type', num2str(Algo.Type), ...
                        'MuC: Simulated Binary Crossover', num2str(Algo.MuC), ...
                        'MuM: Polynomial Mutation', num2str(Algo.MuM)};
        end

        function setParameter(Algo, Parameter)
            i = 1;
            Algo.Type = str2double(Parameter{i}); i = i + 1;
            Algo.MuC = str2double(Parameter{i}); i = i + 1;
            Algo.MuM = str2double(Parameter{i}); i = i + 1;
        end

        function run(Algo, Prob)
            for t = 1:Prob.T
                % Generate the weight vectors
                [W{t}, N{t}] = UniformPoint(Prob.N, Prob.M(t));
                DT{t} = ceil(N{t} / 10);

                % Detect the neighbours of each solution
                B{t} = pdist2(W{t}, W{t});
                [~, B{t}] = sort(B{t}, 2);
                B{t} = B{t}(:, 1:DT{t});
            end

            % Initialize
            population = Initialization(Algo, Prob, Individual);
            for t = 1:Prob.T
                Z{t} = min(population{t}.Objs, [], 1);
            end

            while Algo.notTerminated(Prob, population)
                % Generation
                for t = 1:Prob.T
                    for i = 1:N{t}
                        % Choose the parents
                        P = B{t}(i, randperm(size(B{t}, 2)));
                        % Generate an offspring
                        offspring = Algo.Generation(population{t}(P(1:2)));
                        offspring = Algo.Evaluation(offspring, Prob, t);
                        % Update the ideal point
                        Z{t} = min(Z{t}, offspring.Obj);

                        % Update the neighbours
                        switch Algo.Type
                            case 1
                                % PBI approach
                                normW = sqrt(sum(W{t}(P, :).^2, 2));
                                normP = sqrt(sum((population{t}(P).Objs - repmat(Z{t}, DT{t}, 1)).^2, 2));
                                normO = sqrt(sum((offspring.Obj - Z{t}).^2, 2));
                                CosineP = sum((population{t}(P).Objs - repmat(Z{t}, DT{t}, 1)) .* W{t}(P, :), 2) ./ normW ./ normP;
                                CosineO = sum(repmat(offspring.Obj - Z{t}, DT{t}, 1) .* W{t}(P, :), 2) ./ normW ./ normO;
                                g_old = normP .* CosineP + 5 * normP .* sqrt(1 - CosineP.^2);
                                g_new = normO .* CosineO + 5 * normO .* sqrt(1 - CosineO.^2);
                            case 2
                                % Tchebycheff approach
                                g_old = max(abs(population{t}(P).Objs - repmat(Z{t}, DT{t}, 1)) .* W{t}(P, :), [], 2);
                                g_new = max(repmat(abs(offspring.Obj - Z{t}), DT{t}, 1) .* W{t}(P, :), [], 2);
                            case 3
                                % Tchebycheff approach with normalization
                                Zmax = max(population{t}.Objs, [], 1);
                                g_old = max(abs(population{t}(P).Objs - repmat(Z{t}, DT{t}, 1)) ./ repmat(Zmax - Z{t}, DT{t}, 1) .* W{t}(P, :), [], 2);
                                g_new = max(repmat(abs(offspring.Obj - Z{t}) ./ (Zmax - Z{t}), DT{t}, 1) .* W{t}(P, :), [], 2);
                            case 4
                                % Modified Tchebycheff approach
                                g_old = max(abs(population{t}(P).Objs - repmat(Z{t}, DT{t}, 1)) ./ W{t}(P, :), [], 2);
                                g_new = max(repmat(abs(offspring.Obj - Z{t}), DT{t}, 1) ./ W{t}(P, :), [], 2);
                        end
                        population{t}(P(g_old >= g_new)) = offspring;
                    end
                end
            end
        end

        function offspring = Generation(Algo, population)
            for i = 1:ceil(length(population) / 2)
                p1 = i; p2 = i + fix(length(population) / 2);
                offspring(i) = population(p1);
                offspring(i).Dec = GA_Crossover(population(p1).Dec, population(p2).Dec, Algo.MuC);
                offspring(i).Dec = GA_Mutation(offspring(i).Dec, Algo.MuM);
                offspring(i).Dec(offspring(i).Dec > 1) = 1;
                offspring(i).Dec(offspring(i).Dec < 0) = 0;
            end
        end
    end
end
