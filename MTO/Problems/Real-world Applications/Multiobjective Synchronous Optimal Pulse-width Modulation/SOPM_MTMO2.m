classdef SOPM_MTMO2 < Problem
% <Multi-task> <Multi-objective> <Constrained>

% Multitask Synchronous Optimal Pulse-width Modulation
% [9, 11, 13]-level Inverters

%------------------------------- Reference --------------------------------
% @Article{Li2024MTDE-MKTA,
%   title    = {Multiobjective Multitask Optimization with Multiple Knowledge Types and Transfer Adaptation},
%   author   = {Li, Yanchi and Gong, Wenyin},
%   journal  = {IEEE Transactions on Evolutionary Computation},
%   year     = {2024},
%   doi      = {10.1109/TEVC.2024.3353319},
% }
%--------------------------------------------------------------------------
% @Article{Kumar2021RWMOP,
%   author   = {Abhishek Kumar and Guohua Wu and Mostafa Z. Ali and Qizhang Luo and Rammohan Mallipeddi and Ponnuthurai Nagaratnam Suganthan and Swagatam Das},
%   journal  = {Swarm and Evolutionary Computation},
%   title    = {A Benchmark-suite of Real-world Constrained Multi-objective Optimization Problems and Some Baseline Results},
%   year     = {2021},
%   issn     = {2210-6502},
%   pages    = {100961},
%   volume   = {67},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

methods
    function Prob = SOPM_MTMO2(varargin)
        Prob = Prob@Problem(varargin);
        Prob.maxFE = 300 * 2000;
    end

    function setTasks(Prob)
        Prob.T = 3;
        Prob.M(1) = 2;
        Prob.D(1) = 30;
        Prob.Fnc{1} = @(x)SOPM_9L(x);
        Prob.Lb{1} = zeros(1, Prob.D(1));
        Prob.Ub{1} = 90 * ones(1, Prob.D(1));

        Prob.M(2) = 2;
        Prob.D(2) = 30;
        Prob.Fnc{2} = @(x)SOPM_11L(x);
        Prob.Lb{2} = zeros(1, Prob.D(2));
        Prob.Ub{2} = 90 * ones(1, Prob.D(2));

        Prob.M(3) = 2;
        Prob.D(3) = 30;
        Prob.Fnc{3} = @(x)SOPM_13L(x);
        Prob.Lb{3} = zeros(1, Prob.D(3));
        Prob.Ub{3} = 90 * ones(1, Prob.D(3));
    end

    function optimum = getOptimum(Prob)
        optimum{1} = [5.217146e-01, 1.023999e-01];
        optimum{2} = [6.106382e-01, 1.110885e-01];
        optimum{3} = [1.949969e+00, 1.107699e+01];
    end
end
end

function [Obj, Con] = SOPM_9L(x)
m = 0.32;
s = [1, 1, 1, 1, -1, 1, -1, -1, -1, 1, -1, -1, 1, 1, 1, 1, -1, 1, -1, -1, -1, 1, -1, -1, 1, 1, 1, 1, -1, 1];
k = [5, 7, 11, 13, 17, 19, 23, 25, 29, 31, 35, 37, 41, 43, 47, 49, 53, 55, 59, 61, 65, 67, 71, 73, 77, 79, 83, 85, 91, 95, 97];
% Objective function
for i = 1:size(x, 1)
    su = 0;
    for j = 1:31
        su2 = 0;
        for l = 1:size(x, 2)
            su2 = su2 + s(l) .* cos(k(j) .* x(i, l) * pi / 180);
        end
        su = su + su2.^2 ./ k(j).^4;
    end
    f(i, 1) = (su).^0.5 ./ (sum(1 ./ k.^4)).^0.5;
end
f(:, 2) = (sum(s .* cos(x * pi / 180), 2) - m).^2;
% Constraints
for i = 1:size(x, 2) - 1
    g(:, i) = x(:, i) - x(:, i + 1) +1e-6;
end
g(g < 0) = 0;
Con = g;
Obj = f;
end

function [Obj, Con] = SOPM_11L(x)
m = 0.3333;
s = [1, -1, 1, 1, 1, -1, -1, -1, 1, 1, 1, 1, -1, -1, 1, -1, -1, -1, 1, 1, 1, 1, -1, 1, 1, -1, -1, 1, -1, -1];
k = [5, 7, 11, 13, 17, 19, 23, 25, 29, 31, 35, 37, 41, 43, 47, 49, 53, 55, 59, 61, 65, 67, 71, 73, 77, 79, 83, 85, 91, 95, 97];
% Objective function
for i = 1:size(x, 1)
    su = 0;
    for j = 1:31
        su2 = 0;
        for l = 1:size(x, 2)
            su2 = su2 + s(l) .* cos(k(j) .* x(i, l) * pi / 180);
        end
        su = su + su2.^2 ./ k(j).^4;
    end
    f(i, 1) = (su).^0.5 ./ (sum(1 ./ k.^4)).^0.5;
end
f(:, 2) = (sum(s .* cos(x * pi / 180), 2) - m).^2;
% Constraints
for i = 1:size(x, 2) - 1
    g(:, i) = x(:, i) - x(:, i + 1) +1e-6;
end
g(g < 0) = 0;
Con = g;
Obj = f;
end

function [Obj, Con] = SOPM_13L(x)
m = 0.32;
s = [1, 1, 1, -1, 1, -1, 1, -1, 1, 1, 1, 1, -1, -1, -1, -1, 1, -1, 1, -1, 1, 1, 1, 1, -1, -1, -1, 1, -1, 1];
k = [5, 7, 11, 13, 17, 19, 23, 25, 29, 31, 35, 37, 41, 43, 47, 49, 53, 55, 59, 61, 65, 67, 71, 73, 77, 79, 83, 85, 91, 95, 97];
% Objective function
for i = 1:size(x, 1)
    su = 0;
    for j = 1:31
        su2 = 0;
        for l = 1:size(x, 2)
            su2 = su2 + s(l) .* cos(k(j) .* x(i, l) * pi / 180);
        end
        su = su + su2.^2 ./ k(j).^4;
    end
    f(i, 1) = (su).^0.5 ./ (sum(1 ./ k.^4)).^0.5;
end
f(:, 2) = (sum(s .* cos(x * pi / 180), 2) - m).^2;
% Constraints
for i = 1:size(x, 2) - 1
    g(:, i) = x(:, i) - x(:, i + 1) +1e-6;
end
g(g < 0) = 0;
Con = g;
Obj = f;
end
