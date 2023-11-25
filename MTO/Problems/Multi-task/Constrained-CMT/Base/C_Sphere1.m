function [Obj, Con] = C_Sphere1(var, M, opt, opt_con)
    % Sphere function
    %   - var: design variable vector
    %   - M: rotation matrix
    %   - opt: shift vector
    %   - opt_con: feasible region shift vector
    dim = length(var);

    % Object
    x = (M * (var - opt(1:dim))')';
    Obj = sum(x.^2, 'all');

    % constraint
    x = var - opt_con(1:dim);
    g = sum(x.^2 - 5000 .* cos(0.1 .* pi .* x) - 4000, 2);

    g(g < 0) = 0;
    Con = g;
end
