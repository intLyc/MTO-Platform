classdef Chromosome_DE
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

        function [object, calls] = evaluate_SOO(object, Task, p_il, options)
            [object.factorial_costs, object.rnvec, funcCount] = fnceval(Task, object.rnvec, p_il, options);
            calls = funcCount;
        end
    end
end
