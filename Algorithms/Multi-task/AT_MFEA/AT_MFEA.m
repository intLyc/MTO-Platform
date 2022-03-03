classdef AT_MFEA < Algorithm
    % <Multi> <None>

    % @Article{Xue2020AT-MFEA,
    %   author     = {Xue, Xiaoming and Zhang, Kai and Tan, Kay Chen and Feng, Liang and Wang, Jian and Chen, Guodong and Zhao, Xinggang and Zhang, Liming and Yao, Jun},
    %   journal    = {IEEE Transactions on Cybernetics},
    %   title      = {Affine Transformation-Enhanced Multifactorial Optimization for Heterogeneous Problems},
    %   year       = {2020},
    %   pages      = {1-15},
    %   doi        = {10.1109/TCYB.2020.3036393},
    % }

    properties (SetAccess = private)
        rmp = 0.3
        mu = 2; % index of Simulated Binary Crossover (tunable)
        mum = 5; % index of polynomial mutation
        probswap = 0; % probability of variable swap
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'rmp: Random Mating Probability', num2str(obj.rmp), ...
                        'mu: index of Simulated Binary Crossover (tunable)', num2str(obj.mu), ...
                        'mum: index of polynomial mutation', num2str(obj.mum), ...
                        'probSwap: Variable Swap Probability', num2str(obj.probswap)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.rmp = str2double(parameter_cell{count}); count = count + 1;
            obj.mu = str2double(parameter_cell{count}); count = count + 1;
            obj.mum = str2double(parameter_cell{count}); count = count + 1;
            obj.probswap = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            sub_pop = run_parameter_list(1);
            sub_eva = run_parameter_list(2);
            pop_size = sub_pop * length(Tasks);
            eva_num = sub_eva * length(Tasks);
            tic

            % initialize
            [population, fnceval_calls, bestobj, data.bestX] = initializeMF(Individual, pop_size, Tasks, length(Tasks));
            data.convergence(:, 1) = bestobj;
            % initialize affine transformation
            [mu_tasks, Sigma_tasks] = InitialDistribution(population, length(Tasks));

            generation = 1;
            while fnceval_calls < eva_num
                generation = generation + 1;

                % generation
                [offspring, calls] = OperatorMFEA_AT.generate(1, population, Tasks, obj.rmp, obj.mu, obj.mum, obj.probswap, mu_tasks, Sigma_tasks);
                fnceval_calls = fnceval_calls + calls;

                % selection
                [population, bestobj, data.bestX] = selectMF(population, offspring, Tasks, pop_size, bestobj, data.bestX);
                data.convergence(:, generation) = bestobj;

                % Updates of the progresisonal representation models
                [mu_tasks, Sigma_tasks] = DistributionUpdate(mu_tasks, Sigma_tasks, population, length(Tasks));
            end
            data.bestX = uni2real(data.bestX, Tasks);
            data.clock_time = toc;
        end
    end
end
