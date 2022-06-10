classdef CORCO < Algorithm
    % <Single> <Constrained>

    %------------------------------- Reference --------------------------------
    % @Article{Wang2020CORCO,
    %   title    = {Utilizing the Correlation Between Constraints and Objective Function for Constrained Evolutionary Optimization},
    %   author   = {Wang, Yong and Li, Jia-Peng and Xue, Xihui and Wang, Bing-chuan},
    %   journal  = {IEEE Transactions on Evolutionary Computation},
    %   year     = {2020},
    %   number   = {1},
    %   pages    = {29-43},
    %   volume   = {24},
    %   doi      = {10.1109/TEVC.2019.2904900},
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
        lp = 0.05
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'F pool: Mutation Factor', obj.F, ...
                        'CR pool: Crossover Probability', obj.CR, ...
                        'lp: learning period', num2str(obj.lp)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.F = parameter_cell{count}; count = count + 1;
            obj.CR = parameter_cell{count}; count = count + 1;
            obj.lp = str2double(parameter_cell{count}); count = count + 1;
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
                X = 0;
                cor_idx = 0;
                div_delta = 0;
                p = reshape([population.rnvec], length(population(1).rnvec), length(population))';
                div_init = sum(std(p)) / size(p, 2);
                betterRecord1 = [];
                betterRecord2 = [];

                generation = 1;
                while fnceval_calls < obj.lp * sub_eva
                    generation = generation + 1;

                    % learning stage
                    weights = WeightGenerator(length(population), [population.constraint_violation], [population.factorial_costs], X, cor_idx, div_delta, 1);

                    % generation
                    [offspring, calls] = OperatorCORCO.generate(1, population, Task, F_pool, CR_pool, weights, fnceval_calls, sub_eva);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    [population, bestobj, bestCV, bestX_temp] = selectCORCO(population, offspring, weights, bestobj, bestCV, bestX_temp);
                    [archive, bestobj, bestCV, bestX_temp] = selectCORCOarchive(archive, offspring, 1, bestobj, bestCV, bestX_temp);

                    [con_obj_betterNum, obj_con_betterNum] = InterCompare([archive.factorial_costs], [archive.constraint_violation], [population.factorial_costs], [population.constraint_violation]);
                    p = reshape([population.rnvec], length(population(1).rnvec), length(population))';
                    div_idx = sum(std(p)) / size(p, 2);
                    betterRecord1 = [betterRecord1, con_obj_betterNum];
                    betterRecord2 = [betterRecord2, obj_con_betterNum];

                    converge_temp(generation) = bestobj;
                    converge_cv_temp(generation) = bestCV;
                end

                recordLength = length(betterRecord1);
                betterLength1 = sum(betterRecord1 ~= 0);
                betterLength2 = sum(betterRecord2 ~= 0);
                betterLength = min(betterLength1, betterLength2);
                cor_idx = betterLength / recordLength;
                div_delta = div_init - div_idx;

                while fnceval_calls < sub_eva
                    generation = generation + 1;

                    weights = WeightGenerator(length(population), [population.constraint_violation], [population.factorial_costs], X, cor_idx, div_delta, 2);
                    X = X + sub_pop / sub_eva;

                    % generation
                    [offspring, calls] = OperatorCORCO.generate(1, population, Task, F_pool, CR_pool, weights, fnceval_calls, sub_eva);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    [population, bestobj, bestCV, bestX_temp] = selectCORCO(population, offspring, weights, bestobj, bestCV, bestX_temp);
                    [archive, bestobj, bestCV, bestX_temp] = selectCORCOarchive(archive, offspring, 2, bestobj, bestCV, bestX_temp);
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
