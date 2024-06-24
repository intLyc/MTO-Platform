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
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
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
        load SCP_Adata2
        Prob.T = Prob.TaskNum;
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
rsample = 2 / (size(A, 1) - 1); % range of sample
Objs = [];
for i = 1:size(var, 1)
    x = var(i, :);
    b = 10; c0 = 1;
    x = x(1:dim); % decision variables
    k = dim / 3; % number of sensors
    x = reshape(x, 3, k)';
    d = pdist2(A, x(:, 1:2)); % distance between sensors and points
    iscoverage = (d + rsample <= repmat(x(:, 3)', size(A, 1), 1));
    maxisconverage = max(iscoverage, [], 2);
    convarage_ratio = sum(maxisconverage) / (size(A, 1));
    f1 = 100 * (1 - convarage_ratio); % inverted coverage percentage
    f2 = c0 * k + sum(b * x(:, 3).^2); % cost of sensors
    Obj = [f1, f2];
    Objs(i, :) = Obj;
end
Cons = zeros(size(var, 1), 1);
end
