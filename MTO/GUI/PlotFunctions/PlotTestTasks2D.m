function PlotTestTasks2D(app)
% Draw the Test module's two-variable task slices.
% Edit this file to customize the plot; app provides the current GUI data and controls.

style = PlotStyle();

if isempty(app.TProblemTree.Children), return; end
try
    prob = app.TProblemTree.Children(1).NodeData;
    x = 0:1/app.TSampleNumberEditField.Value:1;
    [gridX, gridY] = meshgrid(x);
    unified = strcmp(app.TShowTypeDropDown.Value, 'Tasks Figure (2D Unified)');
    colors = style.ColorOrder;
    handles = gobjects(0);
    names = {};
    for task = find(prob.D(:)' >= 2)
        [vars, objectives, feasible] = PreviewTaskSlice(prob, task, [gridX(:), gridY(:)]);
        f = PreviewObjectiveValues(objectives, feasible, unified);
        if unified
            plotX = gridX; plotY = gridY;
        else
            plotX = reshape(vars(:, 1), size(gridX));
            plotY = reshape(vars(:, 2), size(gridY));
        end
        color = colors(mod(task-1, size(colors, 1))+1, :);
        handles(end+1) = mesh(app.TUIAxes, plotX, plotY, reshape(f, size(gridX)), ...
            'FaceAlpha', style.SurfaceAlpha, 'FaceColor', color, 'EdgeColor', color, 'LineStyle', '-');
        hold(app.TUIAxes, 'on');
        names{end+1} = ['T', num2str(task)];
    end
    if isempty(handles)
        title(app.TUIAxes, '2D preview requires at least two variables');
        return;
    end
    if unified
        xlim(app.TUIAxes, [0, 1]); ylim(app.TUIAxes, [0, 1]);
        xlabel(app.TUIAxes, 'Normalized Variable 1');
        ylabel(app.TUIAxes, 'Normalized Variable 2');
        zlabel(app.TUIAxes, 'Normalized Objective 1');
    else
        xlim(app.TUIAxes, 'auto'); ylim(app.TUIAxes, 'auto');
        xlabel(app.TUIAxes, 'Variable 1'); ylabel(app.TUIAxes, 'Variable 2');
        zlabel(app.TUIAxes, 'Objective 1');
    end
    title(app.TUIAxes, 'Slice: other variables at bound midpoints');
    legend(app.TUIAxes, handles, names, 'Location', 'best');
    PlotStyle(app.TUIAxes, 'Test');
catch ME
    app.showError(ME, 'Task plot failed');
end
end
