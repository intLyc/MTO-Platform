function population = Initialization_MF(Algo, Prob, Individual_Class)
    %% Multifactorial - Initialize and evaluate the population
    % Input: Algorithm, Problem, Individual_Class
    % Output: population

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    % Generate initial populaiton
    for i = 1:Prob.N * Prob.T
        population(i) = Individual_Class();
        population(i).Dec = rand(1, max(Prob.D));
    end
    for t = 1:Prob.T
        population = Algo.Evaluation(population, Prob, t);
        for i = 1:length(population)
            population(i).MFObj(t) = population(i).Obj;
            population(i).MFCV(t) = population(i).CV;
        end
    end

    % Calculate facotrial ranks
    for t = 1:Prob.T
        for i = 1:length(population)
            Obj(i) = population(i).MFObj(t);
            CV(i) = population(i).MFCV(t);
        end
        [~, rank] = sortrows([CV', Obj'], [1, 2]);
        for i = 1:length(population)
            population(rank(i)).MFRank(t) = i;
        end
    end

    % Calculate skill factor
    for i = 1:length(population)
        min_rank = min(population(i).MFRank);
        min_idx = find(population(i).MFRank == min_rank);
        population(i).MFFactor = min_idx(randi(length(min_idx)));
        population(i).Obj = population(i).MFObj(population(i).MFFactor);
        population(i).CV = population(i).MFCV(population(i).MFFactor);
    end
end
