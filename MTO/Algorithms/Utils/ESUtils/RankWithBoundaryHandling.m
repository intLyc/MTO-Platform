function rank = RankWithBoundaryHandling(sample, Prob)
% Rank the population with boundary constraint handling
if Prob.Bounded
    % Penalty method
    currentObjs = sample.Objs;
    objScale = max(abs(currentObjs));
    if objScale < 1, objScale = 1; end
    penalty = zeros(length(sample), 1);
    for i = 1:length(sample)
        violation = BoundaryViolation(sample(i).Dec);
        penalty(i) = violation * objScale;
    end
    % get rank based on constraint and objective
    [~, rank] = sortrows([sample.CVs, sample.Objs + penalty], [1, 2]);
else
    [~, rank] = sortrows([sample.CVs, sample.Objs], [1, 2]);
end
end
