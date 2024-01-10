classdef OPF_MTMO2 < Problem
% <Multi-task> <Multi-objective> <Constrained>

% Multi-objective Optimal Power Flow

%------------------------------- Reference --------------------------------
% @Article{Li2024MTDE-MKTA,
%   title    = {Multiobjective Multitask Optimization with Multiple Knowledge Types and Transfer Adaptation},
%   author   = {Li, Yanchi and Gong, Wenyin},
%   journal  = {IEEE Transactions on Evolutionary Computation},
%   year     = {2024},
% }
%--------------------------------------------------------------------------
% @Article{Li2022Multi,
%   title    = {Multi-Objective Optimal Power Flow with Stochastic Wind and Solar Power},
%   author   = {Shuijia Li and Wenyin Gong and Ling Wang and Qiong Gu},
%   journal  = {Applied Soft Computing},
%   year     = {2022},
%   issn     = {1568-4946},
%   pages    = {108045},
%   volume   = {114},
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
    function Prob = OPF_MTMO2(name)
        Prob = Prob@Problem(name);
        Prob.maxFE = 1000 * 200;
    end

    function setTasks(Prob)
        Prob.T = 2;
        % IEEE-30
        Prob.M(1) = 3;
        Prob.D(1) = 24;
        Prob.Fnc{1} = @(x)IEEE_30_MO(x, 2);
        Prob.Lb{1} = [20 15 10 10 12 0.95 0.95 0.95 0.95 0.95 0.95 0 0 0 0 0 0 0 0 0 0.9 0.9 0.9 0.9];
        Prob.Ub{1} = [80 50 35 30 40 1.1 1.1 1.1 1.1 1.1 1.1 5 5 5 5 5 5 5 5 5 1.1 1.1 1.1 1.1];
        % IEEE-57
        Prob.M(2) = 3;
        Prob.D(2) = 33;
        Prob.Fnc{2} = @(x)IEEE_57_MO(x, 2);
        Prob.Lb{2} = [30 40 30 100 30 100 0.95 * ones(1, 7) 0 0 0 0.9 * ones(1, 17)];
        Prob.Ub{2} = [100 140 100 550 100 410 1.1 * ones(1, 7) 20 20 20 1.1 * ones(1, 17)];
    end

    function optimum = getOptimum(Prob)
        optimum{1} = [0, 0, 0];
        optimum{2} = [0, 0, 0];
    end
end
end
