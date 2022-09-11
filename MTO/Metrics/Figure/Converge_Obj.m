function result = Converge_Obj(MTOData)
    % <Figure>

    % Convergence of Objective Value
    %% Return Parameter
    % result.Problems
    % result.XData
    % result.YData
    % result.XLabel
    % result.YLabel
    % result.Legend
    % result.GridType
    % result.MarkerType
    % result.LineWidth
    % result.MarkerNum
    % result.MarkerSize

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    XType = 'Evaluation'; % Evaluation/Generation
    YType = 'Log'; % Origin/Log
    LineWidth = 1.5;
    MarkerNum = 10;
    MarkerType = {'o', '*', 'x', '^', '+', 'p', 'v', 's', 'd', '<', '>', 'h'};
    MarkerSize = 7;
    GridType = 'on'; % on/off/minor

    result.Problems = {};
    result.XData = {};
    result.YData = {};
    row_i = 1;
    for prob = 1:length(MTOData.Problems)
        if MTOData.Problems(prob).M ~= 1
            return;
        end
        tnum = MTOData.Problems(prob).T;
        for task = 1:tnum
            result.Problems{row_i} = [MTOData.Problems(prob).Name, '-T', num2str(task)];
            for algo = 1:length(MTOData.Algorithms)
                convergeObj_temp = [];
                for rep = 1:MTOData.Reps
                    temp_obj = MTOData.Results(prob, algo, rep).Obj(task, :);
                    temp_cv = MTOData.Results(prob, algo, rep).CV(task, :);
                    temp_obj(temp_cv > 0) = NaN;
                    convergeObj_temp = [convergeObj_temp; temp_obj];
                end
                convergeObj = mean(convergeObj_temp, 1);
                result.YData{row_i, algo} = convergeObj;
                result.XData{row_i, algo} = 1:size(convergeObj, 2);
                switch XType
                    case 'Evaluation'
                        result.XData{row_i, algo} = result.XData{row_i, algo} / length(result.XData{row_i, algo}) * MTOData.Problems(prob).maxFE / MTOData.Problems(prob).T;
                    case 'Generation'
                        result.XData{row_i, algo} = result.XData{row_i, algo} / length(result.XData{row_i, algo}) * MTOData.Problems(prob).maxFE / (MTOData.Problems(prob).T * MTOData.Problems(prob).N);
                end
            end
            if strcmp(YType, 'Log')
                for i = 1:length(result.YData(row_i, :))
                    result.YData{row_i, i}(result.YData{row_i, i} <= 1e-10) = 1e-10;
                    result.YData{row_i, i} = log(result.YData{row_i, i});
                end
            end
            row_i = row_i + 1;
        end
    end

    switch YType
        case 'Origin'
            result.YLabel = 'Objective Value';
        case 'Log'
            result.YLabel = 'Log(Objective Value)';
    end

    switch XType
        case 'Evaluation'
            result.XLabel = 'Evaluation';
        case 'Generation'
            result.XLabel = 'Generation';
    end
    result.Legend = {MTOData.Algorithms.Name};
    result.GridType = GridType;
    result.MarkerType = MarkerType;
    result.LineWidth = LineWidth;
    result.MarkerNum = MarkerNum;
    result.MarkerSize = MarkerSize;
end
