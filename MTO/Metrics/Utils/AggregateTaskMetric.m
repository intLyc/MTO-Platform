function result = AggregateTaskMetric(data, base, result, aggregate, preserveTaskX)
% Traverse problem slices of a base metric; all task arithmetic is in aggregate.
% aggregate(values) maps task-by-algorithm-by-repetition-by-checkpoint data
% to one-by-algorithm-by-repetition-by-checkpoint data.
% preserveTaskX keeps sampled base coordinates, scaled to the problem budget.
result.ConvergeData.X = [];
result.ConvergeData.Y = [];
if isempty(base.TableData), return; end
row = 1;
for p = 1:numel(data.Problems)
    problem = data.Problems(p);
    rows = row:row + problem.T - 1;
    average = aggregate(base.ConvergeData.Y(rows, :, :, :));
    for a = 1:numel(data.Algorithms)
        history = reshape(average(1, a, :, :), data.Reps, []);
        result = StoreMetricHistory(result, p, a, history, problem.maxFE);
    end
    if preserveTaskX
        result.ConvergeData.X(p, :, :, :) = base.ConvergeData.X(row, :, :, :) * problem.T;
    end
    row = row + problem.T;
end
end
