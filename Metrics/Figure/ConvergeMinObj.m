classdef ConvergeMinObj < Metric
    % <Figure>

    % Minimal Convergence of Objective Value

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

    properties (Constant)
        x_type = 'evaluation' % evaluation/generation
        y_type = 'log' % origin/log
        marker_num = 10
        line_width = 1.5
        marker_type = {'o', '*', 'x', '^', '+', 'p', 'v', 's', 'd', '<', '>', 'h'}
        marker_size = 7
        grid_type = 'on' % on/off/minor
    end

    methods (Static)
        function result = calculate(data)
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

            result.Problems = data.prob_cell;
            result.XData = {};
            result.YData = {};
            for prob = 1:length(data.prob_cell)
                tnum = data.task_num(prob);
                for algo = 1:length(data.algo_cell)
                    convergeObj_rep = [];
                    for rep = 1:data.reps
                        convergeObj_temp = data.result(prob, algo).convergeObj(1 + (rep - 1) * tnum:rep * tnum, :);
                        if isfield(data.result(prob, algo), 'convergeCV')
                            convergeCV_temp = data.result(prob, algo).convergeCV(1 + (rep - 1) * tnum:rep * tnum, :);
                            convergeObj_temp(convergeCV_temp > 0) = NaN;
                        end
                        convergeObj_rep(rep, :) = min(convergeObj_temp, [], 1);
                    end
                    convergeObj = mean(convergeObj_rep, 1);
                    result.YData{prob, algo} = convergeObj;
                    result.XData{prob, algo} = 1:size(convergeObj, 2);
                    switch ConvergeMinObj.x_type
                        case 'evaluation'
                            result.XData{prob, algo} = result.XData{prob, algo} / length(result.XData{prob, algo}) * data.sub_eva(prob) * tnum;
                        case 'generation'
                            result.XData{prob, algo} = result.XData{prob, algo} / length(result.XData{prob, algo}) * (data.sub_eva(prob) / data.sub_pop(prob));
                    end
                end

                if strcmp(ConvergeMinObj.y_type, 'log')
                    for i = 1:length(result.YData(prob, :))
                        result.YData{prob, i}(result.YData{prob, i} <= 0) = 1e-10;
                        result.YData{prob, i} = log(result.YData{prob, i});
                    end
                end
            end

            switch ConvergeMinObj.y_type
                case 'origin'
                    result.YLabel = 'Minimal Objective Value';
                case 'log'
                    result.YLabel = 'log(Minimal Objective Value)';
            end

            switch ConvergeMinObj.x_type
                case 'evaluation'
                    result.XLabel = 'Evaluation';
                case 'generation'
                    result.XLabel = 'Generation';
            end
            result.Legend = data.algo_cell;
            result.GridType = ConvergeMinObj.grid_type;
            result.MarkerType = ConvergeMinObj.marker_type;
            result.LineWidth = ConvergeMinObj.line_width;
            result.MarkerNum = ConvergeMinObj.marker_num;
            result.MarkerSize = ConvergeMinObj.marker_size;
        end
    end
end
