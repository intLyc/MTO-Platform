function PlotTestConvergence(app)
% Draw Test convergence from app.TData on app.TUIAxes.
% Edit this file to customize the plot; app provides the current GUI data and controls.

style = PlotStyle();

% update figure axes

if isempty(app.TData)
    return;
end

cla(app.TUIAxes, 'reset');

if max(app.TData.Problems(1).M) == 1
    result = Obj(app.TData);
else
    result = IGD(app.TData);
end

xlim_min = inf;
xlim_max = 0;
tasks_name = {};
converge_x = result.ConvergeData.X;
converge_y = result.ConvergeData.Y;
for j = 1:size(converge_x, 1)
    if j > length(style.MarkerList)
        marker = 'none';
    else
        marker = style.MarkerList{j};
    end

    y = squeeze(converge_y(j, 1, 1, :))';
    x = squeeze(converge_x(j, 1, 1, :))';
    if isempty(x) || isempty(y), continue; end
    p = plot(app.TUIAxes, x, y, 'LineStyle', '-', 'Marker', marker, ...
        'Color', style.ColorOrder(mod(j-1, size(style.ColorOrder, 1))+1, :));
    p.LineWidth = style.LineWidth;
    indices = max(1, round(length(y)/max(1, style.MarkerNum)));
    p.MarkerIndices = indices:indices:max(indices, length(y)-round(indices/2));
    p.MarkerSize = style.MarkerSize;
    xlim_max = max(xlim_max, x(end));
    xlim_min = min(xlim_min, x(1));
    hold(app.TUIAxes, 'on');
    tasks_name = [tasks_name, ['T', num2str(j)]];
end

if isfinite(xlim_min) && isfinite(xlim_max) && xlim_min < xlim_max
    xlim(app.TUIAxes, [xlim_min, xlim_max]);
end
if max(app.TData.Problems(1).M) == 1
    ylabel(app.TUIAxes, 'Obj');
else
    ylabel(app.TUIAxes, 'IGD');
end
xlabel(app.TUIAxes, 'Evaluation');
legend(app.TUIAxes, tasks_name, 'Location', 'best');
grid(app.TUIAxes, 'on');
pbaspect(app.TUIAxes, [4, 3, 1]);
PlotStyle(app.TUIAxes, 'Test');
end
