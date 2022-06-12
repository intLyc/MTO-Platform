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
            [~, rank] = sort([population.factorial_costs]);
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

                vio_low = find(offspring(i).rnvec < 0);
                offspring(i).rnvec(vio_low) = (population(i).rnvec(vio_low) + 0) / 2;
                vio_up = find(offspring(i).rnvec > 1);
                offspring(i).rnvec(vio_up) = (population(i).rnvec(vio_up) + 1) / 2;
            end
            [offspring, calls] = evaluate(offspring, Task, 1);
        end

        function object = mutate(object, current, pbest, x1, x2)
            object.rnvec = current.rnvec + current.F * (pbest.rnvec - current.rnvec) + current.F * (x1.rnvec - x2.rnvec);
        end

        function object = crossover(object, current)
            replace = rand(1, length(object.rnvec)) > current.CR;
            replace(randi(length(object.rnvec))) = false;
            object.rnvec(replace) = current.rnvec(replace);
        end
    end
end
