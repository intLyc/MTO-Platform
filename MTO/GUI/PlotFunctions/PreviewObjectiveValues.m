function values = PreviewObjectiveValues(objectives, feasible, unified)
% Select and normalize the objective values used by task previews.

% Show the first objective; constant feasible slices normalize to zero.
values = objectives(:, 1);
values(~feasible | ~isfinite(values)) = NaN;
valid = isfinite(values);
if unified && any(valid)
    low = min(values(valid));
    span = max(values(valid)) - low;
    if span > 0
        values(valid) = (values(valid) - low) / span;
    else
        values(valid) = 0;
    end
end
end
