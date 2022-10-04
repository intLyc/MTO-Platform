function rank = sort_FP(Obj, CV, varargin)
    %% Feasible Priority Sort
    [~, rank] = sortrows([CV', Obj'], [1, 2]);
    rank = rank';
end
