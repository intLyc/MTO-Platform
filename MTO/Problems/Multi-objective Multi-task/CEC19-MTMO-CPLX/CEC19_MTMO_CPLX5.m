classdef CEC19_MTMO_CPLX5 < Problem
% <Multi-task> <Multi-objective> <None>

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

methods
    function Prob = CEC19_MTMO_CPLX5(varargin)
        Prob = Prob@Problem(varargin);
        Prob.maxFE = 1000 * 240;
    end

    function setTasks(Prob)
        Prob.T = 2;
        Prob.M(1) = 2;
        Prob.D(1) = 30;
        Prob.Fnc{1} = @(x)LZ09_F3(Prob.M(1), Prob.D(1), x);
        Prob.Lb{1} = 0 * ones(1, Prob.D(1));
        Prob.Ub{1} = 1 * ones(1, Prob.D(1));

        Prob.M(2) = 3;
        Prob.D(2) = 10;
        Prob.Fnc{2} = @(x)LZ09_F6(Prob.M(2), Prob.D(2), x);
        Prob.Lb{2} = 0 * ones(1, Prob.D(2));
        Prob.Ub{2} = 1 * ones(1, Prob.D(2));
    end

    function optimum = getOptimum(Prob)
        N = 10000;
        optimum{1}(:, 1) = linspace(0, 1, N)';
        optimum{1}(:, 2) = 1 - optimum{1}(:, 1).^0.5;

        M = 3;
        optimum{2} = UniformPoint(N, M);
        optimum{2} = optimum{2} ./ repmat(sqrt(sum(optimum{2}.^2, 2)), 1, M);
    end
end
end
