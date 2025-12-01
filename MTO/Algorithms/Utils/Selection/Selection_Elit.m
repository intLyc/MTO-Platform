function [population, rank] = Selection_Elit(population, offspring, varargin)
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

n = length(varargin);
if n == 0
    Ep = 0;
elseif n == 1
    Ep = varargin{1};
end

N = length(population);
population = [population, offspring];
CVs = sum(max(0, population.Cons), 2);
CVs(CVs < Ep) = 0;
Objs = population.Objs;
[~, rank] = sortrows([CVs, Objs], [1, 2]);
population = population(rank(1:N));
end
