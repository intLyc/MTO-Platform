classdef OperatorGA_LDA < OperatorGA
    methods (Static)
        function [offspring, calls] = generateMF(callfun, population, Tasks, rmp, mu, mum, M)
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
                temp_offspring = feval(Individual_class);

                u = rand(1, max([Tasks.dims]));
                cf = zeros(1, max([Tasks.dims]));
                cf(u <= 0.5) = (2 * u(u <= 0.5)).^(1 / (mu + 1));
                cf(u > 0.5) = (2 * (1 - u(u > 0.5))).^(-1 / (mu + 1));

                if population(p1).skill_factor == population(p2).skill_factor || rand < rmp
                    % crossover
                    offspring(count) = OperatorGA_LDA.crossover(offspring(count), population(p1), population(p2), cf);
                    offspring(count + 1) = OperatorGA_LDA.crossover(offspring(count + 1), population(p2), population(p1), cf);
                    % imitate
                    p = [p1, p2];
                    offspring(count).skill_factor = population(p(randi(2))).skill_factor;
                    offspring(count + 1).skill_factor = population(p(randi(2))).skill_factor;
                else
                    % LDA
                    t1 = population(p1).skill_factor;
                    t2 = population(p2).skill_factor;

                    diff = abs(size(M{t1}, 1) - size(M{t2}, 1));
                    % same number of rows for both task populations.
                    % for matrix mapping
                    if size(M{t1}, 1) < size(M{t2}, 1)
                        M{t2} = M{t2}(1:end - diff, :);
                    else
                        M{t1} = M{t1}(1:end - diff, :);
                    end

                    % find Linear Least square mapping between two tasks.
                    if (Tasks(t1).dims > Tasks(t2).dims) % swap t1, t2, make t1.dims < t2.dims
                        tt = t1; t1 = t2; t2 = tt;
                        pp = p1; p1 = p2; p2 = pp;
                    end

                    % map t1 to t2 (low to high dim)
                    [m1, m2] = OperatorGA_LDA.mapping(M{t1}, M{t2});
                    temp_offspring.rnvec = population(p1).rnvec * m1;
                    % crossover
                    offspring(count) = OperatorGA_LDA.crossover(offspring(count), temp_offspring, population(p2), cf);
                    offspring(count + 1) = OperatorGA_LDA.crossover(offspring(count + 1), population(p2), temp_offspring, cf);
                    % imitate
                    p = [p1, p2];
                    rand_p = p(randi(2));
                    offspring(count).skill_factor = population(rand_p).skill_factor;
                    if offspring(count).skill_factor == t1
                        offspring(count).rnvec = offspring(count).rnvec * m2;
                    end
                    rand_p = p(randi(2));
                    offspring(count + 1).skill_factor = population(rand_p).skill_factor;
                    if offspring(count + 1).skill_factor == t1
                        offspring(count + 1).rnvec = offspring(count + 1).rnvec * m2;
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

        function [m1, m2] = mapping(a, b)
            m1 = (inv(transpose(a) * a)) * (transpose(a) * b);
            m2 = transpose(m1) * (inv(m1 * transpose(m1)));
        end
    end
end
