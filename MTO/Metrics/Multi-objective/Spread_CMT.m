function result = Spread_CMT(MTOData, varargin)
% <Multi-task/Many-task> <Multi-objective> <Competitive>

% Competitive Spread of All Tasks

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, ACM Trans. Evol. Learn. Optim., 2026"
%--------------------------------------------------------------------------

result = ComputeParetoMetric(MTOData, 'Spread', true, varargin{:});
end
