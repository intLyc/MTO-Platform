classdef MTV_DE < Algorithm
    % <Single> <Constrained>

    %------------------------------- Reference --------------------------------
    % @article{MezuraMontes2007MTV-DE,
    %   author    = {E. Mezura-Montes and C. A. Coello Coello and J. Velázquez-Reyes and L. Muñoz-Dávila},
    %   title     = {Multiple Trial Vectors in Differential Evolution for Engineering Design},
    %   doi       = {10.1080/03052150701364022},
    %   journal   = {Engineering Optimization},
    %   number    = {5},
    %   pages     = {567-589},
    %   publisher = {Taylor & Francis},
    %   volume    = {39},
    %   year      = {2007}
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        F = 0.5
        CR = 0.9
        no = 5
        sr = 0.45
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'F: Mutation Factor', num2str(obj.F), ...
                        'CR: Crossover Probability', num2str(obj.CR), ...
                        'no: number of trial vectors', num2str(obj.no), ...
                        'sr: stochastic ranking rate', num2str(obj.sr)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.F = str2double(parameter_cell{count}); count = count + 1;
            obj.CR = str2double(parameter_cell{count}); count = count + 1;
            obj.no = str2double(parameter_cell{count}); count = count + 1;
            obj.sr = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            sub_pop = run_parameter_list(1);
            sub_eva = run_parameter_list(2);

            data.convergence = [];
            data.convergence_cv = [];
            data.convergence_fr = [];
            data.bestX = {};

            for sub_task = 1:length(Tasks)
                Task = Tasks(sub_task);

                % initialize
                [population, fnceval_calls] = initialize(Individual, sub_pop, Task, Task.dims);
                [bestobj, bestCV, best_idx] = min_FP([population.factorial_costs], [population.constraint_violation]);
                bestX = population(best_idx).rnvec;
                convergence(1) = bestobj;
                convergence_cv(1) = bestCV;

                generation = 1;
                while fnceval_calls < sub_eva
                    generation = generation + 1;

                    % generation
                    [offspring, calls] = OperatorDE_MTV.generate(1, population, Task, obj.F, obj.CR, obj.no);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    replace_cv = [population.constraint_violation] > [offspring.constraint_violation];
                    equal_cv = [population.constraint_violation] <= 0 & [offspring.constraint_violation] <= 0;
                    replace_obj = [population.factorial_costs] > [offspring.factorial_costs];
                    replace = (equal_cv & replace_obj) | replace_cv;

                    % rand<=sr:obj else rand>sr:fp
                    idx_sr = rand(1, length(population)) <= obj.sr;
                    replace(idx_sr) = replace_obj(idx_sr);

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
        end
    end
end
