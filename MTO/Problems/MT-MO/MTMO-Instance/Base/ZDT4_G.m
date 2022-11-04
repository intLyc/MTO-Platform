classdef ZDT4_G

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function [Obj, Con] = getFnc(x, M)
            D = length(x);
            y = (M * x(2:end)')';
            gx = 2 + sum(y.^2) / 4000;
            gx_2 = 1;
            for i = 2:D
                gx_2 = gx_2 * cos(x(i) / sqrt(i));
            end
            gx = gx - gx_2;
            Obj(1) = x(1);
            Obj(2) = gx * (1 - sqrt(x(1) / gx));
            Con = 0;
        end

        function Optimum = getOptimum(N)
            Optimum(:, 1) = linspace(0, 1, N)';
            Optimum(:, 2) = 1 - Optimum(:, 1).^0.5;
        end
    end
end
