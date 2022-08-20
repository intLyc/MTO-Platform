classdef CV < Metric
    % <Table>

    % Constraint Violation

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function result = calculate(data)
            result.RowName = {};
            row_i = 1;
            for prob = 1:length(data.prob_cell)
                tasks_num = data.tasks_num_list(prob);
                for task = 1:tasks_num
                    result.RowName{row_i} = [data.prob_cell{prob}, '-T', num2str(task)];
                    row_i = row_i + 1;
                end
            end
            result.ColumnName = data.algo_cell;
            result.TableData = [];

            % Calculate Constraint Violation
            for algo = 1:length(data.algo_cell)
                row_i = 1;
                for prob = 1:length(data.prob_cell)
                    tasks_num = data.tasks_num_list(prob);
                    for task = 1:tasks_num
                        if isfield(data.result(prob, algo), 'convergence_cv')
                            result.TableData(row_i, algo, :) = data.result(prob, algo).convergence_cv(task:tasks_num:end, end);
                        else
                            result.TableData(row_i, algo, :) = 0;
                        end
                        row_i = row_i + 1;
                    end
                end
            end
        end
    end
end
