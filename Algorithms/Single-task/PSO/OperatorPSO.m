classdef OperatorPSO < Operator

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function [population, calls] = generate(population, Task, w, c1, c2, gbest)
            for i = 1:length(population)
                population(i) = OperatorPSO.velocityUpdate(population(i), gbest, w, c1, c2);
                population(i) = OperatorPSO.positionUpdate(population(i));
                population(i) = OperatorPSO.pbestUpdate(population(i));
            end
            [population, calls] = evaluate(population, Task, 1);
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
            if object.factorial_costs < object.pbestFitness
                object.pbestFitness = object.factorial_costs;
                object.pbest = object.rnvec;
            end
        end
    end
end
