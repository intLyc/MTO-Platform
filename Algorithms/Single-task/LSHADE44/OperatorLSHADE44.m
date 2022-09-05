classdef OperatorLSHADE44 < Operator

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
            rank = sort_FP([population.Obj], [population.CV]);
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
                        offspring(i) = OperatorLSHADE44.mutate_rand_to_pbest(offspring(i), population(i), population(pbest), population(x1), union(x2));
                        offspring(i) = OperatorLSHADE44.crossover(offspring(i), population(i));
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
                        offspring(i) = OperatorLSHADE44.mutate_rand_to_pbest(offspring(i), population(i), population(pbest), population(x1), union(x2));
                        offspring(i) = OperatorLSHADE44.crossoverExp(offspring(i), population(i));
                    case 3 % randrl + bin
                        A = randperm(length(population), 4);
                        A(A == i) = []; idx = A(1:3);
                        rank_temp = sort_FP([population(idx).Obj], [population(idx).CV]);
                        x1 = idx(rank_temp(1));
                        if rand < 0.5
                            x2 = idx(rank_temp(2)); x3 = idx(rank_temp(3));
                        else
                            x3 = idx(rank_temp(3)); x2 = idx(rank_temp(2));
                        end
                        offspring(i) = OperatorLSHADE44.mutate_rand(offspring(i), population(x1), population(x2), population(x3), population(i).F);
                        offspring(i) = OperatorLSHADE44.crossover(offspring(i), population(i));
                    case 4 % randrl + exp
                        A = randperm(length(population), 4);
                        A(A == i) = []; idx = A(1:3);
                        rank_temp = sort_FP([population(idx).Obj], [population(idx).CV]);
                        x1 = idx(rank_temp(1));
                        if rand < 0.5
                            x2 = idx(rank_temp(2)); x3 = idx(rank_temp(3));
                        else
                            x3 = idx(rank_temp(3)); x2 = idx(rank_temp(2));
                        end
                        offspring(i) = OperatorLSHADE44.mutate_rand(offspring(i), population(x1), population(x2), population(x3), population(i).F);
                        offspring(i) = OperatorLSHADE44.crossoverExp(offspring(i), population(i));
                end

                offspring(i).Dec(offspring(i).Dec > 1) = 1;
                offspring(i).Dec(offspring(i).Dec < 0) = 0;
                % vio_low = find(offspring(i).Dec < 0);
                % offspring(i).Dec(vio_low) = (population(i).Dec(vio_low) + 0) / 2;
                % vio_up = find(offspring(i).Dec > 1);
                % offspring(i).Dec(vio_up) = (population(i).Dec(vio_up) + 1) / 2;
            end
            [offspring, calls] = evaluate(offspring, Task, 1);
        end

        function object = mutate_rand_to_pbest(object, current, pbest, x1, x2)
            object.Dec = current.Dec + current.F * (pbest.Dec - current.Dec) + current.F * (x1.Dec - x2.Dec);
        end

        function object = mutate_rand(object, x1, x2, x3, F)
            object.Dec = x1.Dec + F * (x2.Dec - x3.Dec);
        end

        function object = crossover(object, current)
            replace = rand(1, length(object.Dec)) > current.CR;
            replace(randi(length(object.Dec))) = false;
            object.Dec(replace) = current.Dec(replace);
        end

        function object = crossoverExp(object, current)
            D = length(object.Dec);
            L = 1 + fix(length(object.Dec) * rand());
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
            Dec_temp = current.Dec;
            Dec_temp(replace) = object.Dec(replace);
            object.Dec = Dec_temp;
        end
    end
end
