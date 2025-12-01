classdef ZDT4_G

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

methods (Static)
    function [Obj, Con] = getFnc(x, M)
        D = size(x, 2);
        y = (M * x(:, 2:end)')';
        gx = 2 + sum(y.^2, 2) / 4000;
        gx_2 = 1;
        for i = 2:D
            gx_2 = gx_2 .* cos(x(:, i) ./ sqrt(i));
        end
        gx = gx - gx_2;
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
