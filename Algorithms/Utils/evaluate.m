function [population, calls] = evaluate(population, Task, task_idx, varargin)
    %% Evaluate population in a Task
    % Input: population, Task (single task), task_idx (Obj idx), gene_type
    % Output: population (evaluated), calls (function calls number)

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------
    n = numel(varargin);
    if n == 0
        gene_type = 'unified'; % unified [0, 1]
    elseif n == 1
        gene_type = varargin{1};
    end

    for i = 1:length(population)
        switch gene_type
            case 'unified'
                x = (Task.Ub - Task.Lb) .* population(i).Dec(1:Task.Dim) + Task.Lb;
            case 'real'
                x = population(i).Dec(1:Task.Dim);
        end
        [obj, con] = Task.Fnc(x);
        Obj = obj; CV = sum(con);
        population(i).Obj(task_idx) = Obj;
        population(i).CV(task_idx) = CV;
    end
    calls = length(population);
end
