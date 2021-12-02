classdef LDA_MFEA < Algorithm
    % @inproceedings{bali2017LDA-MFEA,
    %     author    = {Bali, Kavitesh Kumar and Gupta, Abhishek and Feng, Liang and Ong, Yew Soon and Tan Puay Siew},
    %     booktitle = {2017 IEEE Congress on Evolutionary Computation (CEC)},
    %     title     = {Linearized domain adaptation in evolutionary multitasking},
    %     year      = {2017},
    %     volume    = {},
    %     number    = {},
    %     pages     = {1295-1302},
    %     doi       = {10.1109/CEC.2017.7969454},
    % }

    properties (SetAccess = private)
        rmp = 0.3
        mu = 2; % index of Simulated Binary Crossover (tunable)
        mum = 5; % index of polynomial mutation
        store_max = 1000;
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'rmp: Random Mating Probability', num2str(obj.rmp), ...
                        'mu: index of Simulated Binary Crossover (tunable)', num2str(obj.mu), ...
                        'mum: index of polynomial mutation', num2str(obj.mum), ...
                        'store_max: gene store max length', num2str(obj.store_max)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.rmp = str2double(parameter_cell{count}); count = count + 1;
            obj.mu = str2double(parameter_cell{count}); count = count + 1;
            obj.mum = str2double(parameter_cell{count}); count = count + 1;
            obj.store_max = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            pop_size = run_parameter_list(1);
            iter_num = run_parameter_list(2);
            eva_num = run_parameter_list(3);
            pop_size = fixPopSize(pop_size, length(Tasks));
            tic

            fnceval_calls = 0;
            for t = 1:length(Tasks)
                P{t} = [];
                M{t} = [];
            end

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

                % Extract Task specific Data Sets
                for t = 1:length(Tasks)
                    subpops(t).data = [];
                    f(t).cost = [];
                end
                for i = 1:length(population)
                    subpops(population(i).skill_factor).data = [subpops(population(i).skill_factor).data; population(i).rnvec];
                    f(population(i).skill_factor).cost = [f(population(i).skill_factor).cost; population(i).factorial_costs(population(i).skill_factor)];
                end

                for t = 1:length(Tasks)
                    if size(P{t}, 1) > obj.store_max
                        P{t} = P{t}(end - obj.store_max:end, :);
                    end
                    % accumulate all historical points of t  and sort according to factorial cost
                    temp = [P{t}; [subpops(t).data, f(t).cost]];
                    temp = sortrows(temp, max([Tasks.dims]) + 1);
                    P{t} = temp;
                    M{t} = temp(:, 1:end - 1); %extract chromosomes except the last column(factorial_costs), store into matrix
                end

                [offspring, calls] = OperatorGA_LDA.generateMF(1, population, Tasks, obj.rmp, obj.mu, obj.mum, M);
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
                data.bestX{t} = Tasks(t).Lb + data.bestX{t}(1:Tasks(t).dims) .* (Tasks(t).Ub - Tasks(t).Lb);
            end
            data.clock_time = toc;
        end
    end
end
