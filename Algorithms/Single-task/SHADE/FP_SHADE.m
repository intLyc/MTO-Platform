classdef FP_SHADE < Algorithm
    % <Single> <Constrained>

    % SHADE with Feasibility Priority for Constrained MTOPs

    properties (SetAccess = private)
        p = 0.1;
        H = 100;
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'p: 100p% top as pbest', num2str(obj.p), ...
                        'H: success memory size', num2str(obj.H)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.p = str2double(parameter_cell{count}); count = count + 1;
            obj.H = str2double(parameter_cell{count}); count = count + 1;
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
                [population, fnceval_calls, bestobj, bestX] = initialize(IndividualJADE, sub_pop, Task, Task.dims);

                % initialize parameter
                H_idx = 1;
                MF = 0.5 .* ones(obj.H, 1);
                MCR = 0.5 .* ones(obj.H, 1);
                arc = IndividualJADE.empty();

                bestCV = min([population.constraint_violation]);
                pop_temp = population([population.constraint_violation] == bestCV);
                [bestobj, idx] = min([pop_temp.factorial_costs]);
                bestX = pop_temp(idx).rnvec;
                convergence(1) = bestobj;
                convergence_cv(1) = pop_temp(idx).constraint_violation;

                generation = 1;
                while fnceval_calls < sub_eva
                    generation = generation + 1;

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

                    % generation
                    union = [population, arc];
                    [offspring, calls] = OperatorSHADE.generate(1, Task, population, union, obj.p);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    % replace = [population.factorial_costs] > [offspring.factorial_costs];
                    replace_cv = [population.constraint_violation] > [offspring.constraint_violation];
                    equal_cv = [population.constraint_violation] == [offspring.constraint_violation];
                    replace_f = [population.factorial_costs] > [offspring.factorial_costs];
                    replace = (equal_cv & replace_f) | replace_cv;

                    % update archive
                    arc = [arc, population(replace)];
                    if length(arc) > length(population)
                        rnd = randperm(length(arc));
                        arc = arc(rnd(1:length(population)));
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

                    % [bestobj_now, idx] = min([population.factorial_costs]);
                    % if bestobj_now < bestobj
                    %     bestobj = bestobj_now;
                    %     bestX = population(idx).rnvec;
                    % end
                    % convergence(generation) = bestobj;
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
