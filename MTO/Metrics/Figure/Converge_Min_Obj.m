function result = Converge_Min_Obj(MTOData)
    % <Figure>

    % Minimal Convergence of Objective Value
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

    %------------------------------- Reference --------------------------------
    % @Article{Li2022CompetitiveMTO,
    %   author     = {Li, Genghui and Zhang, Qingfu and Wang, Zhenkun},
    %   journal    = {IEEE Transactions on Evolutionary Computation},
    %   title      = {Evolutionary Competitive Multitasking Optimization},
    %   year       = {2022},
    %   pages      = {1-1},
    %   doi        = {10.1109/TEVC.2022.3141819},
    % }
    %--------------------------------------------------------------------------

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

    result.Problems = {MTOData.Problems.Name};
    result.XData = {};
    result.YData = {};
    for prob = 1:length(MTOData.Problems)
        for algo = 1:length(MTOData.Algorithms)
            convergeObj_temp = [];
            for rep = 1:MTOData.Reps
                temp_obj_task = [];
                for task = 1:MTOData.Problems(prob).T
                    temp = [MTOData.Results{prob, algo, rep}{task, :}];
                    temp_obj = [temp.Obj];
                    temp_cv = [temp.CV];
                    temp_obj(temp_cv > 0) = NaN;
                    temp_obj_task = [temp_obj_task; temp_obj];
                end
                convergeObj_temp = [convergeObj_temp; min(temp_obj_task, [], 1)];
            end
            convergeObj = mean(convergeObj_temp, 1);
            result.YData{prob, algo} = convergeObj;
            result.XData{prob, algo} = 1:size(convergeObj, 2);
            switch XType
                case 'Evaluation'
                    result.XData{prob, algo} = result.XData{prob, algo} / length(result.XData{prob, algo}) * MTOData.Problems(prob).maxFE;
                case 'Generation'
                    result.XData{prob, algo} = result.XData{prob, algo} / length(result.XData{prob, algo}) * MTOData.Problems(prob).maxFE / (MTOData.Problems(prob).T * MTOData.Problems(prob).N);
            end
        end

        if strcmp(YType, 'Log')
            for i = 1:length(result.YData(prob, :))
                result.YData{prob, i}(result.YData{prob, i} <= 1e-10) = 1e-10;
                result.YData{prob, i} = log(result.YData{prob, i});
            end
        end
    end

    switch YType
        case 'Origin'
            result.YLabel = 'Minimal Objective Value';
        case 'Log'
            result.YLabel = 'Log(Minimal Objective Value)';
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
