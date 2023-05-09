classdef DrawPopDec < handle

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
%--------------------------------------------------------------------------

properties (SetAccess = private)
    fig
    tiled
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
    end

    function obj = update(obj, Prob, Pop)
        for t = 1:Prob.T
            cla(obj.tiled.Children(end - t + 1))
            for i = 1:length(Pop{t})
                p = plot(obj.tiled.Children(end - t + 1), Pop{t}(i).Dec);
                p.Color = [0.2, 0.2, 0.2];
                p.LineWidth = 1;
                hold(obj.tiled.Children(end - t + 1), 'on');
            end
            xlim(obj.tiled.Children(end - t + 1), [1, max(Prob.D)]);
            ylim(obj.tiled.Children(end - t + 1), [0, 1]);
            title(obj.tiled.Children(end - t + 1), ['Task ', num2str(t)]);
            drawnow;
        end
    end

    function obj = special(obj, Prob, SPop, color)
        for t = 1:Prob.T
            for i = 1:length(SPop{t})
                p = plot(obj.tiled.Children(end - t + 1), SPop{t}(i).Dec);
                p.Color = color;
                p.LineWidth = 1;
                hold(obj.tiled.Children(end - t + 1), 'on');
            end
            drawnow;
        end
    end

    function obj = close(obj)
        close(obj.fig)
    end
end
end
