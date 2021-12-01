function [population, calls] = evaluate(population, Task, task_idx)
    for i = 1:length(population)
        x = (Task.Ub - Task.Lb) .* population(i).rnvec + Task.Lb;
        population(i).factorial_costs(task_idx) = Task.fnc(x);
    end
    calls = length(population);
end
