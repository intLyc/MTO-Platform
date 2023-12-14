function result = Run_Time(MTOData, varargin)
% <Metric> <Single-objective/Multi-objective>

% Run Time

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

result.Metric = 'Min';
result.RowName = {MTOData.Problems.Name};
result.ColumnName = {MTOData.Algorithms.Name};
% Data for Table
result.TableData = [];

for prob = 1:length(MTOData.Problems)
    for algo = 1:length(MTOData.Algorithms)
        result.TableData(prob, algo, :) = MTOData.RunTimes(prob, algo, :);
    end
end
end
