function [population, calls] = evaluate(population, Task)
    for i = 1:length(population)
        x = (Task.Ub - Task.Lb) .* population(i).rnvec + Task.Lb;
        population(i).factorial_costs = Task.fnc(x);
    end
    calls = length(population);
end
