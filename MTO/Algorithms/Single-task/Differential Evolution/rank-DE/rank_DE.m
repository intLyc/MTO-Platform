classdef rank_DE < Algorithm
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
    F = 0.5
    CR = 0.9
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'F: Mutation Factor', num2str(Algo.F), ...
                'CR: Crossover Rate', num2str(Algo.CR)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.F = str2double(Parameter{i}); i = i + 1;
        Algo.CR = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialization
        population = Initialization(Algo, Prob, Individual);

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

            offspring(i).Dec = population(x1).Dec + Algo.F * (population(x2).Dec - population(x3).Dec);
            offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, Algo.CR);

            offspring(i).Dec(offspring(i).Dec > 1) = 1;
            offspring(i).Dec(offspring(i).Dec < 0) = 0;
        end
    end
end
end
