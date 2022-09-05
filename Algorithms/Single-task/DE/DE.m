classdef DE < Algorithm
    % <Single> <None/Constrained>

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
        function Parameter = getParameter(obj)
            Parameter = {'F: Mutation Factor', num2str(obj.F), ...
                        'CR: Crossover Probability', num2str(obj.CR)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.F = str2double(Parameter{i}); i = i + 1;
            obj.CR = str2double(Parameter{i}); i = i + 1;
        end

        function data = run(obj, Tasks, RunPara)
            sub_pop = RunPara(1); sub_eva = RunPara(2);
            convergence = {}; convergence_cv = {}; bestX = {};

            for sub_task = 1:length(Tasks)
                Task = Tasks(sub_task);

                % initialize
                [population, fnceval_calls] = initialize(Individual, sub_pop, Task, Task.dims);
                [bestobj, bestCV, best_idx] = min_FP([population.factorial_costs], [population.constraint_violation]);
                bestX_temp = population(best_idx).rnvec;
                converge_temp(1) = bestobj;
                converge_cv_temp(1) = bestCV;

                generation = 1;
                while fnceval_calls < sub_eva
                    generation = generation + 1;

                    % generation
                    [offspring, calls] = OperatorDE.generate(population, Task, obj.F, obj.CR);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    replace_cv = [population.constraint_violation] > [offspring.constraint_violation];
                    equal_cv = [population.constraint_violation] <= 0 & [offspring.constraint_violation] <= 0;
                    replace_f = [population.factorial_costs] > [offspring.factorial_costs];
                    replace = (equal_cv & replace_f) | replace_cv;

                    population(replace) = offspring(replace);

                    [bestobj_now, bestCV_now, best_idx] = min_FP([offspring.factorial_costs], [offspring.constraint_violation]);
                    if bestCV_now < bestCV || (bestCV_now == bestCV && bestobj_now < bestobj)
                        bestobj = bestobj_now;
                        bestCV = bestCV_now;
                        bestX_temp = offspring(best_idx).rnvec;
                    end
                    converge_temp(generation) = bestobj;
                    converge_cv_temp(generation) = bestCV;
                end
                convergence{sub_task} = converge_temp;
                convergence_cv{sub_task} = converge_cv_temp;
                bestX{sub_task} = bestX_temp;
            end
            data.convergence = gen2eva(cell2matrix(convergence));
            data.convergence_cv = gen2eva(cell2matrix(convergence_cv));
            data.bestX = uni2real(bestX, Tasks);
        end
    end
end
