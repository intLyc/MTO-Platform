function [population, calls, bestobj, bestX] = initializeMF(Individual_class, pop_size, Tasks, tasks_num)
    %% Multifactorial - Initialize and evaluate the population
    % Input: Individual_class, pop_size, Tasks, tasks_num
    % Output: population, calls (function calls number), bestobj, bestX

    [population, calls] = initialize(Individual_class, pop_size, Tasks, tasks_num);

    for t = 1:length(Tasks)
        for i = 1:pop_size
            factorial_costs(i) = population(i).factorial_costs(t);
        end
        [~, rank] = sort(factorial_costs);
        for i = 1:pop_size
            population(rank(i)).factorial_ranks(t) = i;
        end
        bestobj(t) = population(rank(1)).factorial_costs(t);
        bestX{t} = population(rank(1)).rnvec;
    end

    % Calculate skill factor
    for i = 1:pop_size
        min_rank = min(population(i).factorial_ranks);
        min_idx = find(population(i).factorial_ranks == min_rank);

        population(i).skill_factor = min_idx(randi(length(min_idx)));
        population(i).factorial_costs(1:population(i).skill_factor - 1) = inf;
        population(i).factorial_costs(population(i).skill_factor + 1:end) = inf;
    end
end
