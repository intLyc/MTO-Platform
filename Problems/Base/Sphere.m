function obj = Sphere(var, opt)
    %Sphere function
    %   - var: design variable vector
    %   - opt: shift vector
    var = var - opt;
    obj = var * var';
end
