function [population, calls] = initialize(Individual_class, pop_size, Tasks, tasks_num)
    %% Initialize and evaluate the population
    % Input: Individual_class, pop_size, Tasks, tasks_num
    % Output: population, calls (function calls number)

    if tasks_num == 1
        for i = 1:pop_size
            population(i) = Individual_class();
            population(i).rnvec = rand(1, Tasks.dims);
        end
        [population, calls] = evaluate(population, Tasks, 1);
    elseif tasks_num > 1
        for i = 1:pop_size
            population(i) = Individual_class();
            population(i).rnvec = rand(1, max([Tasks.dims]));
            population(i).skill_factor = 0;
            population(i).factorial_costs = inf(1, tasks_num);
            population(i).constraint_violation = inf(1, tasks_num);
        end
        calls = 0;
        for t = 1:tasks_num
            [population, cal] = evaluate(population, Tasks(t), t);
            calls = calls + cal;
        end
    end
end
