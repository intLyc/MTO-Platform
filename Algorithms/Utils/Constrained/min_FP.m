function [min_obj, min_cv, min_idx] = min_FP(obj, cv, varargin)
    %% Minimal Feasible Priority / Epsilon Constraint

    n = numel(varargin);
    if n == 0
        ep = 0;
    elseif n == 1
        ep = varargin{1};
    end
    cv(cv <= ep) = 0;

    min_cv = min(cv);
    idx_min_cv = find(cv == min_cv);
    obj_temp = obj(idx_min_cv);
    [min_obj, idx_temp] = min(obj_temp);
    min_idx = idx_min_cv(idx_temp);
end
