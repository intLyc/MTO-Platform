function result = MT_Score(MTOData)
    % <Table>

    % Multi-task Score

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

    result.RowName = {MTOData.Problems.Name};
    result.ColumnName = {MTOData.Algorithms.Name};

    % Calculate Objective
    result.TableData = [];
    row_i = 1;
    for prob = 1:length(MTOData.Problems)
        for task = 1:MTOData.Problems(prob).T
            for algo = 1:length(MTOData.Algorithms)
                Obj = zeros(1, MTOData.Reps);
                CV = zeros(1, MTOData.Reps);
                for rep = 1:MTOData.Reps
                    Obj(rep) = MTOData.Results{prob, algo, rep}{task, end}.Obj;
                    CV(rep) = MTOData.Results{prob, algo, rep}{task, end}.CV;
                end
                Obj(CV > 0) = NaN;
                obj_matrix(row_i, algo, :) = Obj;
            end
            row_i = row_i + 1;
        end
    end

    % Calculate Multi-task Score
    row_i = 1;
    for prob = 1:length(MTOData.Problems)
        score_temp = zeros(1, length(MTOData.Algorithms));
        for task = 1:MTOData.Problems(prob).T
            mean_task = nanmean(obj_matrix(row_i, :, :), 'all');
            std_task = std(obj_matrix(row_i, :, :), 0, 'all');
            for algo = 1:length(MTOData.Algorithms)
                score_temp(algo) = score_temp(algo) + nanmean((obj_matrix(row_i, algo, :) - mean_task) ./ std_task);
            end
            row_i = row_i + 1;
        end
        result.TableData(prob, :, 1) = score_temp;
    end
end
