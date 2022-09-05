function [population, calls, bestObj, bestCV, bestDec] = initializeECHT(Individual_class, pop_size, Task, task_num)

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    calls = 0;
    population = {};

    for i = 1:pop_size
        pop_temp(i) = Individual_class();
        pop_temp(i).Dec = rand(1, Task.Dim);
    end
    [pop_temp, cal] = evaluate(pop_temp, Task, 1);
    calls = calls + cal;

    [bestObj_temp, bestCV_temp, best_idx] = min_FP([pop_temp.Obj], [pop_temp.CV]);
    bestDec_temp = pop_temp(best_idx).Dec;

    for t = 1:task_num
        population{t} = pop_temp;
        bestObj(t) = bestObj_temp;
        bestCV(t) = bestCV_temp;
        bestDec{t} = bestDec_temp;
    end
end
