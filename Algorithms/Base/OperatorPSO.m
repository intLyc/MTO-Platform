classdef OperatorPSO
    methods (Static)
        function [population, calls] = generateMF(callfun, population, Tasks, rmp, w, c1, c2, c3, gbest)
            Individual_class = class(population(1));
            for i = 1:length(population)
                population(i) = OperatorPSO.velocityUpdate(population(i), gbest, rmp, w, c1, c2, c3, length(Tasks));
                population(i) = OperatorPSO.positionUpdate(population(i));
                population(i) = OperatorPSO.pbestUpdate(population(i));
            end
            if callfun
                population_temp = feval(Individual_class).empty();
                calls = 0;
                for t = 1:length(Tasks)
                    population_t = population([population.skill_factor] == t);
                    [population_t, cal] = evaluate(population_t, Tasks(t), t);
                    population_temp = [population_temp, population_t];
                    calls = calls + cal;
                end
                population = population_temp;
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
