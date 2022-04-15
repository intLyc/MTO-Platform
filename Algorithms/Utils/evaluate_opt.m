function [population, calls] = evaluate_opt(population, Task, task_idx, pil)
    %% Evaluate population in a Task
    % Input: population, Task (single task), task_idx (factorial_costs idx)
    % Output: population (evaluated), calls (function calls number)

    options = optimoptions(@fminunc, 'Display', 'off', 'Algorithm', 'quasi-newton', 'MaxIter', 2); % settings for individual learning

    calls = 0;
    for i = 1:length(population)
        x = (Task.Ub - Task.Lb) .* population(i).rnvec(1:Task.dims) + Task.Lb;
        if rand < pil
            con = population(i).constraint_violation(task_idx);
            [x, obj, ~, out] = fminunc(Task.fnc, x, options);
            rnvec = (x - Task.Lb) ./ (Task.Ub - Task.Lb);
            temp = rnvec;
            temp(temp < 0) = 0;
            temp(temp > 1) = 1;
            population(i).rnvec(1:Task.dims) = temp;
            if ~isempty(rnvec ~= temp)
                x = (Task.Ub - Task.Lb) .* temp + Task.Lb;
                [obj, con] = Task.fnc(x);
                calls = calls + 1;
            end
            population(i).factorial_costs(task_idx) = obj;
            population(i).constraint_violation(task_idx) = con;
            calls = calls + out.funcCount;
        else
            [obj, con] = Task.fnc(x);
            population(i).factorial_costs(task_idx) = obj;
            population(i).constraint_violation(task_idx) = con;
            calls = calls + 1;
        end
    end
end
