function [population, calls] = initialize(pop_size, Task)
    for i = 1:pop_size
        population(i) = Individual();
        population(i).rnvec = Task.Lb + rand(1, Task.dims) .* (Task.Ub - Task.Lb);
    end
    [population, calls] = evaluate(population, Task);
end
