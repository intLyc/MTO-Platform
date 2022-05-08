function Task = benchmark_CEC17_CSO(index, dim)

    file_dir = './Problems/Single-task/CEC17_CSO/Data/';

    ub = 100;
    if index == 4 || index == 5 || index == 9
        ub = 10;
    elseif index == 6
        ub = 20;
    elseif index == 7 || index == 19 || index == 28
        ub = 50;
    end
    o = 0;
    M_10 = 1;
    M_30 = 1;
    M_50 = 1;
    M_100 = 1;
    if index <= 11
        load([file_dir, 'Function', num2str(index)]);
        if index == 5
            M_10 = {M1_10, M2_10};
            M_30 = {M1_30, M2_30};
            M_50 = {M1_50, M2_50};
            M_100 = {M1_100, M2_100};
        end
    else
        load([file_dir, 'ShiftAndRotation']);
    end
    if dim == 10
        M = M_10;
    elseif dim == 30
        M = M_30;
    elseif dim == 50
        M = M_50;
    elseif dim == 100
        M = M_100;
    end
    Task.dims = dim; % dimensionality of Task 1
    Task.fnc = @(x)CEC17_CSO_Func(x, index, o, M);
    Task.Lb = -ub * ones(1, dim); % Upper bound of Task 1
    Task.Ub = ub * ones(1, dim); % Lower bound of Task 1
end
