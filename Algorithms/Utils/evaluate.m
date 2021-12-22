function [population, calls] = evaluate(population, Task, task_idx)
    %% Evaluate population in a Task
    % Input: population, Task (single task), task_idx (factorial_costs idx)
    % Output: population (evaluated), calls (function calls number)

    for i = 1:length(population)
        x = (Task.Ub - Task.Lb) .* population(i).rnvec(1:Task.dims) + Task.Lb;
        [obj, con] = Task.fnc(x);
        population(i).factorial_costs(task_idx) = obj;
        population(i).constraint_violation(task_idx) = con;
    end
    calls = length(population);
end
