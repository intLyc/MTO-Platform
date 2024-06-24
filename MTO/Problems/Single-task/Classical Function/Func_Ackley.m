classdef Func_Ackley < Problem
% <Single-task> <Single-objective> <None>

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

methods
    function Prob = Func_Ackley(varargin)
        Prob = Prob@Problem(varargin);
        Prob.maxFE = 1000 * Prob.D;
        Prob.Lb{1} = -100 * ones(1, Prob.D);
        Prob.Ub{1} = 100 * ones(1, Prob.D);
    end

    function Parameter = getParameter(Prob)
        Parameter = {'Dim', num2str(Prob.D), ...
                'Lb', num2str(mean(Prob.Lb{1})), ...
                'Ub', num2str(mean(Prob.Ub{1}))};
        Parameter = [Prob.getRunParameter(), Parameter];
    end

    function Prob = setParameter(Prob, Parameter)
        D = str2double(Parameter{3});
        if Prob.D == D
            Prob.setRunParameter(Parameter(1:2));
        else
            Prob.D = D;
            Prob.maxFE = 1000 * Prob.D;
            Prob.setRunParameter({Parameter{1}, num2str(Prob.maxFE)});
        end
        Prob.Lb{1} = ones(1, Prob.D) * str2double(Parameter{4});
        Prob.Ub{1} = ones(1, Prob.D) * str2double(Parameter{5});
    end

    function setTasks(Prob)
        if isempty(Prob.D)
            Prob.D = Prob.defaultD;
        end
        Prob.T = 1;
        Prob.Fnc{1} = @(x)Ackley(x, 1, 0, 0);
    end
end
end
