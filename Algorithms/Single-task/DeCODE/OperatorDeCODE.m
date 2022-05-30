classdef OperatorDeCODE < Operator

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function [offspring, calls] = generate(callfun, population, Task, F, CR, weights, prob)
            if isempty(population)
                offspring = population;
                calls = 0;
                return;
            end
            Individual_class = class(population(1));

            Obj = [population.factorial_costs];
            CV = [population.constraint_violation];
            normal_Obj = (Obj - min(Obj)) ./ (max(Obj) - min(Obj) + 1e-15);
            normal_CV = (CV - min(CV)) ./ (max(CV) - min(CV) + 1e-15);

            for i = 1:length(population)
                offspring(i) = feval(Individual_class);

                A = randperm(length(population), 4);
                A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3);
                if rand() < prob
                    % rand-to-best
                    fit = weights(i) * normal_Obj + (1 - weights(i)) * normal_CV;
                    [~, best] = min(fit);

                    offspring(i) = OperatorDeCODE.mutate_rand_to_best(offspring(i), population(best), population(x1), population(x2), population(x3), F(randi(length(F))));
                    offspring(i) = OperatorDE.crossover(offspring(i), population(i), CR(randi(length(CR))));
                else
                    % current-to-rand
                    offspring(i) = OperatorDeCODE.mutate_current_to_rand(offspring(i), population(i), population(x1), population(x2), population(x3), F(randi(length(F))));
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

        function object = mutate_current_to_rand(object, current, x1, x2, x3, F)
            object.rnvec = current.rnvec + rand() * (x1.rnvec - current.rnvec) + F * (x2.rnvec - x3.rnvec);
        end

        function object = mutate_rand_to_best(object, best, x1, x2, x3, F)
            object.rnvec = x1.rnvec + F * (best.rnvec - x1.rnvec) + F * (x2.rnvec - x3.rnvec);
        end
    end
end
