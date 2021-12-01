classdef OperatorDE
    methods (Static)
        function [offspring, calls] = generate(callfun, population, Task, F, pCR)
            for i = 1:length(population)
                offspring(i) = Individual();

                A = randperm(length(population));
                A(A == i) = [];
                x1 = A(1);
                x2 = A(mod(2 - 1, length(A)) + 1);
                x3 = A(mod(3 - 1, length(A)) + 1);

                offspring(i) = OperatorDE.mutate_rand_1(offspring(i), population(x1), population(x2), population(x3), F);
                offspring(i) = OperatorDE.crossover(offspring(i), population(i), pCR);

                lb_idx = offspring(i).rnvec < Task.Lb;
                offspring(i).rnvec(lb_idx) = Task.Lb(lb_idx);
                ub_idx = offspring(i).rnvec > Task.Ub;
                offspring(i).rnvec(ub_idx) = Task.Ub(ub_idx);
            end
            if callfun
                [offspring, calls] = evaluate(offspring, Task);
            else
                calls = 0;
            end
        end

        function object = mutate_rand_1(object, x1, x2, x3, F)
            object.rnvec = x1.rnvec + F * (x2.rnvec - x3.rnvec);
        end

        function object = crossover(object, x, pCR)
            for j = 1:length(object.rnvec)
                if rand > pCR
                    object.rnvec(j) = x.rnvec(j);
                end
            end
        end
    end
end
