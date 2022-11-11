classdef CEC19_MTMO_CPLX6 < Problem
    % <Multi-task> <Multi-objective> <None>

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods
        function Prob = CEC19_MTMO_CPLX6(varargin)
            Prob = Prob@Problem(varargin);
            Prob.maxFE = 1000 * 200;
        end

        function setTasks(Prob)
            Prob.T = 2;
            Prob.M(1) = 2;
            Prob.D(1) = 30;
            Prob.Fnc{1} = @(x)LZ09_F3(Prob.M(1), Prob.D(1), x);
            Prob.Lb{1} = -50 * ones(1, Prob.D(1));
            Prob.Ub{1} = 50 * ones(1, Prob.D(1));
            Prob.Lb{1}(1) = 0;
            Prob.Ub{1}(1) = 1;

            Prob.M(2) = 2;
            Prob.D(2) = 30;
            Prob.Fnc{2} = @(x)LZ09_F9(Prob.M(2), Prob.D(2), x);
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
            optimum{2}(:, 2) = 1 - optimum{2}(:, 1).^2;
        end
    end
end
