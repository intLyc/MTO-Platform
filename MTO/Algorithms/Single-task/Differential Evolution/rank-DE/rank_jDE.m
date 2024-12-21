classdef rank_jDE < Algorithm
% <Single-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Gong2013rank-DE,
%   title      = {Differential Evolution With Ranking-Based Mutation Operators},
%   author     = {Gong, Wenyin and Cai, Zhihua},
%   journal    = {IEEE Transactions on Cybernetics},
%   year       = {2013},
%   number     = {6},
%   pages      = {2066-2081},
%   volume     = {43},
%   doi        = {10.1109/TCYB.2013.2239988},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties (SetAccess = private)
    T1 = 0.1
    T2 = 0.1
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'T1: probability of F change', num2str(Algo.T1), ...
                'T2: probability of CR change', num2str(Algo.T2)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.T1 = str2double(Parameter{i}); i = i + 1;
        Algo.T2 = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialization
        population = Initialization(Algo, Prob, Individual_DE);
        for t = 1:Prob.T
            % initialize F and CR
            for i = 1:length(population{t})
                population{t}(i).F = rand() * 0.9 + 0.1;
                population{t}(i).CR = rand();
            end
        end

        while Algo.notTerminated(Prob, population)
            for t = 1:Prob.T
                % Generation
                offspring = Algo.Generation(population{t});
                % Evaluation
                offspring = Algo.Evaluation(offspring, Prob, t);
                % Selection
                population{t} = Selection_Tournament(population{t}, offspring);
            end
        end
    end

    function offspring = Generation(Algo, population)
        % calculate rank
        [~, rank] = sortrows([population.CVs, population.Objs], [1, 2]);
        [~, rank] = sort(rank);

        for i = 1:length(population)
            offspring(i) = population(i);

            % parameter self-adaptation
            offspring(i).F = population(i).F;
            offspring(i).CR = population(i).CR;
            if rand() < Algo.T1
                offspring(i).F = rand() * 0.9 + 0.1;
            end
            if rand() < Algo.T2
                offspring(i).CR = rand();
            end

            N = length(population);
            x1 = randi(length(population));
            while rand() > (N - rank(x1)) / N || x1 == i
                x1 = randi(length(population));
            end
            x2 = randi(length(population));
            while rand() > (N - rank(x2)) / N || x2 == i || x2 == x1
                x2 = randi(length(population));
            end
            x3 = randi(length(population));
            while x3 == i || x3 == x1 || x3 == x2
                x3 = randi(length(population));
            end

            offspring(i).Dec = population(x1).Dec + offspring(i).F * (population(x2).Dec - population(x3).Dec);
            offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, offspring(i).CR);

            offspring(i).Dec(offspring(i).Dec > 1) = 1;
            offspring(i).Dec(offspring(i).Dec < 0) = 0;
        end
    end
end
end
