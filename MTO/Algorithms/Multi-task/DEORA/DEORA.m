classdef DEORA < Algorithm
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
        Beta = 0.2
        Gama = 0.85
        Pmin = 0.1
        RMP0 = 0.3
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'F: Mutation Factor', num2str(obj.F), ...
                        'CR: Crossover Probability', num2str(obj.CR), ...
                        'Alpha', num2str(obj.Alpha), ...
                        'Beta', num2str(obj.Beta), ...
                        'Gama', num2str(obj.Gama), ...
                        'Pmin: Minimum selection probability', num2str(obj.Pmin), ...
                        'RMP0: Initial random mating probability', num2str(obj.RMP0)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.F = str2double(Parameter{i}); i = i + 1;
            obj.CR = str2double(Parameter{i}); i = i + 1;
            obj.Alpha = str2double(Parameter{i}); i = i + 1;
            obj.Beta = str2double(Parameter{i}); i = i + 1;
            obj.Gama = str2double(Parameter{i}); i = i + 1;
            obj.Pmin = str2double(Parameter{i}); i = i + 1;
            obj.RMP0 = str2double(Parameter{i}); i = i + 1;
        end

        function run(obj, Prob)
            % Initialization
            population = Initialization(obj, Prob, Individual);
            HR = []; % HR is used to store the historical rewards
            maxGen = (Prob.maxFE - Prob.N * Prob.T) / Prob.N + 1;
            delta_rmp = 1 / maxGen;
            RMP = obj.RMP0 * ones(Prob.T, Prob.T) / (Prob.T - 1);
            RMP(logical(eye(size(RMP)))) = (1 - obj.RMP0);

            while obj.notTerminated(Prob)
                % Select the k-th task to optimize
                if obj.Gen <= obj.Beta * maxGen
                    k = unidrnd(Prob.T);
                else
                    weights = obj.Gama.^(obj.Gen - 3:-1:0);
                    sum_weights = sum(weights);
                    for t = 1:Prob.T
                        mean_R(t) = sum(weights .* HR(t, :)) / sum_weights;
                    end
                    % The selection probability
                    prob(obj.Gen, :) = obj.Pmin / Prob.T + (1 - obj.Pmin) * mean_R ./ (sum(mean_R));
                    % Determine the a task based on the selection probability using roulette wheel method
                    r = rand;
                    for t = 1:Prob.T
                        if r <= sum(prob(obj.Gen, 1:t))
                            k = t;
                            break;
                        end
                    end
                end

                [offspring, r1_task] = obj.Generation(population, RMP, k);
                % Evaluation
                offspring = obj.Evaluation(offspring, Prob, k);

                fit_old = [population{k}.Obj];
                replace = [population{k}.Obj] > [offspring.Obj];
                population{k}(replace) = offspring(replace);
                fit_new = [population{k}.Obj];

                % calculate the reward
                R_p = max((fit_old - fit_new) ./ (fit_old), 0);
                best_g = [obj.Best{:}];
                R_b = max((min([best_g.Obj]) - min(fit_new)) / min([best_g.Obj]), 0);
                R = zeros(Prob.T, 1);
                for t = 1:Prob.T
                    if t == k %The main task
                        R(t) = obj.Alpha * R_b + (1 - obj.Alpha) * (sum(R_p) / length(R_p));
                    else % The auxiliary task
                        index = find(r1_task == t);
                        if isempty(index)
                            R(t) = 0;
                        else
                            [~, minid] = min(fit_new);
                            R(t) = obj.Alpha * (r1_task(minid) == t) * R_b + (1 - obj.Alpha) * (sum(R_p(index)) / length(index));
                        end
                    end
                end
                HR = [HR, R];

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

        function [offspring, r1_task] = Generation(obj, population, RMP, k)
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

                offspring(i).Dec = population{r1_task(i)}(x1).Dec + obj.F * (population{k}(x2).Dec - population{k}(x3).Dec);
                offspring(i).Dec = DE_Crossover(offspring(i).Dec, population{k}(i).Dec, obj.CR);

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
