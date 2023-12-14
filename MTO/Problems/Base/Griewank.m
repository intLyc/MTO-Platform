function [Obj, Con] = Griewank(var, M, opt, g)
% GRIEWANK function
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
var = (M * (var - opt)')'; %
sum1 = 0; sum2 = 1;

for i = 1:dim
    sum1 = sum1 + var(i) * var(i);
    sum2 = sum2 * cos(var(i) / (sqrt(i)));
end

Obj = 1 +1/4000 * sum1 - sum2;
Obj = Obj + g;

Con = 0;
end
