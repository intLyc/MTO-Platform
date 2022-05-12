function rank = sort_FP(obj, cv)
    %% Feasible Priority Sort
    [~, rank] = sortrows([cv'; obj']);
    rank = rank';
end
