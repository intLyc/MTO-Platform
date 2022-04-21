function [population, bestobj, bestX] = tour_selectMF(population, offspring, Tasks, pop_size, bestobj, bestX)
    %% Multifactorial - Tournament selection based on scalar fitness
    % Input: population (old), offspring, Tasks, pop_size, bestobj, bestX
    % Output: population (new), bestobj, bestX

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    ostart = length(population) + 1;
    population = [population, offspring];

    for t = 1:length(Tasks)
        for i = 1:length(population)
            factorial_costs(i) = population(i).factorial_costs(t);
        end
        [bestobj_offspring, idx] = min(factorial_costs);
        if bestobj_offspring < bestobj(t)
            bestobj(t) = bestobj_offspring;
            bestX{t} = population(idx).rnvec;
        end

        [~, rank] = sort(factorial_costs);
        for i = 1:length(population)
            population(rank(i)).factorial_ranks(t) = i;
        end
    end
    for i = 1:length(population)
        population(i).scalar_fitness = 1 / min([population(i).factorial_ranks]);
    end

    offspring = population(ostart:end);
    population = population(1:ostart - 1);
    replace = [population.scalar_fitness] < [offspring.scalar_fitness];
    population(replace) = offspring(replace);
end
