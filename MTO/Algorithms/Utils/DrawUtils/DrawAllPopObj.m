classdef DrawAllPopObj < handle

%% Draw Dynamic Population of All Tasks in One Objective Space
% Example:
% dapo = DrawAllPopObj(Algo, Prob); % Initialize Object
% while Algo.notTerminated(Prob, population) % Main Loop
% dapo.update(Algo, Prob, population); % Dynamic Update Population

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties (SetAccess = private)
    fig
    ax
    hplot
end

methods
    function obj = DrawAllPopObj(Algo, Prob)
        obj.fig = figure('Position', [600, 100, 500, 500]);
        obj.ax = axes();
        title(obj.ax, [Algo.Name, ' on ', Prob.Name]);

        optimum = Prob.getOptimum();

        M = max(Prob.M);
        if M == 2
            xlabel(obj.ax, '$f_1$', 'interpreter', 'latex');
            ylabel(obj.ax, '$f_2$', 'interpreter', 'latex');
            grid(obj.ax, 'on');
        elseif M == 3
            xlabel(obj.ax, '$f_1$', 'interpreter', 'latex');
            ylabel(obj.ax, '$f_2$', 'interpreter', 'latex');
            zlabel(obj.ax, '$f_3$', 'interpreter', 'latex');
            view(obj.ax, [135 30]);
            grid(obj.ax, 'on');
        else
            xlabel(obj.ax, 'Dimension', 'interpreter', 'latex');
            ylabel(obj.ax, '$f$', 'interpreter', 'latex');
        end

        alloptimum = [];
        for t = 1:Prob.T
            alloptimum = [alloptimum; optimum{t}];
        end
        alloptimum = getBestObj(alloptimum, zeros(size(alloptimum, 1), 1));

        color = colororder;
        if M == 2
            % draw optimum
            s = scatter(obj.ax, alloptimum(:, 1), alloptimum(:, 2));
            s.MarkerEdgeColor = 'none';
            s.MarkerFaceAlpha = 0.65;
            s.MarkerFaceColor = [.2, .2, .2];
            s.SizeData = 3;
            hold(obj.ax, 'on');

            for t = 1:Prob.T
                % draw objs
                obj.hplot{t} = scatter(obj.ax, 0, 0);
                obj.hplot{t}.MarkerEdgeColor = color(mod(t - 1, size(color, 1)) + 1, :);
                obj.hplot{t}.MarkerFaceAlpha = 0.65;
                obj.hplot{t}.MarkerFaceColor = color(mod(t - 1, size(color, 1)) + 1, :);
                obj.hplot{t}.SizeData = 40;
                hold(obj.ax, 'on');
            end
        elseif M == 3
            % draw optimum
            s = scatter3(obj.ax, alloptimum(:, 1), alloptimum(:, 2), alloptimum(:, 3));
            s.MarkerEdgeColor = 'none';
            s.MarkerFaceAlpha = 0.65;
            s.MarkerFaceColor = [.5, .5, .5];
            s.SizeData = 3;
            hold(obj.ax, 'on');

            for t = 1:Prob.T
                % draw objs
                obj.hplot{t} = scatter3(obj.ax, 0, 0, 0);
                obj.hplot{t}.MarkerEdgeColor = color(mod(t - 1, size(color, 1)) + 1, :);
                obj.hplot{t}.MarkerFaceAlpha = 0.65;
                obj.hplot{t}.MarkerFaceColor = color(mod(t - 1, size(color, 1)) + 1, :);
                obj.hplot{t}.SizeData = 40;
                hold(obj.ax, 'on');
            end
        else
            for t = 1:Prob.T
                obj.hplot{t} = {};
                for i = 1:Prob.N
                    obj.hplot{t}{i} = plot(obj.ax, 0);
                    obj.hplot{t}{i}.Color = [0, 0.4470, 0.7410];
                    obj.hplot{t}{i}.LineWidth = 1;
                    hold(obj.ax, 'on');
                end
            end
        end
        drawnow;
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
        title(obj.ax, [Algo.Name, ' on ', Prob.Name, ' Gen=', num2str(Algo.Gen)]);
        M = max(Prob.M);
        if M == 2
            xlabel(obj.ax, '$f_1$', 'interpreter', 'latex');
            ylabel(obj.ax, '$f_2$', 'interpreter', 'latex');
            grid(obj.ax, 'on');
        elseif M == 3
            xlabel(obj.ax, '$f_1$', 'interpreter', 'latex');
            ylabel(obj.ax, '$f_2$', 'interpreter', 'latex');
            zlabel(obj.ax, '$f_3$', 'interpreter', 'latex');
            view(obj.ax, [135 30]);
            grid(obj.ax, 'on');
        else
            xlabel(obj.ax, 'Dimension', 'interpreter', 'latex');
            ylabel(obj.ax, '$f$', 'interpreter', 'latex');
        end
    end

    function obj = close(obj)
        close(obj.fig)
    end
end
end

function BestObj = getBestObj(Obj, CV)
Feasible = find(all(CV <= 0, 2));
if isempty(Feasible)
    Best = [];
else
    Best = NDSort(Obj(Feasible, :), 1) == 1;
end
BestObj = Obj(Feasible(Best), :);
end
