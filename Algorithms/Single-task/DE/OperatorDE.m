classdef OperatorDE < Operator

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function object = mutate(object, x1, x2, x3, F)
            object.rnvec = x1.rnvec + F * (x2.rnvec - x3.rnvec);
        end

        function object = crossover(object, x, CR)
            replace = rand(1, length(object.rnvec)) > CR;
            replace(randi(length(object.rnvec))) = true;
            object.rnvec(replace) = x.rnvec(replace);
        end

        function [offspring, calls] = generate(callfun, population, Task, F, CR)
            if length(population) <= 3
                offspring = population;
                calls = 0;
                return;
            end
            Individual_class = class(population(1));
            for i = 1:length(population)
                offspring(i) = feval(Individual_class);

                A = randperm(length(population));
                A(A == i) = [];
                x1 = A(1);
                x2 = A(mod(2 - 1, length(A)) + 1);
                x3 = A(mod(3 - 1, length(A)) + 1);

                offspring(i) = OperatorDE.mutate(offspring(i), population(x1), population(x2), population(x3), F);
                offspring(i) = OperatorDE.crossover(offspring(i), population(i), CR);

                offspring(i).rnvec(offspring(i).rnvec > 1) = 1;
                offspring(i).rnvec(offspring(i).rnvec < 0) = 0;
            end
            if callfun
                [offspring, calls] = evaluate(offspring, Task, 1);
            else
                calls = 0;
            end
        end

        function [offspring, calls] = generate_current2rand(callfun, population, Task, F, CR)
            if length(population) <= 3
                offspring = population;
                calls = 0;
                return;
            end
            Individual_class = class(population(1));
            for i = 1:length(population)
                offspring(i) = feval(Individual_class);

                r = randi(length(population));
                while r == i
                    r = randi(length(population));
                end

                offspring(i) = OperatorDE.mutate(offspring(i), population(i), population(r), population(i), F);
                offspring(i) = OperatorDE.crossover(offspring(i), population(i), CR);

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
