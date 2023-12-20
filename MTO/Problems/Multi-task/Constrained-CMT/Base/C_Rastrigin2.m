function [Obj, Con] = C_Rastrigin2(var, M, opt, opt_con)
% Rastrigin function
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

Obj = repmat(10 * D, ps, 1);

for i = 1:D
    Obj = Obj + (x(:, i).^2 - 10 * (cos(2 * pi * x(:, i))));
end

% constraint
x = 2 * (var - repmat(opt_con(1:D), ps, 1));
g = sum(x.^2, 2) - 100 * D;

g(g < 0) = 0;
Con = g;
end
