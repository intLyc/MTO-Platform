function result = Obj_UV(MTOData, varargin)
% <Metric> <Single-objective>

% Objective - Unified Value for all task
% UObj = (Obj - Min) / (Max - Min)
% Min and Max are calculated from all algorithms and reps on a task

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

result.Metric = 'Min';
result.RowName = {};
result.ColumnName = {};
% Data for Table
result.TableData = [];
% Data for Converge Plot
result.ConvergeData.X = [];
result.ConvergeData.Y = [];

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
            gen = size(MTOData.Results(prob, algo, 1).Obj, 2);
            Obj = zeros(MTOData.Reps, gen);
            CV = zeros(MTOData.Reps, gen);
            for rep = 1:MTOData.Reps
                Obj(rep, :) = MTOData.Results(prob, algo, rep).Obj(task, :);
                CV(rep, :) = MTOData.Results(prob, algo, rep).CV(task, :);
            end
            Obj(CV > 0) = NaN;
            ObjMat(row, algo, 1:MTOData.Reps, :) = Obj;
        end
        row = row + 1;
    end
end

% Calculate Obj-UV
row = 1;
for prob = 1:length(MTOData.Problems)
    UObj = [];
    AlgoNum = length(MTOData.Algorithms);
    for task = 1:MTOData.Problems(prob).T
        min_task = min(ObjMat(row, :, :, :), [], 'all');
        max_task = max(ObjMat(row, :, :, :), [], 'all');
        UObj(task, 1:AlgoNum, 1:MTOData.Reps, :) = (ObjMat(row, 1:AlgoNum, 1:MTOData.Reps, :) - min_task) / (max_task - min_task);
        row = row + 1;
    end
    for algo = 1:AlgoNum
        gen = size(MTOData.Results(prob, algo, 1).Obj, 2);
        result.TableData(prob, algo, :) = mean(UObj(1:MTOData.Problems(prob).T, algo, 1:MTOData.Reps, end), 1);
        for rep = 1:MTOData.Reps
            result.ConvergeData.Y(prob, algo, rep, :) = mean(UObj(1:MTOData.Problems(prob).T, algo, rep, 1:gen), 1);
            result.ConvergeData.X(prob, algo, rep, :) = [1:gen] ./ gen .* MTOData.Problems(prob).maxFE;
        end
    end
end
end
