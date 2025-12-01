classdef C4TOP9 < Problem
% <Multi-task> <Single-objective> <Competitive>

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

methods
    function Prob = C4TOP9(varargin)
        Prob = Prob@Problem(varargin);
        Prob.maxFE = 500 * 100 * 4;
    end

    function setTasks(Prob)
        Tasks = benchmark_C4TOP(9);
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
