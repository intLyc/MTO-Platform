classdef OperatorjDE_rank < Operator

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function [offspring, calls] = generate(callfun, population, Task, t1, t2)
            if length(population) <= 3
                offspring = population;
                calls = 0;
                return;
            end

            % calculate rank
            for i = 1:length(population)
                factorial_costs(i) = population(i).factorial_costs;
            end
            [~, rank] = sort(factorial_costs);
            for i = 1:length(population)
                population(rank(i)).factorial_ranks = i;
            end

            Individual_class = class(population(1));
            for i = 1:length(population)
                offspring(i) = feval(Individual_class);
                A = randperm(length(population));

                N = length(population);
                idx = 1;
                while rand > (N - population(A(idx)).factorial_ranks) / N || A(idx) == i
                    idx = mod(idx, length(A)) + 1;
                end
                x1 = A(idx);

                while rand > (N - population(A(idx)).factorial_ranks) / N || A(idx) == x1 || A(idx) == i
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

                offspring(i) = OperatorDE.mutate(offspring(i), population(x1), population(x2), population(x3), offspring.F);
                offspring(i) = OperatorDE.crossover(offspring(i), population(i), offspring.CR);

                offspring(i).rnvec(offspring(i).rnvec > 1) = 1;
                offspring(i).rnvec(offspring(i).rnvec < 0) = 0;
            end
            if callfun
                [offspring, calls] = evaluate(offspring, Task, 1);
            else
                calls = 0;
            end
        end
    end
end
