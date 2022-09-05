classdef OperatorSHADE < Operator

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function [offspring, calls] = generate(Task, population, union, p)
            Individual_class = class(population(1));

            % get top 100p% individuals
            [~, rank] = sort([population.Obj]);
            pop_pbest = rank(1:max(round(p * length(population)), 1));

            for i = 1:length(population)
                offspring(i) = feval(Individual_class);

                pbest = pop_pbest(randi(length(pop_pbest)));
                x1 = randi(length(population));
                while x1 == i || x1 == pbest
                    x1 = randi(length(population));
                end
                x2 = randi(length(union));
                while x2 == i || x2 == x1 || x2 == pbest
                    x2 = randi(length(union));
                end

                offspring(i) = OperatorSHADE.mutate(offspring(i), population(i), population(pbest), population(x1), union(x2));
                offspring(i) = OperatorSHADE.crossover(offspring(i), population(i));

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
