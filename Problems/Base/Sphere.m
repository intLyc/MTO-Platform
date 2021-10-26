function obj = Sphere(x, M, opt)
    %Sphere function
    %   - var: design variable vector
    %   - M: rotation matrix
    %   - opt: shift vector
    var = x;
    dim = length(var);
    var = (M * (var - opt)')';
    sum = 0;
    for i = 1:dim
        sum = sum + var(i) * var(i);
    end
    obj = sum;
end
