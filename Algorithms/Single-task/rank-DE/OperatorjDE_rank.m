classdef OperatorjDE_rank < Operator

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function [offspring, calls] = generate(population, Task, t1, t2)
            % calculate rank
            for i = 1:length(population)
                Obj(i) = population(i).Obj;
            end
            [~, rank] = sort(Obj);
            for i = 1:length(population)
                population(rank(i)).ranking = i;
            end

            Individual_class = class(population(1));
            for i = 1:length(population)
                offspring(i) = feval(Individual_class);
                A = randperm(length(population));

                N = length(population);
                idx = 1;
                while rand > (N - population(A(idx)).ranking) / N || A(idx) == i
                    idx = mod(idx, length(A)) + 1;
                end
                x1 = A(idx);

                while rand > (N - population(A(idx)).ranking) / N || A(idx) == x1 || A(idx) == i
                    idx = mod(idx, length(A)) + 1;
                end
                x2 = A(idx);

                while A(idx) == x1 || A(idx) == x2 || A(idx) == i
                    idx = mod(idx, length(A)) + 1;
                end
                x3 = A(idx);

                % parameter self-adaptation
                offspring(i).F = population(i).F;
                offspring(i).CR = population(i).CR;
                if rand < t1
                    offspring(i).F = rand * 0.9 + 0.1;
                end
                if rand < t2
                    offspring(i).CR = rand;
                end

                offspring(i) = OperatorjDE_rank.mutate(offspring(i), population(x1), population(x2), population(x3), offspring(i).F);
                offspring(i) = OperatorjDE_rank.crossover(offspring(i), population(i), offspring(i).CR);

                offspring(i).Dec(offspring(i).Dec > 1) = 1;
                offspring(i).Dec(offspring(i).Dec < 0) = 0;
            end
            [offspring, calls] = evaluate(offspring, Task, 1);
        end

        function object = mutate(object, x1, x2, x3, F)
            object.Dec = x1.Dec + F * (x2.Dec - x3.Dec);
        end

        function object = crossover(object, x, CR)
            replace = rand(1, length(object.Dec)) > CR;
            replace(randi(length(object.Dec))) = false;
            object.Dec(replace) = x.Dec(replace);
        end
    end
end
