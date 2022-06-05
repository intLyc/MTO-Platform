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
        F = '0.6/0.8/1.0'
        CR = '0.1/0.2/1.0'
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'F pool: Mutation Factor', obj.F, ...
                        'CR pool: Crossover Probability', obj.CR};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.F = parameter_cell{count}; count = count + 1;
            obj.CR = parameter_cell{count}; count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            sub_pop = run_parameter_list(1);
            sub_eva = run_parameter_list(2);

            F_pool = str2double(string(split(obj.F, '/')));
            CR_pool = str2double(string(split(obj.CR, '/')));
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
                VAR0 = min(10^(Tasks.dims / 2), max([population.constraint_violation]));
                cp = (-log(VAR0) - 6) / log(1 - 0.85);
                pmax = 1;
                X = 0;

                generation = 1;
                while fnceval_calls < sub_eva
                    generation = generation + 1;

                    if X < 0.85
                        VAR = VAR0 * (1 - X)^cp;
                    else
                        VAR = 0;
                    end
                    X = X + sub_pop / sub_eva;

                    if length(find([population.constraint_violation] == 0)) > 0.85 * length(population)
                        VAR = 0;
                    end

                    rand_idx = randperm(length(population));
                    population = population(rand_idx);
                    archive = archive(rand_idx);

                    if isempty(find([population.constraint_violation] < VAR, 1))
                        pmax = 1e-18;
                    end

                    pr = max(1e-18, pmax / (1 + exp(30 * (fnceval_calls / sub_eva - 0.75))));

                    % diversity restart
                    if std([population.constraint_violation]) < 1e-6 && isempty(find([population.constraint_violation] == 0, 1))
                        [population, calls] = initialize(Individual, sub_pop, Task, Task.dims);
                        fnceval_calls = fnceval_calls + calls;
                    end

                    weights = [0:pr / length(population):pr - pr / length(population)];
                    weights = weights(randperm(length(weights)));

                    % generation
                    [offspring, calls] = OperatorDeCODE.generate(1, population, Task, F_pool, CR_pool, weights, fnceval_calls, sub_eva);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    [population, bestobj, bestCV, bestX_temp] = selectDeCODE(population, offspring, weights, bestobj, bestCV, bestX_temp);
                    [archive, bestobj, bestCV, bestX_temp] = selectDeCODEarchive(archive, offspring, bestobj, bestCV, bestX_temp);
                    converge_temp(generation) = bestobj;
                    converge_cv_temp(generation) = bestCV;
                end
                convergence = [convergence; converge_temp];
                convergence_cv = [convergence_cv; converge_cv_temp];
                bestX = [bestX, bestX_temp];
            end
            data.convergence = gen2eva(convergence);
            data.convergence_cv = gen2eva(convergence_cv);
            data.bestX = uni2real(bestX, Tasks);
        end
    end
end
