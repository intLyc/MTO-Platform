function [Obj, Con] = Rosenbrock(x, M, opt, g)
    % ROSENBROCK function
    %   - var: design variable vector
    %   - M: rotation matrix
    %   - opt: shift vector
    %   - g: Objective value move

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    var = x;
    dim = length(var);
    var = (M * (var - opt)')';
    sum = 0;
    for ii = 1:(dim - 1)
        xi = var(ii);
        xnext = var(ii + 1);
        new = 100 * (xnext - xi^2)^2 + (xi - 1)^2;
        sum = sum + new;
    end
    if dim == 1
        sum = 100 * (var(1) - var(1)^2)^2 + (var(1) - 1)^2;
    end
    Obj = sum;
    Obj = Obj + g;

    Con = 0;
end
