function Tasks = benchmark_CEC17_MTSO(index)
%BENCHMARK function
%   Input
%   - index: the index number of problem set
%
%   Output:
%   - Tasks: benchmark problem set

%------------------------------- Reference --------------------------------
% @Article{Da2017CEC2017-MTSO,
%   author     = {Da, Bingshui and Ong, Yew-Soon and Feng, Liang and Qin, A Kai and Gupta, Abhishek and Zhu, Zexuan and Ting, Chuan-Kang and Tang, Ke and Yao, Xin},
%   journal    = {arXiv preprint arXiv:1706.03470},
%   title      = {Evolutionary Multitasking for Single-objective Continuous Optimization: Benchmark Problems, Performance Metric, and Baseline Results},
%   year       = {2017},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
%--------------------------------------------------------------------------

file_dir = './Problems/Multi-task/CEC17-MTSO/Tasks/';

switch (index)
    case 1 % complete intersection with high similarity, Griewank and Rastrigin
        load([file_dir, 'CI_H.mat']) % loading data from folder .\Tasks
        dim = 50;
        Tasks(1).Dim = dim; % dimensionality of Task 1
        Tasks(1).Fnc = @(x)Griewank(x, Rotation_Task1, GO_Task1, 0);
        Tasks(1).Lb = -100 * ones(1, dim); % Upper bound of Task 1
        Tasks(1).Ub = 100 * ones(1, dim); % Lower bound of Task 1

        Tasks(2).Dim = dim; % dimensionality of Task 2
        Tasks(2).Fnc = @(x)Rastrigin(x, Rotation_Task2, GO_Task2, 0);
        Tasks(2).Lb = -50 * ones(1, dim); % Upper bound of Task 2
        Tasks(2).Ub = 50 * ones(1, dim); % Lower bound of Task 2

    case 2 % complete intersection with medium similarity, Ackley and Rastrigin
        load([file_dir, 'CI_M.mat'])
        dim = 50;
        Tasks(1).Dim = dim;
        Tasks(1).Fnc = @(x)Ackley(x, Rotation_Task1, GO_Task1, 0);
        Tasks(1).Lb = -50 * ones(1, dim);
        Tasks(1).Ub = 50 * ones(1, dim);

        Tasks(2).Dim = dim;
        Tasks(2).Fnc = @(x)Rastrigin(x, Rotation_Task2, GO_Task2, 0);
        Tasks(2).Lb = -50 * ones(1, dim);
        Tasks(2).Ub = 50 * ones(1, dim);

    case 3 % complete intersection with low similarity, Ackley and Schwefel
        load([file_dir, 'CI_L.mat'])
        dim = 50;
        Tasks(1).Dim = dim;
        Tasks(1).Fnc = @(x)Ackley(x, Rotation_Task1, GO_Task1, 0);
        Tasks(1).Lb = -50 * ones(1, dim);
        Tasks(1).Ub = 50 * ones(1, dim);

        Tasks(2).Dim = dim;
        Tasks(2).Fnc = @(x)Schwefel(x, 1, 0, 0);
        Tasks(2).Lb = -500 * ones(1, dim);
        Tasks(2).Ub = 500 * ones(1, dim);

    case 4 % partially intersection with high similarity, Rastrigin and Sphere
        load([file_dir, 'PI_H.mat'])
        dim = 50;
        Tasks(1).Dim = dim;
        Tasks(1).Fnc = @(x)Rastrigin(x, Rotation_Task1, GO_Task1, 0);
        Tasks(1).Lb = -50 * ones(1, dim);
        Tasks(1).Ub = 50 * ones(1, dim);

        Tasks(2).Dim = dim;
        Tasks(2).Fnc = @(x)Sphere(x, 1, GO_Task2, 0);
        Tasks(2).Lb = -100 * ones(1, dim);
        Tasks(2).Ub = 100 * ones(1, dim);

    case 5 % partially intersection with medium similarity, Ackley and Rosenbrock
        load([file_dir, 'PI_M.mat'])
        dim = 50;
        Tasks(1).Dim = dim;
        Tasks(1).Fnc = @(x)Ackley(x, Rotation_Task1, GO_Task1, 0);
        Tasks(1).Lb = -50 * ones(1, dim);
        Tasks(1).Ub = 50 * ones(1, dim);

        Tasks(2).Dim = dim;
        Tasks(2).Fnc = @(x)Rosenbrock(x, 1, 0, 0);
        Tasks(2).Lb = -50 * ones(1, dim);
        Tasks(2).Ub = 50 * ones(1, dim);

    case 6 % partially intersection with low similarity, Ackley and Weierstrass
        load([file_dir, 'PI_L.mat'])
        dim = 50;
        Tasks(1).Dim = dim;
        Tasks(1).Fnc = @(x)Ackley(x, Rotation_Task1, GO_Task1, 0);
        Tasks(1).Lb = -50 * ones(1, dim);
        Tasks(1).Ub = 50 * ones(1, dim);

        dim = 25;
        Tasks(2).Dim = dim;
        Tasks(2).Fnc = @(x)Weierstrass(x, Rotation_Task2, GO_Task2, 0);
        Tasks(2).Lb = -0.5 * ones(1, dim);
        Tasks(2).Ub = 0.5 * ones(1, dim);

    case 7 % no intersection with high similarity, Rosenbrock and Rastrigin
        load([file_dir, 'NI_H.mat'])
        dim = 50;
        Tasks(1).Dim = dim;
        Tasks(1).Fnc = @(x)Rosenbrock(x, 1, 0, 0);
        Tasks(1).Lb = -50 * ones(1, dim);
        Tasks(1).Ub = 50 * ones(1, dim);

        Tasks(2).Dim = dim;
        Tasks(2).Fnc = @(x)Rastrigin(x, Rotation_Task2, GO_Task2, 0);
        Tasks(2).Lb = -50 * ones(1, dim);
        Tasks(2).Ub = 50 * ones(1, dim);

    case 8 % no intersection with medium similarity, Griewank and Weierstrass
        load([file_dir, 'NI_M.mat'])
        dim = 50;
        Tasks(1).Dim = dim;
        Tasks(1).Fnc = @(x)Griewank(x, Rotation_Task1, GO_Task1, 0);
        Tasks(1).Lb = -100 * ones(1, dim);
        Tasks(1).Ub = 100 * ones(1, dim);

        Tasks(2).Dim = dim;
        Tasks(2).Fnc = @(x)Weierstrass(x, Rotation_Task2, GO_Task2, 0);
        Tasks(2).Lb = -0.5 * ones(1, dim);
        Tasks(2).Ub = 0.5 * ones(1, dim);

    case 9 % no overlap with low similarity, Rastrigin and Schwefel
        load([file_dir, 'NI_L.mat'])
        dim = 50;
        Tasks(1).Dim = dim;
        Tasks(1).Fnc = @(x)Rastrigin(x, Rotation_Task1, GO_Task1, 0);
        Tasks(1).Lb = -50 * ones(1, dim);
        Tasks(1).Ub = 50 * ones(1, dim);

        Tasks(2).Dim = dim;
        Tasks(2).Fnc = @(x)Schwefel(x, 1, 0, 0);
        Tasks(2).Lb = -500 * ones(1, dim);
        Tasks(2).Ub = 500 * ones(1, dim);

end
end
