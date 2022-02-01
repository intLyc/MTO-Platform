classdef OperatorPSO < Operator
    methods (Static)
        function [population, calls] = generate(callfun, population, Task, w, c1, c2, gbest)
            if isempty(population)
                calls = 0;
                return;
            end
            for i = 1:length(population)
                population(i) = OperatorPSO.velocityUpdate(population(i), gbest, w, c1, c2);
                population(i) = OperatorPSO.positionUpdate(population(i));
                population(i) = OperatorPSO.pbestUpdate(population(i));
            end
            if callfun
                [population, calls] = evaluate(population, Task, 1);
            else
                calls = 0;
            end
        end

        function object = velocityUpdate(object, gbest, w, c1, c2)
            % Velocity update
            len = length(object.velocity);
            object.velocity = w * object.velocity + ...
                c1 * rand(1, len) .* (object.pbest - object.rnvec) + ...
                c2 * rand(1, len) .* (gbest - object.rnvec);
        end

        function object = positionUpdate(object)
            % Position update
            object.rnvec = object.rnvec + object.velocity;
            object.rnvec(object.rnvec > 1) = 1;
            object.rnvec(object.rnvec < 0) = 0;
        end

        function object = pbestUpdate(object)
            % pbest update
            if object.factorial_costs(object.skill_factor) < object.pbestFitness
                object.pbestFitness = object.factorial_costs(object.skill_factor);
                object.pbest = object.rnvec;
            end
        end
    end
end
