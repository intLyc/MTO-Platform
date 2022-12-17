function rank = sort_EC(Obj, CV, ep)
%% Epsilon Constraint Sort
Obj = reshape(Obj, length(Obj), 1);
CV = reshape(CV, length(CV), 1);
CV(CV <= ep) = 0;
[~, rank] = sortrows([CV, Obj], [1, 2]);
rank = rank';
end
