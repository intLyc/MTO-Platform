function [population, bestobj, bestCV, bestX] = selectMF_SR(population, offspring, Tasks, pop_size, bestobj, bestCV, bestX, sr)
    %% Constrained - Stochastic Ranking
    %% Multifactorial - Elite selection based on scalar fitness
    % Input: population (old), offspring, Tasks, pop_size, bestobj, bestX, sr
    % Output: population (new), bestobj, bestX

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    population = [population, offspring];

    for t = 1:length(Tasks)
        for i = 1:length(population)
            factorial_costs(i) = population(i).factorial_costs(t);
            constraint_violation(i) = population(i).constraint_violation(t);
        end
        [~, rank_cv] = sort(constraint_violation);
        bestCV_now = constraint_violation(rank_cv(1));
        idx = find(constraint_violation == bestCV_now);
        [bestobj_now, best_idx] = min(factorial_costs(idx));

        if bestCV_now < bestCV(t) || (bestCV_now == bestCV(t) && bestobj_now < bestobj(t))
            bestobj(t) = bestobj_now;
            bestCV(t) = bestCV_now;
            bestX{t} = population(idx(best_idx)).rnvec;
        end

        rank = sort_SR(factorial_costs, constraint_violation, sr);
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
