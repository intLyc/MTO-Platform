function [obj, cv] = Schwefel2(var, M, opt, opt_con)
    % Schwefel function
    %   - var: design variable vector
    %   - M: rotation matrix
    %   - opt: shift vector
    %   - opt_con: feasible region shift vector
    dim = length(var);

    % object
    x = (M * (var - opt(1:dim))')';
    sumx = 0;
    for i = 1:dim
        sumx = sumx + x(i) * sin(sqrt(abs(x(i))));
    end
    obj = 418.9829 * dim - sumx;

    % constraint
    x = 0.2 * (var - opt_con(1:dim));
    g = sum(x.^2, 2) - 100 * dim;

    g(g < 0) = 0;
    cv = g;
end
