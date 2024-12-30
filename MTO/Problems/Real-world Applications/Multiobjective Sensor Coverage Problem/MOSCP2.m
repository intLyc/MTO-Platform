classdef MOSCP2 < Problem
% <Multi-task> <Multi-objective> <None/Competitive>

% Multi-objective Sensor Coverage Problem

%------------------------------- Reference --------------------------------
% @Article{Li2025CMO-MTO,
%   title    = {Evolutionary Competitive Multiobjective Multitasking: One-Pass Optimization of Heterogeneous Pareto Solutions},
%   author   = {Li, Yanchi and Wu, Xinyi and Gong, Wenyin and Xu, Meng and Wang, Yubo and Gu, Qiong},
%   journal  = {IEEE Transactions on Evolutionary Computation},
%   year     = {2024},
%   doi      = {10.1109/TEVC.2024.3524508},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties
    Nmin = 25
    Number = 4
    Gap = 3
end

methods
    function Prob = MOSCP2(name)
        Prob = Prob@Problem(name);
        Prob.maxFE = 1000 * 50 * Prob.Number;
    end

    function parameter = getParameter(Prob)
        parameter = {'Nmin', num2str(Prob.Nmin), ...
                'Number', num2str(Prob.Number), ...
                'Gap', num2str(Prob.Gap)};
        parameter = [Prob.getRunParameter(), parameter];
    end

    function Prob = setParameter(Prob, Parameter)
        nmin = str2double(Parameter{3});
        number = str2double(Parameter{4});
        gap = str2double(Parameter{5});
        if Prob.Nmin == nmin && Prob.Number == number && Prob.Gap == gap
            Prob.setRunParameter(Parameter(1:2));
        else
            Prob.Nmin = nmin;
            Prob.Number = number;
            Prob.Gap = gap;
            Prob.maxFE = 1000 * 50 * Prob.Number;
            Prob.setRunParameter({Parameter{1}, num2str(Prob.maxFE)});
        end
    end

    function setTasks(Prob)
        load SCP_Adata2
        Prob.T = Prob.Number;
        for t = 1:Prob.T
            Prob.M(t) = 2;
            Prob.D(t) = (Prob.Nmin + Prob.Gap * (t - 1)) * 3;
            Prob.Fnc{t} = @(x)MOSCP_func(x, A, Prob.D(t));
            Prob.Lb{t} = -ones(1, Prob.D(t));
            Prob.Ub{t} = ones(1, Prob.D(t));
            index = 3:3:Prob.D(t);
            Prob.Lb{t}(index) = 0.1;
            Prob.Ub{t}(index) = 0.25;
        end
    end

    function optimum = getOptimum(Prob)
        for t = 1:Prob.T
            optimum{t} = [0, 25];
        end
    end
end
end

function [Objs, Cons] = MOSCP_func(var, A, dim)
%% Separate Evaluation
rsample = 2 / (size(A, 1) - 1);
Objs = [];
for i = 1:size(var, 1)
    x = var(i, :);
    b = 10; c0 = 1;
    x = x(1:dim);
    k = dim / 3;
    x = reshape(x, 3, k)';
    d = pdist2(A, x(:, 1:2));
    iscoverage = (d + rsample <= repmat(x(:, 3)', size(A, 1), 1));
    maxisconverage = max(iscoverage, [], 2);
    convarage_ratio = sum(maxisconverage) / (size(A, 1));
    f1 = 100 * (1 - convarage_ratio);
    f2 = c0 * k + sum(b * x(:, 3).^2) + f1 / 10;
    Obj = [f1, f2];
    Objs(i, :) = Obj;
end

% %% Vectorized Evaluation
% rsample = 1 / (size(A, 1) - 1);
% b = 10; c0 = 1;
% x = var(:, 1:dim);
% k = dim / 3;
% x = reshape(x, size(x, 1), 3, k); % extract sensors
% x2d = reshape(permute(x, [3, 1, 2]), size(x, 1) * k, 3);
% d = pdist2(A, x2d(:, 1:2));
% point_num = size(A, 1);
% iscoverage = (d + rsample <= repmat(x2d(:, 3)', point_num, 1));
% iscoverage = reshape(iscoverage, point_num, k, size(var, 1));
% convarage_ratio = sum(any(iscoverage, 2), 1) / (point_num);
% f1 = 1 - squeeze(convarage_ratio);
% f2 = c0 * k + sum(b * x(:, 3, :).^2, 3);
% Objs = [f1, f2];

Cons = zeros(size(var, 1), 1);
end
