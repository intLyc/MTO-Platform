function [Obj, Con] = C_Ackley1(var, M, opt, opt_con)
% Ackley function
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
sum2 = zeros(ps, 1);

for i = 1:D
    sum1 = sum1 + x(:, i) .* x(:, i);
    sum2 = sum2 + cos(2 * pi .* x(:, i));
end

avgsum1 = sum1 ./ D;
avgsum2 = sum2 ./ D;

Obj = -20 * exp(-0.2 .* sqrt(avgsum1)) - exp(avgsum2) + 20 + exp(1);

% constraint
x = 2 * (var - repmat(opt_con(1:D), ps, 1));
g = sum(x.^2 - 5000 .* cos(0.1 .* pi .* x) - 4000, 2);

g(g < 0) = 0;
Con = g;
end
