classdef PSO < Algorithm
    % <Single> <None>

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        wmax = 0.9;
        wmin = 0.4;
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
            sub_pop = run_parameter_list(1);
            sub_eva = run_parameter_list(2);

            data.convergence = [];
            data.bestX = {};

            for sub_task = 1:length(Tasks)
                Task = Tasks(sub_task);

                % initialize
                [population, fnceval_calls, bestobj, bestX] = initialize(IndividualPSO, sub_pop, Task, Task.dims);
                convergence(1) = bestobj;
                % initialize pso
                for i = 1:sub_pop
                    population(i).pbest = population(i).rnvec;
                    population(i).velocity = 0;
                    population(i).pbestFitness = population(i).factorial_costs;
                end

                generation = 1;
                while fnceval_calls < sub_eva
                    generation = generation + 1;

                    w = obj.wmax - (obj.wmax - obj.wmin) * fnceval_calls / sub_eva;

                    % generation
                    [population, calls] = OperatorPSO.generate(1, population, Task, w, obj.c1, obj.c2, bestX);
                    fnceval_calls = fnceval_calls + calls;

                    % update best
                    [bestobj_offspring, idx] = min([population.factorial_costs]);
                    if bestobj_offspring < bestobj
                        bestobj = bestobj_offspring;
                        bestX = population(idx).rnvec;
                    end
                    convergence(generation) = bestobj;
                end
                data.convergence = [data.convergence; convergence];
                data.bestX = [data.bestX, bestX];
            end
            data.convergence = gen2eva(data.convergence);
            data.bestX = uni2real(data.bestX, Tasks);
        end
    end
end
