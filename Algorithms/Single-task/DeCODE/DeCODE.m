classdef DeCODE < Algorithm
    % <Single> <Constrained>

    %------------------------------- Reference --------------------------------
    % @Article{Wang2021DeCODE,
    %   title    = {Decomposition-Based Multiobjective Optimization for Constrained Evolutionary Optimization},
    %   author   = {Wang, Bing-Chuan and Li, Han-Xiong and Zhang, Qingfu and Wang, Yong},
    %   journal  = {IEEE Transactions on Systems, Man, and Cybernetics: Systems},
    %   year     = {2021},
    %   number   = {1},
    %   pages    = {574-587},
    %   volume   = {51},
    %   doi      = {10.1109/TSMC.2018.2876335},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------
    properties (SetAccess = private)
        alpha = 0.75
        beta = 6
        gama = 30
        mu = 1e-6
        p = 0.85
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'alpha', num2str(obj.alpha), ...
                        'beta', num2str(obj.beta), ...
                        'gama', num2str(obj.gama), ...
                        'mu', num2str(obj.mu), ...
                        'p', num2str(obj.p)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.alpha = str2double(parameter_cell{count}); count = count + 1;
            obj.beta = str2double(parameter_cell{count}); count = count + 1;
            obj.gama = str2double(parameter_cell{count}); count = count + 1;
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

                archive = population;
                Ep0 = min(10^(Task.dims / 2), max([population.constraint_violation]));
                cp = (-log(Ep0) - obj.beta) / log(1 - obj.p);
                pmax = 1;
                X = 0;

                generation = 1;
                while fnceval_calls < sub_eva
                    generation = generation + 1;

                    if X < obj.p
                        Ep = Ep0 * (1 - X)^cp;
                    else
                        Ep = 0;
                    end
                    X = X + sub_pop / sub_eva;

                    if length(find([population.constraint_violation] == 0)) > obj.p * length(population)
                        Ep = 0;
                    end

                    rand_idx = randperm(length(population));
                    population = population(rand_idx);
                    archive = archive(rand_idx);

                    if isempty(find([population.constraint_violation] < Ep))
                        pmax = 1e-18;
                    end

                    pr = max(1e-18, pmax / (1 + exp(obj.gama * (fnceval_calls / sub_eva - obj.alpha))));

                    % diversity restart
                    if std([population.constraint_violation]) < obj.mu && isempty(find([population.constraint_violation] == 0))
                        [population, calls] = initialize(Individual, sub_pop, Task, Task.dims);
                        fnceval_calls = fnceval_calls + calls;
                    end

                    weights = [0:pr / length(population):pr - pr / length(population)];
                    weights(randperm(length(weights))) = weights;

                    % generation
                    [offspring, calls] = OperatorDeCODE.generate(population, Task, F_pool, CR_pool, weights, fnceval_calls, sub_eva);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    [population, bestobj, bestCV, bestX_temp] = selectDeCODE(population, offspring, weights, bestobj, bestCV, bestX_temp);
                    [archive, bestobj, bestCV, bestX_temp] = selectDeCODEarchive(archive, offspring, bestobj, bestCV, bestX_temp);
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
