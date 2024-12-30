classdef OPF_CMTMO3 < Problem
% <Multi-task> <Multi-objective> <Constrained/Competitive>

% Competitive Multi-objective Multi-task Optimal Power Flow

%------------------------------- Reference --------------------------------
% @Article{Li2025CMO-MTO,
%   title    = {Evolutionary Competitive Multiobjective Multitasking: One-Pass Optimization of Heterogeneous Pareto Solutions},
%   author   = {Li, Yanchi and Wu, Xinyi and Gong, Wenyin and Xu, Meng and Wang, Yubo and Gu, Qiong},
%   journal  = {IEEE Transactions on Evolutionary Computation},
%   year     = {2024},
%   doi      = {10.1109/TEVC.2024.3524508},
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
    function Prob = OPF_CMTMO3(name)
        Prob = Prob@Problem(name);
        Prob.maxFE = 500 * 200;
    end

    function setTasks(Prob)
        Prob.T = 2;
        % IEEE-30 of Thermal
        Prob.M(1) = 3;
        Prob.D(1) = 24;
        Prob.Fnc{1} = @(x)IEEE_30_Thermal(x, 3);
        Prob.Lb{1} = [20 15 10 10 12 0.95 0.95 0.95 0.95 0.95 0.95 0 0 0 0 0 0 0 0 0 0.9 0.9 0.9 0.9];
        Prob.Ub{1} = [80 50 35 30 40 1.1 1.1 1.1 1.1 1.1 1.1 5 5 5 5 5 5 5 5 5 1.1 1.1 1.1 1.1];
        % IEEE-30 of Wind-Solar and Thermal
        Prob.M(2) = 3;
        Prob.D(2) = 11;
        Prob.Fnc{2} = @(x)IEEE_30_WindSolar(x, 3);
        Prob.Lb{2} = [20 0 10 0 0 0.95 0.95 0.95 0.95 0.95 0.95];
        Prob.Ub{2} = [80 75 35 60 50 1.1 1.1 1.1 1.1 1.1 1.1];
    end

    function optimum = getOptimum(Prob)
        optimum{1} = [750, 0, 0];
        optimum{2} = [750, 0, 0];
    end
end
end
