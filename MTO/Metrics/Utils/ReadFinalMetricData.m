function values = ReadFinalMetricData(data, readFinal)
% Collect task-by-one final values supplied by a summary metric's callback.
values = [];
if any([data.Problems.M] ~= 1), return; end
values = zeros(sum([data.Problems.T]), numel(data.Algorithms), data.Reps);
first = 1;
for p = 1:numel(data.Problems)
    rows = first:first + data.Problems(p).T - 1;
    for a = 1:numel(data.Algorithms)
        for r = 1:data.Reps
            values(rows, a, r) = readFinal(data.Results(p, a, r));
        end
    end
    first = first + data.Problems(p).T;
end
end
