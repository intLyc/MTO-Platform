function rank = sort_FP(Obj, CV, varargin)
%% Feasible Priority Sort
Obj = reshape(Obj, length(Obj), 1);
CV = reshape(CV, length(CV), 1);
[~, rank] = sortrows([CV, Obj], [1, 2]);
rank = rank';
end
