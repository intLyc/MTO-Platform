function [population, bestobj, bestCV, bestX] = selectMF(population, offspring, Tasks, pop_size, bestobj, bestCV, bestX)
    %% Multifactorial - Elite selection based on scalar fitness
    % Input: population (old), offspring, Tasks, pop_size, bestobj, bestX
    % Output: population (new), bestobj, bestX

    population = [population, offspring];

    for t = 1:length(Tasks)
        for i = 1:length(population)
            factorial_costs(i) = population(i).factorial_costs(t);
        end
        [bestobj_offspring, idx] = min(factorial_costs);
        if bestobj_offspring < bestobj(t)
            bestobj(t) = bestobj_offspring;
            bestCV(t) = population(idx).constraint_violation(t);
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

    [~, rank] = sort(- [population.scalar_fitness]);
    population = population(rank(1:pop_size));
end
