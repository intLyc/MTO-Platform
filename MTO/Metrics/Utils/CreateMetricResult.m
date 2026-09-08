function result = CreateMetricResult(data, direction, relative, perTask)
% Initialize the shared metric schema and its problem/task row labels.
result.Metric = direction;
result.IsRelative = relative;
result.RowName = {};
result.ColumnName = {data.Algorithms.Name};
result.TableData = [];
for p = 1:numel(data.Problems)
    problem = data.Problems(p);
    if perTask && problem.T > 1
        names = arrayfun(@(t) sprintf('%s-T%d', problem.Name, t), ...
            1:problem.T, 'UniformOutput', false);
    else
        names = {problem.Name};
    end
    result.RowName = [result.RowName, names];
end
end
