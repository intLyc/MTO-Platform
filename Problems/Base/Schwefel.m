function obj = Schwefel(var)
    %SCHWEFEL function
    %   - var: design variable vector
    dim = length(var);

    sum = 0;

    for i = 1:dim
        sum = sum + var(i) * sin(sqrt(abs(var(i))));
    end

    obj = 418.9829 * dim - sum;

end
