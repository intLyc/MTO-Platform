function [obj, con] = Ackley1(var, M, opt, opt_con)
    % Ackley function
    %   - var: design variable vector
    %   - M: rotation matrix
    %   - opt: shift vector
    %   - opt_con: feasible region shift vector
    dim = length(var);

    % object
    x = (M * (var - opt(1:dim))')';
    sum1 = 0; sum2 = 0;
    for i = 1:dim
        sum1 = sum1 + x(i) * x(i);
        sum2 = sum2 + cos(2 * pi * x(i));
    end
    avgsum1 = sum1 / dim;
    avgsum2 = sum2 / dim;
    obj = -20 * exp(-0.2 * sqrt(avgsum1)) - exp(avgsum2) + 20 + exp(1);
    
    % constraint
    x = 2 * (var - opt_con(1:dim));
    g = sum(x.^2 - 5000 .* cos(0.1 .* pi .* x) - 4000, 2);
    h = 0;

    g(g < 0) = 0;
    h = abs(h) - 1e-4;
    h(h < 0) = 0;
    con = sum(g) + sum(h);
end
