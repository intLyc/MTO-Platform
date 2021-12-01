function [population, calls] = initialize(type, pop_size, Tasks)
    if type == 1
        % only evaluate for 1 task
        for i = 1:pop_size
            population(i) = Individual();
            population(i).rnvec = rand(1, Tasks.dims);
        end
        [population, calls] = evaluate(population, Tasks, 1);
    else
        % multifactorial
        for i = 1:pop_size
            population(i) = Individual();
            population(i).rnvec = rand(1, max([Tasks.dims]));
            population(i).skill_factor = 0;
        end
        calls = 0;
        for t = 1:length(Tasks)
            [population, cal] = evaluate(population, Tasks(t), t);
            calls = calls + cal;
        end
    end
end
