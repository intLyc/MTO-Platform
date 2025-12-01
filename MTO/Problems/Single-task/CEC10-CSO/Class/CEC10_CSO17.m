classdef CEC10_CSO17 < Problem
% <Single-task> <Single-objective> <Constrained>

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

methods
    function Prob = CEC10_CSO17(varargin)
        Prob = Prob@Problem(varargin);
        Prob.maxFE = 20000 * Prob.D;
    end

    function Parameter = getParameter(Prob)
        Parameter = {'Dim', num2str(Prob.D)};
        Parameter = [Prob.getRunParameter(), Parameter];
    end

    function Prob = setParameter(Prob, Parameter)
        D = str2double(Parameter{3});
        if D ~= 10 && D ~= 30
            [~, idx] = min([abs(D - 10), abs(D - 30)]);
            if idx == 1
                D = 10;
            else
                D = 30;
            end
        end
        if Prob.D == D
            Prob.setRunParameter(Parameter(1:2));
        else
            Prob.D = D;
            Prob.maxFE = 20000 * Prob.D;
            Prob.setRunParameter({Parameter{1}, num2str(Prob.maxFE)});
        end
    end

    function setTasks(Prob)
        if isempty(Prob.D)
            D = Prob.defaultD;
            if D ~= 10 && D ~= 30
                [~, idx] = min([abs(D - 10), abs(D - 30)]);
                if idx == 1
                    D = 10;
                else
                    D = 30;
                end
            end
            Prob.D = D;
        end

        Tasks(1) = benchmark_CEC10_CSO(17, Prob.D);
        Prob.T = 1;
        Prob.D(1) = Tasks(1).Dim;
        Prob.Fnc{1} = Tasks(1).Fnc;
        Prob.Lb{1} = Tasks(1).Lb;
        Prob.Ub{1} = Tasks(1).Ub;
    end
end
end
