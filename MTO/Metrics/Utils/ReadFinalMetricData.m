function values = ReadFinalMetricData(data, field)
% Read only final single-objective values for summary metrics such as FR/NBR.
values = [];
if any([data.Problems.M] ~= 1), return; end
values = zeros(sum([data.Problems.T]), numel(data.Algorithms), data.Reps);
first = 1;
for p = 1:numel(data.Problems)
    rows = first:first + data.Problems(p).T - 1;
    for a = 1:numel(data.Algorithms)
        for r = 1:data.Reps
            record = data.Results(p, a, r);
            history = record.(field);
            final = history(:, end);
            if strcmp(field, 'Obj'), final(record.CV(:, end) > 0) = NaN; end
            values(rows, a, r) = final;
        end
    end
    first = first + data.Problems(p).T;
end
end
