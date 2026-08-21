function [coverageRatio, radiusCost] = evaluateSensorCoverage(var, A, dim, distanceOffset, radiusWeight)
%% evaluateSensorCoverage - Batch evaluation shared by sensor coverage problems
% The solutions are processed in chunks to avoid constructing an excessively
% large point-to-sensor distance matrix for high-dimensional tasks.

solutionCount = size(var, 1);
pointCount = size(A, 1);
sensorCount = dim / 3;
coverageRatio = zeros(solutionCount, 1);
radiusCost = zeros(solutionCount, 1);

% A double distance matrix and its logical coverage mask require roughly
% nine bytes per element. Limiting the matrix to five million elements keeps
% the temporary memory footprint at a practical level while retaining batch
% evaluation performance.
maxDistanceElements = 5e6;
chunkSize = max(1, floor(maxDistanceElements / (pointCount * sensorCount)));

for first = 1:chunkSize:solutionCount
    last = min(solutionCount, first + chunkSize - 1);
    batchCount = last - first + 1;

    sensors = permute(reshape(var(first:last, 1:dim)', 3, sensorCount, batchCount), [2, 1, 3]);
    sensors = reshape(permute(sensors, [1, 3, 2]), sensorCount * batchCount, 3);

    distances = pdist2(A, sensors(:, 1:2));
    covered = reshape(distances + distanceOffset <= sensors(:, 3)', ...
        pointCount, sensorCount, batchCount);
    coverageRatio(first:last) = reshape(sum(any(covered, 2), 1), batchCount, 1) / pointCount;

    radii = reshape(sensors(:, 3), sensorCount, batchCount);
    radiusCost(first:last) = sum(radiusWeight * radii.^2, 1)';
end
end
