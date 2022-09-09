classdef DE < Algorithm
    % <ST-SO> <None/Constrained>

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        F = 0.5
        CR = 0.9
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'F: Mutation Factor', num2str(obj.F), ...
                        'CR: Crossover Rate', num2str(obj.CR)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.F = str2double(Parameter{i}); i = i + 1;
            obj.CR = str2double(Parameter{i}); i = i + 1;
        end

        function run(obj, Prob)
            % Initialization
            population = Initialization(obj, Prob, Individual);

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
                A = randperm(length(population), 4);
                A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3);

                offspring(i).Dec = population(x1).Dec + obj.F * (population(x2).Dec - population(x3).Dec);
                offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, obj.CR);

                offspring(i).Dec(offspring(i).Dec > 1) = 1;
                offspring(i).Dec(offspring(i).Dec < 0) = 0;
            end
        end
    end
end
