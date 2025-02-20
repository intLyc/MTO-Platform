function rank = sort_E(obj, cv, epsilon, varargin)
%% Feasible Priority Sort
cv(cv <= epsilon) = 0;
[~, rank] = sortrows([cv', obj'], [1, 2]);
rank = rank';
end
