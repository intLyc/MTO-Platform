function Tasks = benchmark_SCP(Nmin, Nmax)

    %------------------------------- Reference --------------------------------
    % Reference 1
    % @Article{Ryerkerk2017VLP,
    %   title      = {Solving Metameric Variable-length Optimization Problems Using Genetic Algorithms},
    %   author     = {Ryerkerk, Matthew L and Averill, Ronald C and Deb, Kalyanmoy and Goodman, Erik D},
    %   journal    = {Genetic Programming and Evolvable Machines},
    %   year       = {2017},
    %   number     = {2},
    %   pages      = {247--277},
    %   volume     = {18},
    %   publisher  = {Springer},
    % }
    % Reference 2
    % @Article{Li2022CompetitiveMTO,
    %   title      = {Evolutionary Competitive Multitasking Optimization},
    %   author     = {Li, Genghui and Zhang, Qingfu and Wang, Zhenkun},
    %   journal    = {IEEE Transactions on Evolutionary Computation},
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

    load Adata
    K = Nmax - Nmin + 1;
    for i = 1:K
        Tasks(i).Dim = (Nmin + (i - 1)) * 3; % dimensionality of Task 1
        Tasks(i).Fnc = @(x)obj_func(x, A, Tasks(i).Dim);
        Tasks(i).Lb = -1 * ones(1, Tasks(i).Dim);
        Tasks(i).Ub = 1 * ones(1, Tasks(i).Dim);
        index = [3:3:Tasks(i).Dim];
        Tasks(i).Lb(index) = 0.1;
        Tasks(i).Ub(index) = 0.25;
    end
end

function [Obj, Con] = obj_func(x, A, dim)
    a = 1000; b = 10; c0 = 1;
    x = x(1:dim);
    k = dim / 3;
    x = reshape(x, 3, k)';
    d = pdist2(A, x(:, 1:2));
    isconverage = (d <= repmat(x(:, 3)', size(A, 1), 1));
    maxisconverage = max(isconverage, [], 2);
    convarage_ratio = sum(maxisconverage) / (size(A, 1));
    f = a * (1 - convarage_ratio) + c0 * k + sum(b * x(:, 3).^2);
    Obj = f;
    Con = 0;
end
