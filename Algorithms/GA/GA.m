classdef GA < Algorithm

    properties (SetAccess = private)
        mu = 2; % index of Simulated Binary Crossover (tunable)
        mum = 5; % index of polynomial mutation
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'mu: index of Simulated Binary Crossover (tunable)', num2str(obj.mu), ...
                        'mum: index of polynomial mutation', num2str(obj.mum)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.mu = str2double(parameter_cell{count}); count = count + 1;
            obj.mum = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            pop_size = run_parameter_list(1);
            iter_num = run_parameter_list(2);
            eva_num = run_parameter_list(3);
            pop_size = fixPopSize(pop_size, length(Tasks));
            data.convergence = [];
            data.bestX = [];
            tic

            sub_pop = round(pop_size / length(Tasks));
            for sub_task = 1:length(Tasks)
                Task = Tasks(sub_task);
                fnceval_calls = 0;

                [population, calls] = initialize(Individual, sub_pop, Task, 1);
                fnceval_calls = fnceval_calls + calls;

                [bestobj, idx] = min([population.factorial_costs]);
                bestX = population(idx).rnvec;
                convergence(1) = bestobj;

                generation = 1;
                while generation < iter_num && fnceval_calls < round(eva_num / length(Tasks))
                    generation = generation + 1;

                    [offspring, calls] = OperatorGA.generate(1, population, Task, obj.mu, obj.mum);
                    fnceval_calls = fnceval_calls + calls;

                    [bestobj_offspring, idx] = min([offspring.factorial_costs]);
                    if bestobj_offspring < bestobj
                        bestobj = bestobj_offspring;
                        bestX = offspring(idx).rnvec;
                    end
                    convergence(generation) = bestobj;

                    population = [population, offspring];
                    [~, rank] = sort([population.factorial_costs]);
                    population = population(rank(1:sub_pop));
                end
                data.convergence = [data.convergence; convergence];
                data.bestX = [data.bestX, bestX];
                % map to real bound
                data.bestX{sub_task} = Task.Lb + data.bestX{sub_task} .* (Task.Ub - Task.Lb);
            end
            data.clock_time = toc;
        end
    end
end
