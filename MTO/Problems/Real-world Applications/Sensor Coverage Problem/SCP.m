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
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
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
        load SCP_Adata
        Prob.T = Prob.Nmax - Prob.Nmin + 1;
        for t = 1:Prob.T
            Prob.M(t) = 1;
            Prob.D(t) = (Prob.Nmin + (t - 1)) * 3;
            Prob.Fnc{t} = @(x)SCP_func(x, A, Prob.D(t));
            Prob.Lb{t} = -ones(1, Prob.D(t));
            Prob.Ub{t} = ones(1, Prob.D(t));
            index = 3:3:Prob.D(t);
            Prob.Lb{t}(index) = 0.1;
            Prob.Ub{t}(index) = 0.25;
        end
    end
end
end

function [Objs, Cons] = SCP_func(var, A, dim)
Objs = [];
for i = 1:size(var, 1)
    x = var(i, :);
    a = 1000; b = 10; c0 = 1;
    x = x(1:dim);
    k = dim / 3;
    x = reshape(x, 3, k)';
    d = pdist2(A, x(:, 1:2));
    isconverage = (d <= repmat(x(:, 3)', size(A, 1), 1));
    maxisconverage = max(isconverage, [], 2);
    convarage_ratio = sum(maxisconverage) / (size(A, 1));
    f = a * (1 - convarage_ratio) + c0 * k + sum(b * x(:, 3).^2);
    Objs(i, :) = f;
end
Cons = zeros(size(var, 1), 1);
end
