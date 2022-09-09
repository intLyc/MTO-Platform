classdef GA < Algorithm
    % <ST-SO> <None/Constrained>

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        MuC = 2
        MuM = 5
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'MuC: Simulated Binary Crossover', num2str(obj.MuC), ...
                        'MuM: Polynomial Mutation', num2str(obj.MuM)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.MuC = str2double(Parameter{i}); i = i + 1;
            obj.MuM = str2double(Parameter{i}); i = i + 1;
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
                    population{t} = Selection_Elit(population{t}, offspring);
                end
            end
        end

        function offspring = Generation(obj, population)
            indorder = randperm(length(population));
            count = 1;
            for i = 1:ceil(length(population) / 2)
                p1 = indorder(i);
                p2 = indorder(i + fix(length(population) / 2));
                offspring(count) = population(p1);
                offspring(count + 1) = population(p2);

                [offspring(count).Dec, offspring(count + 1).Dec] = GA_Crossover(population(p1).Dec, population(p2).Dec, obj.MuC);

                offspring(count).Dec = GA_Mutation(offspring(count).Dec, obj.MuM);
                offspring(count + 1).Dec = GA_Mutation(offspring(count + 1).Dec, obj.MuM);

                for x = count:count + 1
                    offspring(x).Dec(offspring(x).Dec > 1) = 1;
                    offspring(x).Dec(offspring(x).Dec < 0) = 0;
                end
                count = count + 2;
            end
        end
    end
end
