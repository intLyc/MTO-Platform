classdef MFDE < Algorithm
    % @InProceedings{Feng2017MFDE-MFPSO,
    %     author    = {Feng, L. and Zhou, W. and Zhou, L. and Jiang, S. W. and Zhong, J. H. and Da, B. S. and Zhu, Z. X. and Wang, Y.},
    %     booktitle = {2017 IEEE Congress on Evolutionary Computation (CEC)},
    %     title     = {An empirical study of multifactorial PSO and multifactorial DE},
    %     year      = {2017},
    %     pages     = {921-928},
    %     doi       = {10.1109/CEC.2017.7969407},
    % }

    properties (SetAccess = private)
        rmp = 0.3
        F = 0.5
        pCR = 0.9
    end

    methods

        function parameter = getParameter(obj)
            parameter = {'rmp: Random Mating Probability', num2str(obj.rmp), ...
                        'F: Mutation Factor', num2str(obj.F), ...
                        'pCR: Crossover Probability', num2str(obj.pCR)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.rmp = str2double(parameter_cell{count}); count = count + 1;
            obj.F = str2double(parameter_cell{count}); count = count + 1;
            obj.pCR = str2double(parameter_cell{count}); count = count + 1;
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

                [offspring, calls] = OperatorDE.generateMF(1, population, Tasks, obj.rmp, obj.F, obj.pCR);
                fnceval_calls = fnceval_calls + calls;

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
