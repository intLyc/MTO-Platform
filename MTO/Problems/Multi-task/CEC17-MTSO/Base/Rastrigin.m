function [Obj, Con] = Rastrigin(var, M, opt, g)
    % Rastrigin function
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

    dim = length(var);
    var = (M * (var - opt)')';
    Obj = 10 * dim;

    for i = 1:dim
        Obj = Obj + (var(i)^2 - 10 * (cos(2 * pi * var(i))));
    end
    Obj = Obj + g;

    Con = 0;
end
