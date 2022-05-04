function [population, calls, bestobj, bestCV, bestX] = initializeCMF(Individual_class, pop_size, Tasks, dim, varargin)
    %% Constrained Multifactorial - Initialize and evaluate the population
    % Input: Individual_class, pop_size, Tasks, dim
    % Output: population, calls (function calls number), bestobj, bestCV, bestX, type

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
        for i = 1:length(population)
            factorial_costs(i) = population(i).factorial_costs(t);
            constraint_violation(i) = population(i).constraint_violation(t);
        end
        [~, rank_cv] = sort(constraint_violation);
        bestCV(t) = constraint_violation(rank_cv(1));
        idx = find(constraint_violation == bestCV(t));
        [bestobj(t), best_idx] = min(factorial_costs(idx));
        bestX{t} = population(idx(best_idx)).rnvec;

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

    % Calculate skill factor
    for i = 1:pop_size
        min_rank = min(population(i).factorial_ranks);
        min_idx = find(population(i).factorial_ranks == min_rank);

        population(i).skill_factor = min_idx(randi(length(min_idx)));
        population(i).factorial_costs(1:population(i).skill_factor - 1) = inf;
        population(i).factorial_costs(population(i).skill_factor + 1:end) = inf;
    end
end
