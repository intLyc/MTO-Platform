classdef MOEA_D_DE < Algorithm
% <Single-task> <Multi-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Li2009MOEA-D-DE&NSGA-II-DE,
%   title   = {Multiobjective Optimization Problems With Complicated Pareto Sets, MOEA/D and NSGA-II},
%   author  = {Li, Hui and Zhang, Qingfu},
%   journal = {IEEE Transactions on Evolutionary Computation},
%   year    = {2009},
%   number  = {2},
%   pages   = {284-302},
%   volume  = {13},
%   doi     = {10.1109/TEVC.2008.925798},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
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

properties (SetAccess = public)
    Delta = 0.9
    NR = 2
    F = 0.5
    CR = 0.9
    MuM = 15
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'Delta: Probability of choosing parents locally', num2str(Algo.Delta), ...
                'NR: Maximum number of solutions replaced by each offspring', num2str(Algo.NR), ...
                'F:Mutation Factor', num2str(Algo.F), ...
                'CR: Crossover Rate', num2str(Algo.CR), ...
                'MuM: Polynomial Mutation', num2str(Algo.MuM)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.Delta = str2double(Parameter{i}); i = i + 1;
        Algo.NR = str2double(Parameter{i}); i = i + 1;
        Algo.F = str2double(Parameter{i}); i = i + 1;
        Algo.CR = str2double(Parameter{i}); i = i + 1;
        Algo.MuM = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialize
        for t = 1:Prob.T
            % Generate the weight vectors
            [W{t}, N{t}] = UniformPoint(Prob.N, Prob.M(t));
            DT{t} = ceil(N{t} / 10);

            % Detect the neighbours of each solution
            B{t} = pdist2(W{t}, W{t});
            [~, B{t}] = sort(B{t}, 2);
            B{t} = B{t}(:, 1:DT{t});

            population{t} = Initialization_One(Algo, Prob, t, Individual, N{t});

            Z{t} = min(population{t}.Objs, [], 1);

            if N{t} < Prob.N % Fill population
                population{t}(N{t} + 1:Prob.N) = population{t}(1:Prob.N - N{t});
            end
        end

        while Algo.notTerminated(Prob, population)
            % Generation
            for t = 1:Prob.T
                for i = 1:N{t}
                    % Choose the parents
                    if rand() < Algo.Delta
                        P = B{t}(i, randperm(end));
                    else
                        P = randperm(N{t});
                    end
                    % Generate an offspring
                    offspring = Algo.Generation(population{t}([i, P(1:2)]));
                    offspring = Algo.Evaluation(offspring, Prob, t);
                    % Update the ideal point
                    Z{t} = min(Z{t}, offspring.Obj);

                    % Tchebycheff approach
                    g_old = max(abs(population{t}(P).Objs - repmat(Z{t}, length(P), 1)) .* W{t}(P, :), [], 2);
                    g_new = max(repmat(abs(offspring.Obj - Z{t}), length(P), 1) .* W{t}(P, :), [], 2);

                    CVO = offspring.CV;
                    CVP = population{t}(P).CVs;
                    population{t}(P(find(g_old >= g_new & CVP == CVO | CVP > CVO, Algo.NR))) = offspring;
                end
                if N{t} < Prob.N % Fill population
                    population{t}(N{t} + 1:Prob.N) = population{t}(1:Prob.N - N{t});
                end
            end
        end
    end

    function offspring = Generation(Algo, population)
        offspring = population(1);

        offspring.Dec = population(1).Dec + Algo.F * (population(2).Dec - population(3).Dec);
        offspring.Dec = DE_Crossover(offspring.Dec, population(1).Dec, Algo.CR);
        offspring.Dec = GA_Mutation(offspring.Dec, Algo.MuM);

        offspring.Dec(offspring.Dec > 1) = 1;
        offspring.Dec(offspring.Dec < 0) = 0;
    end
end
end
