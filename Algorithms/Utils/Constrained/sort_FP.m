function rank = sort_FP(obj, cv, varargin)
    %% Feasible Priority Sort
    [~, rank] = sortrows([cv', obj'], [1, 2]);
    rank = rank';
end
