classdef StreamDrawPopDec < handle
% Bind curves to task axes even when populations start empty or change size.

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, ACM Trans. Evol. Learn. Optim., 2026"
%--------------------------------------------------------------------------

properties (SetAccess = private)
    fig
    tiled
    TaskAxes
    hplot
end

properties (Access = private)
    LastDec
    LastTitle = ''
end

methods
    function obj = StreamDrawPopDec(Algo, Prob)
        [rows, cols] = PlotGridSize(Prob.T);
        obj.fig = figure('Position', PlotFigurePosition(rows, cols, [320, 260]));
        obj.tiled = tiledlayout(obj.fig, rows, cols);
        obj.tiled.TileSpacing = 'compact';
        obj.tiled.Padding = 'compact';
        title(obj.tiled, [Algo.Name, ' on ', Prob.Name]);
        xlabel(obj.tiled, 'Dimension');
        ylabel(obj.tiled, 'Unified Decision Variables');
        % Reserve fixed axes for every task, including tasks that have not arrived.
        obj.TaskAxes = gobjects(1, Prob.T);
        obj.hplot = cell(1, Prob.T);
        obj.LastDec = cell(1, Prob.T);
        for t = 1:Prob.T
            ax = nexttile(obj.tiled);
            obj.TaskAxes(t) = ax;
            obj.hplot{t} = gobjects(1, 0);
            hold(ax, 'on');
            xlim(ax, [1, max(2, Prob.D(t))]);
            ylim(ax, [0, 1]);
            title(ax, ['Task ', num2str(t)]);
            grid(ax, 'on');
            pbaspect(ax, [4, 3, 1]);
        end
    end

    function update(obj, Algo, Prob, Pop)
        changed = false;
        for t = 1:Prob.T
            n = numel(Pop{t});
            decs = [];
            if n > 0
                decs = Pop{t}.Decs;
                decs = decs(:, 1:Prob.D(t));
            end
            % Compare decision values to skip unchanged tasks and detect cross-task edits.
            if isequaln(decs, obj.LastDec{t}), continue; end
            changed = true;
            % Add or remove curves as population size changes; reuse existing handles.
            if n < numel(obj.hplot{t})
                delete(obj.hplot{t}(n + 1:end));
                obj.hplot{t}(n + 1:end) = [];
            end
            for i = 1:n
                dec = decs(i, :);
                if i > numel(obj.hplot{t})
                    obj.hplot{t}(i) = plot(obj.TaskAxes(t), 1:Prob.D(t), dec, ...
                        'Color', [.2, .2, .2], 'LineWidth', 1);
                else
                    set(obj.hplot{t}(i), 'XData', 1:Prob.D(t), 'YData', dec);
                end
            end
            obj.LastDec{t} = decs;
        end
        label = sprintf('%s on %s | Time=%g, FE=%g', ...
            Algo.Name, Prob.Name, Algo.Clock, Algo.FE);
        if ~strcmp(label, obj.LastTitle)
            title(obj.tiled, label);
            obj.LastTitle = label;
            changed = true;
        end
        if changed, drawnow('limitrate'); end
    end

    function close(obj)
        if isgraphics(obj.fig), close(obj.fig); end
    end
end
end
