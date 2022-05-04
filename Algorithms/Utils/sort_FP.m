function idx = sort_FP(obj, cv)
    %% Feasible Priority Sort
    idx = 1:length(obj);
    for i = 1:length(obj)
        swap = 0;
        for j = 1:length(obj) - i
            if cv(j) > cv(j + 1) || (cv(j) == cv(j + 1) && obj(j) > obj(j + 1))
                t = idx(j); t_obj = obj(j); t_cv = cv(j);
                idx(j) = idx(j + 1); obj(j) = obj(j + 1); cv(j) = cv(j + 1);
                idx(j + 1) = t; obj(j + 1) = t_obj; cv(j + 1) = t_cv;
                swap = 1;
            end
        end
        if swap == 0
            break;
        end
    end
end
