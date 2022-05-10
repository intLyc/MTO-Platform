classdef TLTLA < Algorithm
    % <Multi> <None>

    %------------------------------- Reference --------------------------------
    % @Article{Ma2020TLTLA,
    %   author    = {Ma, Xiaoliang and Chen, Qunjian and Yu, Yanan and Sun, Yiwen and Ma, Lijia and Zhu, Zexuan},
    %   journal   = {Frontiers in neuroscience},
    %   title     = {A Two-level Transfer Learning Algorithm for Evolutionary Multitasking},
    %   year      = {2020},
    %   pages     = {1408},
    %   volume    = {13},
    %   publisher = {Frontiers},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

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
            [population, fnceval_calls, bestobj, data.bestX] = initializeMF(Individual, pop_size, Tasks, max([Tasks.dims]));
            data.convergence(:, 1) = bestobj;

            generation = 1;
            while fnceval_calls < eva_num
                generation = generation + 1;

                % Upper-level: Inter-task Knowledge Transfer
                % generation
                [offspring, calls] = OperatorMFEA.generate(1, population, Tasks, obj.rmp, obj.mu, obj.mum);
                fnceval_calls = fnceval_calls + calls;
                % selection
                [population, bestobj, data.bestX] = selectMF(population, offspring, Tasks, pop_size, bestobj, data.bestX);

                % Lower-level: Intra-task Knowledge Transfer
                parent = randi(length(population));
                t = population(parent).skill_factor;
                dimen = mod(generation - 2, max([Tasks.dims])) + 1; % start with 1 Dim
                child_rnvec = zeros(size(population(parent)));
                pool = population([population.skill_factor] == t);
                for d = 1:max([Tasks.dims])
                    x = randperm(length(pool), min(3, length(pool)));
                    if length(pool) < 3
                        child_rnvec(d) = pool(x(1)).rnvec(dimen);
                        continue;
                    end
                    if rand > 0.5
                        child_rnvec(d) = pool(x(1)).rnvec(dimen) + 0.5 * rand * (pool(x(2)).rnvec(dimen) - pool(x(3)).rnvec(dimen));
                    else
                        child_rnvec(d) = pool(x(1)).rnvec(dimen) + 0.5 * rand * (pool(x(3)).rnvec(dimen) - pool(x(2)).rnvec(dimen));
                    end
                end
                child_rnvec(child_rnvec > 1) = 1;
                child_rnvec(child_rnvec < 0) = 0;

                if rand > 0.5
                    tmp_population = population(parent);
                    for d = 1:max([Tasks.dims])
                        tmp_population.rnvec(d) = child_rnvec(d);
                        [tmp_population, calls] = evaluate(tmp_population, Tasks(t), t);
                        fnceval_calls = fnceval_calls + calls;

                        if tmp_population.factorial_costs(t) < population(parent).factorial_costs(t)
                            population(parent) = tmp_population;
                            break;
                        end
                    end
                else
                    for d = 1:max([Tasks.dims])
                        tmp_population = population(parent);
                        tmp_population.rnvec(d) = child_rnvec(d);
                        [tmp_population, calls] = evaluate(tmp_population, Tasks(t), t);
                        fnceval_calls = fnceval_calls + calls;

                        if tmp_population.factorial_costs(t) < population(parent).factorial_costs(t)
                            population(parent) = tmp_population;
                            break;
                        end
                    end
                end

                if population(parent).factorial_costs(t) < bestobj(t)
                    bestobj(t) = population(parent).factorial_costs(t);
                    bestX{t} = population(parent).rnvec;
                end

                data.convergence(:, generation) = bestobj;
            end
            data.convergence = gen2eva(data.convergence);
            data.bestX = uni2real(data.bestX, Tasks);
            data.clock_time = toc;
        end
    end
end
