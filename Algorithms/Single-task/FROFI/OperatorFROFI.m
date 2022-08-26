classdef OperatorFROFI < Operator

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

                A = randperm(length(population), 4);
                A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3);

                if rand() < 0.5
                    % rand-to-best
                    [~, best] = min([population.factorial_costs]);

                    offspring(i) = OperatorFROFI.mutate_rand_to_best(offspring(i), population(best), population(x1), population(x2), population(x3), F(randi(length(F))));
                    offspring(i) = OperatorFROFI.crossover(offspring(i), population(i), CR(randi(length(CR))));
                else
                    % current-to-rand
                    offspring(i) = OperatorFROFI.mutate_current_to_rand(offspring(i), population(i), population(x1), population(x2), population(x3), F(randi(length(F))));
                end

                % boundary check
                vio_low = find(offspring(i).rnvec < 0);
                if rand() < 0.5
                    offspring(i).rnvec(vio_low) = 2 * 0 - offspring(i).rnvec(vio_low);
                    vio_temp = offspring(i).rnvec(vio_low) > 1;
                    offspring(i).rnvec(vio_low(vio_temp)) = 1;
                else
                    if rand() < 0.5
                        offspring(i).rnvec(vio_low) = 0;
                    else
                        offspring(i).rnvec(vio_low) = 1;
                    end
                end
                vio_up = find(offspring(i).rnvec > 1);
                if rand() < 0.5
                    offspring(i).rnvec(vio_up) = 2 * 1 - offspring(i).rnvec(vio_up);
                    vio_temp = offspring(i).rnvec(vio_up) < 0;
                    offspring(i).rnvec(vio_up(vio_temp)) = 1;
                else
                    if rand() < 0.5
                        offspring(i).rnvec(vio_up) = 0;
                    else
                        offspring(i).rnvec(vio_up) = 1;
                    end
                end
            end
            [offspring, calls] = evaluate(offspring, Task, 1);
        end

        function object = mutate_current_to_rand(object, current, x1, x2, x3, F)
            object.rnvec = current.rnvec + rand() * (x1.rnvec - current.rnvec) + F * (x2.rnvec - x3.rnvec);
        end

        function object = mutate_rand_to_best(object, best, x1, x2, x3, F)
            object.rnvec = x1.rnvec + F * (best.rnvec - x1.rnvec) + F * (x2.rnvec - x3.rnvec);
        end

        function object = crossover(object, x, CR)
            replace = rand(1, length(object.rnvec)) > CR;
            replace(randi(length(object.rnvec))) = false;
            object.rnvec(replace) = x.rnvec(replace);
        end
    end
end
