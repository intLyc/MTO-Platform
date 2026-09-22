function result = Obj_UV(MTOData, varargin)
% <Multi-task/Many-task> <Single-objective> <None/Constrained>

% Objective - Unified Value for all task
% UObj = (Obj - Min) / (Max - Min)
% Min and Max are calculated from all algorithms and reps on a task

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, ACM Trans. Evol. Learn. Optim., 2026"
%--------------------------------------------------------------------------

base = ReadMetricResult(MTOData, 'Obj', varargin{:});
result = CreateMetricResult(MTOData, base.Metric, true, false);
result = AggregateTaskMetric(MTOData, base, result, @unifiedValue, false);
end

function average = unifiedValue(values)
% Normalize each task over all algorithms, repetitions, and checkpoints.
% A constant task keeps the existing 0/0 (NaN) behavior.
for t = 1:size(values, 1)
    sample = values(t, :, :, :);
    lower = min(sample, [], 'all');
    upper = max(sample, [], 'all');
    values(t, :, :, :) = (sample - lower) / (upper - lower);
end
average = mean(values, 1);
end
