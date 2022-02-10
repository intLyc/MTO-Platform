function [obj, con] = Griewank(var, M, opt, g)
    % GRIEWANK function
    %   - var: design variable vector
    %   - M: rotation matrix
    %   - opt: shift vector
    %   - g: objective value move
    con = 0;
    dim = length(var);
    var = (M * (var - opt)')'; %
    sum1 = 0; sum2 = 1;

    for i = 1:dim
        sum1 = sum1 + var(i) * var(i);
        sum2 = sum2 * cos(var(i) / (sqrt(i)));
    end

    obj = 1 + 1/4000 * sum1 - sum2;
    obj = obj + g;
end
