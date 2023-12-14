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
hv_matrix = hv_result.TableData;
hv_matrix(isnan(hv_matrix)) = 0;
row = 1;
for prob = 1:length(MTOData.Problems)
    score_temp = zeros(1, length(MTOData.Algorithms));
    for task = 1:MTOData.Problems(prob).T
        mean_task = mean(hv_matrix(row, :, :), 'all');
        std_task = max(std(hv_matrix(row, :, :), 0, 'all'), 1e-10);
        for algo = 1:length(MTOData.Algorithms)
            score_temp(algo) = score_temp(algo) + mean((hv_matrix(row, algo, :) - mean_task) ./ std_task);
        end
        row = row + 1;
    end
    result.TableData(prob, :, 1) = score_temp(:);
end
end
