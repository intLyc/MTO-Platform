classdef CAL_SHADE < Algorithm
    % <Single> <Constrained>

    %------------------------------- Reference --------------------------------
    % @InProceedings{Zamuda2017CAL-SHADE,
    %   title     = {Adaptive Constraint Handling and Success History Differential Evolution for Cec 2017 Constrained Real-parameter Optimization},
    %   author    = {Zamuda, Aleš},
    %   booktitle = {2017 IEEE Congress on Evolutionary Computation (CEC)},
    %   year      = {2017},
    %   pages     = {2443-2450},
    %   doi       = {10.1109/CEC.2017.7969601},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        p = 0.11;
        H = 5;
        ep_top = 0.2
        ep_tc = 500
        ep_cp = 5
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'p: 100p% top as pbest', num2str(obj.p), ...
                        'H: success memory size', num2str(obj.H), ...
                        'ep_top', num2str(obj.ep_top), ...
                        'ep_tc', num2str(obj.ep_tc), ...
                        'ep_cp', num2str(obj.ep_cp)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.p = str2double(parameter_cell{count}); count = count + 1;
            obj.H = str2double(parameter_cell{count}); count = count + 1;
            obj.ep_top = str2double(parameter_cell{count}); count = count + 1;
            obj.ep_tc = str2double(parameter_cell{count}); count = count + 1;
            obj.ep_cp = str2double(parameter_cell{count}); count = count + 1;
        end

        function flag = compare_EC(obj, obj_pair, cv_pair, Ep)
            % Epsilon Constraint Compare
            flag = false;
            if cv_pair(1) > cv_pair(2) || ...
                    (cv_pair(1) <= Ep && cv_pair(2) <= Ep && obj_pair(1) > obj_pair(2))
                flag = true;
            end
        end

        function data = run(obj, Tasks, run_parameter_list)
            sub_pop = run_parameter_list(1);
            sub_eva = run_parameter_list(2);
            tic

            data.convergence = [];
            data.convergence_cv = [];
            data.convergence_fr = [];
            data.bestX = {};

            for sub_task = 1:length(Tasks)
                Task = Tasks(sub_task);

                % initialize
                pop_init = Task.dims * 2;
                pop_min = 4;
                [population, fnceval_calls, bestobj, bestX] = initialize(IndividualJADE, pop_init, Task, Task.dims);
                bestCV = min([population.constraint_violation]);
                pop_temp = population([population.constraint_violation] == bestCV);
                [bestobj, idx] = min([pop_temp.factorial_costs]);
                bestX = pop_temp(idx).rnvec;
                convergence(1) = bestobj;
                convergence_cv(1) = pop_temp(idx).constraint_violation;

                % initialize parameter
                n = ceil(obj.ep_top * length(population));
                cv_temp = [population.constraint_violation];
                [~, idx] = sort(cv_temp);
                ep0 = cv_temp(idx(n));
                H_idx = 1;
                MF = 0.5 .* ones(obj.H, 1);
                MCR = 0.5 .* ones(obj.H, 1);
                arc = IndividualJADE.empty();

                generation = 1;
                while fnceval_calls < sub_eva
                    generation = generation + 1;

                    % Linear Population Size Reduction
                    pop_size = round((pop_min - pop_init) ./ sub_eva .* fnceval_calls + pop_init);

                    % calculate individual F and CR
                    for i = 1:length(population)
                        idx = randi(obj.H);
                        uF = MF(idx);
                        population(i).F = uF + 0.1 * tan(pi * (rand - 0.5));
                        while (population(i).F <= 0)
                            population(i).F = uF + 0.1 * tan(pi * (rand - 0.5));
                        end
                        population(i).F(population(i).F > 1) = 1;

                        uCR = MCR(idx);
                        population(i).CR = normrnd(uCR, 0.1);
                        population(i).CR(population(i).CR > 1) = 1;
                        population(i).CR(population(i).CR < 0) = 0;
                    end
                    % calculate epsilon
                    if generation <= obj.ep_tc
                        Ep = ep0 * ((1 - generation / obj.ep_tc)^obj.ep_cp);
                    else
                        Ep = 0;
                    end
                    Ep

                    % generation
                    union = [population, arc];
                    [offspring, calls] = OperatorSHADE.generate(1, Task, population, union, obj.p);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    replace = false(1, length(population));
                    for i = 1:length(population)
                        obj_pair = [population(i).factorial_costs, offspring(i).factorial_costs];
                        cv_pair = [population(i).constraint_violation, offspring(i).constraint_violation];
                        replace(i) = obj.compare_EC(obj_pair, cv_pair, Ep);
                    end

                    % calculate SF SCR
                    SF = [population(replace).F];
                    SCR = [population(replace).CR];
                    dif = abs([population(replace).factorial_costs] - [offspring(replace).factorial_costs]);
                    dif = dif ./ sum(dif);

                    % update MF MCR
                    if ~isempty(SF)
                        MF(H_idx) = (dif * (SF'.^2)) / (dif * SF');
                        MCR(H_idx) = (dif * (SCR'.^2)) / (dif * SCR');
                    else
                        MF(H_idx) = MF(mod(H_idx + obj.H - 2, obj.H) + 1);
                        MCR(H_idx) = MCR(mod(H_idx + obj.H - 2, obj.H) + 1);
                    end
                    H_idx = mod(H_idx, obj.H) + 1;

                    population(replace) = offspring(replace);

                    % update archive
                    arc = [arc, population(replace)];
                    if length(arc) > length(pop_size)
                        rnd = randperm(length(arc));
                        arc = arc(rnd(1:length(pop_size)));
                    end

                    % Linear Population Size Reduction
                    if pop_size < length(population)
                        rank = sort_EC([population.factorial_costs], [population.constraint_violation], Ep);
                        population = population(rank(1:pop_size));
                    end

                    bestCV_now = min([population.constraint_violation]);
                    pop_temp = population([population.constraint_violation] == bestCV_now);
                    [bestobj_now, idx] = min([pop_temp.factorial_costs]);
                    if bestCV_now <= bestCV && bestobj_now < bestobj
                        bestobj = bestobj_now;
                        bestCV = bestCV_now;
                        bestX = pop_temp(idx).rnvec;
                    end
                    convergence(generation) = bestobj;
                    convergence_cv(generation) = bestCV;
                end
                data.convergence = [data.convergence; convergence];
                data.convergence_cv = [data.convergence_cv; convergence_cv];
                data.bestX = [data.bestX, bestX];
            end
            data.convergence(data.convergence_cv > 0) = NaN;
            data.bestX = uni2real(data.bestX, Tasks);
            data.clock_time = toc;
        end
    end
end
