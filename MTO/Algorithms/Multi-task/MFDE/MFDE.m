classdef MFDE < Algorithm
    % <MT-SO> <None/Constrained>

    %------------------------------- Reference --------------------------------
    % @InProceedings{Feng2017MFDE-MFPSO,
    %   title      = {An Empirical Study of Multifactorial PSO and Multifactorial DE},
    %   author     = {Feng, L. and Zhou, W. and Zhou, L. and Jiang, S. W. and Zhong, J. H. and Da, B. S. and Zhu, Z. X. and Wang, Y.},
    %   booktitle  = {2017 IEEE Congress on Evolutionary Computation (CEC)},
    %   year       = {2017},
    %   pages      = {921-928},
    %   doi        = {10.1109/CEC.2017.7969407},
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
        F = 0.5
        CR = 0.9
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'RMP: Random Mating Probability', num2str(obj.RMP), ...
                        'F: Mutation Factor', num2str(obj.F), ...
                        'CR: Crossover Rate', num2str(obj.CR)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.RMP = str2double(Parameter{i}); i = i + 1;
            obj.F = str2double(Parameter{i}); i = i + 1;
            obj.CR = str2double(Parameter{i}); i = i + 1;
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
                % selection
                population = Selection_MF(population, offspring, Prob);
            end
        end

        function offspring = Generation(obj, population)
            for i = 1:length(population)
                offspring(i) = population(i);

                x1 = randi(length(population));
                while x1 == i || population(x1).MFFactor ~= population(i).MFFactor
                    x1 = randi(length(population));
                end
                if rand() < obj.RMP
                    x2 = randi(length(population));
                    while population(x2).MFFactor == population(i).MFFactor
                        x2 = randi(length(population));
                    end
                    x3 = randi(length(population));
                    while x3 == x2 || population(x3).MFFactor == population(i).MFFactor
                        x3 = randi(length(population));
                    end
                    offspring(i).MFFactor = population(x2).MFFactor;
                else
                    x2 = randi(length(population));
                    while x2 == i || x2 == x1 || population(x2).MFFactor ~= population(i).MFFactor
                        x2 = randi(length(population));
                    end
                    x3 = randi(length(population));
                    while x3 == i || x3 == x1 || x3 == x2 || population(x3).MFFactor ~= population(i).MFFactor
                        x3 = randi(length(population));
                    end
                    offspring(i).MFFactor = population(i).MFFactor;
                end

                offspring(i).Dec = population(x1).Dec + obj.F * (population(x2).Dec - population(x3).Dec);
                offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, obj.CR);

                offspring(i).Dec(offspring(i).Dec > 1) = 1;
                offspring(i).Dec(offspring(i).Dec < 0) = 0;
            end
        end
    end
end
