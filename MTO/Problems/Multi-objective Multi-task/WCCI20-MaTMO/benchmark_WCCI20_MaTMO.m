function Tasks = benchmark_WCCI20_MaTMO(Problem, task_size)
    %BENCHMARK function

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    [ShiftVector, RotationMatrix] = readData_WCCI20_MaTMO(Problem, task_size);
    f1Type = {'linear'};
    hType = {'circle'};
    switch (Problem)
        case 1
            Dim = 50;
            Lb = {-100 .* ones(1, Dim)};
            Ub = {100 .* ones(1, Dim)};
            Lb{1}(1) = 0;
            Ub{1}(1) = 1;
            tType = 'DTLZ';
            gType = {'Sphere'};
        case 2
            Dim = 50;
            Lb = {-50 .* ones(1, Dim)};
            Ub = {50 .* ones(1, Dim)};
            Lb{1}(1) = 0;
            Ub{1}(1) = 1;
            tType = 'DTLZ';
            gType = {'Rastrigin'};
        case 3
            Dim = 50;
            Lb = {-100 .* ones(1, Dim)};
            Ub = {100 .* ones(1, Dim)};
            Lb{1}(1) = 0;
            Ub{1}(1) = 1;
            tType = 'DTLZ';
            gType = {'Griewank'};
        case 4
            Dim = 50;
            Lb = {-100 .* ones(1, Dim), -50 .* ones(1, Dim), -50 .* ones(1, Dim)};
            Ub = {100 .* ones(1, Dim), 50 .* ones(1, Dim), 50 .* ones(1, Dim)};
            Lb{1}(1) = 0; Lb{2}(1) = 0; Lb{3}(1) = 0;
            Ub{1}(1) = 1; Ub{2}(1) = 1; Ub{3}(1) = 1;
            tType = 'ZDT';
            gType = {'Sphere', 'Rosenbrock', 'Ackley'};
            f1Type = {'linear'};
            hType = {'concave'};
        case 5
            Dim = 50;
            Lb = {-50 .* ones(1, Dim), -100 .* ones(1, Dim), -0.5 .* ones(1, Dim)};
            Ub = {50 .* ones(1, Dim), 100 .* ones(1, Dim), 0.5 .* ones(1, Dim)};
            Lb{1}(1) = 0; Lb{2}(1) = 0; Lb{3}(1) = 0;
            Ub{1}(1) = 1; Ub{2}(1) = 1; Ub{3}(1) = 1;
            tType = 'ZDT';
            gType = {'Rastrigin', 'Griewank', 'Weierstrass'};
            f1Type = {'linear'};
            hType = {'concave'};
        case 6
            Dim = 50;
            Lb = {-50 .* ones(1, Dim), -100 .* ones(1, Dim), -0.5 .* ones(1, Dim)};
            Ub = {50 .* ones(1, Dim), 100 .* ones(1, Dim), 0.5 .* ones(1, Dim)};
            Lb{1}(1) = 0; Lb{2}(1) = 0; Lb{3}(1) = 0;
            Ub{1}(1) = 1; Ub{2}(1) = 1; Ub{3}(1) = 1;
            tType = 'ZDT';
            gType = {'Rosenbrock', 'Griewank', 'Weierstrass'};
            f1Type = {'linear'};
            hType = {'concave'};
        case 7
            Dim = 50;
            Lb = {-100 .* ones(1, Dim), -50 .* ones(1, Dim), -100 .* ones(1, Dim)};
            Ub = {100 .* ones(1, Dim), 50 .* ones(1, Dim), 100 .* ones(1, Dim)};
            Lb{1}(1) = 0; Lb{2}(1) = 0; Lb{3}(1) = 0;
            Ub{1}(1) = 1; Ub{2}(1) = 1; Ub{3}(1) = 1;
            tType = 'ZDT';
            gType = {'Sphere', 'Ackley', 'Rastrigin'};
            f1Type = {'linear'};
            hType = {'concave'};
        case 8
            Dim = 50;
            Lb = {-100 .* ones(1, Dim), -50 .* ones(1, Dim), -50 .* ones(1, Dim), -50 .* ones(1, Dim), -0.5 .* ones(1, Dim), -100 .* ones(1, Dim)};
            Ub = {100 .* ones(1, Dim), 50 .* ones(1, Dim), 50 .* ones(1, Dim), 50 .* ones(1, Dim), 0.5 .* ones(1, Dim), 100 .* ones(1, Dim)};
            Lb{1}(1) = 0; Lb{2}(1) = 0; Lb{3}(1) = 0; Lb{4}(1) = 0; Lb{5}(1) = 0;
            Ub{1}(1) = 1; Ub{2}(1) = 1; Ub{3}(1) = 1; Ub{4}(1) = 1; Ub{5}(1) = 1;
            tType = 'ZDT';
            gType = {'Sphere', 'Rosenbrock', 'Ackley', 'Rastrigin', 'Weierstrass'};
            f1Type = {'linear'};
            hType = {'convex'};
        case 9
            Dim = 50;
            Lb = {-50 .* ones(1, Dim), -50 .* ones(1, Dim), -50 .* ones(1, Dim), -100 .* ones(1, Dim), -0.5 .* ones(1, Dim), -100 .* ones(1, Dim)};
            Ub = {50 .* ones(1, Dim), 50 .* ones(1, Dim), 50 .* ones(1, Dim), 100 .* ones(1, Dim), 0.5 .* ones(1, Dim), 100 .* ones(1, Dim)};
            Lb{1}(1) = 0; Lb{2}(1) = 0; Lb{3}(1) = 0; Lb{4}(1) = 0; Lb{5}(1) = 0;
            Ub{1}(1) = 1; Ub{2}(1) = 1; Ub{3}(1) = 1; Ub{4}(1) = 1; Ub{5}(1) = 1;
            tType = 'ZDT';
            gType = {'Rosenbrock', 'Ackley', 'Rastrigin', 'Griewank', 'Weierstrass'};
            f1Type = {'linear'};
            hType = {'convex'};
        case 10
            Dim = 50;
            Lb = {-100 .* ones(1, Dim), -50 .* ones(1, Dim), -50 .* ones(1, Dim), -50 .* ones(1, Dim), -100 .* ones(1, Dim), -0.5 .* ones(1, Dim), -100 .* ones(1, Dim)};
            Ub = {100 .* ones(1, Dim), 50 .* ones(1, Dim), 50 .* ones(1, Dim), 50 .* ones(1, Dim), 100 .* ones(1, Dim), 0.5 .* ones(1, Dim), 100 .* ones(1, Dim)};
            Lb{1}(1) = 0; Lb{2}(1) = 0; Lb{3}(1) = 0; Lb{4}(1) = 0; Lb{5}(1) = 0; Lb{6}(1) = 0;
            Ub{1}(1) = 1; Ub{2}(1) = 1; Ub{3}(1) = 1; Ub{4}(1) = 1; Ub{5}(1) = 1; Ub{6}(1) = 1;
            tType = 'ZDT';
            gType = {'Sphere', 'Rosenbrock', 'Ackley', 'Rastrigin', 'Griewank', 'Weierstrass'};
            f1Type = {'linear'};
            hType = {'convex'};
    end

    for task_id = 1:task_size
        gt = gType{mod(task_id - 1, length(gType)) +1};
        f1t = f1Type{mod(task_id - 1, length(f1Type)) +1};
        ht = hType{mod(task_id - 1, length(hType)) +1};
        lb = Lb{mod(task_id - 1, length(Lb)) +1};
        ub = Ub{mod(task_id - 1, length(Ub)) +1};
        Tasks(task_id).Dim = Dim; % dimensionality of Task
        Tasks(task_id).Lb = lb; % Lower bound of Task
        Tasks(task_id).Ub = ub; % Upper bound of Task
        Tasks(task_id).Fnc = @(x)getFun_WCCI20_MaTMO(x, tType, ShiftVector{task_id}, RotationMatrix{task_id}, 1, gt, f1t, ht, lb, ub); % function of Task
    end
end
