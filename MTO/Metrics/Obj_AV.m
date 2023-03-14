function result = Obj_AV(MTOData, varargin)
% <Metric> <Single-objective>

% Objective - Average Value for all task

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
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
for prob = 1:length(MTOData.Problems)
    for algo = 1:length(MTOData.Algorithms)
        gen = size(MTOData.Results(prob, algo, 1).Obj, 2);
        Obj = zeros(MTOData.Reps, MTOData.Problems(prob).T, gen);
        CV = zeros(MTOData.Reps, MTOData.Problems(prob).T, gen);
        for rep = 1:MTOData.Reps
            Obj(rep, :, :) = MTOData.Results(prob, algo, rep).Obj(1:MTOData.Problems(prob).T, :);
            CV(rep, :, :) = MTOData.Results(prob, algo, rep).CV(1:MTOData.Problems(prob).T, :);
        end
        Obj(CV > 0) = NaN;
        AObj = squeeze(mean(Obj, 2));
        result.TableData(prob, algo, :) = AObj(:, end);
        for rep = 1:MTOData.Reps
            result.ConvergeData.Y(prob, algo, rep, :) = AObj(rep, :);
            result.ConvergeData.X(prob, algo, rep, :) = [1:gen] ./ gen .* MTOData.Problems(prob).maxFE;
        end
    end
end
end
