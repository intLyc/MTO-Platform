classdef Time < Metric
    % <Table>

    % Run Time

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

            for prob = 1:length(data.prob_cell)
                for algo = 1:length(data.algo_cell)
                    result.TableData(prob, algo, :) = data.result(prob, algo).clock_time;
                end
            end
        end
    end
end
