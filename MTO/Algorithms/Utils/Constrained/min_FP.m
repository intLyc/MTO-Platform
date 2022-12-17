function [minObj, minCV, min_idx] = min_FP(Obj, CV, varargin)
%% Minimal Feasible Priority / Epsilon Constraint

n = numel(varargin);
if n == 0
    ep = 0;
elseif n == 1
    ep = varargin{1};
end
CV(CV <= ep) = 0;

minCV = min(CV);
idx_min_cv = find(CV == minCV);
obj_temp = Obj(idx_min_cv);
[minObj, idx_temp] = min(obj_temp);
min_idx = idx_min_cv(idx_temp);
end
