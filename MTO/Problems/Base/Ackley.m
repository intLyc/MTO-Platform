function [Obj, Con] = Ackley(var, M, opt, g)
% Ackley function
%   - var: design variable vector
%   - M: rotation matrix
%   - opt: shift vector
%   - g: Objective value move

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

dim = length(var);
var = (M * (var - opt)')';
sum1 = 0; sum2 = 0;

for i = 1:dim
    sum1 = sum1 + var(i) * var(i);
    sum2 = sum2 + cos(2 * pi * var(i));
end

avgsum1 = sum1 / dim;
avgsum2 = sum2 / dim;

Obj = -20 * exp(-0.2 * sqrt(avgsum1)) - exp(avgsum2) + 20 + exp(1);
Obj = Obj + g;

Con = 0;
end
