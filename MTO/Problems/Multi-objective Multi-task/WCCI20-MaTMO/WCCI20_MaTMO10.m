classdef WCCI20_MaTMO10 < Problem
% <Many-task> <Multi-objective> <None>

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

methods
    function Prob = WCCI20_MaTMO10(varargin)
        Prob = Prob@Problem(varargin);
        Prob.maxFE = 500 * 100 * Prob.T;
    end

    function Parameter = getParameter(Prob)
        Parameter = {'Task Num', num2str(Prob.T)};
        Parameter = [Prob.getRunParameter(), Parameter];
    end

    function Prob = setParameter(Prob, Parameter)
        T = str2double(Parameter{3});
        if Prob.T == T
            Prob.setRunParameter(Parameter(1:2));
        else
            Prob.T = T;
            Prob.maxFE = 500 * 100 * Prob.T;
            Prob.setRunParameter({Parameter{1}, num2str(Prob.maxFE)});
        end
    end

    function setTasks(Prob)
        if ~isempty(Prob.T)
            T = Prob.T;
        else
            T = Prob.defaultT;
            Prob.T = Prob.defaultT;
        end
        Tasks = benchmark_WCCI20_MaTMO(10, T);
        Prob.M = [];
        Prob.D = [];
        Prob.Fnc = {};
        Prob.Lb = {};
        Prob.Ub = {};
        for t = 1:Prob.T
            Prob.M(t) = 2;
            Prob.D(t) = Tasks(t).Dim;
            Prob.Fnc{t} = Tasks(t).Fnc;
            Prob.Lb{t} = Tasks(t).Lb;
            Prob.Ub{t} = Tasks(t).Ub;
        end
    end

    function optimum = getOptimum(Prob)
        N = 10000; M = 2;
        for t = 1:Prob.T
            % convex
            optimum{t}(:, 1) = linspace(0, 1, N)';
            optimum{t}(:, 2) = 1 - optimum{t}(:, 1).^0.5;
        end
    end
end
end
