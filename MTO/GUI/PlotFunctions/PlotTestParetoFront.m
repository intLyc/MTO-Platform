function PlotTestParetoFront(app)
% Draw Test Pareto fronts and populations on app.TUIAxes.
% Edit this file to customize the plot; app provides the current GUI data and controls.

style = PlotStyle();

% update figure axes

if isempty(app.TData)
    return;
end

cla(app.TUIAxes, 'reset');

if max(app.TData.Problems(1).M) ~= 2 || min(app.TData.Problems(1).M) ~= 2
    return;
end

result = IGD(app.TData);

tasks_name = {};
handles = gobjects(0);
color_list = style.ColorOrder;
for j = 1:size(result.ParetoData.Obj, 1)
    color = color_list(mod(j-1, size(color_list, 1))+1, :);
    if numel(result.ParetoData.Optimum) >= j && ~isempty(result.ParetoData.Optimum{j})
        optimum = result.ParetoData.Optimum{j};
        handles(end+1) = scatter(app.TUIAxes, optimum(:, 1), optimum(:, 2), ...
            style.ReferencePointSize, 'MarkerEdgeColor', color, 'MarkerFaceColor', color, 'MarkerFaceAlpha', style.PointAlpha);
        hold(app.TUIAxes, 'on');
        tasks_name{end+1} = ['T', num2str(j), ' Pareto Front'];
    end
    % Population visibility must not depend on a reference front being available.
    population = result.ParetoData.Obj{j, 1, 1};
    if ~isempty(population)
        handles(end+1) = scatter(app.TUIAxes, population(:, 1), population(:, 2), ...
            style.PopulationPointSize, 'MarkerEdgeColor', color, 'MarkerFaceColor', color, 'MarkerFaceAlpha', style.PointAlpha);
        hold(app.TUIAxes, 'on');
        tasks_name{end+1} = ['T', num2str(j), ' Population'];
    end
end

xlabel(app.TUIAxes, '$f_1$', 'interpreter', 'latex');
ylabel(app.TUIAxes, '$f_2$', 'interpreter', 'latex');
if ~isempty(handles), legend(app.TUIAxes, handles, tasks_name, 'Location', 'best'); end
grid(app.TUIAxes, 'on');
pbaspect(app.TUIAxes, [1, 1, 1]);
PlotStyle(app.TUIAxes, 'Test');
end
