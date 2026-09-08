function result = IGDp_CMT(MTOData, varargin)
% <Multi-task/Many-task> <Multi-objective> <Competitive>

% Competitive IGD+ of All Tasks

%------------------------------- Reference --------------------------------
% @Article{Li2022CompetitiveMTO,
%   author     = {Li, Genghui and Zhang, Qingfu and Wang, Zhenkun},
%   journal    = {IEEE Transactions on Evolutionary Computation},
%   title      = {Evolutionary Competitive Multitasking Optimization},
%   year       = {2022},
%   pages      = {1-1},
%   doi        = {10.1109/TEVC.2022.3141819},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, ACM Trans. Evol. Learn. Optim., 2026"
%--------------------------------------------------------------------------

result = ComputeParetoMetric(MTOData, 'IGDp', true, varargin{:});
end
