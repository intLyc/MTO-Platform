classdef MaT_CEC17_SO < Problem
% <Many-task> <Single-objective> <None>

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
%--------------------------------------------------------------------------

methods
    function Prob = MaT_CEC17_SO(varargin)
        Prob = Prob@Problem(varargin);
        Prob.maxFE = 3000 * 50 * 29;
    end

    function setTasks(Prob)
        Prob.T = 29 * 3;
        Prob.D = zeros(1, 29 * 3);
        Prob.D(1:29) = 10;
        Prob.D(30:58) = 30;
        Prob.D(59:87) = 50;
        for i = 1:Prob.T / 3
            Task = benchmark_CEC17_SO(i, 10);
            Prob.Fnc{i} = Task.Fnc;
            Prob.Lb{i} = Task.Lb;
            Prob.Ub{i} = Task.Ub;
        end
        for i = Prob.T / 3 + 1:Prob.T / 3 * 2
            j = i - Prob.T / 3;
            Task = benchmark_CEC17_SO(j, 30);
            Prob.Fnc{i} = Task.Fnc;
            Prob.Lb{i} = Task.Lb;
            Prob.Ub{i} = Task.Ub;
        end
        for i = Prob.T / 3 * 2 + 1:Prob.T
            j = i - Prob.T / 3 * 2;
            Task = benchmark_CEC17_SO(j, 50);
            Prob.Fnc{i} = Task.Fnc;
            Prob.Lb{i} = Task.Lb;
            Prob.Ub{i} = Task.Ub;
        end
    end
end
end
