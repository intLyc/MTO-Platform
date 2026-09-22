function result = ComputeObjectiveMetric(data, result, perTask, readHistory, aggregate)
% Traverse single-objective records; the metric supplies all value calculations.
% readHistory(record) returns task-by-checkpoint values. For problem-level
% metrics, aggregate(values) reduces repetitions-by-tasks-by-checkpoints to
% repetitions-by-one-by-checkpoints. The aggregate callback is unused per task.
result.ConvergeData.X = [];
result.ConvergeData.Y = [];
if any([data.Problems.M] ~= 1), return; end
row = 1;
for p = 1:numel(data.Problems)
    problem = data.Problems(p);
    for a = 1:numel(data.Algorithms)
        count = size(data.Results(p, a, 1).CV, 2);
        values = zeros(data.Reps, problem.T, count);
        for r = 1:data.Reps
            history = readHistory(data.Results(p, a, r));
            values(r, :, :) = reshape(history, 1, problem.T, count);
        end
        if perTask
            for t = 1:problem.T
                history = reshape(values(:, t, :), data.Reps, count);
                result = StoreMetricHistory(result, row + t - 1, a, history, problem.maxFE / problem.T);
            end
        else
            history = aggregate(values);
            result = StoreMetricHistory(result, p, a, reshape(history, data.Reps, count), problem.maxFE);
        end
    end
    row = row + problem.T;
end
end
