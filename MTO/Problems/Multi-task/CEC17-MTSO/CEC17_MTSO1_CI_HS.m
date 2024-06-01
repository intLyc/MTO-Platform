classdef CEC17_MTSO1_CI_HS < Problem
% <Multi-task> <Single-objective> <None>

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

methods
    function Prob = CEC17_MTSO1_CI_HS(varargin)
        Prob = Prob@Problem(varargin);
        Prob.maxFE = 1000 * 100;
    end

    function setTasks(Prob)
        Tasks = benchmark_CEC17_MTSO(1);
        Prob.T = length(Tasks);
        for t = 1:Prob.T
            Prob.D(t) = Tasks(t).Dim;
            Prob.Fnc{t} = Tasks(t).Fnc;
            Prob.Lb{t} = Tasks(t).Lb;
            Prob.Ub{t} = Tasks(t).Ub;
        end
    end
end
end
