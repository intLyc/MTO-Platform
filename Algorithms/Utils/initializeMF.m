function [population, calls, bestobj, bestX] = initializeMF(Individual_class, pop_size, Tasks, dim)
    %% Multifactorial - Initialize and evaluate the population
    % Input: Individual_class, pop_size, Tasks, dim
    % Output: population, calls (function calls number), bestobj, bestX

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

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
