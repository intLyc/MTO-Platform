classdef Problem < handle
%% Problem Base Class
% Inherit the Problem class and implement the abstract functions

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties
    defaultT = 50 % Default tasks number
    defaultD = 50 % Default dimension for each task
    defaultN = 100 % Default population size for each task

    Name % (cell) Problems Name List
    T % (integer) Tasks number
    N % (integer) Population size for each task
    M % (vector) Objective number for each task
    D % (vector) Dimension for each task
    Fnc % (cell) Function for each task
    Lb % (cell) Lower Bound for each task
    Ub % (cell) Upper Bound for each task
    maxFE % (integer) Maximum evaluations
end

methods
    function Prob = Problem(varargin)
        if length(varargin) == 1
            Prob.Name = char(varargin{1});
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
end

methods (Abstract)
    setTasks(Prob)
end
end
