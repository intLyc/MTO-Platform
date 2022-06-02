function rank = sort_Obj(obj, cv, varargin)
    %% Feasible Priority Sort
    [~, rank] = sortrows([obj', cv'], [1, 2]);
    rank = rank';
end
