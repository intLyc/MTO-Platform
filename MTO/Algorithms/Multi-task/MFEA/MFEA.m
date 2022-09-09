classdef MFEA < Algorithm
    % <MT-SO> <None/Constrained>

    %------------------------------- Reference --------------------------------
    % @Article{Gupta2016MFEA,
    %   title      = {Multifactorial Evolution: Toward Evolutionary Multitasking},
    %   author     = {Gupta, Abhishek and Ong, Yew-Soon and Feng, Liang},
    %   journal    = {IEEE Transactions on Evolutionary Computation},
    %   year       = {2016},
    %   number     = {3},
    %   pages      = {343-357},
    %   volume     = {20},
    %   doi        = {10.1109/TEVC.2015.2458037},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        RMP = 0.3
        MuC = 2
        MuM = 5
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'RMP: Random Mating Probability', num2str(obj.RMP), ...
                        'MuC: Simulated Binary Crossover', num2str(obj.MuC), ...
                        'MuM: Polynomial Mutation', num2str(obj.MuM)};
        end

        function setParameter(obj, Parameter)
            i = 1;
            obj.RMP = str2double(Parameter{i}); i = i + 1;
            obj.MuC = str2double(Parameter{i}); i = i + 1;
            obj.MuM = str2double(Parameter{i}); i = i + 1;
        end

        function run(obj, Prob)
            % Initialize
            population = Initialization_MF(obj, Prob, Individual_MF);

            while obj.notTerminated(Prob)
                % Generation
                offspring = obj.Generation(population);
                % Evaluation
                offspring_temp = Individual_MF.empty();
                for t = 1:Prob.T
                    offspring_t = offspring([offspring.MFFactor] == t);
                    offspring_t = obj.Evaluation(offspring_t, Prob, t);
                    for i = 1:length(offspring_t)
                        offspring_t(i).MFObj = inf(1, Prob.T);
                        offspring_t(i).MFCV = inf(1, Prob.T);
                        offspring_t(i).MFObj(t) = offspring_t(i).Obj;
                        offspring_t(i).MFCV(t) = offspring_t(i).CV;
                    end
                    offspring_temp = [offspring_temp, offspring_t];
                end
                offspring = offspring_temp;
                % Selection
                population = Selection_MF(population, offspring, Prob);
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

                if (population(p1).MFFactor == population(p2).MFFactor) || rand() < obj.RMP
                    % crossover
                    [offspring(count).Dec, offspring(count + 1).Dec] = GA_Crossover(population(p1).Dec, population(p2).Dec, obj.MuC);
                    % imitation
                    p = [p1, p2];
                    offspring(count).MFFactor = population(p(randi(2))).MFFactor;
                    offspring(count + 1).MFFactor = population(p(randi(2))).MFFactor;
                else
                    % mutation
                    offspring(count).Dec = GA_Mutation(population(p1).Dec, obj.MuM);
                    offspring(count + 1).Dec = GA_Mutation(population(p2).Dec, obj.MuM);
                    % imitation
                    offspring(count).MFFactor = population(p1).MFFactor;
                    offspring(count + 1).MFFactor = population(p2).MFFactor;
                end
                for x = count:count + 1
                    offspring(x).Dec(offspring(x).Dec > 1) = 1;
                    offspring(x).Dec(offspring(x).Dec < 0) = 0;
                end
                count = count + 2;
            end
        end
    end
end
