function result = Obj_NBR(MTOData, varargin)
% <Metric> <Single-objective>

% Number of Best Results for All Tasks - Objective

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
% Data for Converge Plot
% result.ConvergeData.X = [];
% result.ConvergeData.Y = [];

for prob = 1:length(MTOData.Problems)
    if MTOData.Problems(prob).M ~= 1
        return;
    end
end
result.RowName = {MTOData.Problems.Name};
result.ColumnName = {MTOData.Algorithms.Name};

% Calculate Objective
row = 1;
for prob = 1:length(MTOData.Problems)
    for task = 1:MTOData.Problems(prob).T
        for algo = 1:length(MTOData.Algorithms)
            Obj = zeros(1, MTOData.Reps);
            CV = zeros(1, MTOData.Reps);
            for rep = 1:MTOData.Reps
                Obj(rep) = MTOData.Results(prob, algo, rep).Obj(task, end);
                CV(rep) = MTOData.Results(prob, algo, rep).CV(task, end);
            end
            Obj(CV > 0) = NaN;
            obj_matrix(row, algo) = nanmean(Obj);
        end
        row = row + 1;
    end
end

% Calculate Number of Best Result
row = 1;
for prob = 1:length(MTOData.Problems)
    number_temp = zeros(1, length(MTOData.Algorithms));
    for task = 1:MTOData.Problems(prob).T
        [~, algo] = min(obj_matrix(row, :));
        number_temp(algo) = number_temp(algo) + 1;
        row = row + 1;
    end
    result.TableData(prob, :, 1) = number_temp;
end
end
