function output = ProcessMTOData(input, operation, argument)
% Transform value copies of MTOData; source datasets are never modified.
% Split/merge dimensions: 1 = problems, 2 = algorithms, 3 = repetitions.
% Relative metrics are discarded; absolute metrics follow the same transformation.

if strcmp(operation, 'merge')
    output = mergeData(input, argument);
    return;
end
ValidateMTOData(input);
switch operation
    case 'split'
        validateattributes(argument, {'numeric'}, {'scalar', 'integer', '>=', 1, '<=', 3});
        counts = [numel(input.Problems), numel(input.Algorithms), input.Reps];
        output = cell(1, counts(argument));
        for i = 1:counts(argument)
            data = clearMetrics(input);
            indices = {':', ':', ':'};
            indices{argument} = i;
            data.Results = input.Results(indices{:});
            data.RunTimes = input.RunTimes(indices{:});
            switch argument
                case 1, data.Problems = input.Problems(i);
                case 2, data.Algorithms = input.Algorithms(i);
                case 3, data.Reps = 1;
            end
            output{i} = ProcessDataMetrics({input}, data, 'split', argument, i);
        end
    case 'reduce'
        validateattributes(argument, {'numeric'}, {'scalar', 'integer', 'positive', 'finite'});
        output = reduceData(clearMetrics(input), argument);
        output = ProcessDataMetrics({input}, output, 'reduce', argument);
    case 'precision'
        validateattributes(argument, {'numeric'}, {'scalar', 'integer', 'finite'});
        output = clearMetrics(input);
        % Round objectives and violations only; keep decisions and times intact.
        for i = 1:numel(output.Results)
            if iscell(output.Results(i).Obj)
                output.Results(i).Obj = cellfun(@(value) round(value, -argument), ...
                    output.Results(i).Obj, 'UniformOutput', false);
            else
                output.Results(i).Obj = round(output.Results(i).Obj, -argument);
            end
            output.Results(i).CV = round(output.Results(i).CV, -argument);
        end
        output = ProcessDataMetrics({input}, output, 'precision', argument);
    otherwise
        error('MToP:UnknownDataOperation', 'Unknown data operation: %s.', operation);
end
end

function data = clearMetrics(data)
% Metrics may depend on all algorithms/repetitions, even when stored per row.
if isfield(data, 'Metrics')
    data = rmfield(data, 'Metrics');
end
end

function data = reduceData(data, count)
for i = 1:numel(data.Results)
    record = data.Results(i);
    if iscell(record.Obj)
        record.Obj = cellfun(@(value) SampleDataHistory(value, 1, count), ...
            record.Obj, 'UniformOutput', false);
    else
        record.Obj = SampleDataHistory(record.Obj, 2, count);
    end
    record.CV = SampleDataHistory(record.CV, 2, count);
    if isfield(record, 'Dec')
        record.Dec = SampleDataHistory(record.Dec, 2, count);
    end
    data.Results(i) = record;
end
end

function data = mergeData(inputs, dimension)
validateattributes(dimension, {'numeric'}, {'scalar', 'integer', '>=', 1, '<=', 3});
if ~iscell(inputs) || numel(inputs) < 2
    error('MToP:MergeSelection', 'Select at least two datasets to merge.');
end
for i = 1:numel(inputs)
    ValidateMTOData(inputs{i});
    if i > 1
        checkCompatibility(inputs{1}, inputs{i}, dimension);
    end
end
% Align every history, including repetitions with different recording lengths.
count = Inf;
for i = 1:numel(inputs)
    count = min(count, min(arrayfun(@(record) size(record.CV, 2), inputs{i}.Results(:))));
end
sources = inputs;
saveDec = all(cellfun(@(data) isfield(data.Results, 'Dec'), inputs));
for i = 1:numel(inputs)
    inputs{i} = reduceData(clearMetrics(inputs{i}), count);
    if ~saveDec && isfield(inputs{i}.Results, 'Dec')
        inputs{i}.Results = rmfield(inputs{i}.Results, 'Dec');
    end
end
data = inputs{1};
for i = 2:numel(inputs)
    next = inputs{i};
    data.Results = cat(dimension, data.Results, next.Results);
    data.RunTimes = cat(dimension, data.RunTimes, next.RunTimes);
    switch dimension
        case 1, data.Problems = concatenateMetadata(data.Problems, next.Problems);
        case 2, data.Algorithms = concatenateMetadata(data.Algorithms, next.Algorithms);
        case 3, data.Reps = data.Reps + next.Reps;
    end
end
data = ProcessDataMetrics(sources, data, 'merge', dimension, count);
ValidateMTOData(data);
end

function checkCompatibility(first, next, dimension)
if dimension ~= 3 && first.Reps ~= next.Reps
    error('MToP:IncompatibleReps', 'Datasets must have the same repetition count.');
end
if dimension ~= 2 && ~isequaln(first.Algorithms(:), next.Algorithms(:))
    error('MToP:IncompatibleAlgorithms', 'Datasets must have the same algorithms and parameters in the same order.');
end
if dimension ~= 1
    if numel(first.Problems) ~= numel(next.Problems)
        error('MToP:IncompatibleProblems', 'Datasets must have the same problems in the same order.');
    end
    fields = {'Name', 'T', 'M', 'D', 'N', 'maxFE', 'Lb', 'Ub', 'Optimum'};
    for prob = 1:numel(first.Problems)
        for i = 1:numel(fields)
            field = fields{i};
            left = isfield(first.Problems, field);
            right = isfield(next.Problems, field);
            if left ~= right || (left && ~isequaln(first.Problems(prob).(field), next.Problems(prob).(field)))
                error('MToP:IncompatibleProblems', 'Problem %d differs in %s.', prob, field);
            end
        end
    end
end
end

function combined = concatenateMetadata(first, next)
% Single- and multi-objective problems can have different optional metadata.
fields = union(fieldnames(first), fieldnames(next), 'stable');
for i = 1:numel(fields)
    field = fields{i};
    if ~isfield(first, field), [first.(field)] = deal([]); end
    if ~isfield(next, field), [next.(field)] = deal([]); end
end
combined = [first(:).', orderfields(next(:).', first)];
end
