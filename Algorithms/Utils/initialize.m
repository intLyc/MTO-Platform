function [population, calls, bestobj, bestX] = initialize(Individual_class, pop_size, Task, dim)
    %% Initialize and evaluate the population
    % Input: Individual_class, pop_size, Task, dim
    % Output: population, calls (function calls number)

    for i = 1:pop_size
        population(i) = Individual_class();
        population(i).rnvec = rand(1, dim);
    end
    [population, calls] = evaluate(population, Task, 1);

    [bestobj, idx] = min([population.factorial_costs]);
    bestX = population(idx).rnvec;
end
