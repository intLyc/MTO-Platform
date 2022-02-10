function [obj, con] = Weierstrass(var, M, opt, g)
    % WEIERSTASS function
    %   - var: design variable vector
    %   - M: rotation matrix
    %   - opt: shift vector
    %   - g: objective value move
    con = 0;
    D = length(var);
    var = (M * (var - opt)')';
    a = 0.5;
    b = 3;
    kmax = 20;
    obj = 0;

    for i = 1:D

        for k = 0:kmax
            obj = obj + a^k * cos(2 * pi * b^k * (var(i) + 0.5));
        end

    end

    for k = 0:kmax
        obj = obj - D * a^k * cos(2 * pi * b^k * 0.5);
    end
    obj = obj + g;
end
