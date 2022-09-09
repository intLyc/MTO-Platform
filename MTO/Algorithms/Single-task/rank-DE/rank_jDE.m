classdef rank_jDE < Algorithm
    % <ST-SO> <None/Constrained>

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
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        T1 = 0.1
        T2 = 0.1
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'T1: probability of F change', num2str(obj.T1), ...
                        'T2: probability of CR change', num2str(obj.T2)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.T1 = str2double(Parameter{i}); i = i + 1;
            obj.T2 = str2double(Parameter{i}); i = i + 1;
        end

        function run(obj, Prob)
            % Initialization
            population = Initialization(obj, Prob, Individual_DE);
            for t = 1:Prob.T
                % initialize F and CR
                for i = 1:length(population{t})
                    population{t}(i).F = rand() * 0.9 + 0.1;
                    population{t}(i).CR = rand();
                end
            end

            while obj.notTerminated(Prob)
                for t = 1:Prob.T
                    % Generation
                    offspring = obj.Generation(population{t});
                    % Evaluation
                    offspring = obj.Evaluation(offspring, Prob, t);
                    % Selection
                    population{t} = Selection_Tournament(population{t}, offspring);
                end
            end
        end

        function offspring = Generation(obj, population)
            % calculate rank
            [~, rank] = sortrows([[population.CV]', [population.Obj]'], [1, 2]);

            for i = 1:length(population)
                offspring(i) = population(i);

                % parameter self-adaptation
                offspring(i).F = population(i).F;
                offspring(i).CR = population(i).CR;
                if rand() < obj.T1
                    offspring(i).F = rand() * 0.9 + 0.1;
                end
                if rand() < obj.T2
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
