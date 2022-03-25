function [obj, con] = Weierstrass3(var, M, opt, opt_con)
    % WEIERSTASS function
    %   - var: design variable vector
    %   - M: rotation matrix
    %   - opt: shift vector
    %   - opt_con: feasible region shift vector
    dim = length(var);

    % object
    x = (M * (var - opt(1:dim))')';
    a = 0.5;
    b = 3;
    kmax = 20;
    obj = 0;
    for i = 1:dim
        for k = 0:kmax
            obj = obj + a^k * cos(2 * pi * b^k * (x(i) + 0.5));
        end
    end
    for k = 0:kmax
        obj = obj - dim * a^k * cos(2 * pi * b^k * 0.5);
    end

    % constraint
    x = 200 * (var - opt_con(1:dim));
    g1 = -sum(abs(x), 2) + 12 * dim;
    g2 = sum(x.^2, 2) - 500 * dim;
    g = [g1, g2];
    h = 0;

    g(g < 0) = 0;
    h = abs(h) - 1e-4;
    h(h < 0) = 0;
    con = sum(g) + sum(h);
end
