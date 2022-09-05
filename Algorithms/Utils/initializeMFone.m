function [population, calls, bestDec, bestObj, bestCV] = initializeMFone(Individual_class, pop_size, Tasks, dim)
    %% Multifactorial only evaluate one times - Initialize and evaluate the population
    % Input: Individual_class, pop_size, Tasks, dim
    % Output: population, calls (function calls number), bestDec, bestObj, bestCV

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    sf = 1;
    for i = 1:pop_size
        population(i) = Individual_class();
        population(i).Dec = rand(1, dim);
        population(i).skill_factor = sf;
        sf = mod(sf, length(Tasks)) + 1;
        population(i).Obj = inf(1, length(Tasks));
        population(i).CV = inf(1, length(Tasks));
    end

    temp = Individual_class.empty();
    calls = 0;
    for t = 1:length(Tasks)
        temp_t = population([population.skill_factor] == t);
        [temp_t, cal] = evaluate(temp_t, Tasks(t), t);

        for i = 1:length(temp_t)
            Obj(i) = temp_t(i).Obj(t);
            CV(i) = temp_t(i).CV(t);
        end
        [~, ~, min_idx] = min_FP(Obj, CV);
        bestObj(t) = temp_t(min_idx).Obj(t);
        bestCV(t) = temp_t(min_idx).CV(t);
        bestDec{t} = temp_t(min_idx).Dec;

        temp = [temp, temp_t];
        calls = calls + cal;
    end
    population = temp;
end
