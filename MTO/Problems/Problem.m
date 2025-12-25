classdef Problem < handle
%% Problem Base Class
% Inherit the Problem class and implement the abstract functions

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties (Constant)
    defaultT = 50 % Default tasks number
    defaultD = 50 % Default dimension for each task
    defaultN = 100 % Default population size for each task
end

properties
    Name char % Algorithm/Problem Name

    T (1, 1) double % Tasks number
    N (1, 1) double % Population size for each task
    M (:, 1) double % Objective number for each task
    D (:, 1) double % Dimension for each task
    maxFE (1, 1) double % Maximum evaluations

    Fnc cell % Function handle for each task
    Lb cell % Lower Bound for each task
    Ub cell % Upper Bound for each task

    Bounded logical = true % Is the problem bounded
    ReEvalBest logical = false % Re-evaluate the best solution
end

methods (Abstract)
    setTasks(Prob)
end

methods
    function Prob = Problem(name)
        if nargin > 0 && ~isempty(name)
            Prob.Name = char(name);
        else
            Prob.Name = strrep(class(Prob), '_', '-');
        end
        Prob.M = 1;
        Prob.N = Prob.defaultN;
        Prob.setTasks();
    end

    function RunPara = getRunParameter(Prob)
        RunPara = {'N: Each Task Population Size', num2str(Prob.N), ...
                'maxFE: All Task Maximum Evaluations', num2str(Prob.maxFE)};
    end

    function Prob = setRunParameter(Prob, RunPara)
        Prob.N = str2double(RunPara{1});
        Prob.maxFE = str2double(RunPara{2});
        Prob.setTasks();
    end

    function Parameter = getParameter(Prob)
        % Default getParameter
        % return parameter, contains {para1, value1, para2, value2, ...} (string)
        Parameter = Prob.getRunParameter();
    end

    function Prob = setParameter(Prob, Parameter)
        % Default getParameter
        % arg Parameter, contains {value1, value2, ...} (string)
        Prob.setRunParameter(Parameter);
    end

    function [Objs, Cons] = evaluate(Prob, x, t)
        % Evaluate the objective and constraint values of x on task t
        if Prob.Bounded
            x = max(min(x, Prob.Ub{t}), Prob.Lb{t});
        end
        [Objs, Cons] = Prob.Fnc{t}(x);
    end
end
end
