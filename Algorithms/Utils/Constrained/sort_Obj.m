function rank = sort_Obj(obj, cv, varargin)
    %% Feasible Priority Sort
    [~, rank] = sort(obj);
    rank = rank';
end
