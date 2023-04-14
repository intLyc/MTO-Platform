classdef CCMO < Algorithm
% <Single-task> <Multi-objective> <Constrained>

%------------------------------- Reference --------------------------------
% @Article{Tian2021CCMO,
%   author     = {Tian, Ye and Zhang, Tao and Xiao, Jianhua and Zhang, Xingyi and Jin, Yaochu},
%   journal    = {IEEE Transactions on Evolutionary Computation},
%   title      = {A Coevolutionary Framework for Constrained Multiobjective Optimization Problems},
%   year       = {2021},
%   number     = {1},
%   pages      = {102-116},
%   volume     = {25},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
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

properties (SetAccess = private)
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
        population1 = Initialization(Algo, Prob, Individual);
        population2 = Initialization(Algo, Prob, Individual);
        for t = 1:Prob.T
            [population1{t}, Fitness1{t}] = Selection_SPEA2(population1{t}, Prob.N, 0);
            [population2{t}, Fitness2{t}] = Selection_SPEA2(population2{t}, Prob.N, Inf);
        end

        while Algo.notTerminated(Prob, population1)
            for t = 1:Prob.T
                % Generation
                mating_pool1 = TournamentSelection(2, Prob.N, Fitness1{t});
                mating_pool2 = TournamentSelection(2, Prob.N, Fitness2{t});
                offspring1 = Algo.Generation(population1{t}(mating_pool1));
                offspring2 = Algo.Generation(population2{t}(mating_pool2));
                offspring = [offspring1, offspring2];
                % Evaluation
                offspring = Algo.Evaluation(offspring, Prob, t);
                % Selection
                population1{t} = [population1{t}, offspring];
                population2{t} = [population2{t}, offspring];
                [population1{t}, Fitness1{t}] = Selection_SPEA2(population1{t}, Prob.N, 0);
                [population2{t}, Fitness2{t}] = Selection_SPEA2(population2{t}, Prob.N, Inf);
            end
        end
    end

    function offspring = Generation(Algo, population)
        for i = 1:ceil(length(population) / 2)
            offspring(i) = population(i);

            p2 = i + fix(length(population) / 2);
            offspring(i).Dec = GA_Crossover(population(i).Dec, population(p2).Dec, Algo.MuC);
            offspring(i).Dec = GA_Mutation(offspring(i).Dec, Algo.MuM);

            offspring(i).Dec(offspring(i).Dec > 1) = 1;
            offspring(i).Dec(offspring(i).Dec < 0) = 0;
        end
    end
end
end
