function [population, replace] = Selection_Tournament(population, offspring, Ep)
%% Tournament selection
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

PopObj = population.Objs;
PopCV = population.CVs;
OffObj = offspring.Objs;
OffCV = offspring.CVs;

% Apply epsilon constraint handling
PopCV(PopCV <= Ep) = 0;
OffCV(OffCV <= Ep) = 0;

% Selection
case1 = (OffCV == 0) & (PopCV > 0);
case2 = (PopCV > 0) & (OffCV > 0) & (OffCV <= PopCV);
case3 = (PopCV == 0) & (OffCV == 0) & (OffObj <= PopObj);
replace = case1 | case2 | case3;
population(replace) = offspring(replace);
end
