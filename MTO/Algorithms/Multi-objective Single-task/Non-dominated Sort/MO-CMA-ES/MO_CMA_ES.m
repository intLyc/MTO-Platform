classdef MO_CMA_ES < Algorithm
% <Single-task> <Multi-objective> <None>

%------------------------------- Reference --------------------------------
% @Article{Igel2007MO-CMA-ES,
%   title   = {Covariance Matrix Adaptation for Multi-objective Optimization},
%   author  = {Igel, Christian and Hansen, Nikolaus and Roth, Stefan},
%   journal = {Evolutionary Computation},
%   year    = {2007},
%   number  = {1},
%   pages   = {1-28},
%   volume  = {15},
%   doi     = {10.1162/evco.2007.15.1.1},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

% The code implementation is referenced from PlatEMO(https://github.com/BIMK/PlatEMO).
%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

methods
    function run(Algo, Prob)
        population = Initialization(Algo, Prob, Individual_MOCMA);
        ptarget = 1/5.5;
        for t = 1:Prob.T
            for i = 1:Prob.N
                population{t}(i).x = population{t}(i).Dec;
                population{t}(i).psucc = ptarget;
                population{t}(i).sigma = 0.5;
                population{t}(i).pc = 0;
                population{t}(i).C = eye(Prob.D(t));
            end
        end

        while Algo.notTerminated(Prob, population)
            for t = 1:Prob.T
                % Sample solutions
                for i = 1:Prob.N
                    offspring(i) = population{t}(i);
                    offspring(i).x = mvnrnd(population{t}(i).x, population{t}(i).sigma^2 * population{t}(i).C, 1);
                    offspring(i).Dec = offspring(i).x;
                    offspring(i).Dec(offspring(i).Dec > 1) = 1;
                    offspring(i).Dec(offspring(i).Dec < 0) = 0;
                end
                offspring = Algo.Evaluation(offspring, Prob, t);

                % Calculate the fitness
                Q = [population{t}, offspring];
                PopObj = Q.Objs + repmat(1e-6 * sum((cat(1, Q.x) - Q.Decs).^2, 2), 1, Prob.M(t));
                FrontNo = NDSort(PopObj, inf);
                CrowdDis = CrowdingDistance(PopObj, FrontNo);
                [~, rank] = sortrows([FrontNo; -CrowdDis]');
                [~, fitness] = sort(rank);

                % Update the CMA models
                for i = 1:Prob.N
                    population{t}(i) = Algo.updateStepSize(population{t}(i), fitness(Prob.N + i) < fitness(i), ptarget);
                    offspring(i) = Algo.updateStepSize(offspring(i), fitness(Prob.N + i) < fitness(i), ptarget);
                    offspring(i) = Algo.updateCovariance(offspring(i), (offspring(i).x - population{t}(i).x) / population{t}(i).sigma);
                end

                % Individuals for next generation
                Q = [population{t}, offspring];
                population{t} = Q(rank(1:Prob.N));
            end
        end
    end

    function a = updateStepSize(Algo, a, psucc, ptarget)
        % Success rate averaging parameter
        cp = ptarget / (2 + ptarget);
        % Step size damping
        d = 1 + length(a.x) / 2;
        % Update the averaged success rate
        a.psucc = (1 - cp) * a.psucc + cp * psucc;
        % Update the global step size
        a.sigma = a.sigma * exp((a.psucc - ptarget) / d / (1 - ptarget));
    end

    function a = updateCovariance(Algo, a, xstep)
        % Constant of learning rate for evolution path
        cc = 2 / (length(a.x) + 2);
        % Constant of learning rate for covariance matrix
        ccov = 2 / (length(a.x)^2 + 6);
        if a.psucc < 0.44
            % Update the evolution path
            a.pc = (1 - cc) * a.pc + sqrt(cc * (2 - cc)) * xstep;
            % Update the covariance matrix
            a.C = (1 - ccov) * a.C + ccov * a.pc' * a.pc;
        else
            % Update the evolution path
            a.pc = (1 - cc) * a.pc;
            % Update the covariance matrix
            a.C = (1 - ccov) * a.C + ccov * (a.pc' * a.pc + cc * (2 - cc) * a.C);
        end
    end
end
end
