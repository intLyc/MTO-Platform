function [obj, con] = Sphere(x, M, opt, g)
    % Sphere function
    %   - var: design variable vector
    %   - M: rotation matrix
    %   - opt: shift vector
    %   - g: objective value move

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

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
