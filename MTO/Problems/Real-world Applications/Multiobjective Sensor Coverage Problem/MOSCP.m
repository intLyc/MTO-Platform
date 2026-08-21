classdef MOSCP < Problem
% <Multi-task> <Multi-objective> <None/Competitive>

% Multi-objective Sensor Coverage Problem

%------------------------------- Reference --------------------------------
% @InProceedings{Li2024MTEA-D-TSD,
%   title     = {Transfer Search Directions Among Decomposed Subtasks for Evolutionary Multitasking in Multiobjective Optimization},
%   author    = {Li, Yanchi and Gong, Wenyin and Gu, Qiong},
%   booktitle = {Genetic and Evolutionary Computation Conference},
%   year      = {2024},
%   series    = {GECCO '24},
%   doi       = {10.1145/3638529.3653989},
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
    Nmin = 28
    TaskNum = 5
    Gap = 1
end

methods
    function Prob = MOSCP(name)
        Prob = Prob@Problem(name);
        Prob.maxFE = 1000 * 50 * Prob.TaskNum;
    end

    function parameter = getParameter(Prob)
        parameter = {'Minimum Sensor TaskNum', num2str(Prob.Nmin), ...
                'Task Number', num2str(Prob.TaskNum), ...
                'Gap', num2str(Prob.Gap)};
        parameter = [Prob.getRunParameter(), parameter];
    end

    function Prob = setParameter(Prob, Parameter)
        nmin = str2double(Parameter{3});
        taskn = str2double(Parameter{4});
        gap = str2double(Parameter{5});
        if Prob.Nmin == nmin && Prob.TaskNum == taskn && Prob.Gap == gap
            Prob.setRunParameter(Parameter(1:2));
        else
            Prob.Nmin = nmin;
            Prob.TaskNum = taskn;
            Prob.Gap = gap;
            Prob.maxFE = 1000 * 50 * Prob.TaskNum;
            Prob.setRunParameter({Parameter{1}, num2str(Prob.maxFE)});
        end
    end

    function setTasks(Prob)
        currentDir = fileparts(mfilename('fullpath'));
        data = load(fullfile(currentDir, 'SCP_Adata2.mat'), 'A');
        A = data.A;
        Prob.T = Prob.TaskNum;
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
f2 = sensorCost + radiusCost;
Objs = [f1, f2];
Cons = zeros(size(var, 1), 1);
end
