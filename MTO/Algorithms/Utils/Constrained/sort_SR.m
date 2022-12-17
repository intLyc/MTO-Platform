function idx = sort_SR(Obj, CV, sr)
%% Stochastic Ranking Sort
idx = 1:length(Obj);
for i = 1:length(Obj)
    swap = 0;
    for j = 1:length(Obj) - i
        if (0 == CV(j) && 0 == CV(j + 1)) || rand() < sr
            if Obj(j) > Obj(j + 1)
                t = idx(j); t_obj = Obj(j); t_cv = CV(j);
                idx(j) = idx(j + 1); Obj(j) = Obj(j + 1); CV(j) = CV(j + 1);
                idx(j + 1) = t; Obj(j + 1) = t_obj; CV(j + 1) = t_cv;
                swap = 1;
            end
        else
            if CV(j) > CV(j + 1)
                t = idx(j); t_obj = Obj(j); t_cv = CV(j);
                idx(j) = idx(j + 1); Obj(j) = Obj(j + 1); CV(j) = CV(j + 1);
                idx(j + 1) = t; Obj(j + 1) = t_obj; CV(j + 1) = t_cv;
                swap = 1;
            end
        end
    end
    if swap == 0
        break;
    end
end
end
