function [obj, con] = Rosenbrock2(var, M, opt, opt_con)
    % Rosenbrock function
    %   - var: design variable vector
    %   - M: rotation matrix
    %   - opt: shift vector
    %   - opt_con: feasible region shift vector
    dim = length(var);

    % object
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
    obj = sumx;

    % constraint
    x = 2 * (var - opt_con(1:dim));
    g = sum(x.^2, 2) - 100 * dim;
    h = 0;

    g(g < 0) = 0;
    h = abs(h) - 1e-4;
    h(h < 0) = 0;
    con = sum(g) + sum(h);
end
