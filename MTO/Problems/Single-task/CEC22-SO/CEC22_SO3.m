classdef CEC22_SO3 < Problem
% <Single-task> <Single-objective> <None>

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

methods
    function Prob = CEC22_SO3(varargin)
        Prob = Prob@Problem(varargin);
        if Prob.D == 10
            Prob.maxFE = 200 * 1000;
        else
            Prob.maxFE = 1000 * 1000;
        end
    end

    function Parameter = getParameter(Prob)
        Parameter = {'Dim', num2str(Prob.D)};
        Parameter = [Prob.getRunParameter(), Parameter];
    end

    function Prob = setParameter(Prob, Parameter)
        D = str2double(Parameter{3});
        if D < 20
            D = 10;
        else
            D = 20;
        end
        if Prob.D == D
            Prob.setRunParameter(Parameter(1:2));
        else
            Prob.D = D;
            if Prob.D == 10
                Prob.maxFE = 200 * 1000;
            else
                Prob.maxFE = 1000 * 1000;
            end
            Prob.setRunParameter({Parameter{1}, num2str(Prob.maxFE)});
        end
    end

    function setTasks(Prob)
        if isempty(Prob.D)
            D = Prob.defaultD;
            if D < 20
                D = 10;
            else
                D = 20;
            end
            Prob.D = D;
        end
        Tasks(1) = benchmark_CEC22_SO(3, Prob.D);
        Prob.T = 1;
        Prob.D(1) = Tasks(1).Dim;
        Prob.Fnc{1} = Tasks(1).Fnc;
        Prob.Lb{1} = Tasks(1).Lb;
        Prob.Ub{1} = Tasks(1).Ub;
    end
end
end
