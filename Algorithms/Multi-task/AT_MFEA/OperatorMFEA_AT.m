classdef OperatorMFEA_AT < Operator

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function [offspring, calls] = generate(callfun, population, Tasks, rmp, mu, mum, probswap, mu_tasks, Sigma_tasks)
            Individual_class = class(population(1));
            indorder = randperm(length(population));
            count = 1;
            for i = 1:ceil(length(population) / 2)
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
                    % crossover
                    offspring(count) = OperatorGA.crossover(offspring(count), population(p1), population(p2), cf);
                    offspring(count + 1) = OperatorGA.crossover(offspring(count + 1), population(p2), population(p1), cf);
                    % mutate
                    offspring(count) = OperatorGA.mutate(offspring(count), max([Tasks.dims]), mum);
                    offspring(count + 1) = OperatorGA.mutate(offspring(count + 1), max([Tasks.dims]), mum);
                    % variable swap (uniform X)
                    swap_indicator = (rand(1, max([Tasks.dims])) >= probswap);
                    temp = offspring(count + 1).rnvec(swap_indicator);
                    offspring(count + 1).rnvec(swap_indicator) = offspring(count).rnvec(swap_indicator);
                    offspring(count).rnvec(swap_indicator) = temp;
                    % imitate
                    p = [p1, p2];
                    offspring(count).skill_factor = population(p(randi(2))).skill_factor;
                    offspring(count + 1).skill_factor = population(p(randi(2))).skill_factor;
                elseif rand < rmp
                    % affine transformation
                    pm1 = population(p1);
                    pm2 = population(p2);
                    pm1.rnvec = AT_Transfer(population(p1).rnvec, mu_tasks{population(p1).skill_factor}, Sigma_tasks{population(p1).skill_factor}, mu_tasks{population(p2).skill_factor}, Sigma_tasks{population(p2).skill_factor});
                    pm2.rnvec = AT_Transfer(population(p2).rnvec, mu_tasks{population(p2).skill_factor}, Sigma_tasks{population(p2).skill_factor}, mu_tasks{population(p1).skill_factor}, Sigma_tasks{population(p1).skill_factor});
                    % crossover
                    offspring(count) = OperatorGA.crossover(offspring(count), pm1, population(p2), cf);
                    offspring(count + 1) = OperatorGA.crossover(offspring(count + 1), population(p1), pm2, cf);
                    % mutate
                    offspring(count) = OperatorGA.mutate(offspring(count), max([Tasks.dims]), mum);
                    offspring(count + 1) = OperatorGA.mutate(offspring(count + 1), max([Tasks.dims]), mum);
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
                        offspring(count + x - 1) = OperatorGA.crossover(offspring(count + x - 1), population(p(x)), population(idx), cf);
                        temp_offspring = OperatorGA.crossover(temp_offspring, population(idx), population(p(x)), cf);
                        % mutate
                        offspring(count + x - 1) = OperatorGA.mutate(offspring(count + x - 1), max([Tasks.dims]), mum);
                        temp_offspring = OperatorGA.mutate(temp_offspring, max([Tasks.dims]), mum);
                        % variable swap (uniform X)
                        swap_indicator = (rand(1, max([Tasks.dims])) >= probswap);
                        offspring(count + x - 1).rnvec(swap_indicator) = temp_offspring.rnvec(swap_indicator);
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
