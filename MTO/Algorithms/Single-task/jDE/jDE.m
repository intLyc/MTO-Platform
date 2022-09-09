classdef jDE < Algorithm
    % <ST-SO> <None/Constrained>

    %------------------------------- Reference --------------------------------
    % @Article{Brest2006jDE,
    %   title   = {Self-Adapting Control Parameters in Differential Evolution: A Comparative Study on Numerical Benchmark Problems},
    %   author  = {Brest, Janez and Greiner, Sao and Boskovic, Borko and Mernik, Marjan and Zumer, Viljem},
    %   journal = {IEEE Transactions on Evolutionary Computation},
    %   year    = {2006},
    %   number  = {6},
    %   pages   = {646-657},
    %   volume  = {10},
    %   doi     = {10.1109/TEVC.2006.872133},
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

                A = randperm(length(population), 4);
                A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3);

                offspring(i).Dec = population(x1).Dec + offspring(i).F * (population(x2).Dec - population(x3).Dec);
                offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, offspring(i).CR);

                offspring(i).Dec(offspring(i).Dec > 1) = 1;
                offspring(i).Dec(offspring(i).Dec < 0) = 0;
            end
        end
    end
end
