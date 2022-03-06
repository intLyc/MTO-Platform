function [population, calls, bestobj, bestX] = initializeMFone(Individual_class, pop_size, Tasks, tasks_num)
    %% Multifactorial only evaluate one times - Initialize and evaluate the population
    % Input: Individual_class, pop_size, Tasks, tasks_num
    % Output: population, calls (function calls number), bestobj, bestX

    sf = 1;
    for i = 1:pop_size
        population(i) = Individual_class();
        population(i).rnvec = rand(1, max([Tasks.dims]));
        population(i).skill_factor = sf;
        sf = mod(sf, length(Tasks)) + 1;
        population(i).factorial_costs = inf(1, tasks_num);
        population(i).constraint_violation = inf(1, tasks_num);
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
