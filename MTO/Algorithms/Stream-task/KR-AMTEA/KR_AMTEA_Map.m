function [x, order] = KR_AMTEA_Map(source, target, n, option)
% Port of the author's KR-AMTEA varOrder2 + m_transfer1 (option 0/1/2).
% Retain linear-index variance updates and repeated extrema updates for parity
% with the released code. Only zero ranges/variances and 1-D self matching
% receive guards; these cases otherwise produce NaN or an invalid index.
loS = min(source, [], 1); hiS = max(source, [], 1);
loT = min(target, [], 1); hiT = max(target, [], 1);
muS = mean(source, 1); muT = mean(target, 1);
rangeS = hiS - loS; rangeT = hiT - loT;
denominator = rangeS; denominator(denominator == 0) = eps;
DS = size(source, 2); DT = size(target, 2);
temp = (source - muS).^2;
vT = sum((target - muT).^2, 1) / (size(target, 1) - 1);
vT(vT == 0) = eps^2;
% option 0 selects a random rank; 1 selects the closest match; 2 selects the second closest.
if option == 0, rank = randi(DS); else, rank = min(option, DS); end
order = zeros(1, DT);
for i = 1:DT
    for j = 1:DS
        if rangeS(j) ~= rangeT(i)
            % Preserve the author's linear-index update rather than scaling an entire column.
            temp(j) = (temp(j)^0.5 * (rangeT(i) / denominator(j)))^2;
        end
    end
    vS = sum(temp, 1) / (size(target, 1) - 1);
    vS(vS == 0) = eps^2;
    kld = log2(vS.^0.5 / vT(i)^0.5) + ...
        (vT(i) + (muS - muT(i)).^2) ./ (2 * vS) - 0.5;
    [~, indices] = sort(kld);
    order(i) = indices(rank);
end
for i = 1:DT
    j = order(i);
    if option ~= 0
        % Repeated source dimensions rescale the same extrema, matching the author code.
        hiS(j) = (hiS(j) - muS(j)) * (rangeT(i) / denominator(j)) + muS(j);
        loS(j) = (loS(j) - muS(j)) * (rangeT(i) / denominator(j)) + muS(j);
    end
end
x = zeros(n, DT);
for i = 1:DT
    j = order(i);
    if option ~= 0
        x(:, i) = (source(1:n, j) - muS(j)) * (rangeT(i) / denominator(j)) + muS(j);
    else
        x(:, i) = source(1:n, j);
    end
    % Test scaled bounds for overlap; shift means for random mode or nonoverlapping intervals.
    overlap = (loS(j) <= hiT(i) && hiS(j) >= hiT(i) && muS(j) <= hiT(i)) || ...
        (hiS(j) >= loT(i) && loS(j) <= loT(i) && muS(j) >= loT(i));
    if option == 0 || ~overlap, x(:, i) = x(:, i) + muT(i) - muS(j); end
end
x = max(0, min(1, x));
end
