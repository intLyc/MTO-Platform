function [obj, con] = Griewank1(var, M, opt, opt_con)
    % GRIEWANK function
    %   - var: design variable vector
    %   - M: rotation matrix
    %   - opt: shift vector
    %   - opt_con: feasible region shift vector
    dim = length(var);

    % object
    x = (M * (var - opt(1:dim))')';
    sum1 = 0; sum2 = 1;
    for i = 1:dim
        sum1 = sum1 + x(i) * x(i);
        sum2 = sum2 * cos(x(i) / (sqrt(i)));
    end
    obj = 1 + 1/4000 * sum1 - sum2;

    % constraint
    x = var - opt_con(1:dim);
    g = sum(x.^2 - 5000 .* cos(0.1 .* pi .* x) - 4000, 2);
    h = 0;

    g(g < 0) = 0;
    h = abs(h) - 1e-4;
    h(h < 0) = 0;
    con = sum(g) + sum(h);
end
