classdef OperatorMFPSO < Operator

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function [population, calls] = generate(callfun, population, Tasks, rmp, w, c1, c2, c3, gbest)
            if isempty(population)
                calls = 0;
                return;
            end
            Individual_class = class(population(1));
            for i = 1:length(population)
                population(i) = OperatorMFPSO.velocityUpdateMF(population(i), gbest, rmp, w, c1, c2, c3, length(Tasks));
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

        function object = velocityUpdateMF(object, gbest, rmp, w, c1, c2, c3, tasks_num)
            % Multifactorial - Velocity update
            len = length(object.velocity);
            if rand < rmp
                % random select other task
                other_task = randi(tasks_num);
                while other_task == object.skill_factor
                    other_task = randi(tasks_num);
                end

                object.velocity = w * object.velocity + ...
                    c1 * rand(1, len) .* (object.pbest - object.rnvec) + ...
                    c2 * rand(1, len) .* (gbest{object.skill_factor} - object.rnvec) + ...
                    c3 * rand(1, len) .* (gbest{other_task} - object.rnvec);
            else
                object.velocity = w * object.velocity + ...
                    c1 * rand(1, len) .* (object.pbest - object.rnvec) + ...
                    c2 * rand(1, len) .* (gbest{object.skill_factor} - object.rnvec);
            end
        end
    end
end
