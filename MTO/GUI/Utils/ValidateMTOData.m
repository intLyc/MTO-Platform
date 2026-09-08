function ValidateMTOData(data)
% Check the dimensions shared by metadata, results, and run times.
required = {'Reps', 'Problems', 'Algorithms', 'Results', 'RunTimes'};
if ~isstruct(data) || ~isscalar(data) || ~all(isfield(data, required))
    error('MToP:InvalidData', 'MTOData must contain Reps, Problems, Algorithms, Results, and RunTimes.');
end
validateattributes(data.Reps, {'numeric'}, {'scalar', 'integer', 'positive', 'finite'});
shape = [numel(data.Problems), numel(data.Algorithms), data.Reps];
if any(shape == 0) || ~isstruct(data.Problems) || ~isstruct(data.Algorithms) || ...
        ~isstruct(data.Results) || ~all(isfield(data.Results, {'Obj', 'CV'})) || ...
        ~isequal([size(data.Results, 1), size(data.Results, 2), size(data.Results, 3)], shape) || ...
        ~isequal([size(data.RunTimes, 1), size(data.RunTimes, 2), size(data.RunTimes, 3)], shape) || ...
        ndims(data.Results) > 3 || ndims(data.RunTimes) > 3
    error('MToP:InvalidDataShape', 'Results and RunTimes must match Problems x Algorithms x Reps.');
end
for i = 1:numel(data.Results)
    [prob, ~, ~] = ind2sub(shape, i);
    record = data.Results(i);
    tasks = data.Problems(prob).T;
    count = size(record.CV, 2);
    if count == 0 || size(record.CV, 1) ~= tasks
        error('MToP:InvalidHistory', 'Result %d has an empty history or an incorrect task count.', i);
    end
    if iscell(record.Obj)
        aligned = numel(record.Obj) == tasks && ...
            all(cellfun(@(value) size(value, 1) == count, record.Obj));
    else
        aligned = size(record.Obj, 1) == tasks && size(record.Obj, 2) == count;
    end
    if isfield(record, 'Dec') && ~isempty(record.Dec)
        aligned = aligned && size(record.Dec, 1) == tasks && size(record.Dec, 2) == count;
    end
    if ~aligned
        error('MToP:InvalidHistory', 'Result %d has inconsistent Obj, CV, or Dec history dimensions.', i);
    end
end
end
