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

TotalN = Prob.N * Prob.T;
maxD = max(Prob.D);

% Generate Random Population
population(1, TotalN) = Individual_Class();
PopDec = rand(TotalN, maxD); % Decision variables in [0,1]
DecCell = num2cell(PopDec, 2);
[population.Dec] = deal(DecCell{:});

InitVec = inf(1, Prob.T);
InitCell = repmat({InitVec}, 1, TotalN);
[population.MFObj] = deal(InitCell{:});
[population.MFCV] = deal(InitCell{:});

for t = 1:Prob.T
    % Evaluate Initial Population
    population = Algo.Evaluation(population, Prob, t);

    Objs = population.Objs;
    CVs = population.CVs;
    % Store MFObj and MFCV for single-objective problems
    CurrentObj = Objs(:, 1);
    CurrentCV = CVs;

    for i = 1:TotalN
        population(i).MFObj(t) = CurrentObj(i);
        population(i).MFCV(t) = CurrentCV(i);
    end
end

AllMFObj = reshape([population.MFObj], Prob.T, TotalN)';
AllMFCV = reshape([population.MFCV], Prob.T, TotalN)';

MatRank = zeros(TotalN, Prob.T);
for t = 1:Prob.T
    colObj = AllMFObj(:, t);
    colCV = AllMFCV(:, t);

    % sortrows: first by CV, then by Obj
    [~, sortedIdx] = sortrows([colCV, colObj]);

    % Assign ranks
    ranks = zeros(TotalN, 1);
    ranks(sortedIdx) = 1:TotalN;
    MatRank(:, t) = ranks;
end

RankCell = num2cell(MatRank, 2);
[population.MFRank] = deal(RankCell{:});

% Assign skill factors based on ranks
record = zeros(1, Prob.T);
FinalFactor = zeros(TotalN, 1);
for i = 1:TotalN
    [~, idx] = sort(MatRank(i, :));
    j = 1;
    factor = idx(j);
    while record(factor) >= Prob.N && j < Prob.T
        j = j + 1;
        factor = idx(j);
    end
    record(factor) = record(factor) + 1;
    FinalFactor(i) = factor;
end

FactorCell = num2cell(FinalFactor);
[population.MFFactor] = deal(FactorCell{:});
for i = 1:TotalN
    f = FinalFactor(i);
    population(i).Obj = population(i).MFObj(f);
    population(i).CV = population(i).MFCV(f);
end
end
