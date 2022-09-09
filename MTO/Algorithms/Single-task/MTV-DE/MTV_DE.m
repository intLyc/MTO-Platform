classdef MTV_DE < Algorithm
    % <ST-SO> <Constrained>

    %------------------------------- Reference --------------------------------
    % @article{MezuraMontes2007MTV-DE,
    %   title     = {Multiple Trial Vectors in Differential Evolution for Engineering Design},
    %   author    = {E. Mezura-Montes and C. A. Coello Coello and J. Velázquez-Reyes and L. Muñoz-Dávila},
    %   journal   = {Engineering Optimization},
    %   doi       = {10.1080/03052150701364022},
    %   number    = {5},
    %   pages     = {567-589},
    %   publisher = {Taylor & Francis},
    %   volume    = {39},
    %   year      = {2007}
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        F = 0.5
        CR = 0.9
        No = 5
        SR = 0.45
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'F: Mutation Factor', num2str(obj.F), ...
                        'CR: Crossover Probability', num2str(obj.CR), ...
                        'No: number of trial vectors', num2str(obj.No), ...
                        'SR: stochastic ranking rate', num2str(obj.SR)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.F = str2double(Parameter{i}); i = i + 1;
            obj.CR = str2double(Parameter{i}); i = i + 1;
            obj.No = str2double(Parameter{i}); i = i + 1;
            obj.SR = str2double(Parameter{i}); i = i + 1;
        end

        function run(obj, Prob)
            % Initialization
            population = Initialization(obj, Prob, Individual);

            while obj.notTerminated(Prob)
                for t = 1:Prob.T
                    % Generation
                    offspring_temp = obj.Generation(population{t});
                    % Evaluation
                    offspring_temp = obj.Evaluation(offspring_temp, Prob, t);
                    % Pre Selection
                    for i = 1:length(population{t})
                        idx = (i - 1) * obj.No + (1:obj.No);
                        [~, ~, best] = min_FP([offspring_temp(idx).Obj], [offspring_temp(idx).CV]);
                        offspring(i) = offspring_temp(idx(best));
                    end
                    % Selection
                    [~, replace] = Selection_Tournament(population{t}, offspring);
                    replace_obj = [population{t}.Obj] > [offspring.Obj];
                    idx_sr = rand(1, length(population{t})) <= obj.SR;
                    replace(idx_sr) = replace_obj(idx_sr);
                    population{t}(replace) = offspring(replace);
                end
            end
        end

        function offspring = Generation(obj, population)
            for i = 1:length(population)
                j = (i - 1) * obj.No;
                for k = 1:obj.No
                    offspring(j + k) = population(i);
                    A = randperm(length(population), 4);
                    A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3);

                    offspring(j + k).Dec = population(x1).Dec + obj.F * (population(x2).Dec - population(x3).Dec);
                    offspring(j + k).Dec = DE_Crossover(offspring(j + k).Dec, population(i).Dec, obj.CR);

                    offspring(j + k).Dec(offspring(j + k).Dec > 1) = 1;
                    offspring(j + k).Dec(offspring(j + k).Dec < 0) = 0;
                end
            end
        end
    end
end
