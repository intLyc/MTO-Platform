function PlotExperimentConvergence(app)
% Draw the selected Experiment convergence curves and confidence ranges.
% Edit this file to customize the plot; app provides the current GUI data and controls.

style = PlotStyle();

if strcmp(app.EDataTypeDropDown.Value, 'Reps') || ...
        isempty(app.EResultConvergeData) || ...
        isempty(app.ETableSelected)
    msg = 'Select calculated metric data from table first!';
    uiconfirm(app.MToPv111UIFigure, msg, 'warning', 'Icon', 'warning');
    return;
end

prob_list = unique(app.ETableSelected(:, 1));

IsSplitDraw = app.ESplitCheckBox.Value | (length(prob_list)<=1);

if IsSplitDraw
    weidth = 340;
    height = 300;
    position = [10,50,weidth,height];
else
    n_probs = length(prob_list);
    % Use at most five columns and consistent subplot sizes for combined plots.
    [rows, cols] = PlotGridSize(n_probs);

    fig = figure('Position', PlotFigurePosition(rows, cols, [320, 260]));

    t = tiledlayout(rows, cols, 'TileSpacing', 'compact', 'Padding', 'compact');
    all_plot_handles = [];
    all_legend_entries = {};
end


% Check if we need to plot with ranges
plot_with_ranges = strcmp(app.EConvergeTypeDropDown.Value, 'Log Range') || strcmp(app.EConvergeTypeDropDown.Value, 'Norm Range');

for i = 1:length(prob_list)
    if IsSplitDraw
        fig = figure('Position',position);
        if position(1)<1600
            position = position + [weidth,0,0,0];
        else
            position = position + [10-position(1),height+80,0,0];
        end
        ax = axes(fig);

        % Prepare legend entries
        legend_entries = cell(0);
        plot_handles = [];
    else
        nexttile(t);
        ax = gca;
    end

    idx = find(app.ETableSelected(:, 1) == prob_list(i));
    algo_list = app.ETableSelected(idx, 2);

    xlim_min = inf;
    xlim_max = 0;

    for j = 1:length(algo_list)
        if j > length(style.MarkerList)
            marker = 'none';
        else
            marker = style.MarkerList{j};
        end

        % Get mean values
        y_mean = squeeze(mean(app.EResultConvergeData.Y(prob_list(i), algo_list(j), :, :),3))';
        x = squeeze(mean(app.EResultConvergeData.X(prob_list(i), algo_list(j), :, :),3))';

        % Set scale type
        if strcmp(app.EConvergeTypeDropDown.Value, 'Log') || strcmp(app.EConvergeTypeDropDown.Value, 'Log Range')
            set(ax, 'YScale', 'log');
        elseif strcmp(app.EConvergeTypeDropDown.Value, 'Log Type2')
            y_mean = log(y_mean);
        end

        % Plot main line
        p = plot(ax, x, y_mean, 'LineStyle', '-', 'Marker', marker, 'LineWidth', style.LineWidth, ...
            'Color', style.ColorOrder(mod(j-1, size(style.ColorOrder, 1))+1, :));

        % Set marker positions
        indices = max(1, round(length(y_mean)/max(1, min(style.MarkerNum,length(y_mean)))));
        if length(x) <= 3
            p.MarkerIndices = indices:indices:length(y_mean);
        elseif length(y_mean) < style.MarkerNum
            p.MarkerIndices = indices+1:indices:length(y_mean)-round(indices/2);
        else
            p.MarkerIndices = indices:indices:length(y_mean)-round(indices/2);
        end
        p.MarkerSize = style.MarkerSize;

        % Plot ranges if needed
        if plot_with_ranges
            Y_data = squeeze(app.EResultConvergeData.Y(prob_list(i), algo_list(j), :, :));

            mu = mean(Y_data, 1);
            sigma = std(Y_data, 0, 1);
            n = size(Y_data, 1);

            % 0.95 confidence interval
            ci95 = 1.96 * sigma / sqrt(n);
            y_lower = mu - ci95;
            y_upper = mu + ci95;

            y_lower = y_lower(:);
            y_upper = y_upper(:);
            x = x(:);

            hold(ax, 'on');
            fill_color = p.Color;
            fill_alpha = style.RangeAlpha;
            h = fill(ax, [x; flipud(x)], [y_lower; flipud(y_upper)], fill_color, ...
                'FaceAlpha', fill_alpha, 'EdgeColor', 'none', 'DisplayName', '');

            uistack(h, 'bottom');
            h.Annotation.LegendInformation.IconDisplayStyle = 'off';
        end

        xlim_max = max(xlim_max, x(end));
        xlim_min = min(xlim_min, x(1));

        if IsSplitDraw
            % Add to legend entries - ensure it's a string
            algo_name = app.EUITable.ColumnName{algo_list(j)}; % Use {} to get content
            legend_entries{end+1} = strrep(algo_name, '_', '\_');
            plot_handles(end+1) = p;
        else
            if i == 1
                algo_name = app.EUITable.ColumnName{algo_list(j)};
                legend_entry = strrep(algo_name, '_', '\_');
                all_plot_handles(end + 1) = p;
                all_legend_entries{end + 1} = legend_entry;
            end
        end
        hold(ax, 'on');
    end

    if xlim_min ~= xlim_max
        xlim(ax, [xlim_min, xlim_max]);
    end

    if IsSplitDraw
        set(ax,'OuterPosition',[0,0,1,1]);
        % Set labels
        if strcmp(app.EConvergeTypeDropDown.Value, 'Log Type2')
            ylabel(ax, ['Log - ', strrep(app.EDataTypeDropDown.Value, '_', ' ')]);
        else
            ylabel(ax, strrep(app.EDataTypeDropDown.Value, '_', ' '));
        end
        xlabel(ax, 'Evaluation');

        % Set legend
        legend(ax, plot_handles, legend_entries, 'Location', 'best');
        title(ax, strrep(app.EUITable.RowName(prob_list(i)), '_', '\_'),'FontWeight',style.TitleFontWeight)
        grid(ax, 'on');
        PlotStyle(ax);
        set(ax,'LooseInset',get(ax,'TightInset')+0.02)
    else
        title(ax, strrep(app.EUITable.RowName(prob_list(i)), '_', '\_'),'FontWeight',style.TitleFontWeight)
        grid(ax, 'on');
        PlotStyle(ax);
        set(ax, 'LooseInset', get(ax, 'TightInset') + 0.02);
    end
    pbaspect(ax, [4, 3, 1]);
end
if ~IsSplitDraw
    xlabel(t, 'Evaluation', 'FontWeight', style.FontWeight, 'FontName', style.FontName, 'FontSize', style.SharedLabelFontSize);
    if strcmp(app.EConvergeTypeDropDown.Value, 'Log Type2')
        ylabel(t, ['Log - ', strrep(app.EDataTypeDropDown.Value, '_', ' ')], 'FontWeight', style.FontWeight, 'FontName', style.FontName, 'FontSize', style.SharedLabelFontSize);
    else
        ylabel(t, strrep(app.EDataTypeDropDown.Value, '_', ' '), 'FontWeight', style.FontWeight, 'FontName', style.FontName, 'FontSize', style.SharedLabelFontSize);
    end
    lgd = legend(ax, all_plot_handles, all_legend_entries, 'Orientation', 'horizontal', 'FontName', style.FontName, 'FontSize', style.SharedLegendFontSize);
    lgd.Layout.Tile = 'south';
end
end
