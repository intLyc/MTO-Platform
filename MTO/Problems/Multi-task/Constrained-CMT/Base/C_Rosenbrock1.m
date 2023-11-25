function [Obj, Con] = C_Rosenbrock1(var, M, opt, opt_con)
    % Rosenbrock function
    %   - var: design variable vector
    %   - M: rotation matrix
    %   - opt: shift vector
    %   - opt_con: feasible region shift vector
    dim = length(var);

    % Object
    x = (M * (var - opt(1:dim))')';
    sumx = 0;
    for ii = 1:(dim - 1)
        xi = x(ii);
        xnext = x(ii + 1);
        new = 100 * (xnext - xi^2)^2 + (xi - 1)^2;
        sumx = sumx + new;
    end
    if dim == 1
        sumx = 100 * (x(1) - x(1)^2)^2 + (x(1) - 1)^2;
    end
    Obj = sumx;

    % constraint
    x = 2 * (var - opt_con(1:dim));
    g = sum(x.^2 - 5000 .* cos(0.1 .* pi .* x) - 4000, 2);

    g(g < 0) = 0;
    Con = g;
end
