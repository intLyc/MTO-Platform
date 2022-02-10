function [obj, con] = Sphere(x, M, opt, g)
    % Sphere function
    %   - var: design variable vector
    %   - M: rotation matrix
    %   - opt: shift vector
    %   - g: objective value move
    con = 0;
    var = x;
    dim = length(var);
    var = (M * (var - opt)')';
    sum = 0;
    for i = 1:dim
        sum = sum + var(i) * var(i);
    end
    obj = sum;
    obj = obj + g;
end
