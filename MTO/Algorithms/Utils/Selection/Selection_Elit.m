function [population, rank] = Selection_Elit(population, offspring, varargin)
%% Elite selection
% Input: population (old), offspring, epsilon (constraint)
% Output: population (new)

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
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
CV = population.CVs; CV(CV < Ep) = 0;
Obj = population.Objs;
[~, rank] = sortrows([CV, Obj], [1, 2]);
population = population(rank(1:N));
end
