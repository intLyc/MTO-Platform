classdef OperatorGA
    methods (Static)
        function [offspring, calls] = generate(callfun, population, Task, mu, mum)
            indorder = randperm(length(population));
            count = 1;
            for i = 1:ceil(length(population) / 2)
                p1 = indorder(i);
                p2 = indorder(i + fix(length(population) / 2));
                offspring(count) = Individual();
                offspring(count + 1) = Individual();
                u = rand(1, Task.dims);
                cf = zeros(1, Task.dims);
                cf(u <= 0.5) = (2 * u(u <= 0.5)).^(1 / (mu + 1));
                cf(u > 0.5) = (2 * (1 - u(u > 0.5))).^(-1 / (mu + 1));
                offspring(count) = OperatorGA.crossover(offspring(count), population(p1), population(p2), cf);
                offspring(count + 1) = OperatorGA.crossover(offspring(count + 1), population(p2), population(p1), cf);
                if rand(1) < 1
                    offspring(count) = OperatorGA.mutate(offspring(count), offspring(count), Task.dims, mum);
                    offspring(count + 1) = OperatorGA.mutate(offspring(count + 1), offspring(count + 1), Task.dims, mum);
                end
                for x = count:count + 1
                    offspring(x).rnvec(offspring(x).rnvec > 1) = 1;
                    offspring(x).rnvec(offspring(x).rnvec < 0) = 0;
                end
                count = count + 2;
            end
            if callfun
                [offspring, calls] = evaluate(offspring, Task);
            else
                calls = 0;
            end
        end

        % SBX
        function object = crossover(object, p1, p2, cf)
            object.rnvec = 0.5 * ((1 + cf) .* p1.rnvec + (1 - cf) .* p2.rnvec);
        end

        % Polynomial mutation
        function object = mutate(object, p, dim, mum)
            rnvec_temp = p.rnvec;
            for i = 1:dim
                if rand(1) < 1 / dim
                    u = rand(1);
                    if u <= 0.5
                        del = (2 * u)^(1 / (1 + mum)) - 1;
                        rnvec_temp(i) = p.rnvec(i) + del * (p.rnvec(i));
                    else
                        del = 1 - (2 * (1 - u))^(1 / (1 + mum));
                        rnvec_temp(i) = p.rnvec(i) + del * (1 - p.rnvec(i));
                    end
                end
            end
            object.rnvec = rnvec_temp;
        end
    end
end
