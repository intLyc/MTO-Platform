function [Obj, Con] = Rosenbrock(var, M, opt, g)
% ROSENBROCK function
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
for ii = 1:(D - 1)
    xi = var(:, ii);
    xnext = var(:, ii + 1);
    new = 100 * (xnext - xi.^2).^2 + (xi - 1).^2;
    sum1 = sum1 + new;
end
if D == 1
    sum1 = 100 * (var(:, 1) - var(:, 1).^2).^2 + (var(:, 1) - 1).^2;
end
Obj = sum1;
Obj = Obj + g;

Con = zeros(ps, 1);
end
