function result = HV_RefPoint(MTOData, varargin)
% <Single-task/Multi-task/Many-task> <Multi-objective> <None/Constrained>

% HV using Reference Point in Problem.getOptimum (HV_RefPoint)

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, ACM Trans. Evol. Learn. Optim., 2026"
%--------------------------------------------------------------------------

result = CreateMetricResult(MTOData, 'Max', false, true);
result = ComputeParetoMetric(MTOData, result, false, @prepare, varargin{:});
end

function evaluate = prepare(~, ~, ~, reference)
% Use the coordinatewise maximum of the problem optimum as reference point.
evaluate = @(front) getHV(front, max(reference, [], 1));
end
