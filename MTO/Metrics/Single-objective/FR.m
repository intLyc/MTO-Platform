function result = FR(MTOData, varargin)
% <Single-task/Multi-task/Many-task> <Single-objective> <Constrained>

% Feasible Rate

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, ACM Trans. Evol. Learn. Optim., 2026"
%--------------------------------------------------------------------------

result = CreateMetricResult(MTOData, 'Max', false, true);
violations = ReadFinalMetricData(MTOData, 'CV');
if isempty(violations), return; end
% Feasible rate is a summary over repetitions, not a per-repetition value.
result.TableData = mean(violations <= 0, 3);
end
