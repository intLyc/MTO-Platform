function [population, calls, bestobj, bestX] = initializeMFone(Individual_class, pop_size, Tasks, dim)
    %% Multifactorial only evaluate one times - Initialize and evaluate the population
    % Input: Individual_class, pop_size, Tasks, dim
    % Output: population, calls (function calls number), bestobj, bestX

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    sf = 1;
    for i = 1:pop_size
        population(i) = Individual_class();
        population(i).rnvec = rand(1, dim);
        population(i).skill_factor = sf;
        sf = mod(sf, length(Tasks)) + 1;
        population(i).factorial_costs = inf(1, length(Tasks));
        population(i).constraint_violation = inf(1, length(Tasks));
    end

    temp = Individual_class.empty();
    calls = 0;
    for t = 1:length(Tasks)
        temp_t = population([population.skill_factor] == t);
        [temp_t, cal] = evaluate(temp_t, Tasks(t), t);

        for i = 1:length(temp_t)
            factorial_costs(i) = temp_t(i).factorial_costs(t);
        end
        [~, min_idx] = min(factorial_costs);
        bestobj(t) = temp_t(min_idx).factorial_costs(t);
        bestX{t} = temp_t(min_idx).rnvec;

        temp = [temp, temp_t];
        calls = calls + cal;
    end
    population = temp;
end
