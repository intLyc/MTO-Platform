function [population, replace] = Selection_Tournament(population, offspring, varargin)
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

n = length(varargin);
if n == 0
    Ep = 0;
elseif n == 1
    Ep = varargin{1};
end

popCVs = sum(max(0, population.Cons), 2);
offCVs = sum(max(0, offspring.Cons), 2);

replace_cv = popCVs > offCVs & ...
    popCVs > Ep & offCVs > Ep;
equal_cv = popCVs <= Ep & offCVs <= Ep;
replace_f = population.Objs > offspring.Objs;
replace = (equal_cv & replace_f) | replace_cv;
replace = replace';
population(replace) = offspring(replace);
end
