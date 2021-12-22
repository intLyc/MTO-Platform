function Tasks = benchmark_WCCI2020_MTSO(index)
    %BENCHMARK function
    %   Input
    %   - index: the index number of problem set
    %
    %   Output:
    %   - Tasks: benchmark problem set

    switch (index)
        case 1
            dims = 50;
            Tasks(1).dims = dims;
            fnc = 6;
            Tasks(1).Lb = -100 * ones(1, dims);
            Tasks(1).Ub = 100 * ones(1, dims);
            task_id = 1;
            Tasks(1).fnc = @(x)get_func(x, fnc, index, task_id);

            Tasks(2).dims = dims;
            fnc = 6;
            Tasks(2).Lb = -100 * ones(1, dims);
            Tasks(2).Ub = 100 * ones(1, dims);
            task_id = 2;
            Tasks(2).fnc = @(x)get_func(x, fnc, index, task_id);

        case 2
            dims = 50;
            Tasks(1).dims = dims;
            fnc = 7;
            Tasks(1).Lb = -100 * ones(1, dims);
            Tasks(1).Ub = 100 * ones(1, dims);
            task_id = 1;
            Tasks(1).fnc = @(x)get_func(x, fnc, index, task_id);

            Tasks(2).dims = dims;
            fnc = 7;
            Tasks(2).Lb = -100 * ones(1, dims);
            Tasks(2).Ub = 100 * ones(1, dims);
            task_id = 2;
            Tasks(2).fnc = @(x)get_func(x, fnc, index, task_id);

        case 3
            dims = 50;
            Tasks(1).dims = dims;
            fnc = 17;
            Tasks(1).Lb = -100 * ones(1, dims);
            Tasks(1).Ub = 100 * ones(1, dims);
            task_id = 1;
            Tasks(1).fnc = @(x)get_func(x, fnc, index, task_id);

            Tasks(2).dims = dims;
            fnc = 17;
            Tasks(2).Lb = -100 * ones(1, dims);
            Tasks(2).Ub = 100 * ones(1, dims);
            task_id = 2;
            Tasks(2).fnc = @(x)get_func(x, fnc, index, task_id);

        case 4
            dims = 50;
            Tasks(1).dims = dims;
            fnc = 13;
            Tasks(1).Lb = -100 * ones(1, dims);
            Tasks(1).Ub = 100 * ones(1, dims);
            task_id = 1;
            Tasks(1).fnc = @(x)get_func(x, fnc, index, task_id);

            Tasks(2).dims = dims;
            fnc = 13;
            Tasks(2).Lb = -100 * ones(1, dims);
            Tasks(2).Ub = 100 * ones(1, dims);
            task_id = 2;
            Tasks(2).fnc = @(x)get_func(x, fnc, index, task_id);

        case 5
            dims = 50;
            Tasks(1).dims = dims;
            fnc = 15;
            Tasks(1).Lb = -100 * ones(1, dims);
            Tasks(1).Ub = 100 * ones(1, dims);
            task_id = 1;
            Tasks(1).fnc = @(x)get_func(x, fnc, index, task_id);

            Tasks(2).dims = dims;
            fnc = 15;
            Tasks(2).Lb = -100 * ones(1, dims);
            Tasks(2).Ub = 100 * ones(1, dims);
            task_id = 2;
            Tasks(2).fnc = @(x)get_func(x, fnc, index, task_id);

        case 6
            dims = 50;
            Tasks(1).dims = dims;
            fnc = 21;
            Tasks(1).Lb = -100 * ones(1, dims);
            Tasks(1).Ub = 100 * ones(1, dims);
            task_id = 1;
            Tasks(1).fnc = @(x)get_func(x, fnc, index, task_id);

            Tasks(2).dims = dims;
            fnc = 21;
            Tasks(2).Lb = -100 * ones(1, dims);
            Tasks(2).Ub = 100 * ones(1, dims);
            task_id = 2;
            Tasks(2).fnc = @(x)get_func(x, fnc, index, task_id);

        case 7
            dims = 50;
            Tasks(1).dims = dims;
            fnc = 22;
            Tasks(1).Lb = -100 * ones(1, dims);
            Tasks(1).Ub = 100 * ones(1, dims);
            task_id = 1;
            Tasks(1).fnc = @(x)get_func(x, fnc, index, task_id);

            Tasks(2).dims = dims;
            fnc = 22;
            Tasks(2).Lb = -100 * ones(1, dims);
            Tasks(2).Ub = 100 * ones(1, dims);
            task_id = 2;
            Tasks(2).fnc = @(x)get_func(x, fnc, index, task_id);

        case 8
            dims = 50;
            Tasks(1).dims = dims;
            fnc = 5;
            Tasks(1).Lb = -100 * ones(1, dims);
            Tasks(1).Ub = 100 * ones(1, dims);
            task_id = 1;
            Tasks(1).fnc = @(x)get_func(x, fnc, index, task_id);

            Tasks(2).dims = dims;
            fnc = 5;
            Tasks(2).Lb = -100 * ones(1, dims);
            Tasks(2).Ub = 100 * ones(1, dims);
            task_id = 2;
            Tasks(2).fnc = @(x)get_func(x, fnc, index, task_id);

        case 9
            dims = 50;
            Tasks(1).dims = dims;
            fnc = 11;
            Tasks(1).Lb = -100 * ones(1, dims);
            Tasks(1).Ub = 100 * ones(1, dims);
            task_id = 1;
            Tasks(1).fnc = @(x)get_func(x, fnc, index, task_id);

            Tasks(2).dims = dims;
            fnc = 16;
            Tasks(2).Lb = -100 * ones(1, dims);
            Tasks(2).Ub = 100 * ones(1, dims);
            task_id = 2;
            Tasks(2).fnc = @(x)get_func(x, fnc, index, task_id);

        case 10
            dims = 50;
            Tasks(1).dims = dims;
            fnc = 20;
            Tasks(1).Lb = -100 * ones(1, dims);
            Tasks(1).Ub = 100 * ones(1, dims);
            task_id = 1;
            Tasks(1).fnc = @(x)get_func(x, fnc, index, task_id);

            Tasks(2).dims = dims;
            fnc = 21;
            Tasks(2).Lb = -100 * ones(1, dims);
            Tasks(2).Ub = 100 * ones(1, dims);
            task_id = 2;
            Tasks(2).fnc = @(x)get_func(x, fnc, index, task_id);
    end
end

function [obj, con] = get_func(x, fnc, index, task_id)
    obj = cec14_func(x', fnc, index, task_id);
    con = 0;
end
