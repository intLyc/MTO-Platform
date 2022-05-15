function [min_obj, min_cv, min_idx] = min_FP(obj, cv)
    %% Feasible Priority Sort
    min_cv = min(cv);
    idx_min_cv = find(cv == min_cv);
    obj_temp = obj(idx_min_cv);
    [min_obj, idx_temp] = min(obj_temp);
    min_idx = idx_min_cv(idx_temp);
end
