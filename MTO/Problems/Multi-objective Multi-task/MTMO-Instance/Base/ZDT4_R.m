classdef ZDT4_R

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

methods (Static)
    function [Obj, Con] = getFnc(x, M)
        D = size(x, 2);
        y = (M * x(:, 2:end)')';
        gx = 1 + 10 * (D - 1) + sum(y .* y - 10 * cos(4 * pi * y), 2);
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
