function [obj, con] = Ackley(var, M, opt, g)
    % Ackley function
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
    var = (M * (var - opt)')';
    sum1 = 0; sum2 = 0;

    for i = 1:dim
        sum1 = sum1 + var(i) * var(i);
        sum2 = sum2 + cos(2 * pi * var(i));
    end

    avgsum1 = sum1 / dim;
    avgsum2 = sum2 / dim;

    obj = -20 * exp(-0.2 * sqrt(avgsum1)) - exp(avgsum2) + 20 + exp(1);
    obj = obj + g;
end
