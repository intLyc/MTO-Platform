function result = MT_Score(MTOData, varargin)
    % <Metric>

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
                obj_matrix(row, algo, :, :) = Obj;
            end
            row = row + 1;
        end
    end

    % Calculate Multi-task Score
    row = 1;
    for prob = 1:length(MTOData.Problems)
        gen = size(MTOData.Results(prob, 1, 1).Obj, 2);
        score_temp = zeros(length(MTOData.Algorithms), gen);
        for task = 1:MTOData.Problems(prob).T
            for g = 1:gen
                mean_task = nanmean(obj_matrix(row, :, :, g), 'all');
                std_task = std(obj_matrix(row, :, :, g), 0, 'all');
                for algo = 1:length(MTOData.Algorithms)
                    score_temp(algo, g) = score_temp(algo, g) + nanmean((obj_matrix(row, algo, :, g) - mean_task) ./ std_task);
                end
            end
            row = row + 1;
        end
        result.TableData(prob, :, 1) = score_temp(:, end);
        for algo = 1:length(MTOData.Algorithms)
            result.ConvergeData.Y(prob, algo, :) = score_temp(algo, :);
            result.ConvergeData.X(prob, algo, :) = [1:gen] ./ gen .* MTOData.Problems(prob).maxFE ./ MTOData.Problems(prob).T;
        end
    end
end
