classdef OperatorEMEA_GA < Operator

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function [offspring, calls] = generate(population, mu, mum)
            Individual_class = class(population(1));
            indorder = randperm(length(population));
            count = 1;
            for i = 1:ceil(length(population) / 2)
                p1 = indorder(i);
                p2 = indorder(i + fix(length(population) / 2));
                offspring(count) = feval(Individual_class);
                offspring(count + 1) = feval(Individual_class);
                u = rand(1, length(population(1).Dec));
                cf = zeros(1, length(population(1).Dec));
                cf(u <= 0.5) = (2 * u(u <= 0.5)).^(1 / (mu + 1));
                cf(u > 0.5) = (2 * (1 - u(u > 0.5))).^(-1 / (mu + 1));

                offspring(count) = OperatorEMEA_GA.crossover(offspring(count), population(p1), population(p2), cf);
                offspring(count + 1) = OperatorEMEA_GA.crossover(offspring(count + 1), population(p2), population(p1), cf);

                offspring(count) = OperatorEMEA_GA.mutate(offspring(count), length(population(1).Dec), mum);
                offspring(count + 1) = OperatorEMEA_GA.mutate(offspring(count + 1), length(population(1).Dec), mum);

                for x = count:count + 1
                    offspring(x).Dec(offspring(x).Dec > 1) = 1;
                    offspring(x).Dec(offspring(x).Dec < 0) = 0;
                end
                count = count + 2;
            end
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
