classdef SCP < Problem
% <Multi-task> <Single-objective> <None/Competitive>

% Sensor Coverage Problem

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
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, ACM Trans. Evol. Learn. Optim., 2026"
%--------------------------------------------------------------------------

properties
    Nmin = 25
    Nmax = 35
end

methods
    function Prob = SCP(name)
        Prob = Prob@Problem(name);
        Prob.maxFE = 1000 * 50 * (Prob.Nmax - Prob.Nmin + 1);
    end

    function parameter = getParameter(Prob)
        parameter = {'Nmin', num2str(Prob.Nmin), ...
                'Nmax', num2str(Prob.Nmax)};
        parameter = [Prob.getRunParameter(), parameter];
    end

    function Prob = setParameter(Prob, Parameter)
        nmin = str2double(Parameter{3});
        nmax = str2double(Parameter{4});
        if Prob.Nmin == nmin && Prob.Nmax == nmax
            Prob.setRunParameter(Parameter(1:2));
        else
            Prob.Nmin = nmin; Prob.Nmax = nmax;
            Prob.maxFE = 1000 * 50 * (Prob.Nmax - Prob.Nmin + 1);
            Prob.setRunParameter({Parameter{1}, num2str(Prob.maxFE)});
        end
    end

    function setTasks(Prob)
        currentDir = fileparts(mfilename('fullpath'));
        data = load(fullfile(currentDir, 'SCP_Adata.mat'), 'A');
        A = data.A;
        Prob.T = Prob.Nmax - Prob.Nmin + 1;
        Prob.M = ones(1, Prob.T);
        Prob.D = zeros(1, Prob.T);
        Prob.Fnc = cell(1, Prob.T);
        Prob.Lb = cell(1, Prob.T);
        Prob.Ub = cell(1, Prob.T);
        for t = 1:Prob.T
            taskDim = (Prob.Nmin + (t - 1)) * 3;
            Prob.D(t) = taskDim;
            Prob.Fnc{t} = @(x)SCP_func(x, A, taskDim);
            Prob.Lb{t} = -ones(1, taskDim);
            Prob.Ub{t} = ones(1, taskDim);
            index = 3:3:taskDim;
            Prob.Lb{t}(index) = 0.1;
            Prob.Ub{t}(index) = 0.25;
        end
    end
end
end

function [Objs, Cons] = SCP_func(var, A, dim)
coverageWeight = 1000;
radiusWeight = 10;
sensorCost = dim / 3;
[coverageRatio, radiusCost] = evaluateSensorCoverage(var, A, dim, 0, radiusWeight);
Objs = coverageWeight * (1 - coverageRatio) + sensorCost + radiusCost;
Cons = zeros(size(var, 1), 1);
end
