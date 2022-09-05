classdef OperatorMFMP < Operator

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function [offspring, calls, flag] = generate(Task, population, union, c_pop, c_union, rmp, p)
            Individual_class = class(population(1));
            % get top 100p% individuals
            Obj = [];
            for i = 1:length(population)
                Obj(i) = population(i).Obj;
            end
            [~, rank] = sort(Obj);
            pop_pbest = rank(1:round(p * length(population)));
            % get top 100p% individuals in communicate population
            Obj = [];
            for i = 1:length(c_pop)
                Obj(i) = c_pop(i).Obj;
            end
            [~, rank] = sort(Obj);
            c_pop_pbest = rank(1:round(p * length(c_pop)));

            flag = zeros(1, length(population));
            for i = 1:length(population)
                offspring(i) = feval(Individual_class);

                if rand < rmp
                    c_pbest = c_pop_pbest(randi(length(c_pop_pbest)));
                    x1 = randi(length(c_pop));
                    while x1 == c_pbest
                        x1 = randi(length(c_pop));
                    end
                    x2 = randi(length(c_union));
                    while x2 == x1 || x2 == c_pbest
                        x2 = randi(length(c_union));
                    end

                    offspring(i) = OperatorMFMP.mutate(offspring(i), population(i), c_pop(c_pbest), c_pop(x1), c_union(x2));
                    offspring(i) = OperatorMFMP.crossover(offspring(i), population(i));
                    flag(i) = 1;
                else
                    pbest = pop_pbest(randi(length(pop_pbest)));
                    x1 = randi(length(population));
                    while x1 == i || x1 == pbest
                        x1 = randi(length(population));
                    end
                    x2 = randi(length(union));
                    while x2 == i || x2 == x1 || x2 == pbest
                        x2 = randi(length(union));
                    end

                    offspring(i) = OperatorMFMP.mutate(offspring(i), population(i), population(pbest), population(x1), union(x2));
                    offspring(i) = OperatorMFMP.crossover(offspring(i), population(i));
                end

                vio_low = find(offspring(i).Dec < 0);
                offspring(i).Dec(vio_low) = (population(i).Dec(vio_low) + 0) / 2;
                vio_up = find(offspring(i).Dec > 1);
                offspring(i).Dec(vio_up) = (population(i).Dec(vio_up) + 1) / 2;
            end
            [offspring, calls] = evaluate(offspring, Task, 1);
        end

        function object = mutate(object, current, pbest, x1, x2)
            object.Dec = current.Dec + current.F * (pbest.Dec - current.Dec) + current.F * (x1.Dec - x2.Dec);
        end

        function object = crossover(object, current)
            replace = rand(1, length(object.Dec)) > current.CR;
            replace(randi(length(object.Dec))) = false;
            object.Dec(replace) = current.Dec(replace);
        end
    end
end
