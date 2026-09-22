function result = IGD(MTOData, varargin)
% <Single-task/Multi-task/Many-task> <Multi-objective> <None/Constrained>

% Inverted Generational Distance (IGD)

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, ACM Trans. Evol. Learn. Optim., 2026"
%--------------------------------------------------------------------------

result = CreateMetricResult(MTOData, 'Min', false, true);
result = ComputeParetoMetric(MTOData, result, false, @prepare, varargin{:});
end

function evaluate = prepare(~, ~, ~, reference)
% Use the task optimum (pooled nondominated optima for CMT).
% IGD: mean nearest Euclidean distance from reference points to the front.
evaluate = @(front) getIGD(front, reference);
end
