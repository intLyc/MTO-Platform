function f = cal_SP(Obj, CV, varargin)
%% Self-adaptive Penalty

n = numel(varargin);
if n == 0
    type = 1;
elseif n == 1
    type = varargin{1};
end

if type == 1
    fsort = sort(Obj);
    if fsort(end) == fsort(1)
        fnorm = ones(1, length(Obj));
    else
        fnorm = (Obj - fsort(1)) ./ (fsort(end) - fsort(1));
    end
    cv_max = max(CV);
    if ~(cv_max == 0)
        CV = CV / cv_max;
    end
    f_idx = find(CV == 0);
    rf = length(f_idx) / length(Obj);
    if rf == 0
        X = zeros(1, length(Obj));
        d = CV;
    else
        X = CV;
        d = sqrt(fnorm.^2 + CV.^2);
    end
    Y = fnorm;
    Y(f_idx) = zeros(1, length(f_idx));
    p = (1 - rf) .* X + (rf .* Y);
    f = d + p;
elseif type == 2
    bestfeas = min(Obj);
    cv_max = max(CV);
    if cv_max == 0
        f = Obj;
    else
        f = bestfeas + abs(Obj - bestfeas) .* abs(CV ./ cv_max);
    end
end
end
