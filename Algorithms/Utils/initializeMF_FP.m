function [population, calls, bestobj, bestCV, bestX, feasible_rate] = initializeMF_FP(Individual_class, pop_size, Tasks, tasks_num)
    %% Multifactorial - Initialize and evaluate the population
    % Input: Individual_class, pop_size, Tasks, tasks_num
    % Output: population, calls (function calls number), bestobj, bestX

    [population, calls] = initialize(Individual_class, pop_size, Tasks, tasks_num);
    feasible_rate = [];
    for t = 1:length(Tasks)
        for i = 1:pop_size
            constraint_violation(i) = population(i).constraint_violation(t);
        end
        idx = ([population.skill_factor] == t);
        feasible_rate(t) = sum(constraint_violation(idx) <= 0) / sum(idx);
        bestCV(t) = min(constraint_violation);
        [~, rank_cv] = sort(constraint_violation);
        for i = 1:pop_size
            population(rank_cv(i)).factorial_ranks(t) = i;
        end
        bestobj(t) = population(rank_cv(1)).factorial_costs(t);
        bestX{t} = population(rank_cv(1)).rnvec;
        if bestCV(t) <= 0
            x = (constraint_violation == bestCV(t));
            idx = 1:length(x);
            idx = idx(x);
            factorial_costs = [];
            for i = 1:length(idx)
                factorial_costs(i) = population(idx(i)).factorial_costs(t);
            end
            [~, rank] = sort(factorial_costs);
            idx = idx(rank);
            for i = 1:length(idx)
                population(idx(i)).factorial_ranks(t) = i;
            end
            bestobj(t) = population(idx(1)).factorial_costs(t);
            bestX{t} = population(idx(1)).rnvec;
        end
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
