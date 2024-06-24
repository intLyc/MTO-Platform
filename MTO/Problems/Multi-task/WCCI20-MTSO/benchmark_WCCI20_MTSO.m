function Tasks = benchmark_WCCI20_MTSO(index)
%BENCHMARK function
%   Input
%   - index: the index number of problem set
%
%   Output:
%   - Tasks: benchmark problem set

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

switch (index)
    case 1
        dim = 50;
        Tasks(1).Dim = dim;
        fnc = 6;
        Tasks(1).Lb = -100 * ones(1, dim);
        Tasks(1).Ub = 100 * ones(1, dim);
        task_id = 1;
        Tasks(1).Fnc = @(x)get_func(x, fnc, index, task_id);

        Tasks(2).Dim = dim;
        fnc = 6;
        Tasks(2).Lb = -100 * ones(1, dim);
        Tasks(2).Ub = 100 * ones(1, dim);
        task_id = 2;
        Tasks(2).Fnc = @(x)get_func(x, fnc, index, task_id);

    case 2
        dim = 50;
        Tasks(1).Dim = dim;
        fnc = 7;
        Tasks(1).Lb = -100 * ones(1, dim);
        Tasks(1).Ub = 100 * ones(1, dim);
        task_id = 1;
        Tasks(1).Fnc = @(x)get_func(x, fnc, index, task_id);

        Tasks(2).Dim = dim;
        fnc = 7;
        Tasks(2).Lb = -100 * ones(1, dim);
        Tasks(2).Ub = 100 * ones(1, dim);
        task_id = 2;
        Tasks(2).Fnc = @(x)get_func(x, fnc, index, task_id);

    case 3
        dim = 50;
        Tasks(1).Dim = dim;
        fnc = 17;
        Tasks(1).Lb = -100 * ones(1, dim);
        Tasks(1).Ub = 100 * ones(1, dim);
        task_id = 1;
        Tasks(1).Fnc = @(x)get_func(x, fnc, index, task_id);

        Tasks(2).Dim = dim;
        fnc = 17;
        Tasks(2).Lb = -100 * ones(1, dim);
        Tasks(2).Ub = 100 * ones(1, dim);
        task_id = 2;
        Tasks(2).Fnc = @(x)get_func(x, fnc, index, task_id);

    case 4
        dim = 50;
        Tasks(1).Dim = dim;
        fnc = 13;
        Tasks(1).Lb = -100 * ones(1, dim);
        Tasks(1).Ub = 100 * ones(1, dim);
        task_id = 1;
        Tasks(1).Fnc = @(x)get_func(x, fnc, index, task_id);

        Tasks(2).Dim = dim;
        fnc = 13;
        Tasks(2).Lb = -100 * ones(1, dim);
        Tasks(2).Ub = 100 * ones(1, dim);
        task_id = 2;
        Tasks(2).Fnc = @(x)get_func(x, fnc, index, task_id);

    case 5
        dim = 50;
        Tasks(1).Dim = dim;
        fnc = 15;
        Tasks(1).Lb = -100 * ones(1, dim);
        Tasks(1).Ub = 100 * ones(1, dim);
        task_id = 1;
        Tasks(1).Fnc = @(x)get_func(x, fnc, index, task_id);

        Tasks(2).Dim = dim;
        fnc = 15;
        Tasks(2).Lb = -100 * ones(1, dim);
        Tasks(2).Ub = 100 * ones(1, dim);
        task_id = 2;
        Tasks(2).Fnc = @(x)get_func(x, fnc, index, task_id);

    case 6
        dim = 50;
        Tasks(1).Dim = dim;
        fnc = 21;
        Tasks(1).Lb = -100 * ones(1, dim);
        Tasks(1).Ub = 100 * ones(1, dim);
        task_id = 1;
        Tasks(1).Fnc = @(x)get_func(x, fnc, index, task_id);

        Tasks(2).Dim = dim;
        fnc = 21;
        Tasks(2).Lb = -100 * ones(1, dim);
        Tasks(2).Ub = 100 * ones(1, dim);
        task_id = 2;
        Tasks(2).Fnc = @(x)get_func(x, fnc, index, task_id);

    case 7
        dim = 50;
        Tasks(1).Dim = dim;
        fnc = 22;
        Tasks(1).Lb = -100 * ones(1, dim);
        Tasks(1).Ub = 100 * ones(1, dim);
        task_id = 1;
        Tasks(1).Fnc = @(x)get_func(x, fnc, index, task_id);

        Tasks(2).Dim = dim;
        fnc = 22;
        Tasks(2).Lb = -100 * ones(1, dim);
        Tasks(2).Ub = 100 * ones(1, dim);
        task_id = 2;
        Tasks(2).Fnc = @(x)get_func(x, fnc, index, task_id);

    case 8
        dim = 50;
        Tasks(1).Dim = dim;
        fnc = 5;
        Tasks(1).Lb = -100 * ones(1, dim);
        Tasks(1).Ub = 100 * ones(1, dim);
        task_id = 1;
        Tasks(1).Fnc = @(x)get_func(x, fnc, index, task_id);

        Tasks(2).Dim = dim;
        fnc = 5;
        Tasks(2).Lb = -100 * ones(1, dim);
        Tasks(2).Ub = 100 * ones(1, dim);
        task_id = 2;
        Tasks(2).Fnc = @(x)get_func(x, fnc, index, task_id);

    case 9
        dim = 50;
        Tasks(1).Dim = dim;
        fnc = 11;
        Tasks(1).Lb = -100 * ones(1, dim);
        Tasks(1).Ub = 100 * ones(1, dim);
        task_id = 1;
        Tasks(1).Fnc = @(x)get_func(x, fnc, index, task_id);

        Tasks(2).Dim = dim;
        fnc = 16;
        Tasks(2).Lb = -100 * ones(1, dim);
        Tasks(2).Ub = 100 * ones(1, dim);
        task_id = 2;
        Tasks(2).Fnc = @(x)get_func(x, fnc, index, task_id);

    case 10
        dim = 50;
        Tasks(1).Dim = dim;
        fnc = 20;
        Tasks(1).Lb = -100 * ones(1, dim);
        Tasks(1).Ub = 100 * ones(1, dim);
        task_id = 1;
        Tasks(1).Fnc = @(x)get_func(x, fnc, index, task_id);

        Tasks(2).Dim = dim;
        fnc = 21;
        Tasks(2).Lb = -100 * ones(1, dim);
        Tasks(2).Ub = 100 * ones(1, dim);
        task_id = 2;
        Tasks(2).Fnc = @(x)get_func(x, fnc, index, task_id);
end
end

function [Obj, Con] = get_func(x, fnc, index, task_id)
Obj = cec14_func(x', fnc, index, task_id);
Obj = Obj';
Con = zeros(size(x, 1), 1);
end
