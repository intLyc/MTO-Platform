function result = Obj_Neg(MTOData, varargin)
% <Metric> <Single-objective>

% Objective Value (negative)

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

result = Obj(MTOData, varargin);
result.Metric = 'Max';
result.TableData = -result.TableData;
result.ConvergeData.Y = -result.ConvergeData.Y;
