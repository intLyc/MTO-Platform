function result = AggregateTaskMetric(data, baseName, aggregation, varargin)
% Aggregate task metrics, reusing an existing base cache when available.
base = [];
if isfield(data, 'Metrics')
    index = find(strcmp({data.Metrics.Name}, baseName), 1);
    if ~isempty(index), base = data.Metrics(index).Result; end
end
if isempty(base), base = feval(baseName, data, varargin{:}); end
relative = base.IsRelative || ~strcmp(aggregation, 'mean');
result = CreateMetricResult(data, base.Metric, relative, false);
result.ConvergeData.X = [];
result.ConvergeData.Y = [];
if isempty(base.TableData), return; end
row = 1;
for p = 1:numel(data.Problems)
    problem = data.Problems(p);
    rows = row:row + problem.T - 1;
    values = base.ConvergeData.Y(rows, :, :, :);
    switch aggregation
        case 'mts'
            % Standardize each task/checkpoint over all algorithms and repetitions.
            for t = 1:problem.T
                for g = 1:size(values, 4)
                    sample = values(t, :, :, g);
                    if strcmp(baseName, 'Obj'), center = mean(sample, 'all', 'omitnan');
                    else, center = mean(sample, 'all'); end
                    scale = std(sample, 0, 'all');
                    if scale == 0, values(t, :, :, g) = 0;
                    else, values(t, :, :, g) = (sample - center) ./ scale; end
                end
            end
        case 'unified'
            % Normalize over the complete history of each task.
            for t = 1:problem.T
                sample = values(t, :, :, :);
                lower = min(sample, [], 'all');
                upper = max(sample, [], 'all');
                values(t, :, :, :) = (sample - lower) / (upper - lower);
            end
    end
    average = mean(values, 1);
    for a = 1:numel(data.Algorithms)
        history = reshape(average(1, a, :, :), data.Reps, []);
        result = StoreMetricHistory(result, p, a, history, problem.maxFE);
    end
    if strcmp(aggregation, 'mean')
        % Cached curves may already have been sampled at specific FE coordinates.
        result.ConvergeData.X(p, :, :, :) = base.ConvergeData.X(row, :, :, :) * problem.T;
    end
    row = row + problem.T;
end
end
