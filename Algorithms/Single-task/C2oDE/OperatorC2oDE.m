classdef OperatorC2oDE < Operator

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
                j = (i - 1) * 3 + 1;
                offspring(j) = feval(Individual_class);
                offspring(j + 1) = feval(Individual_class);
                offspring(j + 2) = feval(Individual_class);

                % current-to-best
                A = randperm(length(population), 3);
                A(A == i) = []; x1 = A(1); x2 = A(2);
                [~, best] = min([population.factorial_costs]);
                offspring(j) = OperatorC2oDE.mutate_current_to_best(offspring(j), population(i), population(best), population(x1), population(x2), F(randi(length(F))));
                offspring(j) = OperatorC2oDE.crossover(offspring(j), population(i), CR(randi(length(CR))));

                % rand-to-best-modified
                A = randperm(length(population), 5);
                A(A == i + 1) = []; x1 = A(1); x2 = A(2); x3 = A(3); x4 = A(4);
                [~, ~, best] = min_FP([population.factorial_costs], [population.constraint_violation]);
                offspring(j + 1) = OperatorC2oDE.mutate_rand_to_best_modified(offspring(j + 1), population(best), population(x1), population(x2), population(x3), population(x4), F(randi(length(F))));
                offspring(j + 1) = OperatorC2oDE.crossover(offspring(j + 1), population(i), CR(randi(length(CR))));

                % current-to-rand
                A = randperm(length(population), 4);
                A(A == i + 2) = []; x1 = A(1); x2 = A(2); x3 = A(3);
                offspring(j + 2) = OperatorC2oDE.mutate_current_to_rand(offspring(j + 2), population(i), population(x1), population(x2), population(x3), F(randi(length(F))));

                % boundary check
                for x = j:j + 2
                    vio_low = find(offspring(x).rnvec < 0);
                    if rand() < 0.5
                        offspring(x).rnvec(vio_low) = 2 * 0 - offspring(x).rnvec(vio_low);
                        vio_temp = offspring(x).rnvec(vio_low) > 1;
                        offspring(x).rnvec(vio_low(vio_temp)) = 1;
                    else
                        if rand() < 0.5
                            offspring(x).rnvec(vio_low) = 0;
                        else
                            offspring(x).rnvec(vio_low) = 1;
                        end
                    end
                    vio_up = find(offspring(x).rnvec > 1);
                    if rand() < 0.5
                        offspring(x).rnvec(vio_up) = 2 * 1 - offspring(x).rnvec(vio_up);
                        vio_temp = offspring(x).rnvec(vio_up) < 0;
                        offspring(x).rnvec(vio_up(vio_temp)) = 1;
                    else
                        if rand() < 0.5
                            offspring(x).rnvec(vio_up) = 0;
                        else
                            offspring(x).rnvec(vio_up) = 1;
                        end
                    end
                end
            end
            [offspring, calls] = evaluate(offspring, Task, 1);
        end

        function object = mutate_current_to_rand(object, current, x1, x2, x3, F)
            object.rnvec = current.rnvec + rand() * (x1.rnvec - current.rnvec) + F * (x2.rnvec - x3.rnvec);
        end

        function object = mutate_current_to_best(object, current, best, x1, x2, F)
            object.rnvec = current.rnvec + F * (best.rnvec - current.rnvec) + F * (x1.rnvec - x2.rnvec);
        end

        function object = mutate_rand_to_best_modified(object, best, x1, x2, x3, x4, F)
            object.rnvec = x1.rnvec + F * (best.rnvec - x2.rnvec) + F * (x3.rnvec - x4.rnvec);
        end

        function object = crossover(object, x, CR)
            replace = rand(1, length(object.rnvec)) > CR;
            replace(randi(length(object.rnvec))) = false;
            object.rnvec(replace) = x.rnvec(replace);
        end
    end
end
