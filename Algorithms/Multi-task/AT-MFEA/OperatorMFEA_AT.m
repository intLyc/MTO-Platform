classdef OperatorMFEA_AT < Operator

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function [offspring, calls] = generate(population, Tasks, rmp, mu, mum, probswap, mu_tasks, Sigma_tasks)
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

                u = rand(1, max([Tasks.Dim]));
                cf = zeros(1, max([Tasks.Dim]));
                cf(u <= 0.5) = (2 * u(u <= 0.5)).^(1 / (mu + 1));
                cf(u > 0.5) = (2 * (1 - u(u > 0.5))).^(-1 / (mu + 1));

                if population(p1).skill_factor == population(p2).skill_factor
                    % crossover
                    offspring(count) = OperatorMFEA_AT.crossover(offspring(count), population(p1), population(p2), cf);
                    offspring(count + 1) = OperatorMFEA_AT.crossover(offspring(count + 1), population(p2), population(p1), cf);
                    % mutate
                    offspring(count) = OperatorMFEA_AT.mutate(offspring(count), max([Tasks.Dim]), mum);
                    offspring(count + 1) = OperatorMFEA_AT.mutate(offspring(count + 1), max([Tasks.Dim]), mum);
                    % variable swap (uniform X)
                    swap_indicator = (rand(1, max([Tasks.Dim])) >= probswap);
                    temp = offspring(count + 1).Dec(swap_indicator);
                    offspring(count + 1).Dec(swap_indicator) = offspring(count).Dec(swap_indicator);
                    offspring(count).Dec(swap_indicator) = temp;
                    % imitate
                    p = [p1, p2];
                    offspring(count).skill_factor = population(p(randi(2))).skill_factor;
                    offspring(count + 1).skill_factor = population(p(randi(2))).skill_factor;
                elseif rand < rmp
                    % affine transformation
                    pm1 = population(p1);
                    pm2 = population(p2);
                    pm1.Dec = AT_Transfer(population(p1).Dec, mu_tasks{population(p1).skill_factor}, Sigma_tasks{population(p1).skill_factor}, mu_tasks{population(p2).skill_factor}, Sigma_tasks{population(p2).skill_factor});
                    pm2.Dec = AT_Transfer(population(p2).Dec, mu_tasks{population(p2).skill_factor}, Sigma_tasks{population(p2).skill_factor}, mu_tasks{population(p1).skill_factor}, Sigma_tasks{population(p1).skill_factor});
                    % crossover
                    offspring(count) = OperatorMFEA_AT.crossover(offspring(count), pm1, population(p2), cf);
                    offspring(count + 1) = OperatorMFEA_AT.crossover(offspring(count + 1), population(p1), pm2, cf);
                    % mutate
                    offspring(count) = OperatorMFEA_AT.mutate(offspring(count), max([Tasks.Dim]), mum);
                    offspring(count + 1) = OperatorMFEA_AT.mutate(offspring(count + 1), max([Tasks.Dim]), mum);
                    % imitate
                    p = [p1, p2];
                    offspring(count).skill_factor = population(p(randi(2))).skill_factor;
                    offspring(count + 1).skill_factor = population(p(randi(2))).skill_factor;
                else
                    % Randomly pick another individual from the same task
                    p = [p1, p2];
                    for x = 1:2
                        find_idx = find([population.skill_factor] == population(p(x)).skill_factor);
                        idx = find_idx(randi(length(find_idx)));
                        while idx == p(x)
                            idx = find_idx(randi(length(find_idx)));
                        end
                        temp_offspring = feval(Individual_class);
                        % crossover
                        offspring(count + x - 1) = OperatorMFEA_AT.crossover(offspring(count + x - 1), population(p(x)), population(idx), cf);
                        temp_offspring = OperatorMFEA_AT.crossover(temp_offspring, population(idx), population(p(x)), cf);
                        % mutate
                        offspring(count + x - 1) = OperatorMFEA_AT.mutate(offspring(count + x - 1), max([Tasks.Dim]), mum);
                        temp_offspring = OperatorMFEA_AT.mutate(temp_offspring, max([Tasks.Dim]), mum);
                        % variable swap (uniform X)
                        swap_indicator = (rand(1, max([Tasks.Dim])) >= probswap);
                        offspring(count + x - 1).Dec(swap_indicator) = temp_offspring.Dec(swap_indicator);
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

            % Evaluate
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
