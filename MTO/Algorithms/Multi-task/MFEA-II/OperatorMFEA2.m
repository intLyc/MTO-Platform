classdef OperatorMFEA2 < Operator

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function [offspring, calls] = generate(population, Tasks, RMP, mu, mum, probswap)
            Individual_class = class(population(1));
            indorder = randperm(length(population));
            count = 1;
            for i = 1:ceil(length(population) / 2)
                p1 = indorder(i);
                p2 = indorder(i + fix(length(population) / 2));
                rmp = RMP(population(p1).skill_factor, population(p2).skill_factor);
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

                if (population(p1).skill_factor == population(p2).skill_factor) || rand < rmp
                    % crossover
                    offspring(count) = OperatorMFEA2.crossover(offspring(count), population(p1), population(p2), cf);
                    offspring(count + 1) = OperatorMFEA2.crossover(offspring(count + 1), population(p2), population(p1), cf);
                    % mutate
                    offspring(count) = OperatorMFEA2.mutate(offspring(count), max([Tasks.Dim]), mum);
                    offspring(count + 1) = OperatorMFEA2.mutate(offspring(count + 1), max([Tasks.Dim]), mum);
                    % imitate
                    p = [p1, p2];
                    offspring(count).skill_factor = population(p(randi(2))).skill_factor;
                    offspring(count + 1).skill_factor = population(p(randi(2))).skill_factor;

                    if population(p1).skill_factor == population(p2).skill_factor
                        % variable swap (uniform X)
                        swap_indicator = (rand(1, max([Tasks.Dim])) >= probswap);
                        temp = offspring(count + 1).Dec(swap_indicator);
                        offspring(count + 1).Dec(swap_indicator) = offspring(count).Dec(swap_indicator);
                        offspring(count).Dec(swap_indicator) = temp;
                    end
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
                        offspring(count + x - 1) = OperatorMFEA2.crossover(offspring(count + x - 1), population(p(x)), population(idx), cf);
                        temp_offspring = OperatorMFEA2.crossover(temp_offspring, population(idx), population(p(x)), cf);
                        % mutate
                        offspring(count + x - 1) = OperatorMFEA2.mutate(offspring(count + x - 1), max([Tasks.Dim]), mum);
                        temp_offspring = OperatorMFEA2.mutate(temp_offspring, max([Tasks.Dim]), mum);
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
