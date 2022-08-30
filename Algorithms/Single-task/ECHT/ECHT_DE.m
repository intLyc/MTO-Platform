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
        function parameter = getParameter(obj)
            parameter = {'F: Mutation Factor', num2str(obj.F), ...
                        'CR: Crossover Probability', num2str(obj.CR), ...
                        'sr_max', num2str(obj.sr_max), ...
                        'sr_min', num2str(obj.sr_min), ...
                        'ep_top', num2str(obj.ep_top), ...
                        'ep_tc', num2str(obj.ep_tc), ...
                        'ep_cp', num2str(obj.ep_cp)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.F = str2double(parameter_cell{count}); count = count + 1;
            obj.CR = str2double(parameter_cell{count}); count = count + 1;
            obj.sr_max = str2double(parameter_cell{count}); count = count + 1;
            obj.sr_min = str2double(parameter_cell{count}); count = count + 1;
            obj.ep_top = str2double(parameter_cell{count}); count = count + 1;
            obj.ep_tc = str2double(parameter_cell{count}); count = count + 1;
            obj.ep_cp = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            sub_pop = run_parameter_list(1);
            sub_eva = run_parameter_list(2);

            convergence = [];
            convergence_cv = [];
            bestX = {};

            for sub_task = 1:length(Tasks)
                Task = Tasks(sub_task);

                ch_num = 4; % constraint handling techniques

                % initialize
                [population, fnceval_calls, bestobj, bestCV, bestX_temp] = initializeECHT(Individual, sub_pop, Task, ch_num);
                converge_temp(:, 1) = bestobj;
                converge_cv_temp(:, 1) = bestCV;

                % Stochastic Ranking
                Sr = obj.sr_max;
                dSr = (obj.sr_max - obj.sr_min) / (sub_eva / sub_pop);
                % Epsilon
                n = ceil(obj.ep_top * length(population{3}));
                cv_temp = [population{3}.constraint_violation];
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
                                obj_pair = [population{t}(i).factorial_costs, offspring_temp(i).factorial_costs];
                                cv_pair = [population{t}(i).constraint_violation, offspring_temp(i).constraint_violation];
                                switch t
                                    case 1 % Superiority of feasible solutions
                                        flag = sort_FP(obj_pair, cv_pair);
                                    case 2 % Stochastic ranking
                                        flag = sort_SR(obj_pair, cv_pair, Sr);
                                    case 3 % Epsilon constraint
                                        flag = sort_EC(obj_pair, cv_pair, Ep);
                                    case 4 % Self-adaptive penalty
                                        obj_temp = [[population{t}.factorial_costs], offspring_temp(i).factorial_costs];
                                        cv_temp = [[population{t}.constraint_violation], offspring_temp(i).constraint_violation];
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
                        [bestobj_now, bestCV_now, best_idx] = min_FP([offspring{t}.factorial_costs], [offspring{t}.constraint_violation]);
                        if bestCV_now < bestCV(t) || (bestCV_now == bestCV(t) && bestobj_now < bestobj(t))
                            bestobj(t) = bestobj_now;
                            bestCV(t) = bestCV_now;
                            bestX_temp{t} = offspring{t}(best_idx).rnvec;
                        end
                    end
                    converge_temp(:, generation) = bestobj;
                    converge_cv_temp(:, generation) = bestCV;
                end
                [~, ~, best_idx] = min_FP(converge_temp(:, end), converge_cv_temp(:, end));
                convergence(sub_task, :) = converge_temp(best_idx, :);
                convergence_cv(sub_task, :) = converge_cv_temp(best_idx, :);
                bestX{sub_task} = bestX_temp{best_idx};
            end
            data.convergence = gen2eva(convergence);
            data.convergence_cv = gen2eva(convergence_cv);
            data.bestX = uni2real(bestX, Tasks);
        end
    end
end
