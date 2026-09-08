function position = PlotFigurePosition(rows, cols, tileSize)
% tileSize specifies subplot pixels; scale both window dimensions equally to fit the screen.
units = get(groot, 'Units');
% Restore global units after computing pixel dimensions, including on errors.
cleanup = onCleanup(@() set(groot, 'Units', units)); %#ok<NASGU>
set(groot, 'Units', 'pixels');
screen = get(groot, 'ScreenSize');
figureSize = [cols, rows] .* tileSize + [40, 70]; % Labels, title, and legend space.
available = max([1, 1], screen(3:4) - [80, 120]);
scale = min([1, available ./ figureSize]);
figureSize = max([1, 1], floor(figureSize * scale));
position = [screen(1:2) + (screen(3:4) - figureSize) / 2, figureSize];
end
