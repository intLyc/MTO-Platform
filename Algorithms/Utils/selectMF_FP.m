function [population, bestobj, bestCV, bestX, feasible_rate] = selectMF_FP(population, offspring, Tasks, pop_size, bestobj, bestCV, bestX)
    %% Multifactorial - Elite selection based on scalar fitness
    % Input: population (old), offspring, Tasks, pop_size, bestobj, bestX
    % Output: population (new), bestobj, bestX

    population = [population, offspring];

    for t = 1:length(Tasks)
        for i = 1:length(population)
            constraint_violation(i) = population(i).constraint_violation(t);
        end
        idx = ([population.skill_factor] == t);
        feasible_rate(t) = sum(constraint_violation(idx) <= 0) / sum(idx);
        [~, rank_cv] = sort(constraint_violation);
        for i = 1:length(population)
            population(rank_cv(i)).factorial_ranks(t) = i;
        end
        bestobj_now = population(rank_cv(1)).factorial_costs(t);
        bestCV_now = constraint_violation(rank_cv(1));
        best_idx = rank_cv(1);
        if bestCV_now <= 0
            x = (constraint_violation == bestCV_now);
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
            bestobj_now = population(idx(1)).factorial_costs(t);
            best_idx = idx(1);
        end

        if bestCV_now <= bestCV(t) && bestobj_now < bestobj(t)
            bestobj(t) = bestobj_now;
            bestCV(t) = bestCV_now;
            bestX{t} = population(best_idx).rnvec;
        end
    end
    for i = 1:length(population)
        population(i).scalar_fitness = 1 / min([population(i).factorial_ranks]);
    end

    [~, rank] = sort(- [population.scalar_fitness]);
    population = population(rank(1:pop_size));
end
