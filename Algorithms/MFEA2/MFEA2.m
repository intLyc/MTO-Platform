classdef MFEA2 < Algorithm
    % @article{bali2019MFEA2,
    %     author = {Bali, Kavitesh Kumar and Ong, Yew - Soon and Gupta, Abhishek and Tan, Puay Siew},
    %     journal = {IEEE Transactions on Evolutionary Computation},
    %     title = {Multifactorial Evolutionary Algorithm With Online Transfer Parameter Estimation:MFEA - II},
    %     year = {2020},
    %     volume = {24},
    %     number = {1},
    %     pages = {69 - 83},
    %     doi = {10.1109 / TEVC.2019.2906927},
    % }

    properties (SetAccess = private)
        mu = 2; % index of Simulated Binary Crossover (tunable)
        mum = 5; % index of polynomial mutation
        probswap = 0.5; % probability of variable swap
    end

    methods

        function parameter = getParameter(obj)
            parameter = {'mu: index of Simulated Binary Crossover (tunable)', num2str(obj.mu), ...
                        'mum: index of polynomial mutation', num2str(obj.mum), ...
                        'probSwap: Variable Swap Probability', num2str(obj.probswap)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.mu = str2double(parameter_cell{count}); count = count + 1;
            obj.mum = str2double(parameter_cell{count}); count = count + 1;
            obj.probswap = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            pop_size = run_parameter_list(1);
            iter_num = run_parameter_list(2);
            eva_num = run_parameter_list(3);
            pop_size = fixPopSize(pop_size, length(Tasks));
            tic

            fnceval_calls = 0;

            % initialize
            [population, calls] = initialize(Individual, pop_size, Tasks, length(Tasks));
            fnceval_calls = fnceval_calls + calls;

            for t = 1:length(Tasks)
                for i = 1:pop_size
                    factorial_costs(i) = population(i).factorial_costs(t);
                end
                [~, rank] = sort(factorial_costs);
                for i = 1:pop_size
                    population(i).factorial_ranks(t) = rank(i);
                end
                bestobj(t) = population(rank(1)).factorial_costs(t);
                data.bestX{t} = population(rank(1)).rnvec;
                data.convergence(t, 1) = bestobj(t);
            end

            % calculate skill factor
            for i = 1:pop_size
                min_rank = min(population(i).factorial_ranks);
                min_idx = find(population(i).factorial_ranks == min_rank);

                population(i).skill_factor = min_idx(randi(length(min_idx)));
                population(i).factorial_costs(1:population(i).skill_factor - 1) = inf;
                population(i).factorial_costs(population(i).skill_factor + 1:end) = inf;
            end

            generation = 1;
            while generation < iter_num && fnceval_calls < eva_num
                generation = generation + 1;

                % Extract task specific data sets
                for t = 1:length(Tasks)
                    subpops(t).data = [];
                end
                for i = 1:length(population)
                    subpops(population(i).skill_factor).data = [subpops(population(i).skill_factor).data; population(i).rnvec];
                end
                RMP = learnRMP(subpops, [Tasks.dims]); % learning RMP matrix online at every generation.

                [offspring, calls] = OperatorMFEA2.generateMF(1, population, Tasks, RMP, obj.mu, obj.mum, obj.probswap);
                fnceval_calls = fnceval_calls + calls;

                % selection
                population = [population, offspring];
                for t = 1:length(Tasks)
                    for i = 1:length(population)
                        factorial_costs(i) = population(i).factorial_costs(t);
                    end
                    [bestobj_offspring, idx] = min(factorial_costs);
                    if bestobj_offspring < bestobj(t)
                        bestobj(t) = bestobj_offspring;
                        data.bestX{t} = population(idx).rnvec;
                    end
                    data.convergence(t, generation) = bestobj(t);

                    [~, rank] = sort(factorial_costs);
                    for i = 1:length(population)
                        population(rank(i)).factorial_ranks(t) = i;
                    end
                end
                for i = 1:length(population)
                    population(i).scalar_fitness = 1 / min([population(i).factorial_ranks]);
                end
                [~, rank] = sort(- [population.scalar_fitness]);
                population = population(rank(1:pop_size));
            end
            % map to real bound
            for t = 1:length(Tasks)
                data.bestX{t} = Tasks(t).Lb + data.bestX{t} .* (Tasks(t).Ub - Tasks(t).Lb);
            end
            data.clock_time = toc;
        end
    end
end
