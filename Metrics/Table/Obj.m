classdef Obj < Metric
    % <Table>

    % Objective Value

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
                tnum = data.task_num(prob);
                for task = 1:tnum
                    if tnum == 1
                        result.RowName{row_i} = data.prob_cell{prob};
                    else
                        result.RowName{row_i} = [data.prob_cell{prob}, '-T', num2str(task)];
                    end
                    row_i = row_i + 1;
                end
            end
            result.ColumnName = data.algo_cell;
            result.TableData = [];

            % Calculate Objective
            for algo = 1:length(data.algo_cell)
                row_i = 1;
                for prob = 1:length(data.prob_cell)
                    tnum = data.task_num(prob);
                    for task = 1:tnum
                        obj_temp = data.result(prob, algo).convergeObj(task:tnum:end, end);
                        if isfield(data.result(prob, algo), 'convergeCV')
                            cv_temp = data.result(prob, algo).convergeCV(task:tnum:end, end);
                            obj_temp(cv_temp > 0) = NaN;
                        end
                        result.TableData(row_i, algo, :) = obj_temp;
                        row_i = row_i + 1;
                    end
                end
            end
        end
    end
end
