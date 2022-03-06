classdef OperatorMFEA_GHS < OperatorMFEA
    methods (Static)
        function [offspring, calls] = generate(callfun, population, Tasks, rmp, mu, mum, a, max_T, min_T, M)
            Individual_class = class(population(1));
            indorder = randperm(length(population));
            count = 1;
            for i = 1:ceil(length(population) / 2)
                k = 0.5 + 1 * rand;
                p1 = indorder(i);
                p2 = indorder(i + fix(length(population) / 2));
                offspring(count) = feval(Individual_class);
                offspring(count).factorial_costs = inf(1, length(Tasks));
                offspring(count).constraint_violation = inf(1, length(Tasks));
                offspring(count + 1) = feval(Individual_class);
                offspring(count + 1).factorial_costs = inf(1, length(Tasks));
                offspring(count + 1).constraint_violation = inf(1, length(Tasks));

                u = rand(1, max([Tasks.dims]));
                cf = zeros(1, max([Tasks.dims]));
                cf(u <= 0.5) = (2 * u(u <= 0.5)).^(1 / (mu + 1));
                cf(u > 0.5) = (2 * (1 - u(u > 0.5))).^(-1 / (mu + 1));

                if population(p1).skill_factor == population(p2).skill_factor
                    t = population(p1).skill_factor;
                    % crossover
                    offspring(count) = OperatorGA.crossover(offspring(count), population(p1), population(p2), cf);
                    %
                    if rand > a
                        offspring(count + 1).rnvec = 1 - offspring(count).rnvec;
                    else
                        offspring(count + 1).rnvec = k * (max_T{t} + min_T{t}) - offspring(count).rnvec;
                    end
                    % imitate
                    offspring(count).skill_factor = t;
                    offspring(count + 1).skill_factor = t;
                elseif rand < rmp
                    % crossover
                    p = [p1, p2];
                    r1 = randi(2);
                    r2 = mod(r1, 2) + 1;
                    t1 = population(p(r1)).skill_factor;
                    t2 = population(p(r2)).skill_factor;
                    if rand < 0.5
                        tmp = population(p(r1));
                        tmp.rnvec = population(p(r1)).rnvec .* M{t1};
                        tmp.rnvec(tmp.rnvec > 1) = 1;
                        tmp.rnvec(tmp.rnvec < 0) = 0;
                        offspring(count) = OperatorGA.crossover(offspring(count), tmp, population(p(r2)), cf);
                        % OBL
                        if rand > a
                            offspring(count + 1).rnvec = 1 - offspring(count).rnvec;
                        else
                            offspring(count + 1).rnvec = k * (max_T{t2} + min_T{t2}) - offspring(count).rnvec;
                        end
                    else
                        tmp = population(p(r2));
                        tmp.rnvec = population(p(r2)).rnvec .* M{t2};
                        tmp.rnvec(tmp.rnvec > 1) = 1;
                        tmp.rnvec(tmp.rnvec < 0) = 0;
                        offspring(count) = OperatorGA.crossover(offspring(count), population(p(r1)), tmp, cf);
                        % OBL
                        if rand > a
                            offspring(count + 1).rnvec = 1 - offspring(count).rnvec;
                        else
                            offspring(count + 1).rnvec = k * (max_T{t1} + min_T{t1}) - offspring(count).rnvec;
                        end
                    end
                    % imitate
                    offspring(count).skill_factor = population(p(randi(2))).skill_factor;
                    offspring(count + 1).skill_factor = population(p(randi(2))).skill_factor;
                else
                    p = [p1, p2];
                    for x = 1:2
                        % mutate
                        offspring(count + x - 1) = OperatorGA.mutate(population(p(x)), max([Tasks.dims]), mum);
                        % imitate
                        offspring(count + x - 1).skill_factor = population(p(x)).skill_factor;
                    end
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
    end
end
