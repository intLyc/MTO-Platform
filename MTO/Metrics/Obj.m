function result = Obj(MTOData)
    % <Metric>

    % Objective Value

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

    row = 1;
    for prob = 1:length(MTOData.Problems)
        if MTOData.Problems(prob).M ~= 1
            return;
        end
        tnum = MTOData.Problems(prob).T;
        for task = 1:tnum
            if tnum == 1
                result.RowName{row} = MTOData.Problems(prob).Name;
            else
                result.RowName{row} = [MTOData.Problems(prob).Name, '-T', num2str(task)];
            end
            row = row + 1;
        end
    end
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
                result.TableData(row, algo, :) = Obj(:, end);
                result.ConvergeData.Y(row, algo, :) = mean(Obj(:, :), 1);
                result.ConvergeData.X(row, algo, :) = [1:gen] ./ gen .* MTOData.Problems(prob).maxFE ./ MTOData.Problems(prob).T;
            end
            row = row + 1;
        end
    end
end
