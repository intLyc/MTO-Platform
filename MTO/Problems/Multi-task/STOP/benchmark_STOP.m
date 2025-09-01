function Tasks = benchmark_STOP(index, N)

current_dir = fileparts(mfilename('fullpath'));
file_dir = fullfile(current_dir, 'Tasks/');

switch (index)
    case 11
        load([file_dir, 'Ackley-Ta-hl2-d50-k49.mat']) % loading data from folder .\Tasks
        dim = 50;
        Tasks(1).Dim = dim;
        [Tasks(1).Fnc, Tasks(1).Lb, Tasks(1).Ub] = STOP_Pro(target, dim);
        if N > 1
            for i = 2:N
                Tasks(i).Dim = dim;
                [Tasks(i).Fnc, Tasks(i).Lb, Tasks(i).Ub] = STOP_Pro(sources(i - 1), dim);
            end
        end

    case 5 %
        load([file_dir, 'Ackley-Ta-hm1-d25-k49.mat'])
        dim = 25;
        Tasks(1).Dim = dim;
        [Tasks(1).Fnc, Tasks(1).Lb, Tasks(1).Ub] = STOP_Pro(target, dim);
        if N > 1
            for i = 2:N
                Tasks(i).Dim = dim;
                [Tasks(i).Fnc, Tasks(i).Lb, Tasks(i).Ub] = STOP_Pro(sources(i - 1), dim);
            end
        end

    case 2 % complete intersection with low similarity, Ackley and Schwefel
        load([file_dir, 'Ellipsoid-Te-hh2-d25-k49.mat'])
        dim = 25;
        Tasks(1).Dim = dim;
        [Tasks(1).Fnc, Tasks(1).Lb, Tasks(1).Ub] = STOP_Pro(target, dim);
        if N > 1
            for i = 2:N
                Tasks(i).Dim = dim;
                [Tasks(i).Fnc, Tasks(i).Lb, Tasks(i).Ub] = STOP_Pro(sources(i - 1), dim);
            end
        end

    case 12 % partially intersection with high similarity, Rastrigin and Sphere
        load([file_dir, 'Ellipsoid-Te-hl1-d50-k49.mat'])
        dim = 50;
        Tasks(1).Dim = dim;
        [Tasks(1).Fnc, Tasks(1).Lb, Tasks(1).Ub] = STOP_Pro(target, dim);
        if N > 1
            for i = 2:N
                Tasks(i).Dim = dim;
                [Tasks(i).Fnc, Tasks(i).Lb, Tasks(i).Ub] = STOP_Pro(sources(i - 1), dim);
            end
        end

    case 7 % partially intersection with medium similarity, Ackley and Rosenbrock
        load([file_dir, 'Griewank-Ta-hm3-d25-k49.mat'])
        dim = 25;
        Tasks(1).Dim = dim;
        [Tasks(1).Fnc, Tasks(1).Lb, Tasks(1).Ub] = STOP_Pro(target, dim);
        if N > 1
            for i = 2:N
                Tasks(i).Dim = dim;
                [Tasks(i).Fnc, Tasks(i).Lb, Tasks(i).Ub] = STOP_Pro(sources(i - 1), dim);
            end
        end

    case 8 % partially intersection with low similarity, Ackley and Weierstrass
        load([file_dir, 'Levy-Te-hm4-d30-k49.mat'])
        dim = 30;
        Tasks(1).Dim = dim;
        [Tasks(1).Fnc, Tasks(1).Lb, Tasks(1).Ub] = STOP_Pro(target, dim);
        if N > 1
            for i = 2:N
                Tasks(i).Dim = dim;
                [Tasks(i).Fnc, Tasks(i).Lb, Tasks(i).Ub] = STOP_Pro(sources(i - 1), dim);
            end
        end

    case 4 % no intersection with high similarity, Rosenbrock and Rastrigin
        load([file_dir, 'Quartic-Te-hh2-d50-k49.mat'])
        dim = 50;
        Tasks(1).Dim = dim;
        [Tasks(1).Fnc, Tasks(1).Lb, Tasks(1).Ub] = STOP_Pro(target, dim);
        if N > 1
            for i = 2:N
                Tasks(i).Dim = dim;
                [Tasks(i).Fnc, Tasks(i).Lb, Tasks(i).Ub] = STOP_Pro(sources(i - 1), dim);
            end
        end

    case 10 % no intersection with medium similarity, Griewank and Weierstrass
        load([file_dir, 'Rastrigin-Te-hl2-d30-k49.mat'])
        dim = 30;
        Tasks(1).Dim = dim;
        [Tasks(1).Fnc, Tasks(1).Lb, Tasks(1).Ub] = STOP_Pro(target, dim);
        if N > 1
            for i = 2:N
                Tasks(i).Dim = dim;
                [Tasks(i).Fnc, Tasks(i).Lb, Tasks(i).Ub] = STOP_Pro(sources(i - 1), dim);
            end
        end

    case 6 % no overlap with low similarity, Rastrigin and Schwefel
        load([file_dir, 'Rastrigin-Te-hm2-d50-k49.mat'])
        dim = 50;
        Tasks(1).Dim = dim;
        [Tasks(1).Fnc, Tasks(1).Lb, Tasks(1).Ub] = STOP_Pro(target, dim);
        if N > 1
            for i = 2:N
                Tasks(i).Dim = dim;
                [Tasks(i).Fnc, Tasks(i).Lb, Tasks(i).Ub] = STOP_Pro(sources(i - 1), dim);
            end
        end
    case 3 % no overlap with low similarity, Rastrigin and Schwefel
        load([file_dir, 'Schwefel-Ta-hh2-d30-k49.mat'])
        dim = 30;
        Tasks(1).Dim = dim;
        [Tasks(1).Fnc, Tasks(1).Lb, Tasks(1).Ub] = STOP_Pro(target, dim);
        if N > 1
            for i = 2:N
                Tasks(i).Dim = dim;
                [Tasks(i).Fnc, Tasks(i).Lb, Tasks(i).Ub] = STOP_Pro(sources(i - 1), dim);
            end
        end
    case 1 % no overlap with low similarity, Rastrigin and Schwefel
        load([file_dir, 'Sphere-Ta-hh2-d50-k49.mat'])
        dim = 50;
        Tasks(1).Dim = dim;
        [Tasks(1).Fnc, Tasks(1).Lb, Tasks(1).Ub] = STOP_Pro(target, dim);
        if N > 1
            for i = 2:N
                Tasks(i).Dim = dim;
                [Tasks(i).Fnc, Tasks(i).Lb, Tasks(i).Ub] = STOP_Pro(sources(i - 1), dim);
            end
        end
    case 9
        load([file_dir, 'Sphere-Ta-hl1-d25-k49.mat'])
        dim = 25;
        Tasks(1).Dim = dim;
        [Tasks(1).Fnc, Tasks(1).Lb, Tasks(1).Ub] = STOP_Pro(target, dim);
        if N > 1
            for i = 2:N
                Tasks(i).Dim = dim;
                [Tasks(i).Fnc, Tasks(i).Lb, Tasks(i).Ub] = STOP_Pro(sources(i - 1), dim);
            end
        end

