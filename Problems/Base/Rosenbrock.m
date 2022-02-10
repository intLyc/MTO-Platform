function [obj, con] = Rosenbrock(x, M, opt, g)
    % ROSENBROCK function
    %   - var: design variable vector
    %   - M: rotation matrix
    %   - opt: shift vector
    %   - g: objective value move
    con = 0;
    var = x;
    dim = length(var);
    var = (M * (var - opt)')';
    sum = 0;
    for ii = 1:(dim - 1)
        xi = var(ii);
        xnext = var(ii + 1);
        new = 100 * (xnext - xi^2)^2 + (xi - 1)^2;
        sum = sum + new;
    end
    if dim == 1
        sum = 100 * (var(1) - var(1)^2)^2 + (var(1) - 1)^2;
    end
    obj = sum;
    obj = obj + g;
end
