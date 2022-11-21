function score = getIGDp(PopObj, optimum)
    % This code is copy from PlatEMO(https://github.com/BIMK/PlatEMO).

    if size(PopObj, 2) ~= size(optimum, 2)
        score = nan;
    else
        [Nr, M] = size(optimum);
        [N, ~] = size(PopObj);
        delta = zeros(Nr, 1);
        for i = 1:Nr
            delta(i) = min(sqrt(sum(max(PopObj - repmat(optimum(i, :), N, 1), zeros(N, M)).^2, 2)));
        end
        score = mean(delta);
    end
end