end
end
function [fnc, lb, ub] = STOP_Pro(A, dim)
switch A.name
    case 'Sphere'
        fnc = @(x)Sphere(x, 1, A.x_best, 0);
        lb = -100 * ones(1, dim);
        ub = 100 * ones(1, dim);

    case 'Ellipsoid'
        fnc = @(x)S_Ellipsoid(x, A.x_best);
        lb = -50 * ones(1, dim);
        ub = 50 * ones(1, dim);

    case 'Schwefel'
        fnc = @(x)S_Schwefel(x, A.x_best);
        lb = -30 * ones(1, dim);
        ub = 30 * ones(1, dim);

    case 'Quartic'
        fnc = @(x)S_Quartic(x, A.x_best);
        lb = -5 * ones(1, dim);
        ub = 5 * ones(1, dim);

    case 'Ackley'
        fnc = @(x)Ackley(x, eye(dim), A.x_best, 0);
        lb = -32 * ones(1, dim);
        ub = 32 * ones(1, dim);

    case 'Rastrigin'
        fnc = @(x)Rastrigin(x, eye(dim), A.x_best, 0);
        lb = -10 * ones(1, dim);
        ub = 10 * ones(1, dim);

    case 'Griewank'
        fnc = @(x)Griewank(x, eye(dim), A.x_best, 0);
        lb = -200 * ones(1, dim);
        ub = 200 * ones(1, dim);

    case 'Levy'
        fnc = @(x)S_Levy(x, A.x_best);
        lb = -20 * ones(1, dim);
        ub = 20 * ones(1, dim);

    otherwise
        error('Unknown function name: %s', A.name);
end
end
