function front = NondominatedMetricFront(front)
% Keep the first nondominated front without changing the empty-array shape.
if ~isempty(front), front = front(NDSort(front, 1) == 1, :); end
end
