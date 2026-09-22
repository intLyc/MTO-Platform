function result = HV(MTOData, varargin)
% <Single-task/Multi-task/Many-task> <Multi-objective> <None/Constrained>

% Hypervolume (HV)

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, ACM Trans. Evol. Learn. Optim., 2026"
%--------------------------------------------------------------------------

result = CreateMetricResult(MTOData, 'Max', true, true);
result = ComputeParetoMetric(MTOData, result, false, @prepare, varargin{:});
end

function evaluate = prepare(data, problem, tasks, ~)
% Normalize HV using bounds of the pooled final feasible nondominated front.
reference = CollectFinalMetricFront(data, problem, tasks);
if isempty(reference)
    objectives = size(data.Results(problem, 1, 1).Obj{tasks(1)}, 3);
    upper = ones(1, objectives);
    lower = zeros(1, objectives);
else
    upper = max(reference, [], 1);
    lower = min(reference, [], 1);
end
evaluate = @(front) getHV(front, upper, lower);
end
