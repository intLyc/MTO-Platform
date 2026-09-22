function result = ReadMetricResult(data, name, varargin)
% Reuse the first cached base metric, or calculate it through its public entry.
result = [];
if isfield(data, 'Metrics')
    index = find(strcmp({data.Metrics.Name}, name), 1);
    if ~isempty(index), result = data.Metrics(index).Result; end
end
if isempty(result), result = feval(name, data, varargin{:}); end
end
