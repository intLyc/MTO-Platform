classdef TLTLA < Algorithm
    % @Article{Ma2020TLTLA,
    %   author    = {Ma, Xiaoliang and Chen, Qunjian and Yu, Yanan and Sun, Yiwen and Ma, Lijia and Zhu, Zexuan},
    %   journal   = {Frontiers in neuroscience},
    %   title     = {A Two-level Transfer Learning Algorithm for Evolutionary Multitasking},
    %   year      = {2020},
    %   pages     = {1408},
    %   volume    = {13},
    %   publisher = {Frontiers},
    % }

    properties (SetAccess = private)
        rmp = 0.3
        mu = 2; % index of Simulated Binary Crossover (tunable)
        mum = 5; % index of polynomial mutation
    end

    methods

        function parameter = getParameter(obj)
            parameter = {'rmp: Random Mating Probability', num2str(obj.rmp), ...
                        'mu: index of Simulated Binary Crossover (tunable)', num2str(obj.mu), ...
                        'mum: index of polynomial mutation', num2str(obj.mum)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.rmp = str2double(parameter_cell{count}); count = count + 1;
            obj.mu = str2double(parameter_cell{count}); count = count + 1;
            obj.mum = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            pop_size = run_parameter_list(1);
            iter_num = run_parameter_list(2);
            eva_num = run_parameter_list(3);
            pop_size = fixPopSize(pop_size, length(Tasks));
            tic

            % initialize
            [population, fnceval_calls, bestobj, data.bestX] = initializeMF(Individual, pop_size, Tasks, length(Tasks));
            data.convergence(:, 1) = bestobj;

            generation = 1;
            while generation < iter_num && fnceval_calls < eva_num
                generation = generation + 1;

                if mod(generation, 2) == 0
                    % Intra-Task Knowledge Transfer
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
                else
                    % Inter-Task Knowledge Transfer
                    % generation
                    [offspring, calls] = OperatorGA.generateMF(1, population, Tasks, obj.rmp, obj.mu, obj.mum);
                    fnceval_calls = fnceval_calls + calls;
                    % selection
                    [population, bestobj, data.bestX] = selectMF(population, offspring, Tasks, pop_size, bestobj, data.bestX);
                end
                data.convergence(:, generation) = bestobj;
            end
            data.bestX = bin2real(data.bestX, Tasks);
            data.clock_time = toc;
        end
    end
end
