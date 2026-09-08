function [rows, cols] = PlotGridSize(count)
% Use at most five columns: 7 gives 4+3, 10 gives 5+5, and 12 gives 4+4+4.
rows = max(1, ceil(count / 5));
cols = max(1, ceil(count / rows));
end
