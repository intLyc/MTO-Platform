classdef ECHT < Algorithm
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

        function flag = compare_FP(obj, obj_pair, cv_pair)
            % Feasible Priority Compare
            flag = false;
            if cv_pair(1) > cv_pair(2) || ...
                    (0 == cv_pair(1) && 0 == cv_pair(2) && obj_pair(1) > obj_pair(2))
                flag = true;
            end
        end

        function flag = compare_SR(obj, obj_pair, cv_pair, Sr)
            % Stochastic Ranking Compare
            flag = false;
            if ((0 == cv_pair(1) && 0 == cv_pair(2)) || rand() < Sr)
                if obj_pair(1) > obj_pair(2)
                    flag = true;
                end
            else
                if cv_pair(1) > cv_pair(2)
                    flag = true;
                end
            end
        end

        function flag = compare_EC(obj, obj_pair, cv_pair, Ep)
            % Epsilon Constraint Compare
            flag = false;
            if cv_pair(1) > cv_pair(2) || ...
                    (cv_pair(1) < Ep && cv_pair(2) < Ep && obj_pair(1) > obj_pair(2))
                flag = true;
            end
        end

        function data = run(obj, Tasks, run_parameter_list)
            sub_pop = run_parameter_list(1);
            sub_eva = run_parameter_list(2);
            tic

            data.convergence = [];
            data.bestX = {};

            for sub_task = 1:length(Tasks)
                Task = Tasks(sub_task);

                ch_num = 3; % constraint handling techniques

                % initialize
                [population, fnceval_calls, bestobj, bestCV, bestX] = initializeECHT(Individual, sub_pop, Task, ch_num);
                convergence_obj(:, 1) = bestobj;
                convergence_cv(:, 1) = bestCV;

                % Stochastic Ranking
                Sr = obj.sr_max;
                dSr = (obj.sr_max - obj.sr_min) / (sub_eva / sub_pop);
                % Epsilon
                n = ceil(obj.ep_top * length(population{3}));
                cv_temp = [population{3}.constraint_violation];
                [~, idx] = sort(cv_temp);
                ep0 = cv_temp(idx(n));
                Tc = round(obj.ep_tc * sub_eva / sub_pop);

                generation = 1;
                while fnceval_calls < sub_eva
                    generation = generation + 1;

                    for t = 1:length(population)
                        % generate constraint handling population
                        [offspring{t}, calls] = OperatorDE.generate(1, population{t}, Task, obj.F, obj.CR);
                        fnceval_calls = fnceval_calls + calls;
                    end

                    % pre calculate
                    if generation <= Tc
                        Ep = ep0 * ((1 - generation / Tc)^obj.ep_cp);
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
                                        replace(i) = obj.compare_FP(obj_pair, cv_pair);
                                    case 2 % Stochastic ranking
                                        replace(i) = obj.compare_SR(obj_pair, cv_pair, Sr);
                                    case 3 % Epsilon constraint
                                        replace(i) = obj.compare_EC(obj_pair, cv_pair, Ep);
                                        % case 4 % Self-adaptive penalty
                                end
                            end
                            population{t}(replace) = offspring_temp(replace);
                        end
                        bestCV_now = min([population{t}.constraint_violation]);
                        pop_temp = population{t}([population{t}.constraint_violation] == bestCV_now);
                        [bestobj_now, idx] = min([pop_temp.factorial_costs]);
                        if bestCV_now <= bestCV(t) && bestobj_now < bestobj(t)
                            bestobj(t) = bestobj_now;
                            bestCV(t) = bestCV_now;
                            bestX{k} = pop_temp(idx).rnvec;
                        end
                    end
                    convergence_obj(:, generation) = bestobj';
                    convergence_cv(:, generation) = bestCV';
                end
                convergence_obj(convergence_cv > 0) = NaN;
                data.convergence = [data.convergence; nanmin(convergence_obj)];
                [~, best_idx] = nanmin(convergence_obj(:, end));
                data.bestX = [data.bestX, bestX{best_idx}];
            end
            data.bestX = uni2real(data.bestX, Tasks);
            data.clock_time = toc;
        end
    end
end
