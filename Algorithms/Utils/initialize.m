function [population, calls, bestobj, bestX] = initialize(Individual_class, pop_size, Task, dim)
    %% Initialize and evaluate the population
    % Input: Individual_class, pop_size, Task, dim
    % Output: population, calls (function calls number)

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    for i = 1:pop_size
        population(i) = Individual_class();
        population(i).rnvec = rand(1, dim);
    end
    [population, calls] = evaluate(population, Task, 1);

    [bestobj, idx] = min([population.factorial_costs]);
    bestX = population(idx).rnvec;
end
