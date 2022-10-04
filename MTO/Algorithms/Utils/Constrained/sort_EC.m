function rank = sort_EC(Obj, CV, ep)
    %% Epsilon Constraint Sort
    CV(CV <= ep) = 0;
    [~, rank] = sortrows([CV', Obj'], [1, 2]);
    rank = rank';
end
