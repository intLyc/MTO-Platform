classdef DEORA_MTDE < Algorithm
    % <Multi> <Competitive>

    %------------------------------- Reference --------------------------------
    % @Article{Li2022CompetitiveMTO,
    %   author     = {Li, Genghui and Zhang, Qingfu and Wang, Zhenkun},
    %   journal    = {IEEE Transactions on Evolutionary Computation},
    %   title      = {Evolutionary Competitive Multitasking Optimization},
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
        alpha = 0.5
        rmp0 = 0.3
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'F: Mutation Factor', num2str(obj.F), ...
                        'CR: Crossover Probability', num2str(obj.CR), ...
                        'alpha', num2str(obj.alpha), ...
                        'rmp0: Initial random mating probability', num2str(obj.rmp0)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.F = str2double(Parameter{i}); i = i + 1;
            obj.CR = str2double(Parameter{i}); i = i + 1;
            obj.alpha = str2double(Parameter{i}); i = i + 1;
            obj.rmp0 = str2double(Parameter{i}); i = i + 1;
        end

        function data = run(obj, Tasks, RunPara)
            sub_pop = RunPara(1); sub_eva = RunPara(2);
            pop_size = sub_pop * length(Tasks);
            eva_num = sub_eva * length(Tasks);

            gen = (eva_num - (pop_size * length(Tasks) - 1)) / pop_size;
            delta_rmp = 1 / gen;
            rmp = obj.rmp0 * ones(length(Tasks), length(Tasks)) / (length(Tasks) - 1);
            rmp(logical(eye(size(rmp)))) = (1 - obj.rmp0);

            % initialize
            [population, fnceval_calls, bestDec, bestObj] = initializeMT(Individual, sub_pop, Tasks, max([Tasks.Dim]) * ones(1, length(Tasks)));
            convergeObj(:, 1) = bestObj;

            generation = 1;
            while fnceval_calls < eva_num
                generation = generation + 1;

                for k = 1:length(Tasks)
                    % generate
                    [offspring, r1_task, calls] = OperatorDEORA.generate(population, Tasks, k, rmp, obj.F, obj.CR);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    fit_old = [population{k}.Obj];
                    replace = [population{k}.Obj] > [offspring.Obj];
                    population{k}(replace) = offspring(replace);
                    fit_new = [population{k}.Obj];

                    [bestObj_now, idx] = min([population{k}.Obj]);
                    if bestObj_now < bestObj(k)
                        bestObj(k) = bestObj_now;
                        bestDec{k} = population{k}(idx).Dec;
                    end

                    % calculate the reward
                    R_p = max((fit_old - fit_new) ./ (fit_old), 0);
                    R_b = max((bestObj(k) - min(fit_new)) / bestObj(k), 0);
                    R = zeros(length(Tasks), 1);
                    for t = 1:length(Tasks)
                        if t == k %The main task
                            R(t) = obj.alpha * R_b + (1 - obj.alpha) * (sum(R_p) / pop_size);
                        else % The auxiliary task
                            index = find(r1_task == t);
                            if isempty(index)
                                R(t) = 0;
                            else
                                [~, minid] = min(fit_new);
                                R(t) = obj.alpha * (r1_task(minid) == t) * R_b + (1 - obj.alpha) * (sum(R_p(index)) / length(index));
                            end
                        end
                    end

                    % update rmp
                    for t = 1:length(Tasks)
                        if t == k
                            continue;
                        end
                        if R(t) >= R(k)
                            rmp(k, t) = min(rmp(k, t) + delta_rmp, 1);
                            rmp(k, k) = max(rmp(k, k) - delta_rmp, 0);
                        else
                            rmp(k, t) = max(rmp(k, t) - delta_rmp, 0);
                            rmp(k, k) = min(rmp(k, k) + delta_rmp, 1);
                        end
                    end
                end
                convergeObj(:, generation) = bestObj;
            end
            data.convergeObj = gen2eva(convergeObj);
            data.bestDec = uni2real(bestDec, Tasks);
        end
    end
end
