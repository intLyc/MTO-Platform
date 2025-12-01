function result = Run_Time(MTOData, varargin)
% <Single-task/Multi-task/Many-task> <Single-objective/Multi-objective/Many-objective> <None/Constrained/Competitive>

% Run Time

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
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
