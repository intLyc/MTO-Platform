function result = Run_Time(MTOData, varargin)
% <Metric> <Single-objective/Multi-objective>

% Run Time

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
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
