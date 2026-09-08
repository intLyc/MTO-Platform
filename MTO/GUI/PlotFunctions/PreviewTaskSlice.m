function [vars, objectives, feasible] = PreviewTaskSlice(prob, task, coordinates)
% Evaluate a task slice with unplotted variables fixed at bound midpoints.

% Vary the plotted variables and hold all others at their bound midpoints.
lb = prob.Lb{task};
ub = prob.Ub{task};
vars = repmat((lb + ub) / 2, size(coordinates, 1), 1);
dims = 1:size(coordinates, 2);
vars(:, dims) = lb(dims) + coordinates .* (ub(dims) - lb(dims));
[objectives, constraints] = prob.evaluate(vars, task);
feasible = all(constraints <= 0, 2);
end
