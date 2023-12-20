function [Obj, Con] = C_Weierstrass3(var, M, opt, opt_con)
% WEIERSTASS function
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

a = 0.5;
b = 3;
kmax = 20;
Obj = zeros(ps, 1);

for i = 1:D
    for k = 0:kmax
        Obj = Obj + a^k * cos(2 * pi * b^k * (x(:, i) + 0.5));
    end
end

for k = 0:kmax
    Obj = Obj - D * a^k * cos(2 * pi * b^k * 0.5);
end

% constraint
x = 200 * (var - repmat(opt_con(1:D), ps, 1));
g1 = -sum(abs(x), 2) + 12 * D;
g2 = sum(x.^2, 2) - 500 * D;
g = [g1, g2];

g(g < 0) = 0;
Con = g;
end
