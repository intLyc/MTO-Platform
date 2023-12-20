function Tasks = benchmark_C4TOP(index)
%BENCHMARK function
%   Input
%   - index: the index number of problem set
%
%   Output:
%   - Tasks: benchmark problem set

%------------------------------- Reference --------------------------------
% @Article{Li2022CompetitiveMTO,
%   author     = {Li, Genghui and Zhang, Qingfu and Wang, Zhenkun},
%   journal    = {IEEE Transactions on Evolutionary Computation},
%   title      = {Evolutionary Competitive Multitasking Optimization},
%   year       = {2022},
%   pages      = {1-1},
%   doi        = {10.1109/TEVC.2022.3141819},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
%--------------------------------------------------------------------------

file_dir = './Problems/Multi-task/Competitive-C4TOP/Data/';
load([file_dir, 'M_matrix.mat']);
load([file_dir, 'O_matrix.mat']);

D = [50, 50, 50, 50, 50, 40];
Xmin = [-50, -100, -50, -50, -100, -0.5];
Xmax = -Xmin;
fbias = [0, 150, 100, 50, 25, 10];

switch index
    case 1 % The combination of f1 and f2
        Tasks(1).Dim = D(1); % dimensionality of Task 1
        Tasks(1).Fnc = @(x)Rastrigin(x, M_matrix{1}, O_matrix{1}, fbias(1));
        Tasks(1).Lb = Xmin(1) * ones(1, Tasks(1).Dim); % Upper bound of Task 1
        Tasks(1).Ub = Xmax(1) * ones(1, Tasks(1).Dim); % Lower bound of Task 1

        Tasks(2).Dim = D(2); % dimensionality of Task 2
        Tasks(2).Fnc = @(x)Griewank(x, M_matrix{2}, O_matrix{2}, fbias(2));
        Tasks(2).Lb = Xmin(2) * ones(1, Tasks(2).Dim); % Upper bound of Task 2
        Tasks(2).Ub = Xmax(2) * ones(1, Tasks(2).Dim); % Lower bound of Task 2

        Tasks(3).Dim = D(3); % dimensionality of Task 3
        Tasks(3).Fnc = @(x)Sphere(x, M_matrix{3}, O_matrix{3}, fbias(3));
        Tasks(3).Lb = Xmin(3) * ones(1, Tasks(3).Dim); % Upper bound of Task 3
        Tasks(3).Ub = Xmax(3) * ones(1, Tasks(3).Dim); % Lower bound of Task 3

        Tasks(4).Dim = D(4); % dimensionality of Task 4
        Tasks(4).Fnc = @(x)Rosenbrock(x, M_matrix{4}, O_matrix{4}, fbias(4));
        Tasks(4).Lb = Xmin(4) * ones(1, Tasks(4).Dim); % Upper bound of Task 4
        Tasks(4).Ub = Xmax(4) * ones(1, Tasks(4).Dim); % Lower bound of Task 4

    case 2 % The combination of f1 and f3
        Tasks(1).Dim = D(1); % dimensionality of Task 1
        Tasks(1).Fnc = @(x)Rastrigin(x, M_matrix{1}, O_matrix{1}, fbias(1));
        Tasks(1).Lb = Xmin(1) * ones(1, Tasks(1).Dim); % Upper bound of Task 1
        Tasks(1).Ub = Xmax(1) * ones(1, Tasks(1).Dim); % Lower bound of Task 1

        Tasks(2).Dim = D(2); % dimensionality of Task 2
        Tasks(2).Fnc = @(x)Griewank(x, M_matrix{2}, O_matrix{2}, fbias(2));
        Tasks(2).Lb = Xmin(2) * ones(1, Tasks(2).Dim); % Upper bound of Task 2
        Tasks(2).Ub = Xmax(2) * ones(1, Tasks(2).Dim); % Lower bound of Task 2

        Tasks(3).Dim = D(3); % dimensionality of Task 3
        Tasks(3).Fnc = @(x)Sphere(x, M_matrix{3}, O_matrix{3}, fbias(3));
        Tasks(3).Lb = Xmin(3) * ones(1, Tasks(3).Dim); % Upper bound of Task 3
        Tasks(3).Ub = Xmax(3) * ones(1, Tasks(3).Dim); % Lower bound of Task 3

        Tasks(4).Dim = D(5); % dimensionality of Task 4
        Tasks(4).Fnc = @(x)Ackley(x, M_matrix{5}, O_matrix{5}, fbias(5));
        Tasks(4).Lb = Xmin(5) * ones(1, Tasks(4).Dim); % Upper bound of Task 3
        Tasks(4).Ub = Xmax(5) * ones(1, Tasks(4).Dim); % Lower bound of Task 4

    case 3 % The combination of f1 and f4
        Tasks(1).Dim = D(1); % dimensionality of Task 1
        Tasks(1).Fnc = @(x)Rastrigin(x, M_matrix{1}, O_matrix{1}, fbias(1));
        Tasks(1).Lb = Xmin(1) * ones(1, Tasks(1).Dim); % Upper bound of Task 1
        Tasks(1).Ub = Xmax(1) * ones(1, Tasks(1).Dim); % Lower bound of Task 1

        Tasks(2).Dim = D(2); % dimensionality of Task 2
        Tasks(2).Fnc = @(x)Griewank(x, M_matrix{2}, O_matrix{2}, fbias(2));
        Tasks(2).Lb = Xmin(2) * ones(1, Tasks(2).Dim); % Upper bound of Task 2
        Tasks(2).Ub = Xmax(2) * ones(1, Tasks(2).Dim); % Lower bound of Task 2

        Tasks(3).Dim = D(3); % dimensionality of Task 3
        Tasks(3).Fnc = @(x)Sphere(x, M_matrix{3}, O_matrix{3}, fbias(3));
        Tasks(3).Lb = Xmin(3) * ones(1, Tasks(3).Dim); % Upper bound of Task 3
        Tasks(3).Ub = Xmax(3) * ones(1, Tasks(3).Dim); % Lower bound of Task 3

        Tasks(4).Dim = D(6); % dimensionality of Task 4
        Tasks(4).Fnc = @(x)Weierstrass(x, M_matrix{6}, O_matrix{6}, fbias(6));
        Tasks(4).Lb = Xmin(6) * ones(1, Tasks(4).Dim); % Upper bound of Task 3
        Tasks(4).Ub = Xmax(6) * ones(1, Tasks(4).Dim); % Lower bound of Task 4

    case 4 % The combination of f1 and f5
        Tasks(1).Dim = D(1); % dimensionality of Task 1
        Tasks(1).Fnc = @(x)Rastrigin(x, M_matrix{1}, O_matrix{1}, fbias(1));
        Tasks(1).Lb = Xmin(1) * ones(1, Tasks(1).Dim); % Upper bound of Task 1
        Tasks(1).Ub = Xmax(1) * ones(1, Tasks(1).Dim); % Lower bound of Task 1

        Tasks(2).Dim = D(2); % dimensionality of Task 2
        Tasks(2).Fnc = @(x)Griewank(x, M_matrix{2}, O_matrix{2}, fbias(2));
        Tasks(2).Lb = Xmin(2) * ones(1, Tasks(2).Dim); % Upper bound of Task 2
        Tasks(2).Ub = Xmax(2) * ones(1, Tasks(2).Dim); % Lower bound of Task 2

        Tasks(3).Dim = D(4); % dimensionality of Task 4
        Tasks(3).Fnc = @(x)Rosenbrock(x, M_matrix{4}, O_matrix{4}, fbias(4));
        Tasks(3).Lb = Xmin(4) * ones(1, Tasks(3).Dim); % Upper bound of Task 4
        Tasks(3).Ub = Xmax(4) * ones(1, Tasks(3).Dim); % Lower bound of Task 4

        Tasks(4).Dim = D(5); % dimensionality of Task 3
        Tasks(4).Fnc = @(x)Ackley(x, M_matrix{5}, O_matrix{5}, fbias(5));
        Tasks(4).Lb = Xmin(5) * ones(1, Tasks(4).Dim); % Upper bound of Task 3
        Tasks(4).Ub = Xmax(5) * ones(1, Tasks(4).Dim); % Lower bound of Task 3

    case 5 % The combination of f1 and f6
        Tasks(1).Dim = D(1); % dimensionality of Task 1
        Tasks(1).Fnc = @(x)Rastrigin(x, M_matrix{1}, O_matrix{1}, fbias(1));
        Tasks(1).Lb = Xmin(1) * ones(1, Tasks(1).Dim); % Upper bound of Task 1
        Tasks(1).Ub = Xmax(1) * ones(1, Tasks(1).Dim); % Lower bound of Task 1

        Tasks(2).Dim = D(2); % dimensionality of Task 2
        Tasks(2).Fnc = @(x)Griewank(x, M_matrix{2}, O_matrix{2}, fbias(2));
        Tasks(2).Lb = Xmin(2) * ones(1, Tasks(2).Dim); % Upper bound of Task 2
        Tasks(2).Ub = Xmax(2) * ones(1, Tasks(2).Dim); % Lower bound of Task 2

        Tasks(3).Dim = D(4); % dimensionality of Task 4
        Tasks(3).Fnc = @(x)Rosenbrock(x, M_matrix{4}, O_matrix{4}, fbias(4));
        Tasks(3).Lb = Xmin(4) * ones(1, Tasks(3).Dim); % Upper bound of Task 4
        Tasks(3).Ub = Xmax(4) * ones(1, Tasks(3).Dim); % Lower bound of Task 4

        Tasks(4).Dim = D(6); % dimensionality of Task 3
        Tasks(4).Fnc = @(x)Weierstrass(x, M_matrix{6}, O_matrix{6}, fbias(6));
        Tasks(4).Lb = Xmin(6) * ones(1, Tasks(4).Dim); % Upper bound of Task 3
        Tasks(4).Ub = Xmax(6) * ones(1, Tasks(4).Dim); % Lower bound of Task 3

    case 6 % The combination of f2 and f3
        Tasks(1).Dim = D(1); % dimensionality of Task 1
        Tasks(1).Fnc = @(x)Rastrigin(x, M_matrix{1}, O_matrix{1}, fbias(1));
        Tasks(1).Lb = Xmin(1) * ones(1, Tasks(1).Dim); % Upper bound of Task 1
        Tasks(1).Ub = Xmax(1) * ones(1, Tasks(1).Dim); % Lower bound of Task 1

        Tasks(2).Dim = D(2); % dimensionality of Task 2
        Tasks(2).Fnc = @(x)Griewank(x, M_matrix{2}, O_matrix{2}, fbias(2));
        Tasks(2).Lb = Xmin(2) * ones(1, Tasks(2).Dim); % Upper bound of Task 2
        Tasks(2).Ub = Xmax(2) * ones(1, Tasks(2).Dim); % Lower bound of Task 2

        Tasks(3).Dim = D(5); % dimensionality of Task 4
        Tasks(3).Fnc = @(x)Ackley(x, M_matrix{5}, O_matrix{5}, fbias(5));
        Tasks(3).Lb = Xmin(5) * ones(1, Tasks(3).Dim); % Upper bound of Task 4
        Tasks(3).Ub = Xmax(5) * ones(1, Tasks(3).Dim); % Lower bound of Task 4

        Tasks(4).Dim = D(6); % dimensionality of Task 3
        Tasks(4).Fnc = @(x)Weierstrass(x, M_matrix{6}, O_matrix{6}, fbias(6));
        Tasks(4).Lb = Xmin(6) * ones(1, Tasks(4).Dim); % Upper bound of Task 3
        Tasks(4).Ub = Xmax(6) * ones(1, Tasks(4).Dim); % Lower bound of Task 3

    case 7
        Tasks(1).Dim = D(1); % dimensionality of Task 1
        Tasks(1).Fnc = @(x)Rastrigin(x, M_matrix{1}, O_matrix{1}, fbias(1));
        Tasks(1).Lb = Xmin(1) * ones(1, Tasks(1).Dim); % Upper bound of Task 1
        Tasks(1).Ub = Xmax(1) * ones(1, Tasks(1).Dim); % Lower bound of Task 1

        Tasks(2).Dim = D(3); % dimensionality of Task 2
        Tasks(2).Fnc = @(x)Sphere(x, M_matrix{3}, O_matrix{3}, fbias(3));
        Tasks(2).Lb = Xmin(3) * ones(1, Tasks(2).Dim); % Upper bound of Task 2
        Tasks(2).Ub = Xmax(3) * ones(1, Tasks(2).Dim); % Lower bound of Task 2

        Tasks(3).Dim = D(4); % dimensionality of Task 4
        Tasks(3).Fnc = @(x)Rosenbrock(x, M_matrix{4}, O_matrix{4}, fbias(4));
        Tasks(3).Lb = Xmin(4) * ones(1, Tasks(3).Dim); % Upper bound of Task 4
        Tasks(3).Ub = Xmax(4) * ones(1, Tasks(3).Dim); % Lower bound of Task 4

        Tasks(4).Dim = D(5); % dimensionality of Task 3
        Tasks(4).Fnc = @(x)Ackley(x, M_matrix{5}, O_matrix{5}, fbias(5));
        Tasks(4).Lb = Xmin(5) * ones(1, Tasks(4).Dim); % Upper bound of Task 3
        Tasks(4).Ub = Xmax(5) * ones(1, Tasks(4).Dim); % Lower bound of Task 3

    case 8 % The combination of f2 and f4
        Tasks(1).Dim = D(1); % dimensionality of Task 1
        Tasks(1).Fnc = @(x)Rastrigin(x, M_matrix{1}, O_matrix{1}, fbias(1));
        Tasks(1).Lb = Xmin(1) * ones(1, Tasks(1).Dim); % Upper bound of Task 1
        Tasks(1).Ub = Xmax(1) * ones(1, Tasks(1).Dim); % Lower bound of Task 1

        Tasks(2).Dim = D(3); % dimensionality of Task 2
        Tasks(2).Fnc = @(x)Sphere(x, M_matrix{3}, O_matrix{3}, fbias(3));
        Tasks(2).Lb = Xmin(3) * ones(1, Tasks(2).Dim); % Upper bound of Task 2
        Tasks(2).Ub = Xmax(3) * ones(1, Tasks(2).Dim); % Lower bound of Task 2

        Tasks(3).Dim = D(4); % dimensionality of Task 4
        Tasks(3).Fnc = @(x)Rosenbrock(x, M_matrix{4}, O_matrix{4}, fbias(4));
        Tasks(3).Lb = Xmin(4) * ones(1, Tasks(3).Dim); % Upper bound of Task 4
        Tasks(3).Ub = Xmax(4) * ones(1, Tasks(3).Dim); % Lower bound of Task 4

        Tasks(4).Dim = D(6); % dimensionality of Task 3
        Tasks(4).Fnc = @(x)Weierstrass(x, M_matrix{6}, O_matrix{6}, fbias(6));
        Tasks(4).Lb = Xmin(6) * ones(1, Tasks(4).Dim); % Upper bound of Task 3
        Tasks(4).Ub = Xmax(6) * ones(1, Tasks(4).Dim); % Lower bound of Task 3

    case 9 % The combination of f2 and f5
        Tasks(1).Dim = D(1); % dimensionality of Task 1
        Tasks(1).Fnc = @(x)Rastrigin(x, M_matrix{1}, O_matrix{1}, fbias(1));
        Tasks(1).Lb = Xmin(1) * ones(1, Tasks(1).Dim); % Upper bound of Task 1
        Tasks(1).Ub = Xmax(1) * ones(1, Tasks(1).Dim); % Lower bound of Task 1

        Tasks(2).Dim = D(3); % dimensionality of Task 2
        Tasks(2).Fnc = @(x)Sphere(x, M_matrix{3}, O_matrix{3}, fbias(3));
        Tasks(2).Lb = Xmin(3) * ones(1, Tasks(2).Dim); % Upper bound of Task 2
        Tasks(2).Ub = Xmax(3) * ones(1, Tasks(2).Dim); % Lower bound of Task 2

        Tasks(3).Dim = D(5); % dimensionality of Task 4
        Tasks(3).Fnc = @(x)Ackley(x, M_matrix{5}, O_matrix{5}, fbias(5));
        Tasks(3).Lb = Xmin(5) * ones(1, Tasks(3).Dim); % Upper bound of Task 4
        Tasks(3).Ub = Xmax(5) * ones(1, Tasks(3).Dim); % Lower bound of Task 4

        Tasks(4).Dim = D(6); % dimensionality of Task 3
        Tasks(4).Fnc = @(x)Weierstrass(x, M_matrix{6}, O_matrix{6}, fbias(6));
        Tasks(4).Lb = Xmin(6) * ones(1, Tasks(4).Dim); % Upper bound of Task 3
        Tasks(4).Ub = Xmax(6) * ones(1, Tasks(4).Dim); % Lower bound of Task 3

    case 10 % The combination of f2 and f6
        Tasks(1).Dim = D(1); % dimensionality of Task 1
        Tasks(1).Fnc = @(x)Rastrigin(x, M_matrix{1}, O_matrix{1}, fbias(1));
        Tasks(1).Lb = Xmin(1) * ones(1, Tasks(1).Dim); % Upper bound of Task 1
        Tasks(1).Ub = Xmax(1) * ones(1, Tasks(1).Dim); % Lower bound of Task 1

        Tasks(2).Dim = D(4); % dimensionality of Task 2
        Tasks(2).Fnc = @(x)Rosenbrock(x, M_matrix{4}, O_matrix{4}, fbias(4));
        Tasks(2).Lb = Xmin(4) * ones(1, Tasks(2).Dim); % Upper bound of Task 2
        Tasks(2).Ub = Xmax(4) * ones(1, Tasks(2).Dim); % Lower bound of Task 2

        Tasks(3).Dim = D(5); % dimensionality of Task 4
        Tasks(3).Fnc = @(x)Ackley(x, M_matrix{5}, O_matrix{5}, fbias(5));
        Tasks(3).Lb = Xmin(5) * ones(1, Tasks(3).Dim); % Upper bound of Task 4
        Tasks(3).Ub = Xmax(5) * ones(1, Tasks(3).Dim); % Lower bound of Task 4

        Tasks(4).Dim = D(6); % dimensionality of Task 3
        Tasks(4).Fnc = @(x)Weierstrass(x, M_matrix{6}, O_matrix{6}, fbias(6));
        Tasks(4).Lb = Xmin(6) * ones(1, Tasks(4).Dim); % Upper bound of Task 3
        Tasks(4).Ub = Xmax(6) * ones(1, Tasks(4).Dim); % Lower bound of Task 3

    case 11 % The combination of f3 and f4
        shift = -25;
        Tasks(1).Dim = D(2); % dimensionality of Task 1
        Tasks(1).Fnc = @(x)Griewank(x, M_matrix{2}, O_matrix{2}, fbias(2) + shift);
        Tasks(1).Lb = Xmin(2) * ones(1, Tasks(1).Dim); % Upper bound of Task 1
        Tasks(1).Ub = Xmax(2) * ones(1, Tasks(1).Dim); % Lower bound of Task 1

        Tasks(2).Dim = D(3); % dimensionality of Task 2
        Tasks(2).Fnc = @(x)Sphere(x, M_matrix{3}, O_matrix{3}, fbias(3) + shift);
        Tasks(2).Lb = Xmin(3) * ones(1, Tasks(2).Dim); % Upper bound of Task 2
        Tasks(2).Ub = Xmax(3) * ones(1, Tasks(2).Dim); % Lower bound of Task 2

        Tasks(3).Dim = D(4); % dimensionality of Task 4
        Tasks(3).Fnc = @(x)Rosenbrock(x, M_matrix{4}, O_matrix{4}, fbias(4) + shift);
        Tasks(3).Lb = Xmin(4) * ones(1, Tasks(3).Dim); % Upper bound of Task 4
        Tasks(3).Ub = Xmax(4) * ones(1, Tasks(3).Dim); % Lower bound of Task 4

        Tasks(4).Dim = D(5); % dimensionality of Task 3
        Tasks(4).Fnc = @(x)Ackley(x, M_matrix{5}, O_matrix{5}, fbias(5) + shift);
        Tasks(4).Lb = Xmin(5) * ones(1, Tasks(4).Dim); % Upper bound of Task 3
        Tasks(4).Ub = Xmax(5) * ones(1, Tasks(4).Dim); % Lower bound of Task 3

    case 12 % The combination of f3 and f5
        shift = -10;
        Tasks(1).Dim = D(2); % dimensionality of Task 1
        Tasks(1).Fnc = @(x)Griewank(x, M_matrix{2}, O_matrix{2}, fbias(2) + shift);
        Tasks(1).Lb = Xmin(2) * ones(1, Tasks(1).Dim); % Upper bound of Task 1
        Tasks(1).Ub = Xmax(2) * ones(1, Tasks(1).Dim); % Lower bound of Task 1

        Tasks(2).Dim = D(3); % dimensionality of Task 2
        Tasks(2).Fnc = @(x)Sphere(x, M_matrix{3}, O_matrix{3}, fbias(3) + shift);
        Tasks(2).Lb = Xmin(3) * ones(1, Tasks(2).Dim); % Upper bound of Task 2
        Tasks(2).Ub = Xmax(3) * ones(1, Tasks(2).Dim); % Lower bound of Task 2

        Tasks(3).Dim = D(4); % dimensionality of Task 4
        Tasks(3).Fnc = @(x)Rosenbrock(x, M_matrix{4}, O_matrix{4}, fbias(4) + shift);
        Tasks(3).Lb = Xmin(4) * ones(1, Tasks(3).Dim); % Upper bound of Task 4
        Tasks(3).Ub = Xmax(4) * ones(1, Tasks(3).Dim); % Lower bound of Task 4

        Tasks(4).Dim = D(6); % dimensionality of Task 3
        Tasks(4).Fnc = @(x)Weierstrass(x, M_matrix{6}, O_matrix{6}, fbias(6) + shift);
        Tasks(4).Lb = Xmin(6) * ones(1, Tasks(4).Dim); % Upper bound of Task 3
        Tasks(4).Ub = Xmax(6) * ones(1, Tasks(4).Dim); % Lower bound of Task 3

    case 13 % The combination of f3 and f6
        shift = -10;
        Tasks(1).Dim = D(2); % dimensionality of Task 1
        Tasks(1).Fnc = @(x)Griewank(x, M_matrix{2}, O_matrix{2}, fbias(2) + shift);
        Tasks(1).Lb = Xmin(2) * ones(1, Tasks(1).Dim); % Upper bound of Task 1
        Tasks(1).Ub = Xmax(2) * ones(1, Tasks(1).Dim); % Lower bound of Task 1

        Tasks(2).Dim = D(3); % dimensionality of Task 2
        Tasks(2).Fnc = @(x)Sphere(x, M_matrix{3}, O_matrix{3}, fbias(3) + shift);
        Tasks(2).Lb = Xmin(3) * ones(1, Tasks(2).Dim); % Upper bound of Task 2
        Tasks(2).Ub = Xmax(3) * ones(1, Tasks(2).Dim); % Lower bound of Task 2

        Tasks(3).Dim = D(5); % dimensionality of Task 4
        Tasks(3).Fnc = @(x)Ackley(x, M_matrix{5}, O_matrix{5}, fbias(5) + shift);
        Tasks(3).Lb = Xmin(5) * ones(1, Tasks(3).Dim); % Upper bound of Task 4
        Tasks(3).Ub = Xmax(5) * ones(1, Tasks(3).Dim); % Lower bound of Task 4

        Tasks(4).Dim = D(6); % dimensionality of Task 3
        Tasks(4).Fnc = @(x)Weierstrass(x, M_matrix{6}, O_matrix{6}, fbias(6) + shift);
        Tasks(4).Lb = Xmin(6) * ones(1, Tasks(4).Dim); % Upper bound of Task 3
        Tasks(4).Ub = Xmax(6) * ones(1, Tasks(4).Dim); % Lower bound of Task 3

    case 14 % The combination of f4 and f5
        shift = -10;
        Tasks(1).Dim = D(2); % dimensionality of Task 1
        Tasks(1).Fnc = @(x)Griewank(x, M_matrix{2}, O_matrix{2}, fbias(2) + shift);
        Tasks(1).Lb = Xmin(2) * ones(1, Tasks(1).Dim); % Upper bound of Task 1
        Tasks(1).Ub = Xmax(2) * ones(1, Tasks(1).Dim); % Lower bound of Task 1

        Tasks(2).Dim = D(4); % dimensionality of Task 2
        Tasks(2).Fnc = @(x)Rosenbrock(x, M_matrix{4}, O_matrix{4}, fbias(4) + shift);
        Tasks(2).Lb = Xmin(4) * ones(1, Tasks(2).Dim); % Upper bound of Task 2
        Tasks(2).Ub = Xmax(4) * ones(1, Tasks(2).Dim); % Lower bound of Task 2

        Tasks(3).Dim = D(5); % dimensionality of Task 4
        Tasks(3).Fnc = @(x)Ackley(x, M_matrix{5}, O_matrix{5}, fbias(5) + shift);
        Tasks(3).Lb = Xmin(5) * ones(1, Tasks(3).Dim); % Upper bound of Task 4
        Tasks(3).Ub = Xmax(5) * ones(1, Tasks(3).Dim); % Lower bound of Task 4

        Tasks(4).Dim = D(6); % dimensionality of Task 3
        Tasks(4).Fnc = @(x)Weierstrass(x, M_matrix{6}, O_matrix{6}, fbias(6) + shift);
        Tasks(4).Lb = Xmin(6) * ones(1, Tasks(4).Dim); % Upper bound of Task 3
        Tasks(4).Ub = Xmax(6) * ones(1, Tasks(4).Dim); % Lower bound of Task 3

    case 15 % The combination of f4 and f6
        shift = -10;
        Tasks(1).Dim = D(3); % dimensionality of Task 1
        Tasks(1).Fnc = @(x)Sphere(x, M_matrix{3}, O_matrix{3}, fbias(3) + shift);
        Tasks(1).Lb = Xmin(3) * ones(1, Tasks(1).Dim); % Upper bound of Task 1
        Tasks(1).Ub = Xmax(3) * ones(1, Tasks(1).Dim); % Lower bound of Task 1

        Tasks(2).Dim = D(4); % dimensionality of Task 2
        Tasks(2).Fnc = @(x)Rosenbrock(x, M_matrix{4}, O_matrix{4}, fbias(4) + shift);
        Tasks(2).Lb = Xmin(4) * ones(1, Tasks(2).Dim); % Upper bound of Task 2
        Tasks(2).Ub = Xmax(4) * ones(1, Tasks(2).Dim); % Lower bound of Task 2

        Tasks(3).Dim = D(5); % dimensionality of Task 4
        Tasks(3).Fnc = @(x)Ackley(x, M_matrix{5}, O_matrix{5}, fbias(5) + shift);
        Tasks(3).Lb = Xmin(5) * ones(1, Tasks(3).Dim); % Upper bound of Task 4
        Tasks(3).Ub = Xmax(5) * ones(1, Tasks(3).Dim); % Lower bound of Task 4

        Tasks(4).Dim = D(6); % dimensionality of Task 3
        Tasks(4).Fnc = @(x)Weierstrass(x, M_matrix{6}, O_matrix{6}, fbias(6) + shift);
        Tasks(4).Lb = Xmin(6) * ones(1, Tasks(4).Dim); % Upper bound of Task 3
        Tasks(4).Ub = Xmax(6) * ones(1, Tasks(4).Dim); % Lower bound of Task 3
end
end
