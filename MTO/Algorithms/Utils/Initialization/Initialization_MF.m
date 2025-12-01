function population = Initialization_MF(Algo, Prob, Individual_Class)
%% Multifactorial - Initialize and evaluate the population
% Input: Algorithm, Problem, Individual_Class
% Output: population

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
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
        Obj(i, 1) = population(i).MFObj(t);
        CV(i, 1) = population(i).MFCV(t);
    end
    [~, rank] = sortrows([CV, Obj], [1, 2]);
    for i = 1:length(population)
        population(rank(i)).MFRank(t) = i;
    end
end

% Calculate skill factor
record = zeros(1, Prob.T);
for i = 1:Prob.N * Prob.T
    [~, idx] = sort(population(i).MFRank);
    j = 1; factor = idx(j);
    % Generate Uniform Skill Factor
    while record(factor) >= Prob.N
        j = j + 1; factor = idx(j);
    end
    record(factor) = record(factor) + 1;
    population(i).MFFactor = factor;
    population(i).Obj = population(i).MFObj(population(i).MFFactor);
    population(i).CV = population(i).MFCV(population(i).MFFactor);
end
end
