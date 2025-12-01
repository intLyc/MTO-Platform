classdef CEC17_MTMO4_PI_HS < Problem
% <Multi-task> <Multi-objective> <None>

%------------------------------- Reference --------------------------------
% @article{Yuan2017CEC2017-MTMO,
%   title      = {Evolutionary Multitasking for Multiobjective Continuous Optimization: Benchmark Problems, Performance Metrics and Baseline Results},
%   author     = {Yuan, Yuan and Ong, Yew-Soon and Feng, Liang and Qin, A Kai and Gupta, Abhishek and Da, Bingshui and Zhang, Qingfu and Tan, Kay Chen and Jin, Yaochu and Ishibuchi, Hisao},
%   file       = {:Yuan2017CEC2017-MTMO - Evolutionary Multitasking for Multiobjective Continuous Optimization_ Benchmark Problems, Performance Metrics and Baseline Results.pdf:PDF},
%   journal    = {arXiv preprint arXiv:1706.02766},
%   year       = {2017}
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

methods
    function Prob = CEC17_MTMO4_PI_HS(varargin)
        Prob = Prob@Problem(varargin);
        Prob.maxFE = 1000 * 200;
    end

    function setTasks(Prob)
        current_dir = fileparts(mfilename('fullpath'));
        file_dir = fullfile(current_dir, 'Data/');

        Prob.T = 2;
        Prob.M(1) = 2;
        Prob.D(1) = 50;
        Prob.Fnc{1} = @(x)getFun_CEC17_MTMO(x, 4, 1, 1, 0);
        Prob.Lb{1} = -100 * ones(1, Prob.D(1));
        Prob.Ub{1} = 100 * ones(1, Prob.D(1));
        Prob.Lb{1}(1) = 0;
        Prob.Ub{1}(1) = 1;

        load([file_dir, 'Sph2.mat'])
        Prob.M(2) = 2;
        Prob.D(2) = 50;
        Prob.Fnc{2} = @(x)getFun_CEC17_MTMO(x, 4, 2, 1, Sph2);
        Prob.Lb{2} = -100 * ones(1, Prob.D(2));
        Prob.Ub{2} = 100 * ones(1, Prob.D(2));
        Prob.Lb{2}(1) = 0;
        Prob.Ub{2}(1) = 1;
    end

    function optimum = getOptimum(Prob)
        N = 10000;
        optimum{1}(:, 1) = linspace(0, 1, N)';
        optimum{1}(:, 2) = 1 - optimum{1}(:, 1).^0.5;

        optimum{2}(:, 1) = linspace(0, 1, N)';
        optimum{2}(:, 2) = 1 - optimum{2}(:, 1).^0.5;
    end
end
end
