function result = Converge_CV(MTOData)
    % <Figure>

    % Convergence of Constraint Violation
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
        tnum = MTOData.Problems(prob).T;
        for task = 1:tnum
            result.Problems{row_i} = [MTOData.Problems(prob).Name, '-T', num2str(task)];
            for algo = 1:length(MTOData.Algorithms)
                convergeCV_temp = [];
                for rep = 1:MTOData.Reps
                    temp = [MTOData.Results{prob, algo, rep}{task, :}];
                    temp_cv = [temp.CV];
                    convergeCV_temp = [convergeCV_temp; temp_cv];
                end
                convergeCV = mean(convergeCV_temp, 1);
                result.YData{row_i, algo} = convergeCV;
                result.XData{row_i, algo} = 1:size(convergeCV, 2);
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
            result.YLabel = 'Constraint Violation';
        case 'Log'
            result.YLabel = 'Log(Constraint Violation)';
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
