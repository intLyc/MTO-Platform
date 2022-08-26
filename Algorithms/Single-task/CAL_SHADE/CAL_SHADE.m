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
        p = 0.11
        H = 5
        arc_rate = 1
        ep_top = 0.2
        ep_tc = 0.8
        ep_cp = 5
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'p: 100p% top as pbest', num2str(obj.p), ...
                        'H: success memory size', num2str(obj.H), ...
                        'arc_rate: arcive size rate', num2str(obj.arc_rate), ...
                        'ep_top', num2str(obj.ep_top), ...
                        'ep_tc', num2str(obj.ep_tc), ...
                        'ep_cp', num2str(obj.ep_cp)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.p = str2double(parameter_cell{count}); count = count + 1;
            obj.H = str2double(parameter_cell{count}); count = count + 1;
            obj.arc_rate = str2double(parameter_cell{count}); count = count + 1;
            obj.ep_top = str2double(parameter_cell{count}); count = count + 1;
            obj.ep_tc = str2double(parameter_cell{count}); count = count + 1;
            obj.ep_cp = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            sub_pop = run_parameter_list(1);
            sub_eva = run_parameter_list(2);

            convergence = [];
            convergence_cv = [];
            eva_gen = [];
            bestX = {};

            for sub_task = 1:length(Tasks)
                Task = Tasks(sub_task);

                % initialize
                pop_init = Task.dims * 2;
                % pop_init = sub_pop;
                pop_min = 4;
                [population, fnceval_calls] = initialize(IndividualJADE, pop_init, Task, Task.dims);
                [bestobj, bestCV, best_idx] = min_FP([population.factorial_costs], [population.constraint_violation]);
                bestX_temp = population(best_idx).rnvec;
                converge_temp(1) = bestobj;
                converge_cv_temp(1) = bestCV;
                eva_gen_temp(1) = fnceval_calls;

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
                    if fnceval_calls < obj.ep_tc * sub_eva
                        Ep = ep0 * ((1 - fnceval_calls / (obj.ep_tc * sub_eva))^obj.ep_cp);
                    else
                        Ep = 0;
                    end

                    % generation
                    union = [population, arc];
                    [offspring, calls] = OperatorSHADE_CAL.generate(Task, population, union, obj.p, Ep);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    replace_cv = [population.constraint_violation] > [offspring.constraint_violation] & [population.constraint_violation] > Ep & [offspring.constraint_violation] > Ep;
                    equal_cv = [population.constraint_violation] <= Ep & [offspring.constraint_violation] <= Ep;
                    replace_obj = [population.factorial_costs] > [offspring.factorial_costs];
                    replace = (equal_cv & replace_obj) | replace_cv;

                    % calculate SF SCR
                    SF = [population(replace).F];
                    SCR = [population(replace).CR];
                    dif = 1e30 * abs([population(replace).constraint_violation] - [offspring(replace).constraint_violation]) + ...
                        abs([population(replace).factorial_costs] - [offspring(replace).factorial_costs]);
                    dif = dif ./ sum(dif);

                    % update MF MCR
                    if ~isempty(SF)
                        MF(H_idx) = sum(dif .* (SF.^2)) / sum(dif .* SF);
                        MCR(H_idx) = sum(dif .* SCR);
                    else
                        MF(H_idx) = MF(mod(H_idx + obj.H - 2, obj.H) + 1);
                        MCR(H_idx) = MCR(mod(H_idx + obj.H - 2, obj.H) + 1);
                    end
                    H_idx = mod(H_idx, obj.H) + 1;

                    % update archive
                    arc = [arc, population(replace)];
                    if length(arc) > round(pop_size * obj.arc_rate)
                        arc = arc(randperm(length(arc), round(pop_size * obj.arc_rate)));
                    end

                    population(replace) = offspring(replace);

                    % Linear Population Size Reduction
                    obj_list = [population.factorial_costs];
                    cv_list = [population.constraint_violation];
                    cv_list(cv_list < Ep) = 0;
                    [~, rank] = sortrows([cv_list', obj_list'], [1, 2]);
                    population = population(rank(1:pop_size));

                    [bestobj_now, bestCV_now, best_idx] = min_FP([population.factorial_costs], [population.constraint_violation]);
                    if bestCV_now < bestCV || (bestCV_now == bestCV && bestobj_now < bestobj)
                        bestobj = bestobj_now;
                        bestCV = bestCV_now;
                        bestX_temp = population(best_idx).rnvec;
                    end
                    converge_temp(generation) = bestobj;
                    converge_cv_temp(generation) = bestCV;
                    eva_gen_temp(generation) = fnceval_calls;
                end
                convergence(sub_task, :) = converge_temp;
                convergence_cv(sub_task, :) = converge_cv_temp;
                eva_gen(sub_task, :) = eva_gen_temp;
                bestX{sub_task} = bestX_temp;
            end
            data.convergence = gen2eva(convergence, eva_gen);
            data.convergence_cv = gen2eva(convergence_cv, eva_gen);
            data.bestX = uni2real(bestX, Tasks);
        end
    end
end
