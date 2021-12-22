function [obj, con] = Schwefel(x, M, opt)
    % SCHWEFEL function
    %   - var: design variable vector
    con = 0;
    var = x;
    dim = length(var);
    var = (M * (var - opt)')';
    sum = 0;
    for i = 1:dim
        sum = sum + var(i) * sin(sqrt(abs(var(i))));
    end

    obj = 418.9829 * dim - sum;

end
