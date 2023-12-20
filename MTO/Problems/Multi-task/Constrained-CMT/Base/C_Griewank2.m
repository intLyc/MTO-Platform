function [Obj, Con] = C_Griewank2(var, M, opt, opt_con)
% GRIEWANK function
%   - var: design variable vector
%   - M: rotation matrix
%   - opt: shift vector
%   - opt_con: feasible region shift vector

[ps, D] = size(var);

if size(M, 1) == 1
    M = M * eye(D);
end
if size(opt, 2) == 1
    opt = opt * ones(1, D);
end

x = (M(1:D, 1:D) * (var - repmat(opt(1:D), ps, 1))')';

sum1 = zeros(ps, 1);
sum2 = ones(ps, 1);

for i = 1:D
    sum1 = sum1 + x(:, i) .* x(:, i);
    sum2 = sum2 .* cos(x(:, i) ./ (sqrt(i)));
end

Obj = 1 +1/4000 * sum1 - sum2;

% constraint
x = var - repmat(opt_con(1:D), ps, 1);
g = sum(x.^2, 2) - 100 * D;

g(g < 0) = 0;
Con = g;
end
