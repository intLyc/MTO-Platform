function result = CV(MTOData, varargin)
% <Metric> <Single-objective>

% Constraint Violation

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

% Calculate Constraint Violation
row = 1;
for prob = 1:length(MTOData.Problems)
    for task = 1:MTOData.Problems(prob).T
        for algo = 1:length(MTOData.Algorithms)
            gen = size(MTOData.Results(prob, algo, 1).Obj, 2);
            CV = zeros(MTOData.Reps, gen);
            for rep = 1:MTOData.Reps
                CV(rep, :) = MTOData.Results(prob, algo, rep).CV(task, :);
            end
            result.TableData(row, algo, :) = CV(:, end);
            for rep = 1:MTOData.Reps
                result.ConvergeData.Y(row, algo, rep, :) = CV(rep, :);
                result.ConvergeData.X(row, algo, rep, :) = [1:gen] ./ gen .* MTOData.Problems(prob).maxFE ./ MTOData.Problems(prob).T;
            end
        end
        row = row + 1;
    end
end
end
