function result = StoreMetricHistory(result, row, algorithm, values, budget)
% Store a repetitions-by-checkpoints matrix without squeezing singleton axes.
reps = size(values, 1);
count = size(values, 2);
result.TableData(row, algorithm, 1:reps) = values(:, end);
result.ConvergeData.Y(row, algorithm, 1:reps, 1:count) = reshape(values, 1, 1, reps, count);
x = (1:count) ./ count .* budget;
result.ConvergeData.X(row, algorithm, 1:reps, 1:count) = repmat(reshape(x, 1, 1, 1, count), 1, 1, reps, 1);
end
