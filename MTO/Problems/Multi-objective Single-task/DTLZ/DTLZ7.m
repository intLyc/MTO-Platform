classdef DTLZ7 < Problem
% <Single-task> <Multi-objective/Many-objective> <None>

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
    Dim = 22
end

methods
    function Prob = DTLZ7(varargin)
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
    end

    function setTasks(Prob)
        Prob.T = 1;
        Prob.M(1) = Prob.Mobj;
        Prob.D(1) = Prob.Dim;
        Prob.Fnc{1} = @(x) dtlz7(x, Prob.M(1));
        Prob.Lb{1} = zeros(1, Prob.D(1));
        Prob.Ub{1} = ones(1, Prob.D(1));
    end

    function optimum = getOptimum(Prob)
        N = 10000; M = Prob.M(1);
        interval = [0, 0.251412, 0.631627, 0.859401];
        median = (interval(2) - interval(1)) / (interval(4) - interval(3) + interval(2) - interval(1));
        X = UniformPoint(N, M - 1, 'grid');
        X(X <= median) = X(X <= median) * (interval(2) - interval(1)) / median + interval(1);
        X(X > median) = (X(X > median) - median) * (interval(4) - interval(3)) / (1 - median) + interval(3);
        optimum{1} = [X, 2 * (M - sum(X / 2 .* (1 + sin(3 * pi .* X)), 2))];
    end
end
end

function [PopObj, PopCVs] = dtlz7(PopDec, M)
%------------------------------- Copyright --------------------------------
% Copyright (c) 2025 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------
D = size(PopDec, 2);
g = 1 + 9 * mean(PopDec(:, M:end), 2);
PopObj(:, 1:M - 1) = PopDec(:, 1:M - 1);
PopObj(:, M) = (1 + g) .* (M - sum(PopObj(:, 1:M - 1) ./ (1 + repmat(g, 1, M - 1)) .* (1 + sin(3 * pi .* PopObj(:, 1:M - 1))), 2));
PopCVs = zeros(size(PopDec, 1), 1);
end
