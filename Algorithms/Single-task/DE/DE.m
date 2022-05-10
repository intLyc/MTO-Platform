classdef DE < Algorithm
    % <Single> <None>

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        F = 0.5
        CR = 0.9
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'F: Mutation Factor', num2str(obj.F), ...
                        'CR: Crossover Probability', num2str(obj.CR)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.F = str2double(parameter_cell{count}); count = count + 1;
            obj.CR = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            sub_pop = run_parameter_list(1);
            sub_eva = run_parameter_list(2);
            tic

            data.convergence = [];
            data.bestX = {};

            for sub_task = 1:length(Tasks)
                Task = Tasks(sub_task);

                % initialize
                [population, fnceval_calls, bestobj, bestX] = initialize(Individual, sub_pop, Task, Task.dims);
                convergence(1) = bestobj;

                generation = 1;
                while fnceval_calls < sub_eva
                    generation = generation + 1;

                    % generation
                    [offspring, calls] = OperatorDE.generate(1, population, Task, obj.F, obj.CR);
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
            data.convergence = gen2eva(data.convergence);
            data.bestX = uni2real(data.bestX, Tasks);
            data.clock_time = toc;
        end
    end
end
