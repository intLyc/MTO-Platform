function population = Selection_MF(population, offspring, Prob)
%% Elite selection based on scalar fitness
% Input: population (old), offspring,
% Output: population (new)

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

pool = [population, offspring];
Factors = [pool.MFFactor];
Objs = pool.Objs;
CVs = pool.CVs;

NextIdx = [];
for t = 1:Prob.T
    idx = find(Factors == t);
    [~, rank] = sortrows([CVs(idx), Objs(idx, :)]);
    count = min(length(rank), Prob.N);
    NextIdx = [NextIdx, idx(rank(1:count))];
end
population = pool(NextIdx);

%% Original Multifactorial Selection
% for t = 1:Prob.T
%     for i = 1:length(population)
%         Obj(i, 1) = population(i).MFObj(t);
%         CV(i, 1) = population(i).MFCV(t);
%     end
%     [~, rank] = sortrows([CV, Obj], [1, 2]);
%     for i = 1:length(population)
%         population(rank(i)).MFRank(t) = i;
%     end
% end
%
% for i = 1:length(population)
%     fit(i) = 1 / min([population(i).MFRank]);
% end
%
% [~, rank] = sort(fit, 'descend');
% population = population(rank(1:Prob.N * Prob.T));
end
