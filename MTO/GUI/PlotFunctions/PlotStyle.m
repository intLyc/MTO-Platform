function style = PlotStyle(ax, context)
% Edit this file to customize GUI plots. Changes apply the next time a plot is drawn.
% Marker sizes use points; scatter sizes use square points. Colors are RGB rows.

style.MarkerList = {'o', '*', 'x', '^', '+', 'p', 'v', 's', 'd', '<', '>', 'h'};
style.MarkerSize = 7;
style.MarkerNum = 10;
style.LineWidth = 1.5;
style.ColorOrder = get(groot, 'DefaultAxesColorOrder');

style.FontName = 'Helvetica';
style.FontSize = 12;
style.FontWeight = 'bold';
style.TestFontWeight = 'normal';
style.TitleFontWeight = 'bold';
style.LabelFontSizeMultiplier = 1.1;
style.TitleFontSizeMultiplier = 1.1;
style.LegendFontSize = 12;
style.SharedLegendFontSize = 14;
style.SharedLabelFontSize = 16;

style.PopulationPointSize = 40;
style.ReferencePointSize = 3;
style.PointAlpha = 0.65;
style.ReferenceLineWidth = 2;
style.ReferenceLineColor = [0.2, 0.2, 0.2];
style.ReferencePointColor = [0.5, 0.5, 0.5];
style.RangeAlpha = 0.2;

style.PreviewLineWidth = 1;
style.MinimumMarker = '^';
style.MinimumMarkerSize = 8;
style.SurfaceAlpha = 0.15;
style.FeasiblePointSize = 6;
style.FeasiblePointAlpha = 0.6;

% Apply typography after drawing, because plot/cla may reset axes properties.
if nargin == 0, return; end
weight = style.FontWeight;
if nargin > 1 && strcmp(context, 'Test'), weight = style.TestFontWeight; end
set(ax, 'FontName', style.FontName, 'FontSize', style.FontSize, ...
    'FontWeight', weight, 'ColorOrder', style.ColorOrder, ...
    'LabelFontSizeMultiplier', style.LabelFontSizeMultiplier, ...
    'TitleFontSizeMultiplier', style.TitleFontSizeMultiplier);
ax.Title.FontWeight = style.TitleFontWeight;
if ~isempty(ax.Legend)
    set(ax.Legend, 'FontName', style.FontName, 'FontSize', style.LegendFontSize);
end
end
