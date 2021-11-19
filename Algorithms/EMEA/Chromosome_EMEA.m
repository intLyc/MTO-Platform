classdef Chromosome_EMEA
    properties
        rnvec;
        fitness;
    end

    methods

        function object = initialize(object, D)
            object.rnvec = rand(1, D);
        end

        function [object, calls] = evaluate(object, Task)
            [object.fitness, object.rnvec, funcCount] = fnceval(Task, object.rnvec, 0, 0);
            calls = funcCount;
        end

        % SBX
        function object = crossover(object, p1, p2, cf)
            object.rnvec = 0.5 * ((1 + cf) .* p1.rnvec + (1 - cf) .* p2.rnvec);
            object.rnvec(object.rnvec > 1) = 1;
            object.rnvec(object.rnvec < 0) = 0;
        end

        % polynomial mutation
        function object = mutate(object, p, dim, mum)
            rnvec_temp = p.rnvec;
            for i = 1:dim
                if rand(1) < 1 / dim
                    u = rand(1);
                    if u <= 0.5
                        del = (2 * u)^(1 / (1 + mum)) - 1;
                        rnvec_temp(i) = p.rnvec(i) + del * (p.rnvec(i));
                    else
                        del = 1 - (2 * (1 - u))^(1 / (1 + mum));
                        rnvec_temp(i) = p.rnvec(i) + del * (1 - p.rnvec(i));
                    end
                end
            end
            object.rnvec = rnvec_temp;
        end
    end
end
