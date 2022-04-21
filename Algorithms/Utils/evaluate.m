function [population, calls] = evaluate(population, Task, task_idx)
    %% Evaluate population in a Task
    % Input: population, Task (single task), task_idx (factorial_costs idx)
    % Output: population (evaluated), calls (function calls number)

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    for i = 1:length(population)
        x = (Task.Ub - Task.Lb) .* population(i).rnvec(1:Task.dims) + Task.Lb;
        [obj, con] = Task.fnc(x);
        population(i).factorial_costs(task_idx) = obj;
        population(i).constraint_violation(task_idx) = con;
    end
    calls = length(population);
end
