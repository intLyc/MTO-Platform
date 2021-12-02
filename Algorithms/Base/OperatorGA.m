classdef OperatorGA
    methods (Static)
        function [offspring, calls] = generate(callfun, population, Task, mu, mum)
            Individual_class = class(population(1));
            indorder = randperm(length(population));
            count = 1;
            for i = 1:ceil(length(population) / 2)
                p1 = indorder(i);
                p2 = indorder(i + fix(length(population) / 2));
                offspring(count) = feval(Individual_class);
                offspring(count + 1) = feval(Individual_class);
                u = rand(1, Task.dims);
                cf = zeros(1, Task.dims);
                cf(u <= 0.5) = (2 * u(u <= 0.5)).^(1 / (mu + 1));
                cf(u > 0.5) = (2 * (1 - u(u > 0.5))).^(-1 / (mu + 1));

                offspring(count) = OperatorGA.crossover(offspring(count), population(p1), population(p2), cf);
                offspring(count + 1) = OperatorGA.crossover(offspring(count + 1), population(p2), population(p1), cf);

                offspring(count) = OperatorGA.mutate(offspring(count), Task.dims, mum);
                offspring(count + 1) = OperatorGA.mutate(offspring(count + 1), Task.dims, mum);

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

        function [offspring, calls] = generateMF(callfun, population, Tasks, rmp, mu, mum)
            Individual_class = class(population(1));
            indorder = randperm(length(population));
            count = 1;
            for i = 1:ceil(length(population) / 2)
                p1 = indorder(i);
                p2 = indorder(i + fix(length(population) / 2));
                offspring(count) = feval(Individual_class);
                offspring(count).factorial_costs = inf(1, length(Tasks));
                offspring(count + 1) = feval(Individual_class);
                offspring(count + 1).factorial_costs = inf(1, length(Tasks));

                if (population(p1).skill_factor == population(p2).skill_factor) || rand < rmp
                    % crossover
                    u = rand(1, max([Tasks.dims]));
                    cf = zeros(1, max([Tasks.dims]));
                    cf(u <= 0.5) = (2 * u(u <= 0.5)).^(1 / (mu + 1));
                    cf(u > 0.5) = (2 * (1 - u(u > 0.5))).^(-1 / (mu + 1));

                    offspring(count) = OperatorGA.crossover(offspring(count), population(p1), population(p2), cf);
                    offspring(count + 1) = OperatorGA.crossover(offspring(count + 1), population(p2), population(p1), cf);

                    p = [p1, p2];
                    offspring(count).skill_factor = population(p(randi(2))).skill_factor;
                    offspring(count + 1).skill_factor = population(p(randi(2))).skill_factor;

                    % mutate
                    offspring(count) = OperatorGA.mutate(offspring(count), max([Tasks.dims]), mum);
                    offspring(count + 1) = OperatorGA.mutate(offspring(count + 1), max([Tasks.dims]), mum);
                else
                    % mutate
                    offspring(count) = OperatorGA.mutate(population(p1), max([Tasks.dims]), mum);
                    offspring(count).skill_factor = population(p1).skill_factor;
                    offspring(count + 1) = OperatorGA.mutate(population(p2), max([Tasks.dims]), mum);
                    offspring(count).skill_factor = population(p2).skill_factor;
                end
                for x = count:count + 1
                    offspring(x).rnvec(offspring(x).rnvec > 1) = 1;
                    offspring(x).rnvec(offspring(x).rnvec < 0) = 0;
                end
                count = count + 2;
            end
            if callfun
                offspring_temp = feval(Individual_class).empty();
                calls = 0;
                for t = 1:length(Tasks)
                    offspring_t = offspring([offspring.skill_factor] == t);
                    [offspring_t, cal] = evaluate(offspring_t, Tasks(t), t);
                    offspring_temp = [offspring_temp, offspring_t];
                    calls = calls + cal;
                end
                offspring = offspring_temp;
            else
                calls = 0;
            end
        end

        % SBX
        function object = crossover(object, p1, p2, cf)
            object.rnvec = 0.5 * ((1 + cf) .* p1.rnvec + (1 - cf) .* p2.rnvec);
        end

        % Polynomial mutation
        function object = mutate(object, dim, mum)
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
