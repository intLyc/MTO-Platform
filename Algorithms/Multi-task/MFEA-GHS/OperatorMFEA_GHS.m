classdef OperatorMFEA_GHS < Operator

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function [offspring, calls] = generate(population, Tasks, rmp, mu, mum, a, max_T, min_T, M)
            Individual_class = class(population(1));
            indorder = randperm(length(population));
            count = 1;
            for i = 1:ceil(length(population) / 2)
                k = 0.5 + 1 * rand;
                p1 = indorder(i);
                p2 = indorder(i + fix(length(population) / 2));
                offspring(count) = feval(Individual_class);
                offspring(count).Obj = inf(1, length(Tasks));
                offspring(count).CV = inf(1, length(Tasks));
                offspring(count + 1) = feval(Individual_class);
                offspring(count + 1).Obj = inf(1, length(Tasks));
                offspring(count + 1).CV = inf(1, length(Tasks));

                u = rand(1, max([Tasks.Dim]));
                cf = zeros(1, max([Tasks.Dim]));
                cf(u <= 0.5) = (2 * u(u <= 0.5)).^(1 / (mu + 1));
                cf(u > 0.5) = (2 * (1 - u(u > 0.5))).^(-1 / (mu + 1));

                if population(p1).skill_factor == population(p2).skill_factor
                    t = population(p1).skill_factor;
                    % crossover
                    offspring(count) = OperatorMFEA_GHS.crossover(offspring(count), population(p1), population(p2), cf);
                    %
                    if rand > a
                        offspring(count + 1).Dec = 1 - offspring(count).Dec;
                    else
                        offspring(count + 1).Dec = k * (max_T{t} + min_T{t}) - offspring(count).Dec;
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
                        tmp.Dec = population(p(r1)).Dec .* M{t1};
                        tmp.Dec(tmp.Dec > 1) = 1;
                        tmp.Dec(tmp.Dec < 0) = 0;
                        offspring(count) = OperatorMFEA_GHS.crossover(offspring(count), tmp, population(p(r2)), cf);
                        % OBL
                        if rand > a
                            offspring(count + 1).Dec = 1 - offspring(count).Dec;
                        else
                            offspring(count + 1).Dec = k * (max_T{t2} + min_T{t2}) - offspring(count).Dec;
                        end
                    else
                        tmp = population(p(r2));
                        tmp.Dec = population(p(r2)).Dec .* M{t2};
                        tmp.Dec(tmp.Dec > 1) = 1;
                        tmp.Dec(tmp.Dec < 0) = 0;
                        offspring(count) = OperatorMFEA_GHS.crossover(offspring(count), population(p(r1)), tmp, cf);
                        % OBL
                        if rand > a
                            offspring(count + 1).Dec = 1 - offspring(count).Dec;
                        else
                            offspring(count + 1).Dec = k * (max_T{t1} + min_T{t1}) - offspring(count).Dec;
                        end
                    end
                    % imitate
                    offspring(count).skill_factor = population(p(randi(2))).skill_factor;
                    offspring(count + 1).skill_factor = population(p(randi(2))).skill_factor;
                else
                    p = [p1, p2];
                    for x = 1:2
                        % mutate
                        offspring(count + x - 1) = OperatorMFEA_GHS.mutate(population(p(x)), max([Tasks.Dim]), mum);
                        % imitate
                        offspring(count + x - 1).skill_factor = population(p(x)).skill_factor;
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
