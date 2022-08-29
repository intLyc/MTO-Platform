classdef C2oDE < Algorithm
    % <Single> <Constrained>

    %------------------------------- Reference --------------------------------
    % @Article{Wang2019C2oDE,
    %   title    = {Composite Differential Evolution for Constrained Evolutionary Optimization},
    %   author   = {Wang, Bing-Chuan and Li, Han-Xiong and Li, Jia-Peng and Wang, Yong},
    %   journal  = {IEEE Transactions on Systems, Man, and Cybernetics: Systems},
    %   year     = {2019},
    %   number   = {7},
    %   pages    = {1482-1495},
    %   volume   = {49},
    %   doi      = {10.1109/TSMC.2018.2807785},
    % }
    %------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------
    properties (SetAccess = private)
        beta = 6
        mu = 1e-8
        p = 0.5
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'beta', num2str(obj.beta), ...
                        'mu', num2str(obj.mu), ...
                        'p', num2str(obj.p)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.beta = str2double(parameter_cell{count}); count = count + 1;
            obj.mu = str2double(parameter_cell{count}); count = count + 1;
            obj.p = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            sub_pop = run_parameter_list(1);
            sub_eva = run_parameter_list(2);

            F_pool = [0.6, 0.8, 1.0];
            CR_pool = [0.1, 0.2, 1.0];

            convergence = [];
            convergence_cv = [];
            bestX = {};

            for sub_task = 1:length(Tasks)
                Task = Tasks(sub_task);

                % initialize
                [population, fnceval_calls] = initialize(Individual, sub_pop, Task, Task.dims);
                [bestobj, bestCV, best_idx] = min_FP([population.factorial_costs], [population.constraint_violation]);
                bestX_temp = population(best_idx).rnvec;
                converge_temp(1) = bestobj;
                converge_cv_temp(1) = bestCV;

                Ep0 = max([population.constraint_violation]);
                X = 0;

                generation = 1;
                while fnceval_calls < sub_eva
                    generation = generation + 1;

                    cp = (-log(Ep0) - obj.beta) / log(1 - obj.p);
                    % adjust the threshold
                    if X < obj.p
                        Ep = Ep0 * (1 - X)^cp;
                    else
                        Ep = 0;
                    end
                    X = X + fnceval_calls / sub_eva;

                    % diversity restart
                    if std([population.constraint_violation]) < obj.mu && isempty(find([population.constraint_violation] == 0))
                        [population, calls] = initialize(Individual, sub_pop, Task, Task.dims);
                        fnceval_calls = fnceval_calls + calls;
                    end

                    % generation
                    [off_temp, calls] = OperatorC2oDE.generate(population, Task, F_pool, CR_pool);
                    fnceval_calls = fnceval_calls + calls;

                    % pre selection
                    for i = 1:length(population)
                        idx = [(i - 1) * 3 + 1, (i - 1) * 3 + 2, (i - 1) * 3 + 3];
                        [~, ~, best] = min_FP([off_temp(idx).factorial_costs], [off_temp(idx).constraint_violation]);
                        offspring(i) = off_temp(idx(best));
                    end

                    % selection
                    replace_cv = [population.constraint_violation] > [offspring.constraint_violation] & [population.constraint_violation] > Ep & [offspring.constraint_violation] > Ep;
                    equal_cv = [population.constraint_violation] <= Ep & [offspring.constraint_violation] <= Ep;
                    replace_obj = [population.factorial_costs] > [offspring.factorial_costs];
                    replace = (equal_cv & replace_obj) | replace_cv;
                    population(replace) = offspring(replace);

                    % update best
                    [bestobj_now, bestCV_now, best_idx] = min_FP([population.factorial_costs], [population.constraint_violation]);
                    if bestCV_now < bestCV || (bestCV_now == bestCV && bestobj_now < bestobj)
                        bestobj = bestobj_now;
                        bestCV = bestCV_now;
                        bestX_temp = population(best_idx).rnvec;
                    end
                    converge_temp(generation) = bestobj;
                    converge_cv_temp(generation) = bestCV;
                end
                convergence(sub_task, :) = converge_temp;
                convergence_cv(sub_task, :) = converge_cv_temp;
                bestX{sub_task} = bestX_temp;
            end
            data.convergence = gen2eva(convergence);
            data.convergence_cv = gen2eva(convergence_cv);
            data.bestX = uni2real(bestX, Tasks);
        end
    end
end
