function [population, calls, bestDec, bestObj, bestCV] = initializeMF(Individual_class, pop_size, Tasks, dim)
    %% Initialize and evaluate the population
    % Input: Individual_class, pop_size, Tasks, dim
    % Output: population, calls (function calls number), bestDec, bestObj, bestCV

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    for i = 1:pop_size
        population(i) = Individual_class();
        population(i).Dec = rand(1, dim);
        population(i).Obj = inf(1, length(Tasks));
        population(i).CV = inf(1, length(Tasks));
    end
    calls = 0;
    for t = 1:length(Tasks)
        [population, cal] = evaluate(population, Tasks(t), t);
        calls = calls + cal;
    end

    for t = 1:length(Tasks)
        for i = 1:length(population)
            Obj(i) = population(i).Obj(t);
            CV(i) = population(i).CV(t);
        end
        [bestObj(t), bestCV(t), best_idx] = min_FP(Obj, CV);
        bestDec{t} = population(best_idx).Dec;

        rank = sort_FP(Obj, CV);
        for i = 1:length(population)
            population(rank(i)).factorial_ranks(t) = i;
        end
    end

    % Calculate skill factor
    for i = 1:pop_size
        min_rank = min(population(i).factorial_ranks);
        min_idx = find(population(i).factorial_ranks == min_rank);

        population(i).skill_factor = min_idx(randi(length(min_idx)));
        population(i).Obj(1:population(i).skill_factor - 1) = inf;
        population(i).Obj(population(i).skill_factor + 1:end) = inf;
    end
end
