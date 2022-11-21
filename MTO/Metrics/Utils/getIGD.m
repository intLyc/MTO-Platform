function score = getIGD(PopObj, optimum)
    % This code is copy from PlatEMO(https://github.com/BIMK/PlatEMO).

    if size(PopObj, 2) ~= size(optimum, 2)
        score = nan;
    else
        score = mean(min(pdist2(optimum, PopObj), [], 2));
    end
end
