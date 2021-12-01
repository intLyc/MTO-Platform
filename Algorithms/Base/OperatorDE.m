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

                offspring(i).rnvec(offspring(i).rnvec > 1) = 1;
                offspring(i).rnvec(offspring(i).rnvec < 0) = 0;
            end
            if callfun
                [offspring, calls] = evaluate(offspring, Task, 1);
            else
                calls = 0;
            end
        end

        function [offspring, calls] = generateMF(callfun, population, Tasks, rmp, F, pCR)
            group = cell([1, length(Tasks)]);
            for i = 1:length(population)
                group{population(i).skill_factor} = [group{population(i).skill_factor}, i];
            end
            for i = 1:length(population)
                offspring(i) = Individual();
                offspring(i).factorial_costs = inf(1, length(Tasks));

                other = [];
                for t = 1:length(group)
                    if population(i).skill_factor ~= t
                        other = [other, group{t}];
                    end
                end
                other = other(randperm(length(other)));

                A = randperm(length(group{population(i).skill_factor}));
                A = group{population(i).skill_factor}(A);
                A(A == i) = [];
                x1 = A(1);
                if rand < rmp
                    x2 = other(mod(2 - 1, length(other)) + 1);
                    x3 = other(mod(3 - 1, length(other)) + 1);
                    offspring(i).skill_factor = population(x2).skill_factor;
                else
                    x2 = A(mod(2 - 1, length(A)) + 1);
                    x3 = A(mod(3 - 1, length(A)) + 1);
                    offspring(i).skill_factor = population(x1).skill_factor;
                end

                offspring(i) = OperatorDE.mutate_rand_1(offspring(i), population(x1), population(x2), population(x3), F);
                offspring(i) = OperatorDE.crossover(offspring(i), population(i), pCR);

                offspring(i).rnvec(offspring(i).rnvec > 1) = 1;
                offspring(i).rnvec(offspring(i).rnvec < 0) = 0;
            end
            if callfun
                offspring_temp = Individual.empty();
                calls = 0;
                for t = 1:length(Tasks)
                    offspring_t = offspring([offspring.skill_factor] == t);
                    [offspring_t, cal] = evaluate(offspring_t, Tasks(t), t);
                    offspring_temp = [offspring_temp, offspring_t];
                    calls = calls + cal;
                end
                offspring = offspring_temp;
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
