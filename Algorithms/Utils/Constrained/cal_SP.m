function f = cal_SP(obj, cv, varargin)
    %% Self-adaptive Penalty

    n = numel(varargin);
    if n == 0
        type = 1;
    elseif n == 1
        type = varargin{1};
    end

    if type == 1
        fsort = sort(obj);
        if fsort(end) == fsort(1)
            fnorm = ones(1, length(obj));
        else
            fnorm = (obj - fsort(1)) ./ (fsort(end) - fsort(1));
        end
        cv_max = max(cv);
        if ~(cv_max == 0)
            cv = cv / cv_max;
        end
        f_idx = find(cv == 0);
        rf = length(f_idx) / length(obj);
        if rf == 0
            X = zeros(1, length(obj));
            d = cv;
        else
            X = cv;
            d = sqrt(fnorm.^2 + cv.^2);
        end
        Y = fnorm;
        Y(f_idx) = zeros(1, length(f_idx));
        p = (1 - rf) .* X + (rf .* Y);
        f = d + p;
    elseif type == 2
        bestfeas = min(obj);
        cv_max = max(cv);
        f = bestfeas + abs(obj - bestfeas) .* abs(cv ./ cv_max);
    end
end
