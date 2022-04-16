function [population, calls, bestobj, bestCV, bestX] = initializeMF_FP(Individual_class, pop_size, Tasks, dim)
    %% Multifactorial - Initialize and evaluate the population
    % Input: Individual_class, pop_size, Tasks, dim
    % Output: population, calls (function calls number), bestobj, bestX

    for i = 1:pop_size
        population(i) = Individual_class();
        population(i).rnvec = rand(1, dim);
        population(i).factorial_costs = inf(1, length(Tasks));
        population(i).constraint_violation = inf(1, length(Tasks));
    end
    calls = 0;
    for t = 1:length(Tasks)
        [population, cal] = evaluate(population, Tasks(t), t);
        calls = calls + cal;
    end

    for t = 1:length(Tasks)
        for i = 1:pop_size
            constraint_violation(i) = population(i).constraint_violation(t);
        end
        bestCV(t) = min(constraint_violation);
        [~, rank_cv] = sort(constraint_violation);
        for i = 1:pop_size
            population(rank_cv(i)).factorial_ranks(t) = i;
        end
        bestobj(t) = population(rank_cv(1)).factorial_costs(t);
        bestX{t} = population(rank_cv(1)).rnvec;
        if bestCV(t) <= 0
            idx = find(constraint_violation == bestCV(t));
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
