function PlotTestFeasibleRegion(app)
% Draw feasible task slices in the Test module.
% Edit this file to customize the plot; app provides the current GUI data and controls.

style = PlotStyle();

if isempty(app.TProblemTree.Children), return; end
try
    prob = app.TProblemTree.Children(1).NodeData;
    x = 0:1/app.TSampleNumberEditField.Value:1;
    [gridX, gridY] = meshgrid(x);
    coordinates = [gridX(:), gridY(:)];
    colors = style.ColorOrder;
    handles = gobjects(0);
    names = {};
    % Feasibility comes from the selected problem, independently of filter labels.
    for task = find(prob.D(:)' >= 2)
        [~, ~, feasible] = PreviewTaskSlice(prob, task, coordinates);
        color = colors(mod(task-1, size(colors, 1))+1, :);
        handles(end+1) = scatter(app.TUIAxes, coordinates(feasible, 1), coordinates(feasible, 2), ...
            style.FeasiblePointSize, 'filled', 'MarkerFaceAlpha', style.FeasiblePointAlpha, 'MarkerEdgeAlpha', style.FeasiblePointAlpha, ...
            'MarkerFaceColor', color, 'MarkerEdgeColor', color);
        hold(app.TUIAxes, 'on');
        names{end+1} = ['T', num2str(task)];
    end
    if isempty(handles)
        title(app.TUIAxes, '2D preview requires at least two variables');
        return;
    end
    xlim(app.TUIAxes, [0, 1]); ylim(app.TUIAxes, [0, 1]);
    xlabel(app.TUIAxes, 'Normalized Variable 1');
    ylabel(app.TUIAxes, 'Normalized Variable 2');
    title(app.TUIAxes, 'Feasible slice: other variables at bound midpoints');
    legend(app.TUIAxes, handles, names, 'Location', 'best');
    PlotStyle(app.TUIAxes, 'Test');
catch ME
    app.showError(ME, 'Feasible-region plot failed');
end
end
