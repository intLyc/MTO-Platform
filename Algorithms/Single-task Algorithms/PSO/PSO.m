classdef PSO < Algorithm

    properties (SetAccess = private)
        wmax = 0.9; % inertia weight
        wmin = 0.4; % inertia weight
        c1 = 0.2;
        c2 = 0.2;
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'wmax: Inertia Weight Max', num2str(obj.wmax), ...
                        'wmin: Inertia Weight Min', num2str(obj.wmin), ...
                        'c1', num2str(obj.c1), ...
                        'c2', num2str(obj.c2)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.wmax = str2double(parameter_cell{count}); count = count + 1;
            obj.wmin = str2double(parameter_cell{count}); count = count + 1;
            obj.c1 = str2double(parameter_cell{count}); count = count + 1;
            obj.c2 = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            pop_size = run_parameter_list(1);
            iter_num = run_parameter_list(2);
            eva_num = run_parameter_list(3);
            pop_size = fixPopSize(pop_size, length(Tasks));
            data.convergence = [];
            data.convergence_cv = [];
            data.bestX = {};
            tic

            sub_pop = round(pop_size / length(Tasks));
            for sub_task = 1:length(Tasks)
                Task = Tasks(sub_task);

                % initialize
                [population, fnceval_calls] = initialize(IndividualPSO, sub_pop, Task, 1);
                [bestobj, idx] = min([population.factorial_costs]);
                bestX = population(idx).rnvec;
                convergence(1) = bestobj;
                convergence_cv(1) = population(idx).constraint_violation;
                % initialize pso
                for i = 1:sub_pop
                    population(i).pbest = population(i).rnvec;
                    population(i).velocity = 0;
                    population(i).pbestFitness = population(i).factorial_costs;
                end

                generation = 1;
                while generation < iter_num && fnceval_calls < round(eva_num / length(Tasks))
                    generation = generation + 1;

                    if iter_num == inf
                        w = obj.wmax - (obj.wmax - obj.wmin) * fnceval_calls / eva_num;
                    else
                        w = obj.wmax - (obj.wmax - obj.wmin) * generation / iter_num;
                    end

                    % generation
                    [population, calls] = OperatorPSO.generate(1, population, Task, w, obj.c1, obj.c2, bestX);
                    fnceval_calls = fnceval_calls + calls;

                    % update best
                    [bestobj_offspring, idx] = min([population.factorial_costs]);
                    if bestobj_offspring < bestobj
                        bestobj = bestobj_offspring;
                        bestX = population(idx).rnvec;
                        convergence_cv(generation) = population(idx).constraint_violation;
                    else
                        convergence_cv(generation) = convergence_cv(generation - 1);
                    end
                    convergence(generation) = bestobj;
                end
                data.convergence = [data.convergence; convergence];
                data.convergence_cv = [data.convergence_cv; convergence_cv];
                data.bestX = [data.bestX, bestX];
            end
            data.bestX = bin2real(data.bestX, Tasks);
            data.clock_time = toc;
        end
    end
end
