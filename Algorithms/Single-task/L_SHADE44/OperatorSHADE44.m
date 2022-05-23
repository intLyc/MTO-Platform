classdef OperatorSHADE44 < Operator

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
            rank = sort_FP([population.factorial_costs], [population.constraint_violation]);
            pop_pbest = rank(1:max(round(p * length(population)), 1));

            for i = 1:length(population)
                offspring(i) = feval(Individual_class);

                switch population(i).st
                    case 1 % pbest + bin
                        pbest = pop_pbest(randi(length(pop_pbest)));
                        x1 = randi(length(population));
                        while x1 == i || x1 == pbest
                            x1 = randi(length(population));
                        end
                        x2 = randi(length(union));
                        while x2 == i || x2 == x1 || x2 == pbest
                            x2 = randi(length(union));
                        end
                        offspring(i) = OperatorJADE.mutate(offspring(i), population(i), population(pbest), population(x1), union(x2));
                        offspring(i) = OperatorJADE.crossover(offspring(i), population(i));
                    case 2 % pbest + exp
                        pbest = pop_pbest(randi(length(pop_pbest)));
                        x1 = randi(length(population));
                        while x1 == i || x1 == pbest
                            x1 = randi(length(population));
                        end
                        x2 = randi(length(union));
                        while x2 == i || x2 == x1 || x2 == pbest
                            x2 = randi(length(union));
                        end
                        offspring(i) = OperatorJADE.mutate(offspring(i), population(i), population(pbest), population(x1), union(x2));
                        offspring(i) = OperatorSHADE44.crossoverExp(offspring(i), population(i));
                    case 3 % randrl + bin
                        A = randperm(length(population), 4);
                        A(A == i) = []; idx = A(1:3);
                        rank_temp = sort_FP([population(idx).factorial_costs], [population(idx).constraint_violation]);
                        x1 = idx(rank_temp(1));
                        if rand < 0.5
                            x2 = idx(rank_temp(2)); x3 = idx(rank_temp(3));
                        else
                            x3 = idx(rank_temp(3)); x2 = idx(rank_temp(2));
                        end
                        offspring(i) = OperatorDE.mutate(offspring(i), population(x1), population(x2), population(x3), population(i).F);
                        offspring(i) = OperatorJADE.crossover(offspring(i), population(i));
                    case 4 % randrl + exp
                        A = randperm(length(population), 4);
                        A(A == i) = []; idx = A(1:3);
                        rank_temp = sort_FP([population(idx).factorial_costs], [population(idx).constraint_violation]);
                        x1 = idx(rank_temp(1));
                        if rand < 0.5
                            x2 = idx(rank_temp(2)); x3 = idx(rank_temp(3));
                        else
                            x3 = idx(rank_temp(3)); x2 = idx(rank_temp(2));
                        end
                        offspring(i) = OperatorDE.mutate(offspring(i), population(x1), population(x2), population(x3), population(i).F);
                        offspring(i) = OperatorSHADE44.crossoverExp(offspring(i), population(i));
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

        function object = crossoverExp(object, current)
            D = length(object.rnvec);
            L = 1 + fix(length(object.rnvec) * rand());
            replace = L;
            position = L;
            while rand() < current.CR && length(replace) < D
                position = position + 1;
                if position <= D
                    replace(end + 1) = position;
                else
                    replace(end + 1) = mod(position, D);
                end
            end
            rnvec_temp = current.rnvec;
            rnvec_temp(replace) = object.rnvec(replace);
            object.rnvec = rnvec_temp;
        end
    end
end
