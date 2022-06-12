classdef OperatorMaTDE < Operator

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function [offspring, calls] = generate(population, Task, F, CR)
            Individual_class = class(population(1));
            for i = 1:length(population)
                offspring(i) = feval(Individual_class);

                r = randi(length(population));
                while r == i
                    r = randi(length(population));
                end
                x1 = i; x2 = r; x3 = i;

                offspring(i) = OperatorMaTDE.mutate(offspring(i), population(x1), population(x2), population(x3), F);
                offspring(i) = OperatorMaTDE.crossover(offspring(i), population(i), CR);

                rand_rnvec = rand(1, Task.dims);
                offspring(i).rnvec(offspring(i).rnvec > 1) = rand_rnvec(offspring(i).rnvec > 1);
                offspring(i).rnvec(offspring(i).rnvec < 0) = rand_rnvec(offspring(i).rnvec < 0);
            end
            [offspring, calls] = evaluate(offspring, Task, 1);
        end

        function object = mutate(object, x1, x2, x3, F)
            object.rnvec = x1.rnvec + F * (x2.rnvec - x3.rnvec);
        end

        function object = crossover(object, x, CR)
            replace = rand(1, length(object.rnvec)) > CR;
            replace(randi(length(object.rnvec))) = false;
            object.rnvec(replace) = x.rnvec(replace);
        end
    end
end
