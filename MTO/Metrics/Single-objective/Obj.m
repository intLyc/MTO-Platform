function result = Obj(MTOData, varargin)
% <Single-task/Multi-task/Many-task> <Single-objective> <None/Constrained>

% Objective Value

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, ACM Trans. Evol. Learn. Optim., 2026"
%--------------------------------------------------------------------------

result = CreateMetricResult(MTOData, 'Min', false, true);
result = ComputeObjectiveMetric(MTOData, result, true, @evaluate);
end

function history = evaluate(record)
history = record.Obj;
history(record.CV > 0) = NaN;
end
