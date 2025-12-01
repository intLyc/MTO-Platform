classdef CEC21_MTMO_CPLX2 < Problem
% <Multi-task> <Multi-objective> <None>

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

methods
    function Prob = CEC21_MTMO_CPLX2(varargin)
        Prob = Prob@Problem(varargin);
        Prob.maxFE = 1000 * 200;
    end

    function setTasks(Prob)
        Tasks = benchmark_CEC21_MTMO(2);
        Prob.T = length(Tasks);
        for t = 1:Prob.T
            Prob.M(t) = 2;
            Prob.D(t) = Tasks(t).dim;
            Prob.Fnc{t} = @(x)getFun_CEC21_MTMO(x, Tasks(t).tType, Tasks(t).shift, Tasks(t).rotation, Tasks(t).boundaryCvDv, Tasks(t).gType, Tasks(t).f1Type, Tasks(t).hType, Tasks(t).Lb, Tasks(t).Ub);
            Prob.Lb{t} = Tasks(t).Lb;
            Prob.Ub{t} = Tasks(t).Ub;
        end
    end

    function optimum = getOptimum(Prob)
        N = 10000; M = 2;
        % circle
        optimum{1} = UniformPoint(N, M);
        optimum{1} = optimum{1} ./ repmat(sqrt(sum(optimum{1}.^2, 2)), 1, M);
        % concave
        optimum{2}(:, 1) = linspace(0, 1, N)';
        optimum{2}(:, 2) = 1 - optimum{2}(:, 1).^2;
    end
end
end
