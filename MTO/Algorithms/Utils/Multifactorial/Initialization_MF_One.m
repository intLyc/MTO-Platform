function population = Initialization_MF_One(Algo, Prob, Individual_Class)
    %% Multifactorial - Initialize and evaluate the population One Times
    % Input: Algorithm, Problem, Individual_Class
    % Output: population

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    % Generate initial population
    population = Individual_Class.empty();
    for t = 1:Prob.T
        for i = 1:Prob.N
            pop_t(i) = Individual_Class();
            pop_t(i).Dec = rand(1, max(Prob.D));
        end
        pop_t = Algo.Evaluation(pop_t, Prob, t);
        for i = 1:length(pop_t)
            pop_t(i).MFFactor = t;
            pop_t(i).MFObj = inf(1, Prob.T);
            pop_t(i).MFCV = inf(1, Prob.T);
            pop_t(i).MFObj(t) = pop_t(i).Obj;
            pop_t(i).MFCV(t) = pop_t(i).CV;
        end
        population = [population, pop_t];
    end
end
