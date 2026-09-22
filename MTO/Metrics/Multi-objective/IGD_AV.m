function result = IGD_AV(MTOData, varargin)
% <Multi-task/Many-task> <Multi-objective> <None/Constrained>

% Inverted Generational Distance (IGD) - Average Value for all task

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, ACM Trans. Evol. Learn. Optim., 2026"
%--------------------------------------------------------------------------

base = ReadMetricResult(MTOData, 'IGD', varargin{:});
result = CreateMetricResult(MTOData, base.Metric, base.IsRelative, false);
% Average task scores and retain the sampled FE coordinates of the base metric.
result = AggregateTaskMetric(MTOData, base, result, @(values) mean(values, 1), true);
end
