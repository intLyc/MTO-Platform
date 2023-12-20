function [Obj, Con] = C_Rosenbrock1(var, M, opt, opt_con)
% Rosenbrock function
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
for ii = 1:(D - 1)
    xi = x(:, ii);
    xnext = x(:, ii + 1);
    new = 100 * (xnext - xi.^2).^2 + (xi - 1).^2;
    sum1 = sum1 + new;
end
if D == 1
    sum1 = 100 * (x(:, 1) - x(:, 1).^2).^2 + (x(:, 1) - 1).^2;
end
Obj = sum1;

% constraint
x = 2 * (var - repmat(opt_con(1:D), ps, 1));
g = sum(x.^2 - 5000 .* cos(0.1 .* pi .* x) - 4000, 2);

g(g < 0) = 0;
Con = g;
end
