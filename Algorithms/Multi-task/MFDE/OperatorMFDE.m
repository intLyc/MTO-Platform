classdef OperatorMFDE < Operator

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function [offspring, calls] = generate(population, Tasks, rmp, F, CR)
            Individual_class = class(population(1));
            for i = 1:length(population)
                offspring(i) = feval(Individual_class);
                offspring(i).Obj = inf(1, length(Tasks));
                offspring(i).CV = inf(1, length(Tasks));

                x1 = randi(length(population));
                while x1 == i || population(x1).skill_factor ~= population(i).skill_factor
                    x1 = randi(length(population));
                end
                if rand < rmp
                    x2 = randi(length(population));
                    while population(x2).skill_factor == population(i).skill_factor
                        x2 = randi(length(population));
                    end
                    x3 = randi(length(population));
                    while x3 == x2 || population(x3).skill_factor == population(i).skill_factor
                        x3 = randi(length(population));
                    end
                    offspring(i).skill_factor = population(x2).skill_factor;
                else
                    x2 = randi(length(population));
                    while x2 == i || x2 == x1 || population(x2).skill_factor ~= population(i).skill_factor
                        x2 = randi(length(population));
                    end
                    x3 = randi(length(population));
                    while x3 == i || x3 == x1 || x3 == x2 || population(x3).skill_factor ~= population(i).skill_factor
                        x3 = randi(length(population));
                    end
                    offspring(i).skill_factor = population(i).skill_factor;
                end

                offspring(i) = OperatorMFDE.mutate(offspring(i), population(x1), population(x2), population(x3), F);
                offspring(i) = OperatorMFDE.crossover(offspring(i), population(i), CR);

                offspring(i).Dec(offspring(i).Dec > 1) = 1;
                offspring(i).Dec(offspring(i).Dec < 0) = 0;
            end

            % Evaluation
            offspring_temp = feval(Individual_class).empty();
            calls = 0;
            for t = 1:length(Tasks)
                offspring_t = offspring([offspring.skill_factor] == t);
                [offspring_t, cal] = evaluate(offspring_t, Tasks(t), t);
                offspring_temp = [offspring_temp, offspring_t];
                calls = calls + cal;
            end
            offspring = offspring_temp;
        end

        function object = mutate(object, x1, x2, x3, F)
            object.Dec = x1.Dec + F * (x2.Dec - x3.Dec);
        end

        function object = crossover(object, x, CR)
            replace = rand(1, length(object.Dec)) > CR;
            replace(randi(length(object.Dec))) = false;
            object.Dec(replace) = x.Dec(replace);
        end
    end
end
