function rank = sort_EC(obj, cv, ep)
    %% Epsilon Constraint Sort
    cv(cv <= ep) = 0;
    [~, rank] = sortrows([cv', obj'], [1, 2]);
    rank = rank';
end
