classdef FP_AT_MFEA < Algorithm
    % <Multi> <Constrained>

    % AT-MFEA with Feasibility Priority for Constrained MTOPs

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
            [population, fnceval_calls, bestobj, bestCV, data.bestX, ~] = initializeMF_FP(Individual, pop_size, Tasks, length(Tasks));
            data.convergence(:, 1) = bestobj;
            data.convergence_cv(:, 1) = bestCV;
            % initialize affine transformation
            [mu_tasks, Sigma_tasks] = InitialDistribution(population, length(Tasks));

            generation = 1;
            while fnceval_calls < eva_num
                generation = generation + 1;

                % generation
                [offspring, calls] = OperatorMFEA_AT.generate(1, population, Tasks, obj.rmp, obj.mu, obj.mum, obj.probswap, mu_tasks, Sigma_tasks);
                fnceval_calls = fnceval_calls + calls;

                % selection
                [population, bestobj, bestCV, data.bestX, ~] = selectMF_FP(population, offspring, Tasks, pop_size, bestobj, bestCV, data.bestX);
                data.convergence(:, generation) = bestobj;
                data.convergence_cv(:, generation) = bestCV;

                % Updates of the progresisonal representation models
                [mu_tasks, Sigma_tasks] = DistributionUpdate(mu_tasks, Sigma_tasks, population, length(Tasks));
            end
            data.convergence(data.convergence_cv > 0) = NaN;
            data.bestX = uni2real(data.bestX, Tasks);
            data.clock_time = toc;
        end
    end
end
