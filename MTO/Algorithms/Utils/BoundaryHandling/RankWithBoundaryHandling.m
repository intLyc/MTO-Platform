function rank = RankWithBoundaryHandling(sample, Prob)
% Rank the population with boundary constraint handling
if Prob.Bounded
    % Penalty method
    penalty = zeros(length(sample), 1);
    for i = 1:length(sample)
        tempDec = max(0, min(1, sample(i).Dec));
        penalty(i) = sum((sample(i).Dec - tempDec).^2);
    end
    % get rank based on constraint and objective
    [~, rank] = sortrows([sample.CVs, sample.Objs + penalty], [1, 2]);
else
    [~, rank] = sortrows([sample.CVs, sample.Objs], [1, 2]);
end
end
