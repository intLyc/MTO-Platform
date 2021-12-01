function [population, calls] = initialize(pop_size, Task)
    for i = 1:pop_size
        population(i) = Individual();
        population(i).rnvec = rand(1, Task.dims);
    end
    [population, calls] = evaluate(population, Task);
end
