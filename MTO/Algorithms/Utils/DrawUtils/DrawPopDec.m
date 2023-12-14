classdef DrawPopDec < handle

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties (SetAccess = private)
    fig
    tiled
    hplot
end

methods
    function obj = DrawPopDec(Algo, Prob)
        obj.fig = figure();
        obj.tiled = tiledlayout('flow');
        obj.tiled.TileSpacing = 'compact';
        obj.tiled.Padding = 'compact';
        title(obj.tiled, [Algo.Name, ' on ', Prob.Name]);
        xlabel(obj.tiled, 'Dimension');
        ylabel(obj.tiled, 'Unified Decision Variables');
        for t = 1:Prob.T
            nexttile
        end

        for t = 1:Prob.T
            cla(obj.tiled.Children(end - t + 1))
            for i = 1:Prob.N
                obj.hplot{t}{i} = plot(obj.tiled.Children(end - t + 1), 0);
                obj.hplot{t}{i}.Color = [.2, .2, .2];
                obj.hplot{t}{i}.LineWidth = 1;
                hold(obj.tiled.Children(end - t + 1), 'on');
            end
            xlim(obj.tiled.Children(end - t + 1), [1, max(Prob.D)]);
            ylim(obj.tiled.Children(end - t + 1), [0, 1]);
            title(obj.tiled.Children(end - t + 1), ['Task ', num2str(t)]);
            drawnow;
        end
    end

    function obj = update(obj, Prob, Pop)
        for t = 1:Prob.T
            for i = 1:Prob.N
                set(obj.hplot{t}{i}, 'YData', Pop{t}(i).Dec)
            end
            drawnow;
        end
    end

    function obj = close(obj)
        close(obj.fig)
    end
end
end
