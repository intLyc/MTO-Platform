function data = SampleDataHistory(data, dimension, count)
% Reduce one array dimension without flattening population or objective axes.
validateattributes(count, {'numeric'}, {'scalar', 'integer', 'positive', 'finite'});
length = size(data, dimension);
if length <= count
    return;
end
indices = ceil((1:count) * (length / count));
indices(1) = 1;
indices(end) = length; % A single sample retains the final result.
subscripts = repmat({':'}, 1, max(ndims(data), dimension));
subscripts{dimension} = indices;
data = data(subscripts{:});
end
