classdef MFEA < Algorithm
    % @article{Gupta2016MFEA,
    %     author = {Gupta, Abhishek and Ong, Yew - Soon and Feng, Liang},
    %     journal = {IEEE Transactions on Evolutionary Computation},
    %     title = {Multifactorial Evolution:Toward Evolutionary Multitasking},
    %     year = {2016},
    %     number = {3},
    %     pages = {343 - 357},
    %     volume = {20},
    %     doi = {10.1109 / TEVC.2015.2458037},
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
            obj.mu = str2num(parameter_cell{count}); count = count + 1;
            obj.mum = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            pop_size = run_parameter_list(1);
            iter_num = run_parameter_list(2);
            eva_num = run_parameter_list(3);
            pop_size = fixPopSize(pop_size, length(Tasks));
            tic

            fnceval_calls = 0;

            % initialize
            [population, calls] = initialize(pop_size, Tasks, length(Tasks));
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
                data.bestInd_data{t} = population(rank(1)).rnvec;
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

                [offspring, calls] = OperatorGA.generateMF(1, population, Tasks, obj.rmp, obj.mu, obj.mum);
                fnceval_calls = fnceval_calls + calls;

                population = [population, offspring];

                for t = 1:length(Tasks)
                    for i = 1:length(population)
                        factorial_costs(i) = population(i).factorial_costs(t);
                    end
                    [bestobj_offspring, idx] = min(factorial_costs);
                    if bestobj_offspring < bestobj(t)
                        bestobj(t) = bestobj_offspring;
                        data.bestInd_data{t} = population(idx).rnvec;
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
            data.clock_time = toc;
        end
    end
end
