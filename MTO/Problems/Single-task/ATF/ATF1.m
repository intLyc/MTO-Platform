classdef ATF1 < Problem
% <Single-task> <Single-objective> <Constrained>

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

methods
    function Prob = ATF1(varargin)
        Prob = Prob@Problem(varargin);
        Prob.maxFE = 60 * 500;
    end

    function setTasks(Prob)
        Prob.T = 1;
        Prob.D(1) = 2;
        Prob.Fnc{1} = @(x)ATF_Func(x, 1);
        Prob.Lb{1} = [-10, -5];
        Prob.Ub{1} = [5, 5];
    end
end
end
