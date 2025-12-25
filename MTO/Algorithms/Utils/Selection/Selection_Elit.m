function [population, rank] = Selection_Elit(population, offspring, Ep)
%% Elite selection
% Input: population (old), offspring, epsilon (constraint)
% Output: population (new)

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

if nargin < 3
    Ep = 0;
end

N = length(population);
pool = [population, offspring];

AllCV = pool.CVs;
AllObj = pool.Objs;

AllCV(AllCV <= Ep) = 0;

[~, rank] = sortrows([AllCV, AllObj], [1, 2]);

rank = rank(1:N);
population = pool(rank);
end
