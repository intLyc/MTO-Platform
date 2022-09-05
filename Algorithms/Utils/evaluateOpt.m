function [population, calls] = evaluateOpt(population, Task, task_idx, pil)
    %% Evaluate population in a Task with optimoptions
    % Input: population, Task (single task), task_idx (Obj idx)
    % Output: population (evaluated), calls (function calls number)

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    options = optimoptions(@fminunc, 'Display', 'off', 'Algorithm', 'quasi-newton', 'MaxIter', 2); % settings for individual learning

    calls = 0;
    for i = 1:length(population)
        x = (Task.Ub - Task.Lb) .* population(i).Dec(1:Task.Dim) + Task.Lb;
        if rand < pil
            [x, ~, ~, out] = fminunc(Task.Fnc, x, options);
            Dec = (x - Task.Lb) ./ (Task.Ub - Task.Lb);
            temp = Dec;
            temp(temp < 0) = 0;
            temp(temp > 1) = 1;
            population(i).Dec(1:Task.Dim) = temp;
            if ~isempty(Dec ~= temp)
                x = (Task.Ub - Task.Lb) .* temp + Task.Lb;
                [obj, con] = Task.Fnc(x);
                Obj = obj; CV = sum(con);
                calls = calls + 1;
            end
            population(i).Obj(task_idx) = Obj;
            population(i).CV(task_idx) = CV;
            calls = calls + out.funcCount;
        else
            [obj, con] = Task.Fnc(x);
            Obj = obj; CV = sum(con);
            population(i).Obj(task_idx) = Obj;
            population(i).CV(task_idx) = CV;
            calls = calls + 1;
        end
    end
end
