function Tasks = benchmark_WCCI20_MaTSO(ID, task_size)
%BENCHMARK function

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

choice_functions = [];
switch (ID)
    case 1
        choice_functions = [1];
    case 2
        choice_functions = [2];
    case 3
        choice_functions = [4];
    case 4
        choice_functions = [1 2 3];
    case 5
        choice_functions = [4 5 6];
    case 6
        choice_functions = [2 5 7];
    case 7
        choice_functions = [3 4 6];
    case 8
        choice_functions = [2 3 4 5 6];
    case 9
        choice_functions = [2 3 4 5 6 7];
    case 10
        choice_functions = [3 4 5 6 7];
    otherwise
        fprintf("Invalid input: ID should be in [1,10]");
end
for task_id = 1:task_size
    func_id = choice_functions(mod(task_id - 1, length(choice_functions)) + 1);
    current_dir = fileparts(mfilename('fullpath'));
    file_dir = fullfile(current_dir, strcat("Tasks/benchmark_", string(ID)));

    shift_file = strcat("/bias_", string(task_id));
    rotation_file = strcat("/matrix_", string(task_id));
    matrix = load(strcat(file_dir, rotation_file), '-ascii');
    shift = load(strcat(file_dir, shift_file), '-ascii');
    switch func_id
        case 1
            Tasks(task_id).Dim = 50; % dimensionality of Task
            Tasks(task_id).Lb = -100 * ones(1, 50); % Lower bound of Task
            Tasks(task_id).Ub = 100 * ones(1, 50); % Upper bound of Task
            auxiliary(task_id).shift = shift .* ones(1, 50);
            auxiliary(task_id).matrix = matrix;
            Tasks(task_id).Fnc = @(x)Sphere(x, auxiliary(task_id).matrix, auxiliary(task_id).shift, 0); % function of Task
        case 2
            Tasks(task_id).Dim = 50;
            Tasks(task_id).Lb = -50 * ones(1, 50);
            Tasks(task_id).Ub = 50 * ones(1, 50);
            auxiliary(task_id).shift = shift .* ones(1, 50);
            auxiliary(task_id).matrix = matrix;
            Tasks(task_id).Fnc = @(x)Rosenbrock(x, auxiliary(task_id).matrix, auxiliary(task_id).shift, 0);
        case 3
            Tasks(task_id).Dim = 50;
            Tasks(task_id).Lb = -50 * ones(1, 50);
            Tasks(task_id).Ub = 50 * ones(1, 50);
            auxiliary(task_id).shift = shift .* ones(1, 50);
            auxiliary(task_id).matrix = matrix;
            Tasks(task_id).Fnc = @(x)Ackley(x, auxiliary(task_id).matrix, auxiliary(task_id).shift, 0);
        case 4
            Tasks(task_id).Dim = 50;
            Tasks(task_id).Lb = -50 * ones(1, 50);
            Tasks(task_id).Ub = 50 * ones(1, 50);
            auxiliary(task_id).shift = shift .* ones(1, 50);
            auxiliary(task_id).matrix = matrix;
            Tasks(task_id).Fnc = @(x)Rastrigin(x, auxiliary(task_id).matrix, auxiliary(task_id).shift, 0);
        case 5
            Tasks(task_id).Dim = 50;
            Tasks(task_id).Lb = -100 * ones(1, 50);
            Tasks(task_id).Ub = 100 * ones(1, 50);
            auxiliary(task_id).shift = shift .* ones(1, 50);
            auxiliary(task_id).matrix = matrix;
            Tasks(task_id).Fnc = @(x)Griewank(x, auxiliary(task_id).matrix, auxiliary(task_id).shift, 0);
        case 6
            Tasks(task_id).Dim = 50;
            Tasks(task_id).Lb = -0.5 * ones(1, 50);
            Tasks(task_id).Ub = 0.5 * ones(1, 50);
            auxiliary(task_id).shift = shift .* ones(1, 50);
            auxiliary(task_id).matrix = matrix;
            Tasks(task_id).Fnc = @(x)Weierstrass(x, auxiliary(task_id).matrix, auxiliary(task_id).shift, 0);
        case 7
            Tasks(task_id).Dim = 50;
            Tasks(task_id).Lb = -500 * ones(1, 50);
            Tasks(task_id).Ub = 500 * ones(1, 50);
            auxiliary(task_id).shift = shift .* ones(1, 50);
            auxiliary(task_id).matrix = matrix;
            Tasks(task_id).Fnc = @(x)Schwefel(x, auxiliary(task_id).matrix, auxiliary(task_id).shift, 0);
    end
end
