classdef DrawPopDec < handle

%% Draw Dynamic Population in Decision Space
% Example:
% dpd = DrawPopDec(Algo, Prob); % Initialize Object
% while Algo.notTerminated(Prob, population) % Main Loop
% dpd.update(Prob, population); % Dynamic Update Population

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties (SetAccess = private)
    fig
    tiled
    hplot
end

methods
    function obj = DrawPopDec(Algo, Prob)
        obj.fig = figure('Position', [100, 100, 500, 500]);
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
            xlim(obj.tiled.Children(end - t + 1), [1, Prob.D(t)]);
            ylim(obj.tiled.Children(end - t + 1), [0, 1]);
            title(obj.tiled.Children(end - t + 1), ['Task ', num2str(t)]);
            grid(obj.tiled.Children(end - t + 1), 'on');
            drawnow;
        end
    end

    function obj = update(obj, Algo, Prob, Pop)
        if ~isa(Pop, 'cell')
            Pop = MF2MP(Pop, Prob.T);
        end
        for t = 1:Prob.T
            lenPop = length(Pop{t});
            for i = 1:min(lenPop, length(obj.hplot{t}))
                set(obj.hplot{t}{i}, 'YData', Pop{t}(i).Dec)
            end
            for i = min(lenPop, length(obj.hplot{t})) + 1:lenPop
                obj.hplot{t}{i} = plot(Pop{t}(i).Dec);
                obj.hplot{t}{i}.Color = [.2, .2, .2];
                obj.hplot{t}{i}.LineWidth = 1;
                hold(obj.tiled.Children(end - t + 1), 'on');
            end
            if lenPop < length(obj.hplot{t})
                for i = length(obj.hplot{t}):-1:lenPop + 1
                    % set(obj.hplot{t}{i}, 'YData', []);
                    delete(obj.hplot{t}{i})
                    obj.hplot{t}(i) = [];
                end
            end
            drawnow;
        end
        title(obj.tiled, [Algo.Name, ' on ', Prob.Name, ' Gen=', num2str(Algo.Gen)]);
    end

    function obj = close(obj)
        close(obj.fig)
    end
end
end
