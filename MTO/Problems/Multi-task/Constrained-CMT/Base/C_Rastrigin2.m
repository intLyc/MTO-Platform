function [Obj, Con] = C_Rastrigin2(var, M, opt, opt_con)
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
    g = sum(x.^2, 2) - 100 * dim;

    g(g < 0) = 0;
    Con = g;
end
