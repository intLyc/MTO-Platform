function Task = benchmark_CEC06_CSO(index)

%------------------------------- Reference --------------------------------
% @Article{Liang2006CEC06-CSO,
%   title    = {Problem Definitions and Evaluation Criteria for the Cec 2006 Special Session on Constrained Real-parameter Optimization},
%   author   = {Liang, Jing J and Runarsson, Thomas Philip and Mezura-Montes, Efren and Clerc, Maurice and Suganthan, Ponnuthurai Nagaratnam and Coello, CA Coello and Deb, Kalyanmoy},
%   journal  = {Journal of Applied Mechanics},
%   year     = {2006},
%   number   = {8},
%   pages    = {8--31},
%   volume   = {41},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

% Boundary Constraint
aaa = [];
switch index
    case 1
        lb = zeros(1, 13);
        ub = ones(1, 13);
        ub(10:12) = 100;
        D = 13;
    case 2
        lb = zeros(1, 20);
        ub = 10 * ones(1, 20);
        D = 20;
    case 3
        lb = zeros(1, 10);
        ub = ones(1, 10);
        D = 10;
    case 4
        lb = [78 33 27 27 27];
        ub = [102 45 45 45 45];
        D = 5;
    case 5
        lb = [0 0 -0.55 -0.55];
        ub = [1200 1200 0.55 0.55];
        D = 4;
    case 6
        lb = [13, 0];
        ub = [100, 100];
        D = 2;
    case 7
        lb = -10 * ones(1, 10);
        ub = 10 * ones(1, 10);
        D = 10;
    case 8
        lb = [0, 0];
        ub = [10, 10];
        D = 2;
    case 9
        lb = -10 * ones(1, 7);
        ub = 10 * ones(1, 7);
        D = 7;
    case 10
        lb = [100, 1000, 1000, 10, 10, 10, 10, 10];
        ub = [10000, 10000, 10000, 1000, 1000, 1000, 1000, 1000];
        D = 8;
    case 11
        lb = [-1, -1];
        ub = [1, 1];
        D = 2;
    case 12
        lb = [0, 0, 0];
        ub = [10, 10, 10];
        D = 3;
        l = 1;
        for i = 1:9
            for j = 1:9
                for k = 1:9
                    aaa(l, :) = [i j k];
                    l = l + 1;
                end
            end
        end
    case 13
        lb = [-2.3 -2.3 -3.2 -3.2 -3.2];
        ub = [2.3 2.3 3.2 3.2 3.2];
        D = 5;
    case 14
        lb = zeros(1, 10);
        ub = 10 * ones(1, 10);
        D = 10;
    case 15
        lb = zeros(1, 3);
        ub = 10 * ones(1, 3);
        D = 3;
    case 16
        lb = [704.4148 68.6 0 193 25];
        ub = [906.3855 288.88 134.75 287.0966 84.1988];
        D = 5;
    case 17
        lb = [0 0 340 340 -1000 0];
        ub = [400 1000 420 420 1000 0.5236];
        D = 6;
    case 18
        lb = -10 * ones(1, 9); lb(9) = 0;
        ub = 10 * ones(1, 9); ub(9) = 20;
        D = 9;
    case 19
        lb = zeros(1, 15);
        ub = 10 * ones(1, 15);
        D = 15;
    case 20
        lb = zeros(1, 24);
        ub = 10 * ones(1, 24);
        D = 24;
    case 21
        lb = [0 0 0 100 6.3 5.9 4.5];
        ub = [1000 40 40 300 6.7 6.4 6.25];
        D = 7;
    case 22
        lb = [0 0 0 0 0 0 0 100 100 100.01 100 100 0 0 0 0.01 0.01 -4.7 -4.7 -4.7 -4.7 -4.7];
        ub = [20000 10^6 10^6 10^6 4 * 10^7 4 * 10^7 4 * 10^7 299.99 399.99 300 400 600 500 500 500 300 400 6.25 6.25 6.25 6.25 6.25];
        D = 22;
    case 23
        lb = [0 0 0 0 0 0 0 0 0.01];
        ub = [300 300 100 200 100 300 100 200 0.03];
        D = 9;
    case 24
        lb = [0, 0];
        ub = [3, 4];
        D = 2;
end

%% Set Task
Task.Dim = D; % dimensionality of Task 1
Task.Fnc = @(x)CEC06_CSO_Func(x, index, aaa);
Task.Lb = lb; % Upper bound of Task 1
Task.Ub = ub; % Lower bound of Task 1
end
