function PlotTestTasks1D(app)
% Draw the Test module's one-variable task slices.
% Edit this file to customize the plot; app provides the current GUI data and controls.

style = PlotStyle();

if isempty(app.TProblemTree.Children), return; end
try
    prob = app.TProblemTree.Children(1).NodeData;
    x = (0:1/app.TSampleNumberEditField.Value:1)';
    unified = strcmp(app.TShowTypeDropDown.Value, 'Tasks Figure (1D Unified)');
    colors = style.ColorOrder;
    handles = gobjects(0);
    names = {};
    for task = 1:prob.T
        [vars, objectives, feasible] = PreviewTaskSlice(prob, task, x);
        f = PreviewObjectiveValues(objectives, feasible, unified);
        if unified, plotX = x; else, plotX = vars(:, 1); end
        color = colors(mod(task-1, size(colors, 1))+1, :);
        handles(end+1) = plot(app.TUIAxes, plotX, f, 'Color', color, 'LineWidth', style.PreviewLineWidth);
        hold(app.TUIAxes, 'on');
        valid = isfinite(f);
        if any(valid)
            best = valid & f == min(f(valid));
            plot(app.TUIAxes, plotX(best), f(best), style.MinimumMarker, ...
                'MarkerSize', style.MinimumMarkerSize, 'MarkerFaceColor', color, 'MarkerEdgeColor', color);
        end
        names{end+1} = ['T', num2str(task)];
    end
    if unified
        xlim(app.TUIAxes, [0, 1]);
        xlabel(app.TUIAxes, 'Normalized Variable 1');
        ylabel(app.TUIAxes, 'Normalized Objective 1');
    else
        xlim(app.TUIAxes, 'auto');
        xlabel(app.TUIAxes, 'Variable 1');
        ylabel(app.TUIAxes, 'Objective 1');
    end
    title(app.TUIAxes, 'Slice: other variables at bound midpoints');
    legend(app.TUIAxes, handles, names, 'Location', 'best');
    PlotStyle(app.TUIAxes, 'Test');
catch ME
    app.showError(ME, 'Task plot failed');
end
end
