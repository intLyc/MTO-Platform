classdef OperatorGA < Operator
    methods (Static)
        function [offspring, calls] = generate(callfun, population, Task, mu, mum)
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

                offspring(count) = OperatorGA.crossover(offspring(count), population(p1), population(p2), cf);
                offspring(count + 1) = OperatorGA.crossover(offspring(count + 1), population(p2), population(p1), cf);

                offspring(count) = OperatorGA.mutate(offspring(count), length(population(1).rnvec), mum);
                offspring(count + 1) = OperatorGA.mutate(offspring(count + 1), length(population(1).rnvec), mum);

                for x = count:count + 1
                    offspring(x).rnvec(offspring(x).rnvec > 1) = 1;
                    offspring(x).rnvec(offspring(x).rnvec < 0) = 0;
                end
                count = count + 2;
            end
            if callfun
                [offspring, calls] = evaluate(offspring, Task, 1);
            else
                calls = 0;
            end
        end

        function object = crossover(object, p1, p2, cf)
            % SBX - Simulated binary crossover
            object.rnvec = 0.5 * ((1 + cf) .* p1.rnvec + (1 - cf) .* p2.rnvec);
        end

        function object = mutate(object, dim, mum)
            % Polynomial mutation
            rnvec_temp = object.rnvec;
            for i = 1:dim
                if rand(1) < 1 / dim
                    u = rand(1);
                    if u <= 0.5
                        del = (2 * u)^(1 / (1 + mum)) - 1;
                        rnvec_temp(i) = object.rnvec(i) + del * (object.rnvec(i));
                    else
                        del = 1 - (2 * (1 - u))^(1 / (1 + mum));
                        rnvec_temp(i) = object.rnvec(i) + del * (1 - object.rnvec(i));
                    end
                end
            end
            object.rnvec = rnvec_temp;
        end
    end
end
