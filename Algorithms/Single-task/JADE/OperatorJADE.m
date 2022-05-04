classdef OperatorJADE < Operator

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function [offspring, calls] = generate(callfun, Task, population, union, p)
            if length(population) <= 3
                offspring = population;
                calls = 0;
                return;
            end
            Individual_class = class(population(1));

            % get top 100p% individuals
            for i = 1:length(population)
                factorial_costs(i) = population(i).factorial_costs;
            end
            [~, rank] = sort(factorial_costs);
            pop_pbest = rank(1:round(p * length(population)));

            for i = 1:length(population)
                offspring(i) = feval(Individual_class);

                pbest = pop_pbest(randi(length(pop_pbest)));
                x1 = randi(length(population));
                while x1 == i
                    x1 = randi(length(population));
                end
                x2 = randi(length(union));
                while x2 == i || x2 == x1
                    x2 = randi(length(union));
                end

                offspring(i) = OperatorJADE.mutate(offspring(i), population(i), population(pbest), population(x1), union(x2));
                offspring(i) = OperatorJADE.crossover(offspring(i), population(i));

                offspring(i).rnvec(offspring(i).rnvec > 1) = 1;
                offspring(i).rnvec(offspring(i).rnvec < 0) = 0;
            end
            if callfun
                [offspring, calls] = evaluate(offspring, Task, 1);
            else
                calls = 0;
            end
        end

        function object = mutate(object, current, pbest, x1, x2)
            object.rnvec = current.rnvec + current.F * (pbest.rnvec - current.rnvec) + current.F * (x1.rnvec - x2.rnvec);
        end

        function object = crossover(object, current)
            replace = rand(1, length(object.rnvec)) > current.CR;
            replace(randi(length(object.rnvec))) = true;
            object.rnvec(replace) = current.rnvec(replace);
        end
    end
end
