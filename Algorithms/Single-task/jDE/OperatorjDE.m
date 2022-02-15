classdef OperatorjDE < Operator
    methods (Static)
        function [offspring, calls] = generate(callfun, population, Task, t1, t2)
            if length(population) <= 3
                offspring = population;
                calls = 0;
                return;
            end
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

                A = randperm(length(population));
                A(A == i) = [];
                x1 = A(1);
                x2 = A(mod(2 - 1, length(A)) + 1);
                x3 = A(mod(3 - 1, length(A)) + 1);

                offspring(i) = OperatorjDE.mutate_rand_1(offspring(i), population(x1), population(x2), population(x3));
                offspring(i) = OperatorjDE.crossover(offspring(i), population(i));

                offspring(i).rnvec(offspring(i).rnvec > 1) = 1;
                offspring(i).rnvec(offspring(i).rnvec < 0) = 0;
            end
            if callfun
                [offspring, calls] = evaluate(offspring, Task, 1);
            else
                calls = 0;
            end
        end

        function object = mutate_rand_1(object, x1, x2, x3)
            object.rnvec = x1.rnvec + object.F * (x2.rnvec - x3.rnvec);
        end

        function object = crossover(object, x)
            for j = 1:length(object.rnvec)
                if rand > object.CR
                    object.rnvec(j) = x.rnvec(j);
                end
            end
        end
    end
end
