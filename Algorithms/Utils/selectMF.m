function [population, bestDec, bestObj, bestCV] = selectMF(population, offspring, Tasks, pop_size, bestDec, bestObj, varargin)
    %% Elite selection based on scalar fitness
    % Input: population (old), offspring, Tasks, pop_size, bestDec, bestObj, bestCV
    % Output: population (new), bestDec, bestObj, bestCV

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    n = numel(varargin);
    if n == 0
        bestCV = zeros(size(bestObj));
    elseif n == 1
        bestCV = varargin{1};
    end

    population = [population, offspring];

    for t = 1:length(Tasks)
        for i = 1:length(population)
            Obj(i) = population(i).Obj(t);
            CV(i) = population(i).CV(t);
        end
        [bestObj_now, bestCV_now, best_idx] = min_FP(Obj, CV);
        if bestCV_now < bestCV(t) || (bestCV_now == bestCV(t) && bestObj_now <= bestObj(t))
            bestObj(t) = bestObj_now;
            bestCV(t) = bestCV_now;
            bestDec{t} = population(best_idx).Dec;
        end

        rank = sort_FP(Obj, CV);
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
