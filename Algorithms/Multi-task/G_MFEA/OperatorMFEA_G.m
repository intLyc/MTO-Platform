classdef OperatorMFEA_G < Operator

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function [offspring, calls] = generate(population, Tasks, rmp, mu, mum, transfer)
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

                if (population(p1).skill_factor == population(p2).skill_factor)
                    % crossover
                    population(p1).Trnvec = population(p1).rnvec;
                    population(p2).Trnvec = population(p2).rnvec;
                    offspring(count) = OperatorMFEA_G.crossover(offspring(count), population(p1), population(p2), cf);
                    offspring(count + 1) = OperatorMFEA_G.crossover(offspring(count + 1), population(p2), population(p1), cf);
                    offspring(count).skill_factor = population(p1).skill_factor;
                    offspring(count + 1).skill_factor = population(p2).skill_factor;
                elseif rand < rmp
                    % crossover
                    population(p1).Trnvec = population(p1).rnvec + transfer{population(p1).skill_factor, population(p2).skill_factor};
                    population(p2).Trnvec = population(p2).rnvec + transfer{population(p2).skill_factor, population(p1).skill_factor};
                    offspring(count) = OperatorMFEA_G.crossover(offspring(count), population(p1), population(p2), cf);
                    offspring(count + 1) = OperatorMFEA_G.crossover(offspring(count + 1), population(p2), population(p1), cf);
                    offspring(count).rnvec = offspring(count).rnvec - transfer{population(p1).skill_factor, population(p2).skill_factor};
                    offspring(count + 1).rnvec = offspring(count + 1).rnvec - transfer{population(p2).skill_factor, population(p1).skill_factor};
                    % imitate
                    p = [p1, p2];
                    offspring(count).skill_factor = population(p(randi(2))).skill_factor;
                    offspring(count + 1).skill_factor = population(p(randi(2))).skill_factor;
                else
                    p = [p1, p2];
                    for x = 1:2
                        % mutate
                        offspring(count + x - 1) = OperatorMFEA_G.mutate(population(p(x)), max([Tasks.dims]), mum);
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
            object.rnvec = 0.5 * ((1 + cf) .* p1.Trnvec + (1 - cf) .* p2.Trnvec);
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
