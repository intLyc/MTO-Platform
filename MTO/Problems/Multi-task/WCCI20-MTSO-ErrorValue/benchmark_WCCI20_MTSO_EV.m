function Tasks = benchmark_WCCI20_MTSO_EV(index)

%% Error Value Type of WCCI20-MTSO, where real Obj is replaced by Error Value (Obj - Global Optimum)

%BENCHMARK function
%   Input
%   - index: the index number of problem set
%
%   Output:
%   - Tasks: benchmark problem set

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
%--------------------------------------------------------------------------

switch (index)
    case 1
        dim = 50;
        Tasks(1).Dim = dim;
        fnc = 6;
        Tasks(1).Lb = -100 * ones(1, dim);
        Tasks(1).Ub = 100 * ones(1, dim);
        task_id = 1;
        Tasks(1).Fnc = @(x)get_func(x, fnc, index, task_id, 600);

        Tasks(2).Dim = dim;
        fnc = 6;
        Tasks(2).Lb = -100 * ones(1, dim);
        Tasks(2).Ub = 100 * ones(1, dim);
        task_id = 2;
        Tasks(2).Fnc = @(x)get_func(x, fnc, index, task_id, 600);

    case 2
        dim = 50;
        Tasks(1).Dim = dim;
        fnc = 7;
        Tasks(1).Lb = -100 * ones(1, dim);
        Tasks(1).Ub = 100 * ones(1, dim);
        task_id = 1;
        Tasks(1).Fnc = @(x)get_func(x, fnc, index, task_id, 700);

        Tasks(2).Dim = dim;
        fnc = 7;
        Tasks(2).Lb = -100 * ones(1, dim);
        Tasks(2).Ub = 100 * ones(1, dim);
        task_id = 2;
        Tasks(2).Fnc = @(x)get_func(x, fnc, index, task_id, 700);

    case 3
        dim = 50;
        Tasks(1).Dim = dim;
        fnc = 17;
        Tasks(1).Lb = -100 * ones(1, dim);
        Tasks(1).Ub = 100 * ones(1, dim);
        task_id = 1;
        Tasks(1).Fnc = @(x)get_func(x, fnc, index, task_id, 1700);

        Tasks(2).Dim = dim;
        fnc = 17;
        Tasks(2).Lb = -100 * ones(1, dim);
        Tasks(2).Ub = 100 * ones(1, dim);
        task_id = 2;
        Tasks(2).Fnc = @(x)get_func(x, fnc, index, task_id, 1700);

    case 4
        dim = 50;
        Tasks(1).Dim = dim;
        fnc = 13;
        Tasks(1).Lb = -100 * ones(1, dim);
        Tasks(1).Ub = 100 * ones(1, dim);
        task_id = 1;
        Tasks(1).Fnc = @(x)get_func(x, fnc, index, task_id, 1300);

        Tasks(2).Dim = dim;
        fnc = 13;
        Tasks(2).Lb = -100 * ones(1, dim);
        Tasks(2).Ub = 100 * ones(1, dim);
        task_id = 2;
        Tasks(2).Fnc = @(x)get_func(x, fnc, index, task_id, 1300);

    case 5
        dim = 50;
        Tasks(1).Dim = dim;
        fnc = 15;
        Tasks(1).Lb = -100 * ones(1, dim);
        Tasks(1).Ub = 100 * ones(1, dim);
        task_id = 1;
        Tasks(1).Fnc = @(x)get_func(x, fnc, index, task_id, 1500);

        Tasks(2).Dim = dim;
        fnc = 15;
        Tasks(2).Lb = -100 * ones(1, dim);
        Tasks(2).Ub = 100 * ones(1, dim);
        task_id = 2;
        Tasks(2).Fnc = @(x)get_func(x, fnc, index, task_id, 1500);

    case 6
        dim = 50;
        Tasks(1).Dim = dim;
        fnc = 21;
        Tasks(1).Lb = -100 * ones(1, dim);
        Tasks(1).Ub = 100 * ones(1, dim);
        task_id = 1;
        Tasks(1).Fnc = @(x)get_func(x, fnc, index, task_id, 2100);

        Tasks(2).Dim = dim;
        fnc = 21;
        Tasks(2).Lb = -100 * ones(1, dim);
        Tasks(2).Ub = 100 * ones(1, dim);
        task_id = 2;
        Tasks(2).Fnc = @(x)get_func(x, fnc, index, task_id, 2100);

    case 7
        dim = 50;
        Tasks(1).Dim = dim;
        fnc = 22;
        Tasks(1).Lb = -100 * ones(1, dim);
        Tasks(1).Ub = 100 * ones(1, dim);
        task_id = 1;
        Tasks(1).Fnc = @(x)get_func(x, fnc, index, task_id, 2200);

        Tasks(2).Dim = dim;
        fnc = 22;
        Tasks(2).Lb = -100 * ones(1, dim);
        Tasks(2).Ub = 100 * ones(1, dim);
        task_id = 2;
        Tasks(2).Fnc = @(x)get_func(x, fnc, index, task_id, 2200);

    case 8
        dim = 50;
        Tasks(1).Dim = dim;
        fnc = 5;
        Tasks(1).Lb = -100 * ones(1, dim);
        Tasks(1).Ub = 100 * ones(1, dim);
        task_id = 1;
        Tasks(1).Fnc = @(x)get_func(x, fnc, index, task_id, 500);

        Tasks(2).Dim = dim;
        fnc = 5;
        Tasks(2).Lb = -100 * ones(1, dim);
        Tasks(2).Ub = 100 * ones(1, dim);
        task_id = 2;
        Tasks(2).Fnc = @(x)get_func(x, fnc, index, task_id, 500);

    case 9
        dim = 50;
        Tasks(1).Dim = dim;
        fnc = 11;
        Tasks(1).Lb = -100 * ones(1, dim);
        Tasks(1).Ub = 100 * ones(1, dim);
        task_id = 1;
        Tasks(1).Fnc = @(x)get_func(x, fnc, index, task_id, 1100);

        Tasks(2).Dim = dim;
        fnc = 16;
        Tasks(2).Lb = -100 * ones(1, dim);
        Tasks(2).Ub = 100 * ones(1, dim);
        task_id = 2;
        Tasks(2).Fnc = @(x)get_func(x, fnc, index, task_id, 1600);

    case 10
        dim = 50;
        Tasks(1).Dim = dim;
        fnc = 20;
        Tasks(1).Lb = -100 * ones(1, dim);
        Tasks(1).Ub = 100 * ones(1, dim);
        task_id = 1;
        Tasks(1).Fnc = @(x)get_func(x, fnc, index, task_id, 2000);

        Tasks(2).Dim = dim;
        fnc = 21;
        Tasks(2).Lb = -100 * ones(1, dim);
        Tasks(2).Ub = 100 * ones(1, dim);
        task_id = 2;
        Tasks(2).Fnc = @(x)get_func(x, fnc, index, task_id, 2100);
end
end

function [Obj, Con] = get_func(x, fnc, index, task_id, g)
Obj = cec14_func(x', fnc, index, task_id) - g;
Obj = Obj';
Con = zeros(size(x, 1), 1);
end
