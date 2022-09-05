classdef OperatorMFEA_LDA < Operator

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function [offspring, calls] = generate(population, Tasks, rmp, mu, mum, M)
            Individual_class = class(population(1));
            indorder = randperm(length(population));
            count = 1;
            for i = 1:ceil(length(population) / 2)
                p1 = indorder(i);
                p2 = indorder(i + fix(length(population) / 2));
                offspring(count) = feval(Individual_class);
                offspring(count).Obj = inf(1, length(Tasks));
                offspring(count).CV = inf(1, length(Tasks));
                offspring(count + 1) = feval(Individual_class);
                offspring(count + 1).Obj = inf(1, length(Tasks));
                offspring(count + 1).CV = inf(1, length(Tasks));
                temp_offspring = feval(Individual_class);

                u = rand(1, max([Tasks.Dim]));
                cf = zeros(1, max([Tasks.Dim]));
                cf(u <= 0.5) = (2 * u(u <= 0.5)).^(1 / (mu + 1));
                cf(u > 0.5) = (2 * (1 - u(u > 0.5))).^(-1 / (mu + 1));

                if population(p1).skill_factor == population(p2).skill_factor || rand < rmp
                    % crossover
                    offspring(count) = OperatorMFEA_LDA.crossover(offspring(count), population(p1), population(p2), cf);
                    offspring(count + 1) = OperatorMFEA_LDA.crossover(offspring(count + 1), population(p2), population(p1), cf);
                    % mutate
                    offspring(count) = OperatorMFEA_LDA.mutate(offspring(count), max([Tasks.Dim]), mum);
                    offspring(count + 1) = OperatorMFEA_LDA.mutate(offspring(count + 1), max([Tasks.Dim]), mum);
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
                    if (Tasks(t1).Dim > Tasks(t2).Dim) % swap t1, t2, make t1.Dim < t2.Dim
                        tt = t1; t1 = t2; t2 = tt;
                        pp = p1; p1 = p2; p2 = pp;
                    end

                    % map t1 to t2 (low to high dim)
                    [m1, m2] = OperatorMFEA_LDA.mapping(M{t1}, M{t2});
                    temp_offspring.Dec = population(p1).Dec * m1;
                    % crossover
                    offspring(count) = OperatorMFEA_LDA.crossover(offspring(count), temp_offspring, population(p2), cf);
                    offspring(count + 1) = OperatorMFEA_LDA.crossover(offspring(count + 1), population(p2), temp_offspring, cf);
                    % mutate
                    offspring(count) = OperatorMFEA_LDA.mutate(offspring(count), max([Tasks.Dim]), mum);
                    offspring(count + 1) = OperatorMFEA_LDA.mutate(offspring(count + 1), max([Tasks.Dim]), mum);
                    % imitate
                    p = [p1, p2];
                    rand_p = p(randi(2));
                    offspring(count).skill_factor = population(rand_p).skill_factor;
                    if offspring(count).skill_factor == t1
                        offspring(count).Dec = offspring(count).Dec * m2;
                    end
                    rand_p = p(randi(2));
                    offspring(count + 1).skill_factor = population(rand_p).skill_factor;
                    if offspring(count + 1).skill_factor == t1
                        offspring(count + 1).Dec = offspring(count + 1).Dec * m2;
                    end
                end
                for x = count:count + 1
                    offspring(x).Dec(offspring(x).Dec > 1) = 1;
                    offspring(x).Dec(offspring(x).Dec < 0) = 0;
                end
                count = count + 2;
            end

            % Evaluation
            offspring_temp = feval(Individual_class).empty();
            calls = 0;
            for t = 1:length(Tasks)
                offspring_t = offspring([offspring.skill_factor] == t);
                [offspring_t, cal] = evaluate(offspring_t, Tasks(t), t);
                offspring_temp = [offspring_temp, offspring_t];
                calls = calls + cal;
            end
            offspring = offspring_temp;
        end

        function [m1, m2] = mapping(a, b)
            m1 = (inv(transpose(a) * a)) * (transpose(a) * b);
            m2 = transpose(m1) * (inv(m1 * transpose(m1)));
        end

        function object = crossover(object, p1, p2, cf)
            % SBX - Simulated binary crossover
            object.Dec = 0.5 * ((1 + cf) .* p1.Dec + (1 - cf) .* p2.Dec);
        end

        function object = mutate(object, dim, mum)
            % Polynomial mutation
            Dec_temp = object.Dec;
            for i = 1:dim
                if rand(1) < 1 / dim
                    u = rand(1);
                    if u <= 0.5
                        del = (2 * u)^(1 / (1 + mum)) - 1;
                        Dec_temp(i) = object.Dec(i) + del * (object.Dec(i));
                    else
                        del = 1 - (2 * (1 - u))^(1 / (1 + mum));
                        Dec_temp(i) = object.Dec(i) + del * (1 - object.Dec(i));
                    end
                end
            end
            object.Dec = Dec_temp;
        end
    end
end
