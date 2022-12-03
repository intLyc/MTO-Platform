function result = MT_Score_IGD(MTOData, varargin)
    % <Metric>

    % Multi-task Score on IGD

    %------------------------------- Reference --------------------------------
    % @Article{Da2017CEC2017-MTSO,
    %   author     = {Da, Bingshui and Ong, Yew-Soon and Feng, Liang and Qin, A Kai and Gupta, Abhishek and Zhu, Zexuan and Ting, Chuan-Kang and Tang, Ke and Yao, Xin},
    %   journal    = {arXiv preprint arXiv:1706.03470},
    %   title      = {Evolutionary Multitasking for Single-objective Continuous Optimization: Benchmark Problems, Performance Metric, and Baseline Results},
    %   year       = {2017},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    Par_flag = false;
    if length(varargin) >= 1
        % Parallel Calculate
        Par_flag = varargin{1};
    end

    result.Metric = 'Min';
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
        idx = find(strcmp({MTOData.Metrics.Name}, 'IGD'));
        if ~isempty(idx)
            igd_result = MTOData.Metrics(idx).Result;
        else
            igd_result = IGD(MTOData, Par_flag);
        end
    else
        igd_result = IGD(MTOData, Par_flag);
    end

    % Calculate Multi-task Score
    igd_matrix = igd_result.TableData;
    row = 1;
    for prob = 1:length(MTOData.Problems)
        score_temp = zeros(1, length(MTOData.Algorithms));
        for task = 1:MTOData.Problems(prob).T
            mean_task = mean(igd_matrix(row, :, :), 'all');
            std_task = std(igd_matrix(row, :, :), 0, 'all');
            for algo = 1:length(MTOData.Algorithms)
                score_temp(algo) = score_temp(algo) + mean((igd_matrix(row, algo, :) - mean_task) ./ std_task);
            end
            row = row + 1;
        end
        result.TableData(prob, :, 1) = score_temp(:);
    end
end
