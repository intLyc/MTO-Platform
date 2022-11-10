classdef CEC17_MTMO2_CI_MS < Problem
    % <MT-MO> <None>

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
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods
        function Prob = CEC17_MTMO2_CI_MS(varargin)
            Prob = Prob@Problem(varargin);
            Prob.maxFE = 1000 * 200;
        end

        function setTasks(Prob)
            file_dir = './Problems/MT-MO/CEC17-MTMO/Data/';

            Prob.T = 2;
            Prob.M(1) = 2;
            Prob.D(1) = 10;
            Prob.Fnc{1} = @(x)getFun_CEC17_MTMO(x, 2, 1, 1, 0);
            Prob.Lb{1} = -5 * ones(1, Prob.D(1));
            Prob.Ub{1} = 5 * ones(1, Prob.D(1));
            Prob.Lb{1}(1) = 0;
            Prob.Ub{1}(1) = 1;

            load([file_dir, 'Mcm2.mat'])
            load([file_dir, 'Scm2.mat'])
            Prob.M(2) = 2;
            Prob.D(2) = 10;
            Prob.Fnc{2} = @(x)getFun_CEC17_MTMO(x, 2, 2, Mcm2, Scm2);
            Prob.Lb{2} = -5 * ones(1, Prob.D(2));
            Prob.Ub{2} = 5 * ones(1, Prob.D(2));
            Prob.Lb{2}(1) = 0;
            Prob.Ub{2}(1) = 1;
        end

        function optimum = getOptimum(Prob)
            N = 10000; M = 2;
            optimum{1}(:, 1) = linspace(0, 1, N)';
            optimum{1}(:, 2) = 1 - optimum{1}(:, 1).^2;

            optimum{2} = UniformPoint(N, M);
            optimum{2} = optimum{2} ./ repmat(sqrt(sum(optimum{2}.^2, 2)), 1, M);
        end
    end
end
