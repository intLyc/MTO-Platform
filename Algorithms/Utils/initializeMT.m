function [population, calls, bestobj, bestX] = initializeMT(Individual_class, sub_pop, Tasks, dims)
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
        [population{t}, cal, bestobj(t), bestX{t}] = initialize(Individual_class, sub_pop, Tasks(t), dims(t));
        calls = calls + cal;
    end
end
