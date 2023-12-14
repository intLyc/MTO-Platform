function result = FR(MTOData, varargin)
% <Metric> <Single-objective>

% Feasible Rate

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

result.Metric = 'Max';
result.RowName = {};
result.ColumnName = {};
% Data for Table
result.TableData = [];

row = 1;
for prob = 1:length(MTOData.Problems)
    if MTOData.Problems(prob).M ~= 1
        return;
    end
    tnum = MTOData.Problems(prob).T;
    for task = 1:tnum
        if tnum == 1
            result.RowName{row} = MTOData.Problems(prob).Name;
        else
            result.RowName{row} = [MTOData.Problems(prob).Name, '-T', num2str(task)];
        end
        row = row + 1;
    end
end
result.ColumnName = {MTOData.Algorithms.Name};

% Calculate Feasible Rate
row = 1;
for prob = 1:length(MTOData.Problems)
    for task = 1:MTOData.Problems(prob).T
        for algo = 1:length(MTOData.Algorithms)
            CV = zeros(1, MTOData.Reps);
            for rep = 1:MTOData.Reps
                CV(rep) = MTOData.Results(prob, algo, rep).CV(task, end);
            end
            result.TableData(row, algo, :) = sum(CV <= 0) / MTOData.Reps;
        end
        row = row + 1;
    end
end
end
