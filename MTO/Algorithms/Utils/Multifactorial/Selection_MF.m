function population = Selection_MF(population, offspring, Prob)
%% Elite selection based on scalar fitness
% Input: population (old), offspring,
% Output: population (new)

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
%--------------------------------------------------------------------------

population = [population, offspring];

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

for i = 1:length(population)
    fit(i) = 1 / min([population(i).MFRank]);
end

[~, rank] = sort(fit, 'descend');
population = population(rank(1:Prob.N * Prob.T));
end
