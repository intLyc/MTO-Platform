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

[ps, D] = size(var);

if size(M, 1) == 1
    M = M * eye(D);
end
if size(opt, 2) == 1
    opt = opt * ones(1, D);
end

var = (M(1:D, 1:D) * (var - repmat(opt(1:D), ps, 1))')';

sum1 = zeros(ps, 1);
sum2 = ones(ps, 1);

for i = 1:D
    sum1 = sum1 + var(:, i) .* var(:, i);
    sum2 = sum2 .* cos(var(:, i) ./ (sqrt(i)));
end

Obj = 1 +1/4000 * sum1 - sum2;
Obj = Obj + g;

Con = zeros(ps, 1);
end
