classdef ConvergeCV < Metric
    % <Figure>

    % Convergence of Constraint Violation

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

            result.Problems = {};
            result.XData = {};
            result.YData = {};
            row_i = 1;
            for prob = 1:length(data.prob_cell)
                tnum = data.task_num(prob);
                for task = 1:tnum
                    result.Problems{row_i} = [data.prob_cell{prob}, '-T', num2str(task)];
                    for algo = 1:length(data.algo_cell)
                        if isfield(data.result(prob, algo), 'convergeCV')
                            convergence_task = data.result(prob, algo).convergeCV(task:tnum:end, :);
                        else
                            convergence_task = 0;
                        end
                        convergeCV = mean(convergence_task, 1);
                        result.YData{row_i, algo} = convergeCV;
                        result.XData{row_i, algo} = 1:size(convergeCV, 2);
                        switch ConvergeCV.x_type
                            case 'evaluation'
                                result.XData{row_i, algo} = result.XData{row_i, algo} / length(result.XData{row_i, algo}) * data.sub_eva(prob);
                            case 'generation'
                                result.XData{row_i, algo} = result.XData{row_i, algo} / length(result.XData{row_i, algo}) * (data.sub_eva(prob) / data.sub_pop(prob));
                        end
                    end
                    if strcmp(ConvergeCV.y_type, 'log')
                        for i = 1:length(result.YData(row_i, :))
                            result.YData{row_i, i}(result.YData{row_i, i} <= 0) = 1e-10;
                            result.YData{row_i, i} = log(result.YData{row_i, i});
                        end
                    end

                    row_i = row_i + 1;
                end
            end

            switch ConvergeCV.y_type
                case 'origin'
                    result.YLabel = 'Constraint Violation';
                case 'log'
                    result.YLabel = 'log(Constraint Violation)';
            end

            switch ConvergeCV.x_type
                case 'evaluation'
                    result.XLabel = 'Evaluation';
                case 'generation'
                    result.XLabel = 'Generation';
            end
            result.Legend = data.algo_cell;
            result.GridType = ConvergeCV.grid_type;
            result.MarkerType = ConvergeCV.marker_type;
            result.LineWidth = ConvergeCV.line_width;
            result.MarkerNum = ConvergeCV.marker_num;
            result.MarkerSize = ConvergeCV.marker_size;
        end
    end
end
