function result = Obj_AV(MTOData, varargin)
% <Metric> <Single-objective>

% Objective - Average Value for all task

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
for prob = 1:length(MTOData.Problems)
    for algo = 1:length(MTOData.Algorithms)
        gen = size(MTOData.Results(prob, algo, 1).Obj, 2);
        Obj = zeros(MTOData.Reps, MTOData.Problems(prob).T, gen);
        CV = zeros(MTOData.Reps, MTOData.Problems(prob).T, gen);
        for rep = 1:MTOData.Reps
            Obj(rep, 1:MTOData.Problems(prob).T, 1:gen) = MTOData.Results(prob, algo, rep).Obj(1:MTOData.Problems(prob).T, 1:gen);
            CV(rep, 1:MTOData.Problems(prob).T, 1:gen) = MTOData.Results(prob, algo, rep).CV(1:MTOData.Problems(prob).T, 1:gen);
        end
        Obj(CV > 0) = NaN;
        AObj = reshape(mean(Obj, 2), size(Obj, 1), size(Obj, 3));
        result.TableData(prob, algo, 1:MTOData.Reps) = AObj(1:MTOData.Reps, end);
        for rep = 1:MTOData.Reps
            result.ConvergeData.Y(prob, algo, rep, 1:gen) = AObj(rep, 1:gen);
            result.ConvergeData.X(prob, algo, rep, 1:gen) = [1:gen] ./ gen .* MTOData.Problems(prob).maxFE;
        end
    end
end
end
