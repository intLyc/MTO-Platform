function result = ComputeObjectiveMetric(data, field, aggregation)
% Read single-objective histories once and optionally aggregate across tasks.
perTask = strcmp(aggregation, 'task');
result = CreateMetricResult(data, 'Min', false, perTask);
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
            record = data.Results(p, a, r);
            history = record.(field);
            if strcmp(field, 'Obj'), history(record.CV > 0) = NaN; end
            values(r, :, :) = reshape(history, 1, problem.T, count);
        end
        if perTask
            for t = 1:problem.T
                history = reshape(values(:, t, :), data.Reps, count);
                result = StoreMetricHistory(result, row + t - 1, a, history, problem.maxFE / problem.T);
            end
        else
            switch aggregation
                case 'mean', history = mean(values, 2);
                case 'min', history = min(values, [], 2);
            end
            result = StoreMetricHistory(result, p, a, reshape(history, data.Reps, count), problem.maxFE);
        end
    end
    row = row + problem.T;
end
end
