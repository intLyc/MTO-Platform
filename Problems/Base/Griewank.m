function [obj, con] = Griewank(var, M, opt, g)
    % GRIEWANK function
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
