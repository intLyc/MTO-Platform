classdef OperatorDE_MTV < Operator

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function [offspring, calls] = generate(callfun, population, Task, F, CR, no)
            if length(population) <= 3
                offspring = population;
                calls = 0;
                return;
            end
            calls = 0;
            Individual_class = class(population(1));
            for i = 1:length(population)
                offspring_temp = feval(Individual_class);
                offspring(i) = feval(Individual_class);

                for k = 1:no
                    % multiple offspring
                    A = randperm(length(population), 4);
                    A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3);

                    offspring_temp = OperatorDE.mutate_rand_1(offspring_temp, population(x1), population(x2), population(x3), F);
                    offspring_temp = OperatorDE.crossover(offspring_temp, population(i), CR);

                    offspring_temp.rnvec(offspring_temp.rnvec > 1) = 1;
                    offspring_temp.rnvec(offspring_temp.rnvec < 0) = 0;
                    [offspring_temp, cal] = evaluate(offspring_temp, Task, 1);
                    calls = calls + cal;

                    if k == 1
                        offspring(i) = offspring_temp;
                    else
                        if offspring_temp.constraint_violation < offspring(i).constraint_violation || ...
                                (offspring_temp.constraint_violation == offspring(i).constraint_violation && ...
                                offspring_temp.factorial_costs < offspring(i).factorial_costs)
                            offspring(i) = offspring_temp;
                        end
                    end
                end
            end
        end
    end
end
