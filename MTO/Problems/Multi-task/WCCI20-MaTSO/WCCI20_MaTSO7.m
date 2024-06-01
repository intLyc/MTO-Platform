classdef WCCI20_MaTSO7 < Problem
% <Many-task> <Single-objective> <None>

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

methods
    function Prob = WCCI20_MaTSO7(varargin)
        Prob = Prob@Problem(varargin);
        Prob.maxFE = 1000 * 50 * Prob.T;
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
            Prob.maxFE = 1000 * 50 * Prob.T;
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
        Tasks = benchmark_WCCI20_MaTSO(7, T);
        Prob.D = [];
        Prob.Fnc = {};
        Prob.Lb = {};
        Prob.Ub = {};
        for t = 1:Prob.T
            Prob.D(t) = Tasks(t).Dim;
            Prob.Fnc{t} = Tasks(t).Fnc;
            Prob.Lb{t} = Tasks(t).Lb;
            Prob.Ub{t} = Tasks(t).Ub;
        end
    end
end
end
