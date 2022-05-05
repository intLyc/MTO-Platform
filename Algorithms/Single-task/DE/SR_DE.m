classdef SR_DE < Algorithm
    % <Single> <Constrained>

    %------------------------------- Reference --------------------------------
    % @article{Runarsson2000SR-DE,
    %   author   = {Runarsson, T.P. and Xin Yao},
    %   title    = {Stochastic Ranking for Constrained Evolutionary Optimization},
    %   doi      = {10.1109/4235.873238},
    %   journal  = {IEEE Transactions on Evolutionary Computation},
    %   number   = {3},
    %   pages    = {284-294},
    %   volume   = {4},
    %   year     = {2000}
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
        sr = 0.45
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'F: Mutation Factor', num2str(obj.F), ...
                        'CR: Crossover Probability', num2str(obj.CR), ...
                        'sr: stochastic ranking rate', num2str(obj.sr)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.F = str2double(parameter_cell{count}); count = count + 1;
            obj.CR = str2double(parameter_cell{count}); count = count + 1;
            obj.sr = str2double(parameter_cell{count}); count = count + 1;
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
                [population, fnceval_calls, bestobj, bestX] = initialize(Individual, sub_pop, Task, Task.dims);

                bestCV = min([population.constraint_violation]);
                pop_temp = population([population.constraint_violation] == bestCV);
                [bestobj, idx] = min([pop_temp.factorial_costs]);
                bestX = pop_temp(idx).rnvec;
                convergence(1) = bestobj;
                convergence_cv(1) = pop_temp(idx).constraint_violation;

                generation = 1;
                while fnceval_calls < sub_eva
                    generation = generation + 1;

                    % generation
                    [offspring, calls] = OperatorDE.generate(1, population, Task, obj.F, obj.CR);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    replace_cv = [population.constraint_violation] > [offspring.constraint_violation];
                    equal_cv = [population.constraint_violation] == [offspring.constraint_violation];
                    replace_obj = [population.factorial_costs] > [offspring.factorial_costs];
                    replace = (equal_cv & replace_obj) | replace_cv;

                    % rand<=sr:obj else rand>sr:fp
                    idx_sr = rand(1, length(population)) <= obj.sr;
                    replace(idx_sr) = replace_obj(idx_sr);

                    population(replace) = offspring(replace);

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
