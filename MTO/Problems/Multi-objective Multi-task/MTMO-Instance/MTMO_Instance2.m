classdef MTMO_Instance2 < Problem
% <Multi-task> <Multi-objective> <Constrained>

%------------------------------- Reference --------------------------------
% @article{Gupta2017MO-MFEA,
%   title      = {Multiobjective Multifactorial Optimization in Evolutionary Multitasking},
%   author     = {Gupta, Abhishek and Ong, Yew-Soon and Feng, Liang and Tan, Kay Chen},
%   journal    = {IEEE Transactions on Cybernetics},
%   number     = {7},
%   pages      = {1652-1665},
%   volume     = {47},
%   year       = {2017}
%   doi        = {10.1109/TCYB.2016.2554622},
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
    function Prob = MTMO_Instance2(varargin)
        Prob = Prob@Problem(varargin);
        Prob.maxFE = 250 * 100;
    end

    function setTasks(Prob)
        file_dir = './Problems/Multi-objective Multi-task/MTMO-Instance/';
        load([file_dir, 'M_MTMO_Instance.mat']);

        Prob.T = 2;
        Prob.M(1) = 2;
        Prob.D(1) = 10;
        Prob.Fnc{1} = @(x)ZDT4_RC.getFnc(x, 1);
        Prob.Lb{1} = -5 * ones(1, Prob.D(1));
        Prob.Ub{1} = 5 * ones(1, Prob.D(1));
        Prob.Lb{1}(1) = 0;
        Prob.Ub{1}(1) = 1;

        Prob.M(2) = 2;
        Prob.D(2) = 10;
        Prob.Fnc{2} = @(x)ZDT4_A.getFnc(x, M);
        Prob.Lb{2} = -32 * ones(1, Prob.D(2));
        Prob.Ub{2} = 32 * ones(1, Prob.D(2));
        Prob.Lb{2}(1) = 0;
        Prob.Ub{2}(1) = 1;
    end

    function optimum = getOptimum(Prob)
        optimum{1} = ZDT4_R.getOptimum(10000);
        optimum{2} = ZDT4_G.getOptimum(10000);
    end
end
end
