function [obj, con] = Rastrigin2(var, M, opt, opt_con)
    % Rastrigin function
    %   - var: design variable vector
    %   - M: rotation matrix
    %   - opt: shift vector
    %   - opt_con: feasible region shift vector
    dim = length(var);

    % object
    x = (M * (var - opt(1:dim))')';
    obj = 10 * dim;
    for i = 1:dim
        obj = obj + (x(i)^2 - 10 * (cos(2 * pi * x(i))));
    end

    % constraint
    x = 2 * (var - opt_con(1:dim));
    g = sum(x.^2, 2) - 100 * dim;
    h = 0;

    g(g < 0) = 0;
    h = abs(h) - 1e-4;
    h(h < 0) = 0;
    con = sum(g) + sum(h);
end
