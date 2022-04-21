classdef OperatorMFMP < Operator

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function [offspring, calls, flag] = generate(callfun, Task, population, union, c_pop, c_union, rmp, p)
            if isempty(population)
                offspring = population;
                calls = 0;
                return;
            end
            Individual_class = class(population(1));
            % get top 100p% individuals
            factorial_costs = [];
            for i = 1:length(population)
                factorial_costs(i) = population(i).factorial_costs;
            end
            [~, rank] = sort(factorial_costs);
            pop_pbest = rank(1:round(p * length(population)));
            % get top 100p% individuals in communicate population
            factorial_costs = [];
            for i = 1:length(c_pop)
                factorial_costs(i) = c_pop(i).factorial_costs;
            end
            [~, rank] = sort(factorial_costs);
            c_pop_pbest = rank(1:round(p * length(c_pop)));

            flag = zeros(1, length(population));
            for i = 1:length(population)
                offspring(i) = feval(Individual_class);

                if rand < rmp
                    c_pbest = c_pop_pbest(randi(length(c_pop_pbest)));
                    x1 = randi(length(c_pop));
                    while x1 == i
                        x1 = randi(length(c_pop));
                    end
                    x2 = randi(length(c_union));

                    offspring(i) = OperatorJADE.mutate_current_pbest_1(offspring(i), population(i), c_pop(c_pbest), c_pop(x1), c_union(x2));
                    offspring(i) = OperatorJADE.crossover(offspring(i), population(i));
                    flag(i) = 1;
                else
                    pbest = pop_pbest(randi(length(pop_pbest)));
                    x1 = randi(length(population));
                    while x1 == i
                        x1 = randi(length(population));
                    end
                    x2 = randi(length(union));

                    offspring(i) = OperatorJADE.mutate_current_pbest_1(offspring(i), population(i), population(pbest), population(x1), union(x2));
                    offspring(i) = OperatorJADE.crossover(offspring(i), population(i));
                end

                vio_low = find(offspring(i).rnvec < 0);
                offspring(i).rnvec(vio_low) = (population(i).rnvec(vio_low) + 0) / 2;
                vio_up = find(offspring(i).rnvec > 1);
                offspring(i).rnvec(vio_up) = (population(i).rnvec(vio_up) + 1) / 2;
            end
            if callfun
                [offspring, calls] = evaluate(offspring, Task, 1);
            else
                calls = 0;
            end
        end
    end
end
