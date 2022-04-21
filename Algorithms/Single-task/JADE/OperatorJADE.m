classdef OperatorJADE < Operator

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function [offspring, calls] = generate(callfun, population, Task, p)
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

                A = randperm(length(population));
                A(A == i) = [];
                x1 = A(1);
                x2 = A(mod(2 - 1, length(A)) + 1);

                offspring(i) = OperatorJADE.mutate_current_pbest_1(offspring(i), population(i), population(pbest), population(x1), population(x2));
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

        function object = mutate_current_pbest_1(object, current, pbest, x1, x2)
            object.rnvec = current.rnvec + current.F * (pbest.rnvec - current.rnvec) + current.F * (x1.rnvec - x2.rnvec);
        end

        function object = crossover(object, current)
            for j = 1:length(object.rnvec)
                if rand > current.CR
                    object.rnvec(j) = current.rnvec(j);
                end
            end
        end
    end
end
