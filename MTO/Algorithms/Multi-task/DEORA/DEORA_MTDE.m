classdef DEORA_MTDE < Algorithm
    % <MT-SO> <Competitive>

    %------------------------------- Reference --------------------------------
    % @Article{Li2022CompetitiveMTO,
    %   title      = {Evolutionary Competitive Multitasking Optimization},
    %   author     = {Li, Genghui and Zhang, Qingfu and Wang, Zhenkun},
    %   journal    = {IEEE Transactions on Evolutionary Computation},
    %   year       = {2022},
    %   pages      = {1-1},
    %   doi        = {10.1109/TEVC.2022.3141819},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        F = 0.5
        CR = 0.9
        Alpha = 0.5
        RMP0 = 0.3
    end

    methods
        function Parameter = getParameter(Algo)
            Parameter = {'F: Mutation Factor', num2str(Algo.F), ...
                        'CR: Crossover Probability', num2str(Algo.CR), ...
                        'Alpha', num2str(Algo.Alpha), ...
                        'RMP0: Initial random mating probability', num2str(Algo.RMP0)};
        end

        function Algo = setParameter(Algo, Parameter)
            i = 1;
            Algo.F = str2double(Parameter{i}); i = i + 1;
            Algo.CR = str2double(Parameter{i}); i = i + 1;
            Algo.Alpha = str2double(Parameter{i}); i = i + 1;
            Algo.RMP0 = str2double(Parameter{i}); i = i + 1;
        end

        function run(Algo, Prob)
            % Initialization
            population = Initialization(Algo, Prob, Individual);
            maxGen = (Prob.maxFE - Prob.N * Prob.T) / Prob.N + 1;
            delta_rmp = 1 / maxGen;
            RMP = Algo.RMP0 * ones(Prob.T, Prob.T) / (Prob.T - 1);
            RMP(logical(eye(size(RMP)))) = (1 - Algo.RMP0);

            while Algo.notTerminated(Prob)
                for k = Prob.T
                    [offspring, r1_task] = Algo.Generation(population, RMP, k);
                    % Evaluation
                    offspring = Algo.Evaluation(offspring, Prob, k);

                    fit_old = [population{k}.Obj];
                    replace = [population{k}.Obj] > [offspring.Obj];
                    population{k}(replace) = offspring(replace);
                    fit_new = [population{k}.Obj];

                    % calculate the reward
                    R_p = max((fit_old - fit_new) ./ (fit_old), 0);
                    best_g = [Algo.Best{:}];
                    R_b = max((min([best_g.Obj]) - min(fit_new)) / min([best_g.Obj]), 0);
                    R = zeros(Prob.T, 1);
                    for t = 1:Prob.T
                        if t == k %The main task
                            R(t) = Algo.Alpha * R_b + (1 - Algo.Alpha) * (sum(R_p) / length(R_p));
                        else % The auxiliary task
                            index = find(r1_task == t);
                            if isempty(index)
                                R(t) = 0;
                            else
                                [~, minid] = min(fit_new);
                                R(t) = Algo.Alpha * (r1_task(minid) == t) * R_b + (1 - Algo.Alpha) * (sum(R_p(index)) / length(index));
                            end
                        end
                    end

                    % update RMP
                    for t = 1:Prob.T
                        if t == k
                            continue;
                        end
                        if R(t) >= R(k)
                            RMP(k, t) = min(RMP(k, t) + delta_rmp, 1);
                            RMP(k, k) = max(RMP(k, k) - delta_rmp, 0);
                        else
                            RMP(k, t) = max(RMP(k, t) - delta_rmp, 0);
                            RMP(k, k) = min(RMP(k, k) + delta_rmp, 1);
                        end
                    end
                end
            end
        end

        function [offspring, r1_task] = Generation(Algo, population, RMP, k)
            r1_task = zeros(1, length(population{k}));
            for i = 1:length(population{k})
                offspring(i) = population{k}(i);
                rnd = randperm(length(population{k}), 3);
                x1 = rnd(1); x2 = rnd(2); x3 = rnd(3);

                r = rand();
                for t = 1:length(population)
                    if r <= sum(RMP(k, 1:t))
                        r1_task(i) = t;
                        break;
                    end
                end

                offspring(i).Dec = population{r1_task(i)}(x1).Dec + Algo.F * (population{k}(x2).Dec - population{k}(x3).Dec);
                offspring(i).Dec = DE_Crossover(offspring(i).Dec, population{k}(i).Dec, Algo.CR);

                % offspring(i).Dec(offspring(i).Dec > 1) = 1;
                % offspring(i).Dec(offspring(i).Dec < 0) = 0;

                vio_low = find(offspring(i).Dec < 0);
                offspring(i).Dec(vio_low) = (population{k}(i).Dec(vio_low) + 0) / 2;
                vio_up = find(offspring(i).Dec > 1);
                offspring(i).Dec(vio_up) = (population{k}(i).Dec(vio_up) + 1) / 2;
            end
        end
    end
end
