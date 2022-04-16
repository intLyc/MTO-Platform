classdef MFEA_GHS < Algorithm
    % <Multi> <None>

    % @Article{Liang2019MFEA-GHS,
    %   author   = {Zhengping Liang and Jian Zhang and Liang Feng and Zexuan Zhu},
    %   journal  = {Expert Systems with Applications},
    %   title    = {A Hybrid of Genetic Transform and Hyper-rectangle Search Strategies for Evolutionary Multi-tasking},
    %   year     = {2019},
    %   volume   = {138},
    % }

    properties (SetAccess = private)
        rmp = 0.3
        mu = 2;
        mum = 5;
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'rmp: Random Mating Probability', num2str(obj.rmp), ...
                        'mu: index of Simulated Binary Crossover', num2str(obj.mu), ...
                        'mum: index of polynomial mutation', num2str(obj.mum)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.rmp = str2double(parameter_cell{count}); count = count + 1;
            obj.mu = str2double(parameter_cell{count}); count = count + 1;
            obj.mum = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            sub_pop = run_parameter_list(1);
            sub_eva = run_parameter_list(2);
            pop_size = sub_pop * length(Tasks);
            eva_num = sub_eva * length(Tasks);
            tic

            % initialize
            [population, fnceval_calls, bestobj, data.bestX] = initializeMFone(Individual, pop_size, Tasks, max([Tasks.dims]));
            data.convergence(:, 1) = bestobj;
            [max_T, min_T] = cal_max_min(population, Tasks);
            M = {};
            for t = 1:length(Tasks)
                M{t} = ones(1, max(Tasks.dims));
            end

            generation = 1;
            while fnceval_calls < eva_num
                generation = generation + 1;

                % generation
                a = mod(generation, 2);
                [offspring, calls] = OperatorMFEA_GHS.generate(1, population, Tasks, obj.rmp, obj.mu, obj.mum, a, max_T, min_T, M);
                fnceval_calls = fnceval_calls + calls;

                % selection
                [population, bestobj, data.bestX] = selectMF(population, offspring, Tasks, pop_size, bestobj, data.bestX);
                data.convergence(:, generation) = bestobj;

                % update
                [max_T, min_T] = cal_max_min(population, Tasks);
                M = domain_ad(population, Tasks);
            end
            data.bestX = uni2real(data.bestX, Tasks);
            data.clock_time = toc;
        end
    end
end
