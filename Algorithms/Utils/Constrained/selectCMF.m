function [population, bestobj, bestCV, bestX] = selectCMF(population, offspring, Tasks, pop_size, bestobj, bestCV, bestX, varargin)
    %% Constrained Multifactorial - Elite selection based on scalar fitness
    % Input: population (old), offspring, Tasks, pop_size, bestobj, bestCV, bestX, type
    % Output: population (new), bestobj, bestCV, bestX

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    n = numel(varargin);
    if n == 0
        type = 'Feasible_Priority'; % unified [0, 1]
    elseif n == 2
        type = varargin{1};
        sr = varargin{2};
    end

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

        switch type
            case 'Feasible_Priority'
                rank = sort_FP(factorial_costs, constraint_violation);
            case 'Stochastic_Ranking'
                rank = sort_SR(factorial_costs, constraint_violation, sr);
        end
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
