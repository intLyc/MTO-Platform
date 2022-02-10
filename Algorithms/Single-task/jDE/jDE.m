classdef jDE < Algorithm
    % @Article{Brest2006jDE,
    %   author  = {Brest, Janez and Greiner, Sao and Boskovic, Borko and Mernik, Marjan and Zumer, Viljem},
    %   journal = {IEEE Transactions on Evolutionary Computation},
    %   title   = {Self-Adapting Control Parameters in Differential Evolution: A Comparative Study on Numerical Benchmark Problems},
    %   year    = {2006},
    %   number  = {6},
    %   pages   = {646-657},
    %   volume  = {10},
    %   doi     = {10.1109/TEVC.2006.872133},
    % }

    properties (SetAccess = private)
        t1 = 0.1;
        t2 = 0.1;
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'t1: probability of F change', num2str(obj.t1), ...
                        't2: probability of CR change', num2str(obj.t2)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.t1 = str2double(parameter_cell{count}); count = count + 1;
            obj.t2 = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            sub_pop = run_parameter_list(1);
            iter_num = run_parameter_list(2);
            eva_num = run_parameter_list(3) * length(tasks);
            tic

            data.convergence = [];
            data.bestX = {};

            for sub_task = 1:length(Tasks)
                Task = Tasks(sub_task);

                % initialize
                [population, fnceval_calls] = initialize(IndividualjDE, sub_pop, Task, 1);
                % initialize F and pCR
                for i = 1:length(population)
                    population(i).F = rand * 0.9 + 0.1;
                    population(i).pCR = rand;
                end

                [bestobj, idx] = min([population.factorial_costs]);
                bestX = population(idx).rnvec;
                convergence(1) = bestobj;

                generation = 1;
                while generation < iter_num && fnceval_calls < round(eva_num / length(Tasks))
                    generation = generation + 1;

                    % generation
                    [offspring, calls] = OperatorjDE.generate(1, population, Task, obj.t1, obj.t2);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    replace = [population.factorial_costs] > [offspring.factorial_costs];
                    population(replace) = offspring(replace);
                    [bestobj_now, idx] = min([population.factorial_costs]);
                    if bestobj_now < bestobj
                        bestobj = bestobj_now;
                        bestX = population(idx).rnvec;
                    end
                    convergence(generation) = bestobj;
                end
                data.convergence = [data.convergence; convergence];
                data.bestX = [data.bestX, bestX];
            end
            data.bestX = uni2real(data.bestX, Tasks);
            data.clock_time = toc;
        end
    end
end
