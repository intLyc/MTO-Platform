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
            count = 1;
            for i = 1:ceil(length(population) / 2)
                p1 = indorder(i);
                p2 = indorder(i + fix(length(population) / 2));
                offspring(count) = Individual();
                offspring(count).factorial_costs = inf(1, length(Tasks));
                offspring(count + 1) = Individual();
                offspring(count + 1).factorial_costs = inf(1, length(Tasks));

                if (population(p1).skill_factor == population(p2).skill_factor) || rand < rmp
                    u = rand(1, max([Tasks.dims]));
                    cf = zeros(1, max([Tasks.dims]));
                    cf(u <= 0.5) = (2 * u(u <= 0.5)).^(1 / (mu + 1));
                    cf(u > 0.5) = (2 * (1 - u(u > 0.5))).^(-1 / (mu + 1));

                    offspring(count) = OperatorGA.crossover(offspring(count), population(p1), population(p2), cf);
                    offspring(count + 1) = OperatorGA.crossover(offspring(count + 1), population(p2), population(p1), cf);

                    p = [p1, p2];
                    offspring(count).skill_factor = population(p(randi(2))).skill_factor;
                    offspring(count + 1).skill_factor = population(p(randi(2))).skill_factor;
                else
                    offspring(count) = OperatorGA.mutate(population(p1), max([Tasks.dims]), mum);
                    offspring(count + 1) = OperatorGA.mutate(population(p2), max([Tasks.dims]), mum);
                end
                for x = count:count + 1
                    offspring(x).rnvec(offspring(x).rnvec > 1) = 1;
                    offspring(x).rnvec(offspring(x).rnvec < 0) = 0;
                end
                count = count + 2;
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
