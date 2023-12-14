function result = Obj_MTS(MTOData, varargin)
% <Metric> <Single-objective>

%  Objective - Multi-task Score

%------------------------------- Reference --------------------------------
% @Article{Da2017CEC2017-MTSO,
%   author     = {Da, Bingshui and Ong, Yew-Soon and Feng, Liang and Qin, A Kai and Gupta, Abhishek and Zhu, Zexuan and Ting, Chuan-Kang and Tang, Ke and Yao, Xin},
%   journal    = {arXiv preprint arXiv:1706.03470},
%   title      = {Evolutionary Multitasking for Single-objective Continuous Optimization: Benchmark Problems, Performance Metric, and Baseline Results},
%   year       = {2017},
% }
%--------------------------------------------------------------------------

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
                Obj(rep, 1:gen) = MTOData.Results(prob, algo, rep).Obj(task, :);
                CV(rep, 1:gen) = MTOData.Results(prob, algo, rep).CV(task, :);
            end
            Obj(CV > 0) = NaN;
            ObjMat(row, algo, 1:MTOData.Reps, 1:gen) = Obj;
        end
        row = row + 1;
    end
end

% Calculate Multi-task Score
row = 1;
for prob = 1:length(MTOData.Problems)
    UObj = [];
    AlgoNum = length(MTOData.Algorithms);
    for task = 1:MTOData.Problems(prob).T
        for gen = 1:size(ObjMat, 4)
            mean_task = nanmean(ObjMat(row, :, :, gen), 'all');
            std_task = std(ObjMat(row, :, :, gen), 0, 'all');
            if std_task == 0
                UObj(task, 1:AlgoNum, 1:MTOData.Reps, gen) = 0;
            else
                UObj(task, 1:AlgoNum, 1:MTOData.Reps, gen) = (ObjMat(row, 1:AlgoNum, 1:MTOData.Reps, gen) - mean_task) ./ std_task;
            end
        end
        row = row + 1;
    end
    for algo = 1:length(MTOData.Algorithms)
        gen = size(MTOData.Results(prob, algo, 1).Obj, 2);
        result.TableData(prob, algo, :) = mean(UObj(1:MTOData.Problems(prob).T, algo, 1:MTOData.Reps, end), 1);
        for rep = 1:MTOData.Reps
            result.ConvergeData.Y(prob, algo, rep, :) = mean(UObj(1:MTOData.Problems(prob).T, algo, rep, 1:gen), 1);
            result.ConvergeData.X(prob, algo, rep, :) = [1:gen] ./ gen .* MTOData.Problems(prob).maxFE;
        end
    end
end
end
