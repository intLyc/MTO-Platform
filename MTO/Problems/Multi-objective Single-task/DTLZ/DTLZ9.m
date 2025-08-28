classdef DTLZ9 < Problem
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
    Mobj = 2
    Dim = 20
end

methods
    function Prob = DTLZ9(varargin)
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
        Prob.Dim = ceil(Prob.Dim / Prob.Mobj) * Prob.Mobj;
    end

    function setTasks(Prob)
        Prob.T = 1;
        Prob.M(1) = Prob.Mobj;
        Prob.D(1) = Prob.Dim;
        Prob.Fnc{1} = @(x) dtlz9(x, Prob.M(1));
        Prob.Lb{1} = zeros(1, Prob.D(1));
        Prob.Ub{1} = ones(1, Prob.D(1));
    end

    function optimum = getOptimum(Prob)
        N = 10000; M = Prob.M(1);
        Temp = (0:1 / (N - 1):1)';
        optimum{1} = [repmat(cos(0.5 .* pi .* Temp), 1, M - 1), sin(0.5 .* pi .* Temp)];
    end
end
end

function [PopObj, PopCVs] = dtlz9(PopDec, M)
%------------------------------- Copyright --------------------------------
% Copyright (c) 2025 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------
D = size(PopDec, 2);
X = PopDec;
PopDec = PopDec.^0.1;
PopObj = zeros(size(PopDec, 1), M);
for m = 1:M
    PopObj(:, m) = sum(PopDec(:, (m - 1) * D / M + 1:m * D / M), 2);
end
PopCon = 1 - repmat(PopObj(:, M).^2, 1, M - 1) - PopObj(:, 1:M - 1).^2;
PopCVs = sum(max(0, PopCon), 2);
end
