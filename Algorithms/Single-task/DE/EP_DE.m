classdef EP_DE < Algorithm
    % <Single> <Constrained>

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        F = 0.7
        CR = 0.9
        cp = 5
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'F: Mutation Factor', num2str(obj.F), ...
                        'CR: Crossover Probability', num2str(obj.CR), ...
                        'cp', num2str(obj.cp)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.F = str2double(parameter_cell{count}); count = count + 1;
            obj.CR = str2double(parameter_cell{count}); count = count + 1;
            obj.cp = str2double(parameter_cell{count}); count = count + 1;
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
                [population, fnceval_calls] = initialize(Individual, pop_init, Task, Task.dims);
                [bestobj, bestCV, best_idx] = min_FP([popualtion.factorial_costs], [popualtion.constraint_violation]);
                bestX = population(best_idx).rnvec;
                convergence(1) = bestobj;
                convergence_cv(1) = bestCV;

                n = ceil(0.05 * length(population));
                cv_temp = [population.constraint_violation];
                [~, idx] = sort(cv_temp);
                ep0 = cv_temp(idx(n));
                Tc = round(0.2 * sub_eva / sub_pop);

                generation = 1;
                while fnceval_calls < sub_eva
                    generation = generation + 1;

                    if generation <= Tc
                        ep = ep0 * ((1 - generation / Tc)^obj.cp);
                    else
                        ep = 0;
                    end

                    % generation
                    [offspring, calls] = OperatorDE.generate(1, population, Task, obj.F, obj.CR);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    replace_cv = [population.constraint_violation] > [offspring.constraint_violation];
                    equal_cv = [population.constraint_violation] <= ep & [offspring.constraint_violation] <= ep;
                    replace_obj = [population.factorial_costs] > [offspring.factorial_costs];
                    replace = (equal_cv & replace_obj) | replace_cv;

                    population(replace) = offspring(replace);

                    [bestobj_now, bestCV_now, best_idx] = min_FP([population.factorial_costs], [population.constraint_violation]);
                    if bestCV_now <= bestCV && bestobj_now <= bestobj
                        bestobj = bestobj_now;
                        bestCV = bestCV_now;
                        bestX = population(best_idx).rnvec;
                    end
                    convergence(generation) = bestobj;
                    convergence_cv(generation) = bestCV;
                end
                data.convergence = [data.convergence; convergence];
                data.convergence_cv = [data.convergence_cv; convergence_cv];
                data.bestX = [data.bestX, bestX];
            end
            data.convergence(data.convergence_cv > 0) = NaN;
            data.convergence = gen2eva(data.convergence);
            data.bestX = uni2real(data.bestX, Tasks);
            data.clock_time = toc;
        end
    end
end
