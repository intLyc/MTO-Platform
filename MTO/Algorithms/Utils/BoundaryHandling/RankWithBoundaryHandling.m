function rank = RankWithBoundaryHandling(sample, Prob, varargin)
% Rank the population with boundary constraint handling
if Prob.Bounded
    if isempty(varargin) || strcmp(varargin{1}, 'projection')
        % Boundary constraint handling (projection method)
        for i = 1:length(sample)
            sample(i).Dec = max(0, min(1, sample(i).Dec));
        end
        [~, rank] = sortrows([sample.CVs, sample.Objs], [1, 2]);
    elseif strcmp(varargin{1}, 'penalty')
        % Penalty method via boundary constraint
        boundCVs = zeros(length(sample), 1);
        for i = 1:length(sample)
            tempDec = max(0, min(1, sample(i).Dec));
            boundCVs(i) = sum((sample(i).Dec - tempDec).^2);
        end
        boundCVs(boundCVs > 0) = boundCVs(boundCVs > 0) + max(sample.CVs);
        % get rank based on constraint and objective
        [~, rank] = sortrows([sample.CVs, sample.Objs + boundCVs], [1, 2]);
    else
        error('Unknown boundary constraint handling method.');
    end
else
    [~, rank] = sortrows([sample.CVs, sample.Objs], [1, 2]);
end
end
