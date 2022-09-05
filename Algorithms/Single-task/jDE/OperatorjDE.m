classdef OperatorjDE < Operator

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function [offspring, calls] = generate(population, Task, t1, t2)
            Individual_class = class(population(1));
            for i = 1:length(population)
                offspring(i) = feval(Individual_class);

                % parameter self-adaptation
                offspring(i).F = population(i).F;
                offspring(i).CR = population(i).CR;
                if rand < t1
                    offspring(i).F = rand * 0.9 + 0.1;
                end
                if rand < t2
                    offspring(i).CR = rand;
                end

                A = randperm(length(population), 4);
                A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3);

                offspring(i) = OperatorjDE.mutate(offspring(i), population(x1), population(x2), population(x3), offspring(i).F);
                offspring(i) = OperatorjDE.crossover(offspring(i), population(i), offspring(i).CR);

                offspring(i).Dec(offspring(i).Dec > 1) = 1;
                offspring(i).Dec(offspring(i).Dec < 0) = 0;
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
