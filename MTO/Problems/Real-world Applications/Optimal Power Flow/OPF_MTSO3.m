classdef OPF_MTSO3 < Problem
% <Multi-task> <Single-objective> <Constrained>

% Optimal Power Flow as Constrained Multitask Optimization

%------------------------------- Reference --------------------------------
% @Article{Li2023MTES-KG,
%   title    = {Multitask Evolution Strategy with Knowledge-Guided External Sampling},
%   author   = {Li, Yanchi and Gong, Wenyin and Li, Shuijia},
%   journal  = {IEEE Transactions on Evolutionary Computation},
%   year     = {2023},
%   doi      = {10.1109/TEVC.2023.3330265},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

methods
    function Prob = OPF_MTSO3(name)
        Prob = Prob@Problem(name);
        Prob.maxFE = 1000 * 200;
    end

    function setTasks(Prob)
        Prob.T = 2;
        Prob.D(1) = 24;
        Prob.Fnc{1} = @(x)IEEE_30_SO(x, 3);
        Prob.Lb{1} = [20 15 10 10 12 0.95 0.95 0.95 0.95 0.95 0.95 0 0 0 0 0 0 0 0 0 0.9 0.9 0.9 0.9];
        Prob.Ub{1} = [80 50 35 30 40 1.1 1.1 1.1 1.1 1.1 1.1 5 5 5 5 5 5 5 5 5 1.1 1.1 1.1 1.1];
        Prob.D(2) = 33;
        Prob.Fnc{2} = @(x)IEEE_57_SO(x, 3);
        Prob.Lb{2} = [30 40 30 100 30 100 0.95 * ones(1, 7) 0 0 0 0.9 * ones(1, 17)];
        Prob.Ub{2} = [100 140 100 550 100 410 1.1 * ones(1, 7) 20 20 20 1.1 * ones(1, 17)];
    end
end
end
