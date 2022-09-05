classdef ECHT_DE < Algorithm
    % <Single> <Constrained>

    %------------------------------- Reference --------------------------------
    % @Article{Mallipeddi2010ECHT,
    %   author   = {Mallipeddi, Rammohan and Suganthan, Ponnuthurai N.},
    %   journal  = {IEEE Transactions on Evolutionary Computation},
    %   title    = {Ensemble of Constraint Handling Techniques},
    %   year     = {2010},
    %   number   = {4},
    %   pages    = {561-579},
    %   volume   = {14},
    %   doi      = {10.1109/TEVC.2009.2033582},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        F = 0.7
        CR = 0.9
        sr_max = 0.475
        sr_min = 0.025
        ep_top = 0.05
        ep_tc = 0.2
        ep_cp = 5
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'F: Mutation Factor', num2str(obj.F), ...
                        'CR: Crossover Probability', num2str(obj.CR), ...
                        'sr_max', num2str(obj.sr_max), ...
                        'sr_min', num2str(obj.sr_min), ...
                        'ep_top', num2str(obj.ep_top), ...
                        'ep_tc', num2str(obj.ep_tc), ...
                        'ep_cp', num2str(obj.ep_cp)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.F = str2double(Parameter{i}); i = i + 1;
            obj.CR = str2double(Parameter{i}); i = i + 1;
            obj.sr_max = str2double(Parameter{i}); i = i + 1;
            obj.sr_min = str2double(Parameter{i}); i = i + 1;
            obj.ep_top = str2double(Parameter{i}); i = i + 1;
            obj.ep_tc = str2double(Parameter{i}); i = i + 1;
            obj.ep_cp = str2double(Parameter{i}); i = i + 1;
        end

        function data = run(obj, Tasks, RunPara)
            sub_pop = RunPara(1); sub_eva = RunPara(2);
            convergeObj = []; convergeCV = []; bestDec = {};

            for sub_task = 1:length(Tasks)
                Task = Tasks(sub_task);

                ch_num = 4; % constraint handling techniques

                % initialize
                [population, fnceval_calls, bestObj, bestCV, bestDec_temp] = initializeECHT(Individual, sub_pop, Task, ch_num);
                convergeObj_temp(:, 1) = bestObj;
                convergeCV_temp(:, 1) = bestCV;

                % Stochastic Ranking
                Sr = obj.sr_max;
                dSr = (obj.sr_max - obj.sr_min) / (sub_eva / sub_pop);
                % Epsilon
                n = ceil(obj.ep_top * length(population{3}));
                cv_temp = [population{3}.CV];
                [~, idx] = sort(cv_temp);
                ep0 = cv_temp(idx(n));

                generation = 1;
                while fnceval_calls < sub_eva
                    generation = generation + 1;

                    for t = 1:length(population)
                        % generate constraint handling population
                        [offspring{t}, calls] = OperatorECHT.generate(population{t}, Task, obj.F, obj.CR);
                        fnceval_calls = fnceval_calls + calls;
                    end

                    % pre calculate
                    if fnceval_calls < obj.ep_tc * sub_eva
                        Ep = ep0 * ((1 - fnceval_calls / (obj.ep_tc * sub_eva))^obj.ep_cp);
                    else
                        Ep = 0;
                    end
                    Sr = Sr - dSr;

                    % selection
                    for t = 1:length(population)
                        for k = 1:length(population)
                            if t == k
                                offspring_temp = offspring{k};
                            else
                                offspring_temp = offspring{k}(randperm(length(offspring{k})));
                            end
                            replace = false(1, length(population{t}));
                            for i = 1:length(population{t})
                                obj_pair = [population{t}(i).Obj, offspring_temp(i).Obj];
                                cv_pair = [population{t}(i).CV, offspring_temp(i).CV];
                                switch t
                                    case 1 % Superiority of feasible solutions
                                        flag = sort_FP(obj_pair, cv_pair);
                                    case 2 % Stochastic ranking
                                        flag = sort_SR(obj_pair, cv_pair, Sr);
                                    case 3 % Epsilon constraint
                                        flag = sort_EC(obj_pair, cv_pair, Ep);
                                    case 4 % Self-adaptive penalty
                                        obj_temp = [[population{t}.Obj], offspring_temp(i).Obj];
                                        cv_temp = [[population{t}.CV], offspring_temp(i).CV];
                                        f = cal_SP(obj_temp, cv_temp, 1);
                                        if f(i) > f(end)
                                            flag = [2, 1];
                                        else
                                            flag = [1, 2];
                                        end
                                end
                                replace(i) = (flag(1) ~= 1);
                            end
                            population{t}(replace) = offspring_temp(replace);
                        end
                        [bestObj_now, bestCV_now, best_idx] = min_FP([offspring{t}.Obj], [offspring{t}.CV]);
                        if bestCV_now < bestCV(t) || (bestCV_now == bestCV(t) && bestObj_now < bestObj(t))
                            bestObj(t) = bestObj_now;
                            bestCV(t) = bestCV_now;
                            bestDec_temp{t} = offspring{t}(best_idx).Dec;
                        end
                    end
                    convergeObj_temp(:, generation) = bestObj;
                    convergeCV_temp(:, generation) = bestCV;
                end
                [~, ~, best_idx] = min_FP(convergeObj_temp(:, end), convergeCV_temp(:, end));
                convergeObj{sub_task} = convergeObj_temp(best_idx, :);
                convergeCV{sub_task} = convergeCV_temp(best_idx, :);
                bestDec{sub_task} = bestDec_temp{best_idx};
            end
            data.convergeObj = gen2eva(cell2matrix(convergeObj));
            data.convergeCV = gen2eva(cell2matrix(convergeCV));
            data.bestDec = uni2real(bestDec, Tasks);
        end
    end
end
