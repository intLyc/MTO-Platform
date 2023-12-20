classdef ZDT4_A

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
%--------------------------------------------------------------------------

methods (Static)
    function [Obj, Con] = getFnc(x, M)
        D = size(x, 2);
        y = (M * x(:, 2:end)')';
        gx = -20 * exp(-0.2 * sqrt(sum(y.^2, 2) / (D - 1))) - exp(sum(cos(2 * pi * y), 2) / (D - 1)) + 21 + exp(1);
        Obj(:, 1) = x(:, 1);
        Obj(:, 2) = gx .* (1 - sqrt(x(:, 1) ./ gx));
        Con = zeros(size(x, 1), 1);
    end

    function Optimum = getOptimum(N)
        Optimum(:, 1) = linspace(0, 1, N)';
        Optimum(:, 2) = 1 - Optimum(:, 1).^0.5;
    end
end
end
