function Tasks = benchmark_CEC19_MaTSO(ID, task_size)
%BENCHMARK function

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

current_dir = fileparts(mfilename('fullpath'));
file_dir = fullfile(current_dir, 'Tasks/');

dim = 50;
switch (ID)
    case 1
        load([file_dir, 'GoTask1.mat']);
        load([file_dir, 'RotationTask1.mat']);
        for i = 1:task_size
            Tasks(i).Dim = dim;
            Tasks(i).Fnc = @(x)Rosenbrock(x, RotationTask1{i}, GoTask1(i, :), 0);
            Tasks(i).Lb = -50 * ones(1, dim);
            Tasks(i).Ub = 50 * ones(1, dim);
        end
    case 2
        load([file_dir, 'GoTask2.mat']);
        load([file_dir, 'RotationTask2.mat']);
        for i = 1:task_size
            Tasks(i).Dim = dim;
            Tasks(i).Fnc = @(x)Ackley(x, RotationTask2{i}, GoTask2(i, :), 0);
            Tasks(i).Lb = -50 * ones(1, dim);
            Tasks(i).Ub = 50 * ones(1, dim);
        end
    case 3
        load([file_dir, 'GoTask3.mat']);
        load([file_dir, 'RotationTask3.mat']);
        for i = 1:task_size
            Tasks(i).Dim = dim;
            Tasks(i).Fnc = @(x)Rastrigin(x, RotationTask3{i}, GoTask3(i, :), 0);
            Tasks(i).Lb = -50 * ones(1, dim);
            Tasks(i).Ub = 50 * ones(1, dim);
        end
    case 4
        load([file_dir, 'GoTask4.mat']);
        load([file_dir, 'RotationTask4.mat']);
        for i = 1:task_size
            Tasks(i).Dim = dim;
            Tasks(i).Fnc = @(x)Griewank(x, RotationTask4{i}, GoTask4(i, :), 0);
            Tasks(i).Lb = -100 * ones(1, dim);
            Tasks(i).Ub = 100 * ones(1, dim);
        end
    case 5
        load([file_dir, 'GoTask5.mat']);
        load([file_dir, 'RotationTask5.mat']);
        for i = 1:task_size
            Tasks(i).Dim = dim;
            Tasks(i).Fnc = @(x)Weierstrass(x, RotationTask5{i}, GoTask5(i, :), 0);
            Tasks(i).Lb = -0.5 * ones(1, dim);
            Tasks(i).Ub = 0.5 * ones(1, dim);
        end
    case 6
        load([file_dir, 'GoTask6.mat']);
        load([file_dir, 'RotationTask6.mat']);
        for i = 1:task_size
            Tasks(i).Dim = dim;
            Tasks(i).Fnc = @(x)Schwefel(x, RotationTask6{i}, GoTask6(i, :), 0);
            Tasks(i).Lb = -500 * ones(1, dim);
            Tasks(i).Ub = 500 * ones(1, dim);
        end
end
end
