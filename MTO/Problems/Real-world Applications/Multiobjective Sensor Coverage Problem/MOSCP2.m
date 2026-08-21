classdef MOSCP2 < Problem
% <Multi-task> <Multi-objective> <None/Competitive>

% Multi-objective Sensor Coverage Problem

%------------------------------- Reference --------------------------------
% @Article{Li2025CMO-MTO,
%   title    = {Evolutionary Competitive Multiobjective Multitasking: One-Pass Optimization of Heterogeneous Pareto Solutions},
%   author   = {Li, Yanchi and Wu, Xinyi and Gong, Wenyin and Xu, Meng and Wang, Yubo and Gu, Qiong},
%   journal  = {IEEE Transactions on Evolutionary Computation},
%   year     = {2025},
%   volume   = {29},
%   number   = {6},
%   pages    = {2757-2770},
%   doi      = {10.1109/TEVC.2024.3524508},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, ACM Trans. Evol. Learn. Optim., 2026"
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
        currentDir = fileparts(mfilename('fullpath'));
        data = load(fullfile(currentDir, 'SCP_Adata2.mat'), 'A');
        A = data.A;
        Prob.T = Prob.Number;
        Prob.M = 2 * ones(1, Prob.T);
        Prob.D = zeros(1, Prob.T);
        Prob.Fnc = cell(1, Prob.T);
        Prob.Lb = cell(1, Prob.T);
        Prob.Ub = cell(1, Prob.T);
        for t = 1:Prob.T
            taskDim = (Prob.Nmin + Prob.Gap * (t - 1)) * 3;
            Prob.D(t) = taskDim;
            Prob.Fnc{t} = @(x)MOSCP_func(x, A, taskDim);
            Prob.Lb{t} = -ones(1, taskDim);
            Prob.Ub{t} = ones(1, taskDim);
            index = 3:3:taskDim;
            Prob.Lb{t}(index) = 0.1;
            Prob.Ub{t}(index) = 0.25;
        end
    end

    function optimum = getOptimum(Prob)
        optimum = cell(1, Prob.T);
        for t = 1:Prob.T
            optimum{t} = [80, 40];
        end
    end
end
end

function [Objs, Cons] = MOSCP_func(var, A, dim)
distanceOffset = 2 / (size(A, 1) - 1);
radiusWeight = 10;
sensorCost = dim / 3;
[coverageRatio, radiusCost] = evaluateSensorCoverage(var, A, dim, distanceOffset, radiusWeight);
f1 = 100 * (1 - coverageRatio);
f2 = sensorCost + radiusCost + f1 / 10;
Objs = [f1, f2];
Cons = zeros(size(var, 1), 1);
end
