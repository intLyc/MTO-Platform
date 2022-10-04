function [Obj, Con] = Rastrigin4(var, M, opt, opt_con)
    % Rastrigin function
    %   - var: design variable vector
    %   - M: rotation matrix
    %   - opt: shift vector
    %   - opt_con: feasible region shift vector
    dim = length(var);

    % Object
    x = (M * (var - opt(1:dim))')';
    Obj = 10 * dim;
    for i = 1:dim
        Obj = Obj + (x(i)^2 - 10 * (cos(2 * pi * x(i))));
    end

    % constraint
    x = 2 * (var - opt_con(1:dim));
    h = -sum(x .* sin(0.1 * pi * x), 2);

    h = abs(h) - 1e-4;
    h(h < 0) = 0;
    Con = h;
end
