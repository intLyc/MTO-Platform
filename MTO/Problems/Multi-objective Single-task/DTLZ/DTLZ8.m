classdef DTLZ8 < Problem
% <Single-task> <Multi-objective/Many-objective> <Constrained>

%------------------------------- Reference --------------------------------
% @InBook{Deb2005DTLZ,
%   title      = {Scalable Test Problems for Evolutionary Multiobjective Optimization},
%   author     = {Deb, Kalyanmoy and Thiele, Lothar and Laumanns, Marco and Zitzler, Eckart},
%   editor     = {Abraham, Ajith and Jain, Lakhmi and Goldberg, Robert},
%   pages      = {105--145},
%   publisher  = {Springer London},
%   year       = {2005},
%   address    = {London},
%   isbn       = {978-1-84628-137-2},
%   booktitle  = {Evolutionary Multiobjective Optimization: Theoretical Advances and Applications},
%   doi        = {10.1007/1-84628-137-7_6},
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
    Mobj = 3
    Dim = 30
end

methods
    function Prob = DTLZ8(varargin)
        Prob = Prob@Problem(varargin);
        Prob.maxFE = 10000;
    end

    function parameter = getParameter(Prob)
        parameter = {'M: Number of Objectives', num2str(Prob.Mobj), ...
                'D: Dimensions', num2str(Prob.Dim)};
        parent_para = Prob.getRunParameter();
        parameter = [parent_para, parameter];
    end

    function Prob = setParameter(Prob, Parameter)
        Prob.Mobj = str2double(Parameter{3});
        Prob.Dim = str2double(Parameter{4});
        Prob.setRunParameter(Parameter(1:2));
        Prob.Dim = ceil(Prob.Dim / Prob.Mobj) * Prob.Mobj;
    end

    function setTasks(Prob)
        Prob.T = 1;
        Prob.M(1) = Prob.Mobj;
        Prob.D(1) = Prob.Dim;
        Prob.Fnc{1} = @(x) dtlz8(x, Prob.M(1));
        Prob.Lb{1} = zeros(1, Prob.D(1));
        Prob.Ub{1} = ones(1, Prob.D(1));
    end

    function optimum = getOptimum(Prob)
        N = 10000; M = Prob.M(1);
        if M == 2
            temp = (0:1 / (N - 1):1)';
            optimum{1} = [(1 - temp) / 4, temp];
        else
            temp = UniformPoint(N / (M - 1), 3);
            temp(:, 3) = temp(:, 3) / 2;
            temp = temp(temp(:, 1) >= (1 - temp(:, 3)) / 4 & temp(:, 1) <= temp(:, 2) & temp(:, 3) <= 1/3, :);
            optimum{1} = [repmat(temp(:, 2), M - 1, M - 1), repmat(temp(:, 3), M - 1, 1)];
            for i = 1:M - 1
                optimum{1}((i - 1) * size(temp, 1) + 1:i * size(temp, 1), i) = temp(:, 1);
            end
            gap = sort(unique(optimum{1}(:, M)));
            gap = gap(2) - gap(1);
            temp = (1/3:gap:1)';
            optimum{1} = [optimum{1}; repmat((1 - temp) / 4, 1, M - 1), temp];
            optimum{1} = unique(optimum{1}, 'rows');
        end
    end
end
end

function [PopObj, PopCon] = dtlz8(PopDec, M)
%------------------------------- Copyright --------------------------------
% Copyright (c) 2025 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------
D = size(PopDec, 2);
PopObj = zeros(size(PopDec, 1), M);
for m = 1:M
    PopObj(:, m) = mean(PopDec(:, (m - 1) * D / M + 1:m * D / M), 2);
end
PopCon = zeros(size(PopObj, 1), M);
PopCon(:, 1:M - 1) = 1 - repmat(PopObj(:, M), 1, M - 1) - 4 * PopObj(:, 1:M - 1);
if M == 2
    PopCon(:, M) = 0;
else
    minValue = sort(PopObj(:, 1:M - 1), 2);
    PopCon(:, M) = 1 - 2 * PopObj(:, M) - sum(minValue(:, 1:2), 2);
end
end
