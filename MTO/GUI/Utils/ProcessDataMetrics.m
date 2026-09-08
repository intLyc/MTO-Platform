function output = ProcessDataMetrics(inputs, output, operation, argument, index)
% Retain compatible absolute caches and discard metrics that need a new comparison.
if nargin < 5, index = []; end
if isfield(output, 'Metrics'), output = rmfield(output, 'Metrics'); end
if ~all(cellfun(@(data) isfield(data, 'Metrics') && ~isempty(data.Metrics), inputs))
    return;
end
names = {inputs{1}.Metrics.Name};
for i = 2:numel(inputs)
    names = intersect(names, {inputs{i}.Metrics.Name}, 'stable');
end
for i = 1:numel(names)
    entries = cell(size(inputs));
    for j = 1:numel(inputs)
        entries{j} = inputs{j}.Metrics(strcmp({inputs{j}.Metrics.Name}, names{i}));
    end
    if ~all(cellfun(@isAbsolute, entries)), continue; end
    try
        results = cellfun(@(entry) entry.Result, entries, 'UniformOutput', false);
        for j = 1:numel(inputs), checkLayout(results{j}, inputs{j}); end
        % Rounding raw objectives/violations can change feasibility and nonlinear metrics.
        % Repetition summaries (for example FR) also need fresh aggregation.
        summary = strcmp(names{i}, 'FR') || any(cellfun(@(result, data) ...
            size(result.TableData, 3) ~= data.Reps, results, inputs));
        recalculate = strcmp(operation, 'precision') || ...
            (any(strcmp(operation, {'split', 'merge'})) && argument == 3 && summary);
        if recalculate
            if exist(names{i}, 'file') ~= 2, continue; end
            result = feval(names{i}, output);
            checkLayout(result, output);
        else
            switch operation
                case 'split'
                    result = splitMetric(results{1}, inputs{1}, argument, index);
                case 'merge'
                    results = cellfun(@(result) reduceMetric(result, index), results, 'UniformOutput', false);
                    result = mergeMetrics(results, argument);
                case 'reduce'
                    result = reduceMetric(results{1}, argument);
            end
            checkLayout(result, output);
        end
        entry = entries{1};
        entry.Result = result;
        if ~isAbsolute(entry), continue; end
        if ~isfield(output, 'Metrics'), output.Metrics = entry;
        else, output.Metrics(end+1) = entry; end
    catch
        % An incompatible cache is optional; raw results remain available for recalculation.
    end
end
end

function valid = isAbsolute(entry)
% Old files may contain incorrect flags for these built-in relative metrics.
relative = {'Obj_NBR', 'Obj_UV', 'Obj_MTS', 'IGD_MTS', 'IGDp_MTS'};
valid = isscalar(entry) && ~ismember(entry.Name, relative) && ...
    isfield(entry.Result, 'IsRelative') && isequal(entry.Result.IsRelative, false);
end

function checkLayout(result, data)
rows = numel(result.RowName);
assert(rows == numel(data.Problems) || rows == sum([data.Problems.T]));
assert(~isempty(result.TableData) && size(result.TableData, 1) == rows && ...
    size(result.TableData, 2) == numel(data.Algorithms) && ...
    numel(result.ColumnName) == numel(data.Algorithms) && ...
    ismember(size(result.TableData, 3), [1, data.Reps]) && ndims(result.TableData) <= 3);
if isfield(result, 'ConvergeData')
    curve = result.ConvergeData;
    assert(isequal(size(curve.X), size(curve.Y)) && size(curve.X, 1) == rows && ...
        size(curve.X, 2) == numel(data.Algorithms) && size(curve.X, 3) == data.Reps && ...
        ndims(curve.X) <= 4 && ~isempty(curve.X));
end
if isfield(result, 'ParetoData')
    front = result.ParetoData;
    assert(numel(front.Optimum) == rows && size(front.Obj, 1) == rows && ...
        size(front.Obj, 2) == numel(data.Algorithms) && size(front.Obj, 3) == data.Reps);
end
end

function result = splitMetric(result, data, dimension, index)
indices = {':', ':', ':'};
indices{dimension} = index;
if dimension == 1
    % Metrics use either one row per problem or one row per task.
    if numel(result.RowName) ~= numel(data.Problems)
        first = sum([data.Problems(1:index-1).T]) + 1;
        indices{1} = first:first + data.Problems(index).T - 1;
    end
    result.RowName = result.RowName(indices{1});
elseif dimension == 2
    result.ColumnName = result.ColumnName(index);
end
result.TableData = result.TableData(indices{:});
if isfield(result, 'ConvergeData')
    result.ConvergeData.X = result.ConvergeData.X(indices{:}, :);
    result.ConvergeData.Y = result.ConvergeData.Y(indices{:}, :);
end
if isfield(result, 'ParetoData')
    result.ParetoData.Obj = result.ParetoData.Obj(indices{:});
    if dimension == 1
        result.ParetoData.Optimum = result.ParetoData.Optimum(indices{1});
    end
end
end

function result = reduceMetric(result, count)
% Preserve the recorded FE coordinates and the final table/front values.
if isfield(result, 'ConvergeData')
    result.ConvergeData.X = SampleDataHistory(result.ConvergeData.X, 4, count);
    result.ConvergeData.Y = SampleDataHistory(result.ConvergeData.Y, 4, count);
end
end

function result = mergeMetrics(results, dimension)
result = results{1};
for i = 2:numel(results)
    next = results{i};
    assert(isequal(sort(fieldnames(result)), sort(fieldnames(next))) && strcmp(result.Metric, next.Metric));
    if dimension ~= 1, assert(isequal(result.RowName(:), next.RowName(:))); end
    if dimension ~= 2, assert(isequal(result.ColumnName(:), next.ColumnName(:))); end
    result.TableData = cat(dimension, result.TableData, next.TableData);
    if dimension == 1
        result.RowName = [result.RowName(:).', next.RowName(:).'];
    elseif dimension == 2
        result.ColumnName = [result.ColumnName(:).', next.ColumnName(:).'];
    end
    if isfield(result, 'ConvergeData')
        result.ConvergeData.X = cat(dimension, result.ConvergeData.X, next.ConvergeData.X);
        result.ConvergeData.Y = cat(dimension, result.ConvergeData.Y, next.ConvergeData.Y);
    end
    if isfield(result, 'ParetoData')
        result.ParetoData.Obj = cat(dimension, result.ParetoData.Obj, next.ParetoData.Obj);
        if dimension == 1
            result.ParetoData.Optimum = [result.ParetoData.Optimum(:).', next.ParetoData.Optimum(:).'];
        else
            assert(isequaln(result.ParetoData.Optimum(:), next.ParetoData.Optimum(:)));
        end
    end
end
end
