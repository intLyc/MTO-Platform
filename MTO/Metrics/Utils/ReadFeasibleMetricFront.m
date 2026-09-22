function front = ReadFeasibleMetricFront(record, tasks, generation)
% Pool feasible objective rows for the requested tasks and checkpoint.
parts = cell(1, numel(tasks));
for i = 1:numel(tasks)
    task = tasks(i);
    history = record.Obj{task};
    % Explicit dimensions also handle a population containing one individual.
    objectives = reshape(history(generation, :, :), size(history, 2), size(history, 3));
    violations = reshape(record.CV(task, generation, :), [], 1);
    parts{i} = objectives(violations <= 0, :);
end
front = vertcat(parts{:});
end
