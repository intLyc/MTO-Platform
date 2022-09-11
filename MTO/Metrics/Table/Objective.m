function result = Objective(MTOData)
    % <Table>

    % Objective Value

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    result.RowName = {};
    result.ColumnName = {};
    result.TableData = [];
    row_i = 1;
    for prob = 1:length(MTOData.Problems)
        if MTOData.Problems(prob).M ~= 1
            return;
        end
        tnum = MTOData.Problems(prob).T;
        for task = 1:tnum
            if tnum == 1
                result.RowName{row_i} = MTOData.Problems(prob).Name;
            else
                result.RowName{row_i} = [MTOData.Problems(prob).Name, '-T', num2str(task)];
            end
            row_i = row_i + 1;
        end
    end
    result.ColumnName = {MTOData.Algorithms.Name};

    % Calculate Objective
    row_i = 1;
    for prob = 1:length(MTOData.Problems)
        for task = 1:MTOData.Problems(prob).T
            for algo = 1:length(MTOData.Algorithms)
                Obj = zeros(1, MTOData.Reps);
                CV = zeros(1, MTOData.Reps);
                for rep = 1:MTOData.Reps
                    Obj(rep) = MTOData.Results(prob, algo, rep).Obj(task, end);
                    CV(rep) = MTOData.Results(prob, algo, rep).CV(task, end);
                end
                Obj(CV > 0) = NaN;
                result.TableData(row_i, algo, :) = Obj;
            end
            row_i = row_i + 1;
        end
    end
end
