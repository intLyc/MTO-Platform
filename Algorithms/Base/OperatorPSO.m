classdef OperatorPSO
    methods (Static)
        function [offspring, calls] = generateMF(callfun, population, Tasks, rmp, w, c1, c2, c3, no_improve, generation, gbest)
            Individual_class = class(population(1));
            for i = 1:length(population)
                offspring(i) = population(i);
                offspring(i).factorial_costs = inf(1, length(Tasks));

                if ~mod(generation, 10) && no_improve >= 20
                    big = 1000;
                    offspring(i) = OperatorPSO.velocityUpdate(offspring(i), gbest, rmp, big, big, big, big, length(Tasks));
                else
                    offspring(i) = OperatorPSO.velocityUpdate(offspring(i), gbest, rmp, w, c1, c2, c3, length(Tasks));
                end
                offspring(i) = OperatorPSO.positionUpdate(offspring(i));
                offspring(i) = OperatorPSO.pbestUpdate(offspring(i));
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

        % velocity update
        function object = velocityUpdate(object, gbest, rmp, w, c1, c2, c3, tasks_num)
            len = length(object.velocity);
            if rand < rmp
                object.velocity = w * object.velocity + ...
                    c1 * rand(1, len) .* (object.pbest - object.rnvec) + ...
                    c2 * rand(1, len) .* (gbest{object.skill_factor} - object.rnvec) + ...
                    c3 * rand(1, len) .* (gbest{randi(tasks_num)} - object.rnvec);
            else
                object.velocity = w * object.velocity + ...
                    c1 * rand(1, len) .* (object.pbest - object.rnvec) + ...
                    c2 * rand(1, len) .* (gbest{object.skill_factor} - object.rnvec);
            end
        end

        % position update
        function object = positionUpdate(object)
            object.rnvec = object.rnvec + object.velocity;
            object.rnvec(object.rnvec > 1) = 1;
            object.rnvec(object.rnvec < 0) = 0;
        end

        % pbest update
        function object = pbestUpdate(object)
            if object.factorial_costs(object.skill_factor) < object.pbestFitness
                object.pbestFitness = object.factorial_costs(object.skill_factor);
                object.pbest = object.rnvec;
            end
        end
    end
end
