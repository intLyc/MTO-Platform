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
                tasks_num = data.tasks_num_list(prob);
                for algo = 1:length(data.algo_cell)
                    convergence_rep = [];
                    for rep = 1:data.reps
                        convergence_temp = data.result(prob, algo).convergence(1 + (rep - 1) * tasks_num:rep * tasks_num, :);
                        if isfield(data.result(prob, algo), 'convergence_cv')
                            convergence_cv_temp = data.result(prob, algo).convergence_cv(1 + (rep - 1) * tasks_num:rep * tasks_num, :);
                            convergence_temp(convergence_cv_temp > 0) = NaN;
                        end
                        convergence_rep(rep, :) = min(convergence_temp, [], 1);
                    end
                    convergence = mean(convergence_rep, 1);
                    result.YData{prob, algo} = convergence;
                    result.XData{prob, algo} = 1:size(convergence, 2);
                    switch ConvergeMinObj.x_type
                        case 'evaluation'
                            result.XData{prob, algo} = result.XData{prob, algo} / length(result.XData{prob, algo}) * data.sub_eva(prob) * tasks_num;
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
