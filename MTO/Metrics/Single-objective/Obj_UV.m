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

result = AggregateTaskMetric(MTOData, 'Obj', 'unified', varargin{:});
end
