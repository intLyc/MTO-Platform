classdef OperatorDeCODE < Operator

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function [offspring, calls] = generate(population, Task, F, CR, weights, fnceval, eva_num)
            Individual_class = class(population(1));

            Obj = [population.Obj];
            CV = [population.CV];
            normal_Obj = (Obj - min(Obj)) ./ (std(Obj) + eps(0));
            normal_CV = (CV - min(CV)) ./ (std(CV) + eps(0));

            for i = 1:length(population)
                offspring(i) = feval(Individual_class);

                A = randperm(length(population), 4);
                A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3);
                if rand() < fnceval / eva_num
                    % rand-to-best
                    fit = weights(i) * normal_Obj + (1 - weights(i)) * normal_CV;
                    [~, best] = min(fit);

                    offspring(i) = OperatorDeCODE.mutate_rand_to_best(offspring(i), population(best), population(x1), population(x2), population(x3), F(randi(length(F))));
                    offspring(i) = OperatorDeCODE.crossover(offspring(i), population(i), CR(randi(length(CR))));
                else
                    % current-to-rand
                    offspring(i) = OperatorDeCODE.mutate_current_to_rand(offspring(i), population(i), population(x1), population(x2), population(x3), F(randi(length(F))));
                end

                % boundary check
                 vio_low = find(offspring(i).Dec < 0);
                if rand() < 0.5
                    offspring(i).Dec(vio_low) = 2 * 0 - offspring(i).Dec(vio_low);
                    vio_temp = offspring(i).Dec(vio_low) > 1;
                    offspring(i).Dec(vio_low(vio_temp)) = 1;
                else
                    if rand() < 0.5
                        offspring(i).Dec(vio_low) = 0;
                    else
                        offspring(i).Dec(vio_low) = 1;
                    end
                end
                vio_up = find(offspring(i).Dec > 1);
                if rand() < 0.5
                    offspring(i).Dec(vio_up) = 2 * 1 - offspring(i).Dec(vio_up);
                    vio_temp = offspring(i).Dec(vio_up) < 0;
                    offspring(i).Dec(vio_up(vio_temp)) = 1;
                else
                    if rand() < 0.5
                        offspring(i).Dec(vio_up) = 0;
                    else
                        offspring(i).Dec(vio_up) = 1;
                    end
                end
            end
            [offspring, calls] = evaluate(offspring, Task, 1);
        end

        function object = mutate_current_to_rand(object, current, x1, x2, x3, F)
            object.Dec = current.Dec + rand() * (x1.Dec - current.Dec) + F * (x2.Dec - x3.Dec);
        end

        function object = mutate_rand_to_best(object, best, x1, x2, x3, F)
            object.Dec = x1.Dec + F * (best.Dec - x1.Dec) + F * (x2.Dec - x3.Dec);
        end

        function object = crossover(object, x, CR)
            replace = rand(1, length(object.Dec)) > CR;
            replace(randi(length(object.Dec))) = false;
            object.Dec(replace) = x.Dec(replace);
        end
    end
end
