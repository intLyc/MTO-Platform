function result = Obj_Neg(MTOData, varargin)
% <Single-task/Multi-task/Many-task> <Single-objective> <None/Constrained>

% Objective Value (negative) for maximization problems

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

result = Obj(MTOData, varargin);
result.Metric = 'Max';
result.TableData = -result.TableData;
result.ConvergeData.Y = -result.ConvergeData.Y;
