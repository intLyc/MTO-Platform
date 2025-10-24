classdef NSGA_II < Algorithm
% <Single-task> <Multi-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @article{Deb2002NSGA2,
%   title      = {A Fast and Elitist Multiobjective Genetic Algorithm: Nsga-ii},
%   author     = {Deb, K. and Pratap, A. and Agarwal, S. and Meyarivan, T.},
%   journal    = {IEEE Transactions on Evolutionary Computation},
%   number     = {2},
%   pages      = {182-197},
%   volume     = {6},
%   year       = {2002}
%   doi        = {10.1109/4235.996017},
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

properties (SetAccess = public)
    MuC = 20
    MuM = 15
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'MuC: Simulated Binary Crossover', num2str(Algo.MuC), ...
                'MuM: Polynomial Mutation', num2str(Algo.MuM)};
    end

    function setParameter(Algo, Parameter)
        i = 1;
        Algo.MuC = str2double(Parameter{i}); i = i + 1;
        Algo.MuM = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialize
        population = Initialization(Algo, Prob, Individual);
        for t = 1:Prob.T
            rank = NSGA2Sort(population{t});
            population{t} = population{t}(rank);
        end

        while Algo.notTerminated(Prob, population)
            for t = 1:Prob.T
                % Generation
                mating_pool = TournamentSelection(2, Prob.N, 1:Prob.N);
                offspring = Algo.Generation(population{t}(mating_pool));
                % Evaluation
                offspring = Algo.Evaluation(offspring, Prob, t);
                % Selection
                population{t} = [population{t}, offspring];
                rank = NSGA2Sort(population{t});
                population{t} = population{t}(rank(1:Prob.N));
            end
        end
    end

    function offspring = Generation(Algo, population)
        count = 1;
        for i = 1:ceil(length(population) / 2)
            p1 = i; p2 = i + fix(length(population) / 2);
            offspring(count) = population(p1);
            offspring(count + 1) = population(p2);

            [offspring(count).Dec, offspring(count + 1).Dec] = GA_Crossover(population(p1).Dec, population(p2).Dec, Algo.MuC);

            offspring(count).Dec = GA_Mutation(offspring(count).Dec, Algo.MuM);
            offspring(count + 1).Dec = GA_Mutation(offspring(count + 1).Dec, Algo.MuM);

            for x = count:count + 1
                offspring(x).Dec(offspring(x).Dec > 1) = 1;
                offspring(x).Dec(offspring(x).Dec < 0) = 0;
            end
            count = count + 2;
        end
    end
end
end
