classdef Chromosome_MFDE
    properties
        rnvec;
        factorial_costs;
        factorial_ranks;
        scalar_fitness;
        skill_factor;
    end

    methods

        function object = initialize(object, D)
            object.rnvec = rand(1, D);
        end

        function [object, calls] = evaluate(object, Tasks, p_il, no_of_tasks, options)
            if object.skill_factor == 0
                calls = 0;
                for i = 1:no_of_tasks
                    [object.factorial_costs(i), object.rnvec, funcCount] = fnceval(Tasks(i), object.rnvec, p_il, options);
                    calls = calls + funcCount;
                end
            else
                object.factorial_costs(1:no_of_tasks) = inf;
                [object.factorial_costs(object.skill_factor), object.rnvec, funcCount] = fnceval(Tasks(object.skill_factor), object.rnvec, p_il, options);
                calls = funcCount;
            end
        end
    end
end
