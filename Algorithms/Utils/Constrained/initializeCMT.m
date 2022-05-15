function [population, calls, bestobj, bestCV, bestX] = initializeCMT(Individual_class, sub_pop, Tasks, dims)
    %% Constrained Multi-task - Initialize and evaluate the population
    % Input: Individual_class, sub_pop, Tasks, dims
    % Output: population, calls (function calls number), bestobj, bestCV, bestX

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    calls = 0;
    population = {};
    for t = 1:length(Tasks)
        for i = 1:sub_pop
            population{t}(i) = Individual_class();
            population{t}(i).rnvec = rand(1, dims(t));
        end
        [population{t}, cal] = evaluate(population{t}, Tasks(t), 1);
        calls = calls + cal;

        [bestobj(t), bestCV(t), best_idx] = min_FP([population{t}.factorial_costs], [population{t}.constraint_violation]);
        bestX{t} = population{t}(best_idx);
    end
end
