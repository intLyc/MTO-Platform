classdef Func_Schwefel2 < Problem
% <Single-task> <Single-objective> <None>

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
%--------------------------------------------------------------------------

methods
    function Prob = Func_Schwefel2(varargin)
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
        Prob.Fnc{1} = @(x)Schwefel2(x, 1, 0, 0);
    end
end
end
