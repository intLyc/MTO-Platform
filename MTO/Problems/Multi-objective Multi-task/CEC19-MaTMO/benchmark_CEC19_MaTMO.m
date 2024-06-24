function Tasks = benchmark_CEC19_MaTMO(Problem, task_size)
%BENCHMARK function

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

[ShiftVector, RotationMatrix] = readData_CEC19_MaTMO(Problem, task_size);
switch (Problem)
    case 1
        Dim = 50;
        Lb = -100 .* ones(1, Dim);
        Ub = 100 .* ones(1, Dim);
        Lb(1) = 0;
        Ub(1) = 1;
        gType = 'Sphere';
        f1Type = 'linear';
        hType = 'circle';
    case 2
        Dim = 50;
        Lb = -100 .* ones(1, Dim);
        Ub = 100 .* ones(1, Dim);
        Lb(1) = 0;
        Ub(1) = 1;
        gType = 'Mean';
        f1Type = 'linear';
        hType = 'concave';
    case 3
        Dim = 10;
        Lb = -5 .* ones(1, Dim);
        Ub = 5 .* ones(1, Dim);
        Lb(1) = 0;
        Ub(1) = 1;
        gType = 'Rosenbrock';
        f1Type = 'linear';
        hType = 'concave';
    case 4
        Dim = 50;
        Lb = -2 .* ones(1, Dim);
        Ub = 2 .* ones(1, Dim);
        Lb(1) = 0;
        Ub(1) = 1;
        gType = 'Rastrigin';
        f1Type = 'linear';
        hType = 'circle';
    case 5
        Dim = 50;
        Lb = -1 .* ones(1, Dim);
        Ub = 1 .* ones(1, Dim);
        Lb(1) = 0;
        Ub(1) = 1;
        gType = 'Ackley';
        f1Type = 'linear';
        hType = 'convex';
    case 6
        Dim = 50;
        Lb = -50 .* ones(1, Dim);
        Ub = 50 .* ones(1, Dim);
        Lb(1) = 0;
        Ub(1) = 1;
        gType = 'Griewank';
        f1Type = 'linear';
        hType = 'circle';
end

for task_id = 1:task_size
    Tasks(task_id).Dim = Dim; % dimensionality of Task
    Tasks(task_id).Lb = Lb; % Lower bound of Task
    Tasks(task_id).Ub = Ub; % Upper bound of Task
    Tasks(task_id).Fnc = @(x)getFun_CEC19_MaTMO(x, Problem, ShiftVector{task_id}, RotationMatrix{task_id}, 1, gType, f1Type, hType, Lb, Ub); % function of Task
end
end
