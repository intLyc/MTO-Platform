classdef OperatorGA_SRE < OperatorGA
    methods (Static)
        function [offspring, calls] = generate(callfun, population, Tasks, taski, mu, mum)
            if length(population) <= 2
                offspring = population;
                calls = 0;
                return;
            end
            Individual_class = class(population(1));
            indorder = randperm(length(population));
            count = 1;
            for i = 1:ceil(length(population) / 2)
                p1 = indorder(i);
                p2 = indorder(i + fix(length(population) / 2));
                offspring(count) = feval(Individual_class);
                offspring(count + 1) = feval(Individual_class);
                u = rand(1, length(population(1).rnvec));
                cf = zeros(1, length(population(1).rnvec));
                cf(u <= 0.5) = (2 * u(u <= 0.5)).^(1 / (mu + 1));
                cf(u > 0.5) = (2 * (1 - u(u > 0.5))).^(-1 / (mu + 1));

                offspring(count) = OperatorGA_SRE.crossover(offspring(count), population(p1), population(p2), cf);
                offspring(count + 1) = OperatorGA_SRE.crossover(offspring(count + 1), population(p2), population(p1), cf);

                offspring(count) = OperatorGA_SRE.mutate(offspring(count), length(population(1).rnvec), mum);
                offspring(count + 1) = OperatorGA_SRE.mutate(offspring(count + 1), length(population(1).rnvec), mum);

                % inherit ability vector
                rp = randperm(2);
                p = [p1, p2];
                offspring(count).ability_vector = population(p(rp(1))).ability_vector;
                offspring(count + 1).ability_vector = population(p(rp(2))).ability_vector;

                for x = count:count + 1
                    offspring(x).rnvec(offspring(x).rnvec > 1) = 1;
                    offspring(x).rnvec(offspring(x).rnvec < 0) = 0;
                end
                count = count + 2;
            end
            calls = 0;
            if callfun
                for i = 1:length(offspring)
                    for t = 1:length(Tasks)
                        if t == taski || rand < offspring(i).ability_vector(t)
                            x = (Tasks(t).Ub - Tasks(t).Lb) .* offspring(i).rnvec(1:Tasks(t).dims) + Tasks(t).Lb;
                            [f, cv] = Tasks(t).fnc(x);
                            offspring(i).factorial_costs(t) = f;
                            offspring(i).constraint_violation(t) = cv;
                            calls = calls + 1;
                        else
                            offspring(i).factorial_costs(t) = inf;
                            offspring(i).constraint_violation(t) = inf;
                        end
                    end
                end
            end
        end
    end
end
