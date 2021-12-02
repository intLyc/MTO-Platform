classdef DE < Algorithm

    properties (SetAccess = private)
        F = 0.5
        pCR = 0.9
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'F: Mutation Factor', num2str(obj.F), ...
                        'pCR: Crossover Probability', num2str(obj.pCR)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.F = str2double(parameter_cell{count}); count = count + 1;
            obj.pCR = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            pop_size = run_parameter_list(1);
            iter_num = run_parameter_list(2);
            eva_num = run_parameter_list(3);
            pop_size = fixPopSize(pop_size, length(Tasks));
            data.convergence = [];
            data.bestX = {};
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

                    [offspring, calls] = OperatorDE.generate(1, population, Task, obj.F, obj.pCR);
                    fnceval_calls = fnceval_calls + calls;

                    [bestobj_offspring, idx] = min([offspring.factorial_costs]);
                    if bestobj_offspring < bestobj
                        bestobj = bestobj_offspring;
                        bestX = offspring(idx).rnvec;
                    end
                    convergence(generation) = bestobj;

                    replace = [population.factorial_costs] > [offspring.factorial_costs];
                    population(replace) = offspring(replace);
                end
                data.convergence = [data.convergence; convergence];
                data.bestX = [data.bestX, bestX];
                % map to real bound
                data.bestX{sub_task} = Task.Lb + data.bestX{sub_task}(1:Task.dims) .* (Task.Ub - Task.Lb);
            end
            data.clock_time = toc;
        end
    end
end
