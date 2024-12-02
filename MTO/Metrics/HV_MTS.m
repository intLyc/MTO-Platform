function result = HV_MTS(MTOData, varargin)
% <Metric> <Multi-objective>

% Multi-task Score on HV

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

Par_flag = false;
if length(varargin) >= 1
    % Parallel Calculate
    Par_flag = varargin{1};
end

result.Metric = 'Max';
result.RowName = {};
result.ColumnName = {};
% Data for Table
result.TableData = [];

for prob = 1:length(MTOData.Problems)
    if MTOData.Problems(prob).M <= 1
        return;
    end
end
result.RowName = {MTOData.Problems.Name};
result.ColumnName = {MTOData.Algorithms.Name};

if isfield(MTOData, 'Metrics')
    idx = find(strcmp({MTOData.Metrics.Name}, 'HV'));
    if ~isempty(idx)
        hv_result = MTOData.Metrics(idx).Result;
    else
        hv_result = HV(MTOData, Par_flag);
    end
else
    hv_result = HV(MTOData, Par_flag);
end

% Calculate Multi-task Score
hv_matrix = hv_result.ConvergeData.Y;
row = 1;
for prob = 1:length(MTOData.Problems)
    AlgoNum = length(MTOData.Algorithms);
    score_temp = [];
    Gen = size(MTOData.Results(1, 1, 1).Obj{1}, 1);
    for task = 1:MTOData.Problems(prob).T
        for gen = 1:Gen
            mean_task = mean(hv_matrix(row, :, :, gen), 'all');
            std_task = std(hv_matrix(row, :, :, gen), 0, 'all');
            if std_task == 0
                score_temp(task, 1:AlgoNum, 1:MTOData.Reps, gen) = 0;
            else
                score_temp(task, 1:AlgoNum, 1:MTOData.Reps, gen) = (hv_matrix(row, 1:AlgoNum, 1:MTOData.Reps, gen) - mean_task) ./ std_task;
            end
        end
        row = row + 1;
    end
    for algo = 1:AlgoNum
        result.TableData(prob, algo, :) = mean(score_temp(1:MTOData.Problems(prob).T, algo, 1:MTOData.Reps, end), 1);
        for rep = 1:MTOData.Reps
            result.ConvergeData.Y(prob, algo, rep, :) = mean(score_temp(1:MTOData.Problems(prob).T, algo, rep, 1:Gen), 1);
            result.ConvergeData.X(prob, algo, rep, :) = [1:Gen] ./ Gen .* MTOData.Problems(prob).maxFE;
        end
    end
end
end
