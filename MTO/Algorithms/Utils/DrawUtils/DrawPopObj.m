classdef DrawPopObj < handle

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
    function obj = DrawPopObj(Algo, Prob)
        obj.fig = figure();
        obj.tiled = tiledlayout('flow');
        obj.tiled.TileSpacing = 'compact';
        obj.tiled.Padding = 'compact';
        title(obj.tiled, [Algo.Name, ' on ', Prob.Name]);
        for t = 1:Prob.T
            nexttile
        end

        optimum = Prob.getOptimum();
        for t = 1:Prob.T
            M = Prob.M(t);
            if M == 2
                % draw optimum
                s = scatter(obj.tiled.Children(end - t + 1), optimum{t}(:, 1), optimum{t}(:, 2));
                s.MarkerEdgeColor = 'none';
                s.MarkerFaceAlpha = 0.65;
                s.MarkerFaceColor = [.2, .2, .2];
                s.SizeData = 3;
                hold(obj.tiled.Children(end - t + 1), 'on');

                % draw objs
                obj.hplot{t} = scatter(obj.tiled.Children(end - t + 1), 0, 0);
                obj.hplot{t}.MarkerEdgeColor = [0, 0.4470, 0.7410];
                obj.hplot{t}.MarkerFaceAlpha = 0.65;
                obj.hplot{t}.MarkerFaceColor = [0, 0.4470, 0.7410];
                obj.hplot{t}.SizeData = 40;
                hold(obj.tiled.Children(end - t + 1), 'on');
                xlabel(obj.tiled.Children(end - t + 1), '$f_1$', 'interpreter', 'latex');
                ylabel(obj.tiled.Children(end - t + 1), '$f_2$', 'interpreter', 'latex');
                grid(obj.tiled.Children(end - t + 1), 'on');
            elseif M == 3
                % draw optimum
                s = scatter3(obj.tiled.Children(end - t + 1), optimum{t}(:, 1), optimum{t}(:, 2), optimum{t}(:, 3));
                s.MarkerEdgeColor = 'none';
                s.MarkerFaceAlpha = 0.65;
                s.MarkerFaceColor = [.5, .5, .5];
                s.SizeData = 3;
                hold(obj.tiled.Children(end - t + 1), 'on');

                % draw objs
                obj.hplot{t} = scatter3(obj.tiled.Children(end - t + 1), 0, 0, 0);
                obj.hplot{t}.MarkerEdgeColor = [0, 0.4470, 0.7410];
                obj.hplot{t}.MarkerFaceAlpha = 0.65;
                obj.hplot{t}.MarkerFaceColor = [0, 0.4470, 0.7410];
                obj.hplot{t}.SizeData = 40;
                hold(obj.tiled.Children(end - t + 1), 'on');
                xlabel(obj.tiled.Children(end - t + 1), '$f_1$', 'interpreter', 'latex');
                ylabel(obj.tiled.Children(end - t + 1), '$f_2$', 'interpreter', 'latex');
                zlabel(obj.tiled.Children(end - t + 1), '$f_3$', 'interpreter', 'latex');
                view(obj.tiled.Children(end - t + 1), [135 30]);
                grid(obj.tiled.Children(end - t + 1), 'on');
            else
                obj.hplot{t} = {};
                for i = 1:Prob.N
                    obj.hplot{t}{i} = plot(obj.tiled.Children(end - t + 1), 0);
                    obj.hplot{t}{i}.Color = [0, 0.4470, 0.7410];
                    obj.hplot{t}{i}.LineWidth = 1;
                    hold(obj.tiled.Children(end - t + 1), 'on');
                end
                xlabel(obj.tiled.Children(end - t + 1), 'Dimension', 'interpreter', 'latex');
                ylabel(obj.tiled.Children(end - t + 1), '$f$', 'interpreter', 'latex');
            end
            title(obj.tiled.Children(end - t + 1), ['Task ', num2str(t)]);
            drawnow;
        end
    end

    function obj = update(obj, Algo, Prob, Pop)
        for t = 1:Prob.T
            M = Prob.M(t);
            Obj = Pop{t}.Objs;
            if M == 2
                set(obj.hplot{t}, 'XData', Obj(:, 1), 'YData', Obj(:, 2));
            elseif M == 3
                % draw optimum
                set(obj.hplot{t}, 'XData', Obj(:, 1), 'YData', Obj(:, 2), 'ZData', Obj(:, 3));
            else
                for i = 1:Prob.N
                    set(obj.hplot{t}{i}, 'YData', Obj(i, :));
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
