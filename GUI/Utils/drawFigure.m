classdef drawFigure < handle

    properties
        x_cell % contains {x1, x2, ...}
        y_cell % contains {y1, y2, ...}
        title_str
        xlabel_str
        ylabel_str
        legend_cell % contains {legend1, legend2}
        save_dir = './'
        figure_type = 'png'
        marker_indices = 10
    end

    methods
        function obj = setXY(obj, x_cell, y_cell)
            obj.x_cell = x_cell;
            obj.y_cell = y_cell;
        end

        function obj = setTitle(obj, title_str)
            obj.title_str = title_str;
        end

        function obj = setXYlabel(obj, xlabel_str, ylabel_str)
            obj.xlabel_str = xlabel_str;
            obj.ylabel_str = ylabel_str;
        end

        function obj = setXLabel(obj, xlabel_str)
            obj.xlabel_str = xlabel_str;
        end

        function obj = setYLabel(obj, ylabel_str)
            obj.ylabel_str = ylabel_str;
        end

        function obj = setLegend(obj, legend_cell)
            obj.legend_cell = legend_cell;
        end

        function obj = setSaveDir(obj, save_dir)
            obj.save_dir = save_dir;
        end

        function obj = setFigureType(obj, figure_type)
            obj.figure_type = figure_type;
        end

        function obj = setMarkerIndices(obj, marker_indices)
            obj.marker_indices = marker_indices;
        end

        function obj = save(obj)
            fig = figure('Visible', 'off');

            marker_list = {'o', '*', 'x', '^', '+', 'p', 'v', 's', 'd', '<', '>', 'h'};

            for i = 1:length(obj.x_cell)
                if i <= length(marker_list)
                    marker = marker_list{i};
                else
                    marker = '';
                end
                p = plot(obj.x_cell{i}, obj.y_cell{i}, ['-', marker]);
                p.LineWidth = 1;
                indices = round(length(obj.y_cell{i}) / obj.marker_indices);
                p.MarkerIndices = indices:indices:length(obj.y_cell{i}) - round(indices / 2);
                p.MarkerSize = 5;
                hold on;
            end

            if ~isempty(obj.title_str)
                title(strrep(obj.title_str, '_', '-'));
            end
            if ~isempty(obj.xlabel_str)
                xlabel(strrep(obj.xlabel_str, '_', '\_'));
            end
            if ~isempty(obj.ylabel_str)
                ylabel(strrep(obj.ylabel_str, '_', '\_'));
            end
            if ~isempty(obj.legend_cell)
                legend(strrep(obj.legend_cell, '_', '\_'));
            end

            file_name = [obj.save_dir, obj.title_str, '.', obj.figure_type];

            exportgraphics(fig, file_name);
        end
    end
end
