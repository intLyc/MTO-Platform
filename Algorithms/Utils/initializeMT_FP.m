function [population, calls, bestobj, bestCV, bestX] = initializeMT_FP(Individual_class, sub_pop, Tasks, dims)
    %% Multi-task - Initialize and evaluate the population
    % Input: Individual_class, sub_pop, Tasks, dims
    % Output: population, calls (function calls number), bestobj, bestX

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

        bestCV(t) = min([population{t}.constraint_violation]);
        bestcv_idx = find([population{t}.constraint_violation] == bestCV(t));
        [bestobj(t), idx] = min([population{t}(bestcv_idx).factorial_costs]);
        bestX{t} = population{t}(bestcv_idx(idx)).rnvec;
    end
end
