classdef OperatorMaTDE < Operator

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function [offspring, calls] = generate(population, Task, F, CR)
            Individual_class = class(population(1));
            for i = 1:length(population)
                offspring(i) = feval(Individual_class);

                r = randi(length(population));
                while r == i
                    r = randi(length(population));
                end
                x1 = i; x2 = r; x3 = i;

                offspring(i) = OperatorMaTDE.mutate(offspring(i), population(x1), population(x2), population(x3), F);
                offspring(i) = OperatorMaTDE.crossover(offspring(i), population(i), CR);

                rand_Dec = rand(1, Task.Dim);
                offspring(i).Dec(offspring(i).Dec > 1) = rand_Dec(offspring(i).Dec > 1);
                offspring(i).Dec(offspring(i).Dec < 0) = rand_Dec(offspring(i).Dec < 0);
            end
            [offspring, calls] = evaluate(offspring, Task, 1);
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
