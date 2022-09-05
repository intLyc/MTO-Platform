function [population, calls, bestDec, bestObj, bestCV] = initializeMT(Individual_class, sub_pop, Tasks, Dim)
    %% Multi-task - Initialize and evaluate the population
    % Input: Individual_class, sub_pop, Tasks, Dim
    % Output: population, calls (function calls number), bestDec, bestObj, bestCV

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    calls = 0;
    population = {};
    for t = 1:length(Tasks)
        [population{t}, cal, bestDec{t}, bestObj(t), bestCV(t)] = initialize(Individual_class, sub_pop, Tasks(t), Dim(t));
        calls = calls + cal;
    end
end
