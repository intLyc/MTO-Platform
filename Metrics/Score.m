classdef Score < Metric
    % <Metric>

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function result = calculate(data)
            result.RowName = data.prob_cell;
            result.ColumnName = data.algo_cell;
            result.TableData = [];

            % Calculate Objective
            obj_matrix = [];
            for algo = 1:length(data.algo_cell)
                row_i = 1;
                for prob = 1:length(data.prob_cell)
                    tasks_num = data.tasks_num_list(prob);
                    for task = 1:tasks_num
                        obj_temp = data.result(prob, algo).convergence(task:tasks_num:end, end);
                        if isfield(data.result(prob, algo), 'convergence_cv')
                            cv_temp = data.result(prob, algo).convergence_cv(task:tasks_num:end, end);
                            obj_temp(cv_temp > 0) = NaN;
                        end
                        obj_matrix(row_i, algo, :) = obj_temp;
                        row_i = row_i + 1;
                    end
                end
            end

            % Calculate multi-task Score
            row_i = 1;
            for prob = 1:length(data.prob_cell)
                tasks_num = data.tasks_num_list(prob);
                score_temp = zeros(1, length(data.algo_cell));
                for task = 1:tasks_num
                    mean_task = nanmean(obj_matrix(row_i, :, :), 'all');
                    std_task = std(obj_matrix(row_i, :, :), 0, 'all');
                    for algo = 1:length(data.algo_cell)
                        score_temp(algo) = score_temp(algo) + nanmean((obj_matrix(row_i, algo, :) - mean_task) ./ std_task);
                    end
                    row_i = row_i + 1;
                end
                result.TableData(prob, :, 1) = score_temp;
            end
        end
    end
end
