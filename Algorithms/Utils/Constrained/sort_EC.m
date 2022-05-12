function rank = sort_EC(obj, cv, ep)
    %% Epsilon Constraint Sort
    cv(cv < ep) = 0;
    [~, rank] = sortrows([cv'; obj']);
    rank = rank';
end
