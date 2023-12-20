function Tasks = benchmark_Comp_CPLX(index, case_idx)
%BENCHMARK function
%   Input
%   - index: the index number of problem set
%
%   Output:
%   - Tasks: benchmark problem set

%------------------------------- Reference --------------------------------
% @Article{Li2023MTSRA,
%   title      = {Evolutionary Competitive Multitasking Optimization Via Improved Adaptive Differential Evolution},
%   author     = {Yanchi Li and Wenyin Gong and Shuijia Li},
%   journal    = {Expert Systems with Applications},
%   year       = {2023},
%   issn       = {0957-4174},
%   pages      = {119550},
%   doi        = {https://doi.org/10.1016/j.eswa.2023.119550},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
%--------------------------------------------------------------------------

switch (case_idx)
    case 1
        c1 = 1000; c2 = 0;
    case 2
        c1 = 0; c2 = 1000;
end

switch (index)
    case 1
        dim = 50;
        Tasks(1).Dim = dim;
        fnc = 6;
        Tasks(1).Lb = -100 * ones(1, dim);
        Tasks(1).Ub = 100 * ones(1, dim);
        task_id = 1;
        Tasks(1).Fnc = @(x)get_func(x, fnc, index, task_id, c1);

        Tasks(2).Dim = dim;
        fnc = 6;
        Tasks(2).Lb = -100 * ones(1, dim);
        Tasks(2).Ub = 100 * ones(1, dim);
        task_id = 2;
        Tasks(2).Fnc = @(x)get_func(x, fnc, index, task_id, c2);

    case 2
        dim = 50;
        Tasks(1).Dim = dim;
        fnc = 7;
        Tasks(1).Lb = -100 * ones(1, dim);
        Tasks(1).Ub = 100 * ones(1, dim);
        task_id = 1;
        Tasks(1).Fnc = @(x)get_func(x, fnc, index, task_id, c1);

        Tasks(2).Dim = dim;
        fnc = 7;
        Tasks(2).Lb = -100 * ones(1, dim);
        Tasks(2).Ub = 100 * ones(1, dim);
        task_id = 2;
        Tasks(2).Fnc = @(x)get_func(x, fnc, index, task_id, c2);

    case 3
        dim = 50;
        Tasks(1).Dim = dim;
        fnc = 17;
        Tasks(1).Lb = -100 * ones(1, dim);
        Tasks(1).Ub = 100 * ones(1, dim);
        task_id = 1;
        Tasks(1).Fnc = @(x)get_func(x, fnc, index, task_id, c1);

        Tasks(2).Dim = dim;
        fnc = 17;
        Tasks(2).Lb = -100 * ones(1, dim);
        Tasks(2).Ub = 100 * ones(1, dim);
        task_id = 2;
        Tasks(2).Fnc = @(x)get_func(x, fnc, index, task_id, c2);

    case 4
        dim = 50;
        Tasks(1).Dim = dim;
        fnc = 13;
        Tasks(1).Lb = -100 * ones(1, dim);
        Tasks(1).Ub = 100 * ones(1, dim);
        task_id = 1;
        Tasks(1).Fnc = @(x)get_func(x, fnc, index, task_id, c1);

        Tasks(2).Dim = dim;
        fnc = 13;
        Tasks(2).Lb = -100 * ones(1, dim);
        Tasks(2).Ub = 100 * ones(1, dim);
        task_id = 2;
        Tasks(2).Fnc = @(x)get_func(x, fnc, index, task_id, c2);

    case 5
        dim = 50;
        Tasks(1).Dim = dim;
        fnc = 15;
        Tasks(1).Lb = -100 * ones(1, dim);
        Tasks(1).Ub = 100 * ones(1, dim);
        task_id = 1;
        Tasks(1).Fnc = @(x)get_func(x, fnc, index, task_id, c1);

        Tasks(2).Dim = dim;
        fnc = 15;
        Tasks(2).Lb = -100 * ones(1, dim);
        Tasks(2).Ub = 100 * ones(1, dim);
        task_id = 2;
        Tasks(2).Fnc = @(x)get_func(x, fnc, index, task_id, c2);

    case 6
        dim = 50;
        Tasks(1).Dim = dim;
        fnc = 21;
        Tasks(1).Lb = -100 * ones(1, dim);
        Tasks(1).Ub = 100 * ones(1, dim);
        task_id = 1;
        Tasks(1).Fnc = @(x)get_func(x, fnc, index, task_id, c1);

        Tasks(2).Dim = dim;
        fnc = 21;
        Tasks(2).Lb = -100 * ones(1, dim);
        Tasks(2).Ub = 100 * ones(1, dim);
        task_id = 2;
        Tasks(2).Fnc = @(x)get_func(x, fnc, index, task_id, c2);

    case 7
        dim = 50;
        Tasks(1).Dim = dim;
        fnc = 22;
        Tasks(1).Lb = -100 * ones(1, dim);
        Tasks(1).Ub = 100 * ones(1, dim);
        task_id = 1;
        Tasks(1).Fnc = @(x)get_func(x, fnc, index, task_id, c1);

        Tasks(2).Dim = dim;
        fnc = 22;
        Tasks(2).Lb = -100 * ones(1, dim);
        Tasks(2).Ub = 100 * ones(1, dim);
        task_id = 2;
        Tasks(2).Fnc = @(x)get_func(x, fnc, index, task_id, c2);

    case 8
        dim = 50;
        Tasks(1).Dim = dim;
        fnc = 5;
        Tasks(1).Lb = -100 * ones(1, dim);
        Tasks(1).Ub = 100 * ones(1, dim);
        task_id = 1;
        Tasks(1).Fnc = @(x)get_func(x, fnc, index, task_id, c1);

        Tasks(2).Dim = dim;
        fnc = 5;
        Tasks(2).Lb = -100 * ones(1, dim);
        Tasks(2).Ub = 100 * ones(1, dim);
        task_id = 2;
        Tasks(2).Fnc = @(x)get_func(x, fnc, index, task_id, c2);

    case 9
        dim = 50;
        Tasks(1).Dim = dim;
        fnc = 11;
        Tasks(1).Lb = -100 * ones(1, dim);
        Tasks(1).Ub = 100 * ones(1, dim);
        task_id = 1;
        Tasks(1).Fnc = @(x)get_func(x, fnc, index, task_id, c1);

        Tasks(2).Dim = dim;
        fnc = 16;
        Tasks(2).Lb = -100 * ones(1, dim);
        Tasks(2).Ub = 100 * ones(1, dim);
        task_id = 2;
        Tasks(2).Fnc = @(x)get_func(x, fnc, index, task_id, c2);

    case 10
        dim = 50;
        Tasks(1).Dim = dim;
        fnc = 20;
        Tasks(1).Lb = -100 * ones(1, dim);
        Tasks(1).Ub = 100 * ones(1, dim);
        task_id = 1;
        Tasks(1).Fnc = @(x)get_func(x, fnc, index, task_id, c1);

        Tasks(2).Dim = dim;
        fnc = 21;
        Tasks(2).Lb = -100 * ones(1, dim);
        Tasks(2).Ub = 100 * ones(1, dim);
        task_id = 2;
        Tasks(2).Fnc = @(x)get_func(x, fnc, index, task_id, c2);
end
end

function [Obj, Con] = get_func(x, fnc, index, task_id, c)
Obj = cec14_func(x', fnc, index, task_id) + c;
Obj = Obj';
Con = zeros(size(x, 1), 1);
end
