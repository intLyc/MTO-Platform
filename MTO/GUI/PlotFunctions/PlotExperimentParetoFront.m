function PlotExperimentParetoFront(app)
% Draw the selected Experiment Pareto fronts and populations.
% Edit this file to customize the plot; app provides the current GUI data and controls.

style = PlotStyle();

if strcmp(app.EDataTypeDropDown.Value, 'Reps') || ...
        isempty(app.EResultParetoData) || ...
        isempty(app.ETableSelected)
    msg = 'Select calculated multi-objective metric data from table first!';
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

    fig = figure('Position', PlotFigurePosition(rows, cols, [300, 300]));

    t = tiledlayout(rows, cols, 'TileSpacing', 'compact', 'Padding', 'compact');
    all_plot_handles = [];
    all_legend_entries = {};
end


for i = 1:length(prob_list)
    if IsSplitDraw
        fig = figure('Position',position);
        if position(1)<1600
            position = position + [weidth,0,0,0];
        else
            position = position + [10-position(1),height+80,0,0];
        end
        ax = axes(fig);

        legend_entries = cell(0);
        plot_handles = [];
    else
        nexttile(t);
        ax = gca;
    end

    idx = find(app.ETableSelected(:, 1) == prob_list(i));
    algo_list = app.ETableSelected(idx, 2);

    M = size(app.EResultParetoData.Obj{prob_list(i),1,1}, 2);
    if M == 2
        if ~isempty(app.EResultParetoData.Optimum) && ...
                size(app.EResultParetoData.Optimum{prob_list(i)}, 1) > 2
            % draw optimum
            x = squeeze(app.EResultParetoData.Optimum{prob_list(i)}(:, 1));
            y = squeeze(app.EResultParetoData.Optimum{prob_list(i)}(:, 2));

            [x, sortIdx] = sort(x);
            y = y(sortIdx);

            N = length(x);
            sampleSize = 100;
            if N > sampleSize * 3
                indices = round(linspace(1, N, sampleSize));
                sampledX = x(indices);
                sampledY = y(indices);
            else
                sampledX = x;
                sampledY = y;
            end

            % Calculate threshold for Pareto front plot
            distArray = sqrt(diff(sampledX).^2 + diff(sampledY).^2);
            distMean = mean(distArray);
            distStd  = std(distArray);
            autoThreshold = distMean + 2 * distStd;

            xPlot = [];
            yPlot = [];
            for idx = 1:length(sampledX)-1
                xPlot(end+1) = sampledX(idx);
                yPlot(end+1) = sampledY(idx);
                % if dist exceed threshold, insert [NaN, NaN]
                if distArray(idx) > autoThreshold
                    xPlot(end+1) = NaN;
                    yPlot(end+1) = NaN;
                end
            end
            xPlot(end+1) = sampledX(end);
            yPlot(end+1) = sampledY(end);

            p = plot(ax, xPlot, yPlot);
            p.Color = style.ReferenceLineColor;
            p.LineWidth = style.ReferenceLineWidth;
            hold(ax, 'on');

            if IsSplitDraw
                legend_entries{end+1} = 'Pareto Front';
                plot_handles(end+1) = p;
            else
                if i == 1
                    legend_entry = 'Pareto Front';
                    all_plot_handles(end + 1) = p;
                    all_legend_entries{end + 1} = legend_entry;
                end
            end
        end

        % draw each algorithm
        color_list = style.ColorOrder;
        for j = 1:length(algo_list)
            metric_data = squeeze(app.EResultTableData(prob_list(i), algo_list(j), :));
            [~, rank] = sort(metric_data);
            mid_idx = rank(ceil(end / 2));
            x = squeeze(app.EResultParetoData.Obj{prob_list(i), algo_list(j), mid_idx}(:, 1));
            y = squeeze(app.EResultParetoData.Obj{prob_list(i), algo_list(j), mid_idx}(:, 2));
            s = scatter(ax, x, y);
            s.MarkerEdgeColor = color_list(mod(j-1, size(color_list, 1))+1, :);
            s.MarkerFaceAlpha = style.PointAlpha;
            s.MarkerFaceColor = color_list(mod(j-1, size(color_list, 1))+1, :);
            s.SizeData = style.PopulationPointSize;
            if IsSplitDraw
                legend_entries{end+1} = char(strrep(app.EUITable.ColumnName(algo_list(j)), '_', '\_'));
                plot_handles(end+1) = s;
            else
                if i == 1
                    legend_entry = char(strrep(app.EUITable.ColumnName(algo_list(j)), '_', '\_'));
                    all_plot_handles(end + 1) = s;
                    all_legend_entries{end + 1} = legend_entry;
                end
            end
            hold(ax, 'on');
        end

        xlabel(ax, '$f_1$', 'interpreter', 'latex');
        ylabel(ax, '$f_2$', 'interpreter', 'latex');

        if IsSplitDraw
            legend(ax, plot_handles, legend_entries, 'Location', 'best');
        end

        title(ax, strrep(app.EUITable.RowName(prob_list(i)), '_', '\_'),'FontWeight',style.TitleFontWeight)
        grid(ax, 'on');
    elseif M == 3
        if ~isempty(app.EResultParetoData.Optimum) && ...
                size(app.EResultParetoData.Optimum{prob_list(i)}, 1) > 2
            % draw optimum
            x = squeeze(app.EResultParetoData.Optimum{prob_list(i)}(:, 1));
            y = squeeze(app.EResultParetoData.Optimum{prob_list(i)}(:, 2));
            z = squeeze(app.EResultParetoData.Optimum{prob_list(i)}(:, 3));

            s = scatter3(ax, x, y, z);
            s.MarkerEdgeColor = 'none';
            s.MarkerFaceAlpha = style.PointAlpha;
            s.MarkerFaceColor = style.ReferencePointColor;
            s.SizeData = style.ReferencePointSize;
            hold(ax, 'on');

            if IsSplitDraw
                legend_entries{end+1} = 'Pareto Front';
                plot_handles(end+1) = s;
            else
                if i == 1
                    legend_entry = 'Pareto Front';
                    all_plot_handles(end + 1) = s;
                    all_legend_entries{end + 1} = legend_entry;
                end
            end
        end

        % draw each algorithm
        color_list = style.ColorOrder;
        for j = 1:length(algo_list)
            metric_data = squeeze(app.EResultTableData(prob_list(i), algo_list(j), :));
            [~, rank] = sort(metric_data);
            mid_idx = rank(ceil(end / 2));
            x = squeeze(app.EResultParetoData.Obj{prob_list(i), algo_list(j), mid_idx}(:, 1));
            y = squeeze(app.EResultParetoData.Obj{prob_list(i), algo_list(j), mid_idx}(:, 2));
            z = squeeze(app.EResultParetoData.Obj{prob_list(i), algo_list(j), mid_idx}(:, 3));
            s = scatter3(ax, x, y, z);
            s.MarkerEdgeColor = color_list(mod(j-1, size(color_list, 1))+1, :);
            s.MarkerFaceAlpha = style.PointAlpha;
            s.MarkerFaceColor = color_list(mod(j-1, size(color_list, 1))+1, :);
            s.SizeData = style.PopulationPointSize;

            if IsSplitDraw
                legend_entries{end+1} = char(strrep(app.EUITable.ColumnName(algo_list(j)), '_', '\_'));
                plot_handles(end+1) = s;
            else
                if i == 1
                    legend_entry = char(strrep(app.EUITable.ColumnName(algo_list(j)), '_', '\_'));
                    all_plot_handles(end + 1) = s;
                    all_legend_entries{end + 1} = legend_entry;
                end
            end
            hold(ax, 'on');
        end

        xlabel(ax, '$f_1$', 'interpreter', 'latex');
        ylabel(ax, '$f_2$', 'interpreter', 'latex');
        zlabel(ax, '$f_3$', 'interpreter', 'latex');

        if IsSplitDraw
            legend(ax, plot_handles, legend_entries, 'Location', 'best');
        end

        title(ax, strrep(app.EUITable.RowName(prob_list(i)), '_', '\_'),'FontWeight',style.TitleFontWeight)
        view(ax,[135 30]);
        grid(ax, 'on');
    else % M > 3
        % draw each algorithm
        color_list = style.ColorOrder;
        min_data = []; max_data = [];
        for j = 1:size(app.EResultTableData, 2)
            metric_data = squeeze(app.EResultTableData(prob_list(i), j, :));
            [~, rank] = sort(metric_data);
            mid_idx = rank(ceil(end / 2));

            data = app.EResultParetoData.Obj{prob_list(i), j, mid_idx};
            min_data = min([data; min_data],[],1);
            max_data = max([data; max_data],[],1);
        end
        for j = 1:length(algo_list)
            metric_data = squeeze(app.EResultTableData(prob_list(i), algo_list(j), :));
            [~, rank] = sort(metric_data);
            mid_idx = rank(ceil(end / 2));

            data = app.EResultParetoData.Obj{prob_list(i), algo_list(j), mid_idx};
            % data = (data - min_data) ./ (max_data - min_data); % Unify
            for k = 1:size(app.EResultParetoData.Obj{prob_list(i), algo_list(j), mid_idx}, 1)
                p(j) = plot(ax, data(k,:));
                p(j).Color = color_list(mod(j-1, size(color_list, 1))+1, :);
                p(j).LineWidth = style.LineWidth;
                hold(ax, 'on');
            end
            if IsSplitDraw
                legend_entries{end+1} = char(strrep(app.EUITable.ColumnName(algo_list(j)), '_', '\_'));
                plot_handles(end+1) = p(j);
            else
                if i == 1
                    legend_entry = char(strrep(app.EUITable.ColumnName(algo_list(j)), '_', '\_'));
                    all_plot_handles(end + 1) = p(j);
                    all_legend_entries{end + 1} = legend_entry;
                end
            end
        end

        % ylim([0,1]); % Unify
        xlabel(ax, 'Dimension', 'interpreter', 'latex');
        ylabel(ax, '$f$', 'interpreter', 'latex');

        if IsSplitDraw
            legend(ax, plot_handles, legend_entries, 'Location', 'best');
        end

        title(ax, strrep(app.EUITable.RowName(prob_list(i)), '_', '\_'),'FontWeight',style.TitleFontWeight)
        grid(ax, 'on');
    end
    if IsSplitDraw
        set(ax,'OuterPosition',[0,0,1,1]);
        PlotStyle(ax);
        set(ax,'LooseInset',get(ax,'TightInset')+0.02)
    else
        PlotStyle(ax);
        set(ax,'LooseInset',get(ax,'TightInset')+0.02)
    end
    if M <= 3, pbaspect(ax, [1, 1, 1]); else, pbaspect(ax, [4, 3, 1]); end
end
if ~IsSplitDraw
    lgd = legend(ax, all_plot_handles, all_legend_entries, 'Orientation', 'horizontal', 'FontName', style.FontName, 'FontSize', style.SharedLegendFontSize);
    lgd.Layout.Tile = 'south';
end
end
