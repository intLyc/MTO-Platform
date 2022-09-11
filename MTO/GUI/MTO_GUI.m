classdef MTO_GUI < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        MTOPlatformUIFigure           matlab.ui.Figure
        MTOPlatformGridLayout         matlab.ui.container.GridLayout
        MTOPlatformTabGroup           matlab.ui.container.TabGroup
        TestTab                       matlab.ui.container.Tab
        TestGridLayout                matlab.ui.container.GridLayout
        TPanel1                       matlab.ui.container.Panel
        TP1GridLayout                 matlab.ui.container.GridLayout
        AlgorithmDropDownLabel        matlab.ui.control.Label
        TAlgorithmDropDown            matlab.ui.control.DropDown
        TAlgorithmTree                matlab.ui.container.Tree
        TProblemTree                  matlab.ui.container.Tree
        TProblemDropDown              matlab.ui.control.DropDown
        ProblemDropDownLabel          matlab.ui.control.Label
        TTaskTypeDropDown             matlab.ui.control.DropDown
        TaskLabel_2                   matlab.ui.control.Label
        SpecialLabel_2                matlab.ui.control.Label
        TSpecialTypeDropDown          matlab.ui.control.DropDown
        TPanel2                       matlab.ui.container.Panel
        TP2GridLayout                 matlab.ui.container.GridLayout
        TP21GridLayout                matlab.ui.container.GridLayout
        TShowTypeDropDown             matlab.ui.control.DropDown
        TSaveButton                   matlab.ui.control.Button
        TP24GridLayout                matlab.ui.container.GridLayout
        TStartButton                  matlab.ui.control.Button
        TResetButton                  matlab.ui.control.Button
        TUIAxes                       matlab.ui.control.UIAxes
        TPanel3                       matlab.ui.container.Panel
        TP3GridLayout                 matlab.ui.container.GridLayout
        OutputTextAreaLabel           matlab.ui.control.Label
        TOutputTextArea               matlab.ui.control.TextArea
        MTOPlatformv020YanchiLiLabel  matlab.ui.control.Label
        ExperimentTab                 matlab.ui.container.Tab
        ExperimentsGridLayout         matlab.ui.container.GridLayout
        EPanel3                       matlab.ui.container.Panel
        EP3GridLayout                 matlab.ui.container.GridLayout
        ETableTabGroup                matlab.ui.container.TabGroup
        ETableTab                     matlab.ui.container.Tab
        EP3TGridLayout                matlab.ui.container.GridLayout
        EP3T1GridLayout               matlab.ui.container.GridLayout
        ETestTypeDropDown             matlab.ui.control.DropDown
        EAlgorithmDropDown            matlab.ui.control.DropDown
        EShowTypeDropDown             matlab.ui.control.DropDown
        EDataTypeDropDown             matlab.ui.control.DropDown
        EHighlightTypeDropDown        matlab.ui.control.DropDown
        ESaveTableButton              matlab.ui.control.Button
        EDataFormatEditField          matlab.ui.control.EditField
        EUITable                      matlab.ui.control.Table
        EFigureTab                    matlab.ui.container.Tab
        EP3FGridLayout                matlab.ui.container.GridLayout
        EP3F1GridLayout               matlab.ui.container.GridLayout
        EProblemsDropDown             matlab.ui.control.DropDown
        ESaveFigureButton             matlab.ui.control.Button
        ESaveFigureTypeDropDown       matlab.ui.control.DropDown
        EFigureTypeDropDown           matlab.ui.control.DropDown
        EConvergenceTrendUIAxes       matlab.ui.control.UIAxes
        EPanel1                       matlab.ui.container.Panel
        EP1GridLayout                 matlab.ui.container.GridLayout
        EProblemsAddButton            matlab.ui.control.Button
        EAlgorithmsAddButton          matlab.ui.control.Button
        ERepsEditField                matlab.ui.control.NumericEditField
        ERunTimesEditFieldLabel       matlab.ui.control.Label
        EAlgorithmsListBox            matlab.ui.control.ListBox
        AlgorithmsLabel               matlab.ui.control.Label
        EProblemsListBox              matlab.ui.control.ListBox
        ProblemsLabel                 matlab.ui.control.Label
        ParallelDropDownLabel         matlab.ui.control.Label
        EParallelDropDown             matlab.ui.control.DropDown
        TypeLabel                     matlab.ui.control.Label
        ETaskTypeDropDown             matlab.ui.control.DropDown
        ELoadDataButton               matlab.ui.control.Button
        SpecialLabel                  matlab.ui.control.Label
        ESpecialTypeDropDown          matlab.ui.control.DropDown
        EPanel2                       matlab.ui.container.Panel
        EP2GridLayout                 matlab.ui.container.GridLayout
        EStartButton                  matlab.ui.control.Button
        EPauseButton                  matlab.ui.control.Button
        EStopButton                   matlab.ui.control.Button
        EAlgorithmsTree               matlab.ui.container.Tree
        EProblemsTree                 matlab.ui.container.Tree
        ESelectedAlgorithmsLabel      matlab.ui.control.Label
        ESelectedProblemsLabel        matlab.ui.control.Label
        EAlgorithmsDelButton          matlab.ui.control.Button
        EProblemsDelButton            matlab.ui.control.Button
        ESaveDataButton               matlab.ui.control.Button
        DataProcessTab                matlab.ui.container.Tab
        DataProcessGridLayout         matlab.ui.container.GridLayout
        DPanel1                       matlab.ui.container.Panel
        DP1GridLayout                 matlab.ui.container.GridLayout
        DDataProcessModuleLabel       matlab.ui.control.Label
        DP1Panel1                     matlab.ui.container.Panel
        DP1P1GridLayout               matlab.ui.container.GridLayout
        DLoadDataButton               matlab.ui.control.Button
        DDeleteDataButton             matlab.ui.control.Button
        DSaveDataButton               matlab.ui.control.Button
        DLoadDataorSelectandDeleteSaveDataLabel_3  matlab.ui.control.Label
        DLoadDataorSelectandDeleteSaveDataLabel_4  matlab.ui.control.Label
        DP1Panel2                     matlab.ui.container.Panel
        DP1P2GridLayout               matlab.ui.container.GridLayout
        DSelectandSplitDataLabel      matlab.ui.control.Label
        DRepsSplitButton              matlab.ui.control.Button
        DAlgorithmsSplitButton        matlab.ui.control.Button
        DProblemsSplitButton          matlab.ui.control.Button
        DP1Panel3                     matlab.ui.container.Panel
        DP1P3GridLayout               matlab.ui.container.GridLayout
        DSelectandMergeDataLabel      matlab.ui.control.Label
        DRepsMergeButton              matlab.ui.control.Button
        DAlgorithmsMergeButton        matlab.ui.control.Button
        DProblemsMergeButton          matlab.ui.control.Button
        DP1Panel4                     matlab.ui.container.Panel
        DP1P4GridLayout               matlab.ui.container.GridLayout
        DUpandDownDataLabel           matlab.ui.control.Label
        DUpButton                     matlab.ui.control.Button
        DDownButton                   matlab.ui.control.Button
        DPanel2                       matlab.ui.container.Panel
        DP2GridLayout                 matlab.ui.container.GridLayout
        DDataTree                     matlab.ui.container.Tree
        SelectedAlgoContextMenu       matlab.ui.container.ContextMenu
        SelectedAlgoSelectAllMenu     matlab.ui.container.Menu
        DDataContextMenu              matlab.ui.container.ContextMenu
        SelectedAlgoSelectAllMenu_2   matlab.ui.container.Menu
        SelectedProbContextMenu       matlab.ui.container.ContextMenu
        SelectedProbSelectAllMenu     matlab.ui.container.Menu
        AlgorithmsContextMenu         matlab.ui.container.ContextMenu
        AlgorithmsSelectAllMenu       matlab.ui.container.Menu
        ProblemsContextMenu           matlab.ui.container.ContextMenu
        ProblemsSelectAllMenu         matlab.ui.container.Menu
    end

    properties (Access = public)
        AlgoLoad % cell of algorithms loaded from folder
        ProbLoad % cell of problems loaded from folder
        MetricLoad % cell of metrics loaded from folder
        
        % convergence axes set
        DefaultLineWidth = 1.5
        DefaultMarkerList = {'o', '*', 'x', '^', '+', 'p', 'v', 's', 'd', '<', '>', 'h'}
        DefaultMarkerSize = 7
        
        % Test Module
        TData % data
        
        % Experiment Module
        EData % data
        EFigureData
        EStopFlag % stop button clicked flag
        ETableData % table data for calculate
        ETableView % table data view
        ETableTest % table data view test
        ETableReps % table reps
        
        % Data Process Module
        DDataFlag % legal data node index
    end
    
    methods (Access = public)
        
        function readAlgoProb(app, label_str)
            % load the algorithms and problems list
            
            app.AlgoLoad = app.readList('../Algorithms', label_str);
            app.ProbLoad = app.readList('../Problems', label_str);
            
            app.AlgoLoad = sort_nat(app.AlgoLoad);
            app.ProbLoad = sort_nat(app.ProbLoad);
        end
        
        function readMetric(app)
            % load the metrics
            
            metric_table = app.readList('../Metrics', {'Table'});
            metric_table = sort_nat(metric_table);
            app.EDataTypeDropDown.Items = ['Reps', metric_table];
            
            metric_figure = app.readList('../Metrics', {'Figure'});
            metric_figure = sort_nat(metric_figure);
            
            app.TShowTypeDropDown.Items = [app.TShowTypeDropDown.Items, metric_figure];
            app.EFigureTypeDropDown.Items = metric_figure;
        end
        
        function read_list = readList(app, folder_name, label_str)
            % read file name list with labels
            
            read_list = {};
            folders = split(genpath(fullfile(fileparts(mfilename('fullpath')), folder_name)),pathsep);
            for i = 1:length(folders)
                files = what(folders{i});
                files = files.m;
                for j = 1:length(files)
                    fid = fopen(files{j});
                    fgetl(fid);
                    str = regexprep(fgetl(fid),'^\s*%\s*','','once');
                    fclose(fid);
                    label_find = regexp(str,'(?<=<).*?(?=>)','match');
                    label_all = {};
                    for k = 1:length(label_find)
                        label_all = [label_all, split(label_find{k}, '/')'];
                    end
                    if sum(ismember(label_str, label_all)) == length(label_str)
                        read_list = [read_list, files{j}(1:end-2)];
                    end
                end
            end
        end
        
        function TloadAlgoProb(app)
            % load the algorithms and problems in Test module
            
            label_str = {app.TTaskTypeDropDown.Value, app.TSpecialTypeDropDown.Value};
            app.readAlgoProb(label_str);
            app.TAlgorithmDropDown.Items = {};
            app.TProblemDropDown.Items = {};
            app.TAlgorithmDropDown.Items = strrep(app.AlgoLoad, '_', '-');
            app.TAlgorithmDropDown.ItemsData = app.AlgoLoad;
            app.TProblemDropDown.Items = strrep(app.ProbLoad, '_', '-');
            app.TProblemDropDown.ItemsData = app.ProbLoad;
        end
        
        function EloadAlgoProb(app)
            % load the algorithms and problems in Experiment module
            
            label_str = {app.ETaskTypeDropDown.Value, app.ESpecialTypeDropDown.Value};
            app.readAlgoProb(label_str);
            app.EAlgorithmsListBox.Items(:) = [];
            app.EProblemsListBox.Items(:) = [];
            app.EAlgorithmsListBox.Items = strrep(app.AlgoLoad, '_', '-');
            app.EAlgorithmsListBox.ItemsData = app.AlgoLoad;
            app.EProblemsListBox.Items = strrep(app.ProbLoad, '_', '-');
            app.EProblemsListBox.ItemsData = app.ProbLoad;
        end
        
        function TstartEnable(app, value)
            % change controler enable when start button pused and end
            % in Test module
            
            app.TStartButton.Enable = value;
            app.TTaskTypeDropDown.Enable = value;
            app.TSpecialTypeDropDown.Enable = value;
            app.TAlgorithmDropDown.Enable = value;
            app.TAlgorithmTree.Enable = value;
            app.TProblemDropDown.Enable = value;
            app.TProblemTree.Enable = value;
        end
        
        function EstartEnable(app, value)
            % change controler enable when start button pused and end
            % in Experiment module
            
            app.EStartButton.Enable = value;
            app.ERepsEditField.Enable = value;
            app.EParallelDropDown.Enable = value;
            app.ETaskTypeDropDown.Enable = value;
            app.ESpecialTypeDropDown.Enable = value;
            app.EAlgorithmsAddButton.Enable = value;
            app.EProblemsAddButton.Enable = value;
            app.EAlgorithmsListBox.Enable = value;
            app.EProblemsListBox.Enable = value;
            app.EAlgorithmsDelButton.Enable = value;
            app.EProblemsDelButton.Enable = value;
            app.EAlgorithmsTree.Enable = value;
            app.EProblemsTree.Enable = value;
            app.ELoadDataButton.Enable = value;
            app.ESaveDataButton.Enable = value;
            app.EPauseButton.Enable = ~value;
            app.EStopButton.Enable = ~value;
        end
        
        function EcheckPauseStopStatus(app)
            % This function can be called at any time to check that status of the pause and stop buttons.
            % If paused, it will wait until un-paused.
            % If stopped, it will throw an error to break execution. The error will not be thrown.
            
            if app.EStopFlag
                app.EstartEnable(true);
                error('User Stop');
            end
            
            if strcmp(app.EPauseButton.Text, 'Resume')
                waitfor(app.EPauseButton,'Text', 'Pause');
            end
        end
        
        function TupdateAlgorithm(app)
            % update algorithm tree in Test module
            
            if isempty(app.TAlgorithmDropDown.Value)
                return;
            end
            
            app.TAlgorithmTree.Children.delete;
            
            algo_name = app.TAlgorithmDropDown.Value;
            eval(['algo_obj = ', algo_name, '(''', strrep(algo_name, '_', '-'), ''');']);
            algo_node = uitreenode(app.TAlgorithmTree);
            algo_node.Text = algo_obj.Name;
            algo_node.NodeData = algo_obj;
            algo_node.ContextMenu = app.SelectedProbContextMenu;
            
            % child parameter node
            parameter = algo_obj.getParameter();
            for p = 1:2:length(parameter)
                para_name_node = uitreenode(algo_node);
                para_name_node.Text = ['[ ', parameter{p}, ' ]'];
                para_name_node.NodeData = para_name_node.Text;
                para_name_node.ContextMenu = app.SelectedAlgoContextMenu;
                para_value_node = uitreenode(algo_node);
                para_value_node.Text = parameter{p+1};
                para_value_node.ContextMenu = app.SelectedAlgoContextMenu;
            end
            
            expand(algo_node);
        end
        
        function TupdateProblem(app)
            % update problem tree in Test module
            
            if isempty(app.TProblemDropDown.Value)
                return;
            end
            
            app.TProblemTree.Children.delete;
            
            prob_name = app.TProblemDropDown.Value;
            eval(['prob_obj = ', prob_name, '(''', strrep(prob_name, '_', '-'), ''');']);
            prob_node = uitreenode(app.TProblemTree);
            prob_node.Text = prob_obj.Name;
            prob_node.NodeData = prob_obj;
            prob_node.ContextMenu = app.SelectedProbContextMenu;
            
            % child parameter node
            parameter = prob_obj.getParameter();
            for p = 1:2:length(parameter)
                para_name_node = uitreenode(prob_node);
                para_name_node.Text = ['[ ', parameter{p}, ' ]'];
                para_name_node.NodeData = para_name_node.Text;
                para_name_node.ContextMenu = app.SelectedProbContextMenu;
                para_value_node = uitreenode(prob_node);
                para_value_node.Text = parameter{p+1};
                para_value_node.ContextMenu = app.SelectedProbContextMenu;
            end
            
            expand(prob_node);
        end
        
        function TupdateUIAxes(app)
            % update UI Axes in Test module
            
            cla(app.TUIAxes, 'reset');
            type = app.TShowTypeDropDown.Value;
            switch type
                case 'Tasks Figure (1D Unified)' % Tasks Figure (1D unified)
                    app.TupdateTasksFigure();
                case 'Tasks Figure (1D Real)' % Tasks Figure (1D real)
                    app.TupdateTasksFigure();
                case 'Feasible Region (2D)' % Feasible Region (2D)
                    app.TupdateFeasibleRegion();
                otherwise % Metric
                    app.TupdateFigureAxes();
            end
        end
        
        function TupdateTasksFigure(app)
            % update selected problem tasks figure in Test module
            try
                x = 0:1/1000:1;
                f = zeros(size(x));
                
                legend_cell = {};
                plot_handle = {};
                color = colororder;
                for no = 1:app.TProblemTree.Children(1).NodeData.T
                    for i = 1:length(x)
                        minrange = app.TProblemTree.Children(1).NodeData.Lb{no}(1);
                        maxrange = app.TProblemTree.Children(1).NodeData.Ub{no}(1);
                        y = maxrange - minrange;
                        vars = y .* x(i) + minrange;
                        [ff, con] = app.TProblemTree.Children(1).NodeData.Fnc{no}(vars);
                        if con > 0
                            f(i) = NaN;
                        else
                            f(i) = ff;
                        end
                    end
                    
                    fmin = min(f);
                    fmax = max(f);
                    if strcmp(app.TShowTypeDropDown.Value, 'Tasks Figure (1D Unified)') % unified
                        f = (f - fmin) / (fmax - fmin);
                    end
                    
                    p1 = plot(app.TUIAxes, x, f);
                    p1.Color = color(mod(no-1, size(color, 1))+1, :);
                    p1.LineWidth = 1;
                    hold(app.TUIAxes, 'on');
                    
                    if ~isnan(f)
                        xmin = x(f == min(f));
                        fmin = min(f) * ones(size(xmin));
                        p2 = plot(app.TUIAxes, xmin, fmin, '^');
                        p2.MarkerSize = 8;
                        p2.MarkerFaceColor = color(mod(no-1, size(color, 1))+1, :);
                        p2.MarkerEdgeColor = color(mod(no-1, size(color, 1))+1, :);
                        hold(app.TUIAxes, 'on');
                    end
                    
                    legend_cell = [legend_cell, ['Task', num2str(no)]];
                    plot_handle = [plot_handle, p1];
                end
                xlim(app.TUIAxes, [0, 1]);
                xlabel(app.TUIAxes, 'Variable Value');
                ylabel(app.TUIAxes, 'Objective Value');
                legend(app.TUIAxes, plot_handle, legend_cell);
            catch ME
                return;
            end
        end
        
        function TupdateFeasibleRegion(app)
            % update selected problem tasks feasible region
            
            try
                if ~strcmp(app.TSpecialTypeDropDown.Value, 'Constrained')
                    return;
                end
                
                x = 0:1/150:1;
                
                legend_cell = {};
                plot_handle = {};
                
                color = colororder;
                for no = 1:app.TProblemTree.Children(1).NodeData.T
                    %x = x + (1/100)/3;
                    %x = x(1:end-1);
                    x1 = [];
                    x2 = [];
                    minrange = app.TProblemTree.Children(1).NodeData.Lb{no}(1);
                    maxrange = app.TProblemTree.Children(1).NodeData.Ub{no}(1);
                    y = maxrange - minrange;
                    
                    for i = 1:length(x)
                        for j = 1:length(x)
                            vars1 = y .* x(i) + minrange;
                            vars2 = y .* x(j) + minrange;
                            [ff, con] = app.TProblemTree.Children(1).NodeData.Fnc{no}([vars1, vars2]);
                            if con <= 0
                                x1 = [x1, x(i)];
                                x2 = [x2, x(j)];
                            end
                        end
                    end
                    
                    p1 = scatter(app.TUIAxes, x1, x2, 6, 'filled');
                    p1.MarkerFaceAlpha = 0.6;
                    p1.MarkerEdgeAlpha = 0.6;
                    p1.MarkerEdgeColor = color(mod(no-1, size(color, 1))+1, :);
                    % p1.MarkerFaceColor = color(mod(no-1, size(color, 1))+1, :);
                    hold(app.TUIAxes, 'on');
                    
                    legend_cell = [legend_cell, ['T', num2str(no)]];
                    plot_handle = [plot_handle, p1];
                end
                xlim(app.TUIAxes, [0, 1]);
                ylim(app.TUIAxes, [0, 1]);
                legend(app.TUIAxes, plot_handle, legend_cell);
            catch ME
                return;
            end
        end
        
        function TupdateFigureAxes(app)
            % update figure axes
            
            if isempty(app.TData)
                return;
            end
            eval(['TFigureData = ', app.TShowTypeDropDown.Value, '(app.TData);']);
            cla(app.TUIAxes, 'reset');
            
            xdata = TFigureData.XData(:, 1);
            ydata = TFigureData.YData(:, 1);
            xlim_max = 0;
            tasks_name = {};
            for i = 1:length(xdata)
                if i > length(TFigureData.MarkerType)
                    marker = '';
                else
                    marker = TFigureData.MarkerType{i};
                end
                p = plot(app.TUIAxes, xdata{i}, ydata{i}, ['-', marker]);
                p.LineWidth = TFigureData.LineWidth;
                indices = round(length(ydata{i})/TFigureData.MarkerNum);
                p.MarkerIndices = indices:indices:length(ydata{i})-round(indices/2);
                p.MarkerSize = TFigureData.MarkerSize;
                hold(app.TUIAxes, 'on');
                xlim_max = max(xlim_max, xdata{i}(end));
                tasks_name = [tasks_name, ['T', num2str(i)]];
            end
            
            xlim(app.TUIAxes, [1, xlim_max]);
            xlabel(app.TUIAxes, TFigureData.XLabel);
            ylabel(app.TUIAxes, TFigureData.YLabel);
            if length(xdata) > 1
                legend(app.TUIAxes, tasks_name);
            end
            grid(app.TUIAxes, TFigureData.GridType);
        end
        
        function Toutput(app, output_str)
            if strcmp(app.TOutputTextArea.Value, '')
                app.TOutputTextArea.Value = output_str;
            else
                app.TOutputTextArea.Value = [app.TOutputTextArea.Value; output_str];
            end
            drawnow;
        end
        
        function EresetTableAlgorithmDropDown(app, algo_cell)
            % reset table's algorithms drop down in Experiment module
            
            algo_index = [];
            for algo = 1:length(algo_cell)
                algo_index = [algo_index, algo];
            end
            app.EAlgorithmDropDown.Items = algo_cell;
            app.EAlgorithmDropDown.ItemsData = algo_index;
            app.EAlgorithmDropDown.Value = 1;
        end
        
        function EresetTable(app, row_name, column_name)
            % reset table in Experiment module
            
            app.EUITable.Data = {};
            app.EUITable.RowName = row_name;
            app.EUITable.ColumnName = column_name;
            app.ETableData = {};
            app.ETableView = {};
            app.ETableTest = {};
            drawnow;
        end
        
        function EupdateTableReps(app)
            % update table reps per run
            
            app.EUITable.Data = sprintfc('%d', app.ETableReps);
            drawnow;
        end
        
        function EupdateTableData(app, table_data)
            % update table data
            
            show_type = app.EShowTypeDropDown.Value;
            format_str = app.EDataFormatEditField.Value;
            app.EUITable.Data = {};
            app.ETableData = [];
            app.ETableView = {};
            
            switch show_type
                case 'Mean' % Mean
                    data_mean = nanmean(table_data, 3);
                    app.ETableData = data_mean;
                    app.ETableView = sprintfc(format_str, data_mean);
                case 'Mean&Std' % Mean&Std
                    data_mean = nanmean(table_data, 3);
                    data_std = nanstd(table_data, 0, 3);
                    app.ETableData = data_mean;
                    x = zeros([size(data_mean, 1), 2*size(data_mean, 2)]);
                    x(:, 1:2:end) = data_mean;
                    x(:, 2:2:end) = data_std;
                    app.ETableView = sprintfc(format_str, x);
                case 'Std'
                    data_std = nanstd(table_data, 0, 3);
                    app.ETableData = data_std;
                    app.ETableView = sprintfc(format_str, data_std);
                case 'Median'
                    data_median = nanmedian(table_data, 3);
                    app.ETableData = data_median;
                    app.ETableView = sprintfc(format_str, data_median);
                case 'Best'
                    data_min = min(table_data, [], 3);
                    app.ETableData = data_min;
                    app.ETableView = sprintfc(format_str, data_min);
                case 'Worst'
                    data_nan = max(isnan(table_data), [], 3);
                    data_max = max(table_data, [], 3);
                    data_max(data_nan == 1) = NaN;
                    app.ETableData = data_max;
                    app.ETableView = sprintfc(format_str, data_max);
            end
            app.EUITable.Data = app.ETableView;
        end
        
        function EupdateTableTest(app, table_data)
            % update table test
            
            if isempty(app.EData)
                return;
            end
            
            test_type = app.ETestTypeDropDown.Value;
            algo_selected = app.EAlgorithmDropDown.Value;
            app.ETableTest = {};
            
            if strcmp(test_type, 'None')
                app.EUITable.Data = app.ETableView;
                app.EUITable.RowName{size(app.ETableData, 1)+1} = [];
                drawnow;
                return;
            end
            
            app.EUITable.RowName{size(app.ETableData, 1)+1} = '+/-/=';
            
            % Rank sum or Signed rank test
            for algo = 1:size(app.ETableData, 2)
                if algo == algo_selected
                    app.ETableTest{size(app.ETableData, 1)+1, algo} = 'Base';
                    continue;
                end
                sign_p = [0 0 0];
                for row_i = 1:size(app.ETableData, 1)
                    x1 = reshape(table_data(row_i, algo, :), 1, length(table_data(row_i, algo, :)));
                    x2 = reshape(table_data(row_i, algo_selected, :), 1, length(table_data(row_i, algo_selected, :)));
                    
                    p = 0;
                    x1(isnan(x1)) = 1e5; % big number replace NaN
                    x2(isnan(x2)) = 1e5; % big number replace NaN
                    if strcmp(test_type, 'Rank sum test')
                        p = ranksum(x1, x2);
                    elseif strcmp(test_type, 'Signed rank test')
                        p = signrank(x1, x2);
                    end
                    if p < 0.05
                        data1 = app.ETableData(row_i, algo);
                        data1(isnan(data1)) = 1e5;
                        data2 = app.ETableData(row_i, algo_selected);
                        data2(isnan(data2)) = 1e5;
                        if data1 < data2
                            app.ETableTest{row_i, algo} = '+';
                            sign_p(1) = sign_p(1) + 1;
                        elseif data1 > data2
                            app.ETableTest{row_i, algo} = '-';
                            sign_p(2) = sign_p(2) + 1;
                        else
                            app.ETableTest{row_i, algo} = '=';
                            sign_p(3) = sign_p(3) + 1;
                        end
                    else
                        app.ETableTest{row_i, algo} = '=';
                        sign_p(3) = sign_p(3) + 1;
                    end
                end
                app.ETableTest{size(app.ETableData, 1)+1, algo} = sprintf('%d/%d/%d', sign_p);
            end
            for algo = 1:size(app.ETableData, 2)
                for row_i = 1:size(app.ETableData, 1)
                    if size(app.ETableTest, 2) < algo
                        app.EUITable.Data{row_i, algo} = app.ETableView{row_i, algo};
                    else
                        app.EUITable.Data{row_i, algo} = [app.ETableView{row_i, algo}, ' ', app.ETableTest{row_i, algo}];
                    end
                    drawnow;
                end
                if size(app.ETableTest, 2) < algo
                    app.EUITable.Data{size(app.ETableData, 1)+1, algo} = '';
                else
                    app.EUITable.Data{size(app.ETableData, 1)+1, algo} = app.ETableTest{size(app.ETableData, 1)+1, algo};
                end
                drawnow;
            end
        end
        
        function EupdateTableHighlight(app)
            % update table highlight
            
            highlight_type = app.EHighlightTypeDropDown.Value;
            
            % highlight best value
            app.EUITable.removeStyle();
            high_color = uistyle('BackgroundColor', [0.67,0.95,0.67]);
            font_bold = uistyle('FontWeight', 'bold');
            low_color = uistyle('BackgroundColor', [1.00,0.60,0.60]);
            if isempty(app.ETableData) || size(app.ETableData, 2) <= 1
                drawnow;
                return;
            end
            for row_i = 1:size(app.ETableData, 1)
                % best
                if ~strcmp(highlight_type, 'None')
                    if ~(sum(isnan(app.ETableData(row_i, :))) == size(app.ETableData, 2))
                        temp_data = app.ETableData(row_i, :);
                        min_data = min(temp_data);
                        temp_idx = temp_data == min_data;
                        x = 1:length(temp_idx);
                        x = x(temp_idx);
                        for xx = 1:length(x)
                            app.EUITable.addStyle(high_color, 'cell', [row_i, x(xx)]);
                            app.EUITable.addStyle(font_bold, 'cell', [row_i, x(xx)]);
                        end
                    end
                end
                % worst
                if strcmp(highlight_type, 'Best&Worst')
                    isnan_temp = isnan(app.ETableData(row_i, :));
                    if sum(isnan_temp)
                        x = 1:length(isnan_temp);
                        x = x(isnan_temp);
                        for xx = 1:length(x)
                            app.EUITable.addStyle(low_color, 'cell', [row_i, x(xx)]);
                        end
                    else
                        [~, index] = max(app.ETableData(row_i, :));
                        app.EUITable.addStyle(low_color, 'cell', [row_i, index]);
                    end
                end
                drawnow;
            end
        end
        
        function EupdateTable(app)
            % update table in Experiment module
            
            if isempty(app.EData)
                return;
            end
            
            switch app.EDataTypeDropDown.Value
                case 'Reps'
                    app.EresetTable({app.EData.Problems.Name}, {app.EData.Algorithms.Name});
                    app.EupdateTableReps();
                otherwise
                    eval(['result = ', app.EDataTypeDropDown.Value, '(app.EData);']);
                    app.EresetTable(result.RowName, result.ColumnName);
                    app.EupdateTableData(result.TableData);
                    app.EupdateTableTest(result.TableData);
            end
            drawnow;
            app.EupdateTableHighlight();
        end
        
        function EresetFormat(app)
            format_str = app.EDataFormatEditField.Value;
            
            switch app.EShowTypeDropDown.Value
                case 'Mean'
                    format_str = '%.2e';
                case 'Mean&Std'
                    format_str = '%.2e (%.2e)';
                case 'Std'
                    format_str = '%.2e';
                case 'Median'
                    format_str = '%.2e';
                case 'Best'
                    format_str = '%.2e';
                case 'Worst'
                    format_str = '%.2e';
            end
            
            app.EDataFormatEditField.Value = format_str;
        end
        
        function EresetFigureData(app)
            cla(app.EConvergenceTrendUIAxes, 'reset');
            
            if isempty(app.EData)
                app.EFigureData = [];
                return;
            end
            
            eval(['app.EFigureData = ', app.EFigureTypeDropDown.Value, '(app.EData);']);
            app.EProblemsDropDown.Items = app.EFigureData.Problems;
            app.EProblemsDropDown.ItemsData = 1:length(app.EProblemsDropDown.Items);
            app.EupdateFigureAxes();
        end
        
        function EupdateFigureAxes(app)
            % update figure axes
            
            cla(app.EConvergenceTrendUIAxes, 'reset');
            problem_index = app.EProblemsDropDown.Value;
            xlim_max = 0;
            xdata = app.EFigureData.XData(problem_index, :);
            ydata = app.EFigureData.YData(problem_index, :);
            
            for i = 1:length(xdata)
                if i > length(app.EFigureData.MarkerType)
                    marker = '';
                else
                    marker = app.EFigureData.MarkerType{i};
                end
                p = plot(app.EConvergenceTrendUIAxes, xdata{i}, ydata{i}, ['-', marker]);
                p.LineWidth = app.EFigureData.LineWidth;
                indices = round(length(ydata{i})/app.EFigureData.MarkerNum);
                p.MarkerIndices = indices:indices:length(ydata{i})-round(indices/2);
                p.MarkerSize = app.EFigureData.MarkerSize;
                hold(app.EConvergenceTrendUIAxes, 'on');
                xlim_max = max(xlim_max, xdata{i}(end));
            end
            
            xlim(app.EConvergenceTrendUIAxes, [1, xlim_max]);
            xlabel(app.EConvergenceTrendUIAxes, app.EFigureData.XLabel);
            ylabel(app.EConvergenceTrendUIAxes, app.EFigureData.YLabel);
            legend(app.EConvergenceTrendUIAxes, strrep(app.EFigureData.Legend, '_', '\_'));
            grid(app.EConvergenceTrendUIAxes, app.EFigureData.GridType);
        end
        
        function result = DcheckSplitData(app)
            % check and reproduce split data
            
            data_selected = app.DDataTree.SelectedNodes;
            app.DDataFlag = [];
            data_num = 0;
            for i = 1:length(data_selected)
                if isa(data_selected(i).Parent, 'matlab.ui.container.Tree')
                    data_num = data_num + 1;
                    app.DDataFlag(i) = 1;
                else
                    app.DDataFlag(i) = 0;
                end
            end
            if data_num < 1
                msg = 'Select at least 1 data node to split';
                uiconfirm(app.MTOPlatformUIFigure, msg, 'error', 'Icon','warning');
                result = false;
                return;
            end
            
            result = true;
        end
        
        function result = DcheckMergeData(app)
            % check merge data num, pop size, iter num, eva num
            % select legal node
            
            data_selected = app.DDataTree.SelectedNodes;
            app.DDataFlag = [];
            data_num = 0;
            for i = 1:length(data_selected)
                if isa(data_selected(i).Parent, 'matlab.ui.container.Tree')
                    data_num = data_num + 1;
                    app.DDataFlag(i) = 1;
                else
                    app.DDataFlag(i) = 0;
                end
            end
            if data_num < 2
                msg = 'Select at least 2 data node to merge';
                uiconfirm(app.MTOPlatformUIFigure, msg, 'error', 'Icon','warning');
                result = false;
                return;
            end
            result = true;
        end
        
        function result = DcheckMergeReps(app)
            % check merge reps
            
            data_num = sum(app.DDataFlag);
            data_selected = app.DDataTree.SelectedNodes;
            data_selected = data_selected(app.DDataFlag == 1);
            reps = data_selected(1).NodeData.Reps;
            for i = 2:data_num
                if data_selected(i).NodeData.Reps ~= reps
                    msg = 'The data''s reps not equal';
                    uiconfirm(app.MTOPlatformUIFigure, msg, 'error', 'Icon','warning');
                    result = false;
                    return;
                end
            end
            result = true;
        end
        
        function result = DcheckMergeAlgorithms(app)
            % check merge algorithms
            
            data_num = sum(app.DDataFlag);
            data_selected = app.DDataTree.SelectedNodes;
            data_selected = data_selected(app.DDataFlag == 1);
            algorithms = data_selected(1).NodeData.Algorithms;
            for i = 2:data_num
                % check algo length
                if length(algorithms) ~= length(data_selected(i).NodeData.Algorithms)
                    msg = 'The data''s algorithms not equal';
                    uiconfirm(app.MTOPlatformUIFigure, msg, 'error', 'Icon','warning');
                    result = false;
                    return;
                end
                for algo = 1:length(algorithms)
                    % check algo name
                    if ~strcmp(data_selected(i).NodeData.Algorithms(algo).Name, algorithms(algo).Name)
                        msg = 'The data''s algorithms not equal';
                        uiconfirm(app.MTOPlatformUIFigure, msg, 'error', 'Icon','warning');
                        result = false;
                        return;
                    end
                    % check algo para length
                    if length(algorithms(algo).Para) ~= length(data_selected(i).NodeData.Algorithms(algo).Para)
                        msg = 'The data''s algorithms not equal';
                        uiconfirm(app.MTOPlatformUIFigure, msg, 'error', 'Icon','warning');
                        result = false;
                        return;
                    end
                    for pa = 1:length(algorithms(algo).Para)
                        % check algo para name
                        if ~strcmp(data_selected(i).NodeData.Algorithms(algo).Para{pa}, algorithms(algo).Para{pa})
                            msg = 'The data''s algorithms not equal';
                            uiconfirm(app.MTOPlatformUIFigure, msg, 'error', 'Icon','warning');
                            result = false;
                            return;
                        end
                    end
                end
            end
            result = true;
        end
        
        function result = DcheckMergeProblems(app)
            % check merge problems
            
            data_num = sum(app.DDataFlag);
            data_selected = app.DDataTree.SelectedNodes;
            data_selected = data_selected(app.DDataFlag == 1);
            problems = data_selected(1).NodeData.Problems;
            for i = 2:data_num
                % check prob length
                if length(problems) ~= length(data_selected(i).NodeData.Problems)
                    msg = 'The data''s problems not equal';
                    uiconfirm(app.MTOPlatformUIFigure, msg, 'error', 'Icon','warning');
                    result = false;
                    return;
                end
                for prob = 1:length(problems)
                    % check prob name
                    if ~strcmp(data_selected(i).NodeData.Problems(prob).Name, problems(prob).Name) || ...
                            data_selected(i).NodeData.Problems(prob).T ~= problems(prob).T || ...
                            data_selected(i).NodeData.Problems(prob).M ~= problems(prob).M || ...
                            sum(data_selected(i).NodeData.Problems(prob).D ~= problems(prob).D) || ...
                            data_selected(i).NodeData.Problems(prob).N ~= problems(prob).N || ...
                            data_selected(i).NodeData.Problems(prob).maxFE ~= problems(prob).maxFE
                        msg = 'The data''s problems not equal';
                        uiconfirm(app.MTOPlatformUIFigure, msg, 'error', 'Icon','warning');
                        result = false;
                        return;
                    end
                end
            end
            result = true;
        end
        
        function DputDataNode(app, name, MTOData)
            % add data to tree in Data process module
            
            data_node = uitreenode(app.DDataTree);
            data_node.Text = name;
            data_node.NodeData = MTOData;
            data_node.ContextMenu = app.DDataContextMenu;
            
            % child node
            reps_node = uitreenode(data_node);
            reps_node.Text = ['Reps: ', num2str(data_node.NodeData.Reps)];
            reps_node.NodeData = reps_node.Text;
            reps_node.ContextMenu = app.DDataContextMenu;
            
            algo_node = uitreenode(data_node);
            algo_node.Text = 'Algorithms:';
            algo_node.NodeData = algo_node.Text;
            algo_node.ContextMenu = app.DDataContextMenu;
            for algo = 1:length(data_node.NodeData.Algorithms)
                algo_child_node = uitreenode(algo_node);
                algo_child_node.Text = data_node.NodeData.Algorithms(algo).Name;
                algo_child_node.NodeData = algo_child_node.Text;
                algo_child_node.ContextMenu = app.DDataContextMenu;
            end
            
            prob_node = uitreenode(data_node);
            prob_node.Text = 'Problems:';
            prob_node.ContextMenu = app.DDataContextMenu;
            for prob = 1:length(data_node.NodeData.Problems)
                prob_child_node = uitreenode(prob_node);
                prob_child_node.Text = data_node.NodeData.Problems(prob).Name;
                prob_child_node.NodeData = prob_child_node.Text;
                prob_child_node.ContextMenu = app.DDataContextMenu;
            end
        end
        
        function DsaveData(app, MTOData)
            % save data to folder in Data process module
            
            % check selected file name
            [file_name, dir_name] = uiputfile('MTOData.mat');
            figure(app.MTOPlatformUIFigure);
            if file_name == 0
                return;
            end
            
            % save data
            save([dir_name, file_name], 'MTOData');
        end
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            % App startup function
            
            app.TloadAlgoProb();
            app.TupdateAlgorithm();
            app.TupdateProblem();
            app.TupdateUIAxes();
            app.EloadAlgoProb();
            app.readMetric();
        end

        % Value changed function: TTaskTypeDropDown
        function TTaskTypeDropDownValueChanged(app, event)
            app.TloadAlgoProb();
        end

        % Value changed function: TSpecialTypeDropDown
        function TSpecialTypeDropDownValueChanged(app, event)
            app.TloadAlgoProb();
        end

        % Value changed function: TAlgorithmDropDown
        function TAlgorithmDropDownValueChanged(app, event)
            app.TupdateAlgorithm();
            app.TData = [];
            app.TupdateUIAxes();
        end

        % Drop down opening function: TAlgorithmDropDown
        function TAlgorithmDropDownOpening(app, event)
            app.TupdateAlgorithm();
            app.TData = [];
            app.TupdateUIAxes();
        end

        % Node text changed function: TAlgorithmTree
        function TAlgorithmTreeNodeTextChanged(app, event)
            % update algorithm obj parameter
            
            node = event.Node;
            if isa(node.Parent, 'matlab.ui.container.Tree')
                % this is algorithm name node
                node.NodeData.name = node.Text;
            else
                % this is parameter node
                parameter = {};
                % the first node text is parameter name, can't change
                for x = 1:2:length(node.Parent.Children)
                    node.Parent.Children(x).Text = node.Parent.Children(x).NodeData;
                end
                % the second node text is parameter value
                for x = 2:2:length(node.Parent.Children)
                    parameter = [parameter, node.Parent.Children(x).Text];
                end
                node.Parent.NodeData.setParameter(parameter);
            end
            app.TData = [];
            app.TupdateUIAxes();
        end

        % Value changed function: TProblemDropDown
        function TProblemDropDownValueChanged(app, event)
            app.TupdateProblem();
            app.TData = [];
            app.TupdateUIAxes();
        end

        % Drop down opening function: TProblemDropDown
        function TProblemDropDownOpening(app, event)
            app.TupdateProblem();
            app.TData = [];
            app.TupdateUIAxes();
        end

        % Node text changed function: TProblemTree
        function TProblemTreeNodeTextChanged(app, event)
            % update problem obj parameter
            
            node = event.Node;
            if isa(node.Parent, 'matlab.ui.container.Tree')
                % this is problem node
                node.NodeData.name = node.Text;
            else
                % this is parameter node
                parameter = {};
                % the first node text is parameter name, can't change
                for x = 1:2:length(node.Parent.Children)
                    node.Parent.Children(x).Text = node.Parent.Children(x).NodeData;
                end
                % the second node text is parameter value
                for x = 2:2:length(node.Parent.Children)
                    parameter = [parameter, node.Parent.Children(x).Text];
                end
                node.Parent.NodeData.setParameter(parameter);
            end
            
            app.TData = [];
            app.TupdateUIAxes();
        end

        % Value changed function: TShowTypeDropDown
        function TShowTypeDropDownValueChanged(app, event)
            app.TupdateUIAxes();
        end

        % Button pushed function: TStartButton
        function TStartButtonPushed(app, event)
            % start this test
            
            % off the start button
            app.TstartEnable(false);
            drawnow;
            
            % set data
            app.TData = [];
            app.TData.Reps = 1;
            app.TData.Problems = [];
            app.TData.Problems(1).Name = app.TProblemTree.Children(1).NodeData.Name;
            app.TData.Problems(1).T = app.TProblemTree.Children(1).NodeData.T;
            app.TData.Problems(1).M = app.TProblemTree.Children(1).NodeData.M;
            app.TData.Problems(1).D = app.TProblemTree.Children(1).NodeData.D;
            app.TData.Problems(1).N = app.TProblemTree.Children(1).NodeData.N;
            app.TData.Problems(1).Fnc = app.TProblemTree.Children(1).NodeData.Fnc;
            app.TData.Problems(1).Lb = app.TProblemTree.Children(1).NodeData.Lb;
            app.TData.Problems(1).Ub = app.TProblemTree.Children(1).NodeData.Ub;
            app.TData.Problems(1).maxFE = app.TProblemTree.Children(1).NodeData.maxFE;
            app.TData.Algorithms = [];
            app.TData.Algorithms(1).Name = app.TAlgorithmTree.Children(1).NodeData.Name;
            app.TData.Algorithms(1).Para = app.TAlgorithmTree.Children(1).NodeData.getParameter();
            app.TData.Results = [];
            app.TData.RunTimes = [];
            
            % run
            app.TAlgorithmTree.Children(1).NodeData.run(app.TProblemTree.Children(1).NodeData);
            tmp = app.TAlgorithmTree.Children(1).NodeData.getResult(app.TProblemTree.Children(1).NodeData);
            for t = 1:size(tmp, 1)
                for g = 1:size(tmp,2)
                    app.TData.Results(1,1,1).Obj(t, g) = tmp(t, g).Obj;
                    app.TData.Results(1,1,1).CV(t, g) = tmp(t, g).CV;
                end
            end
            best_data = app.TAlgorithmTree.Children(1).NodeData.Best;
            app.TAlgorithmTree.Children(1).NodeData.reset();
            
            app.TupdateUIAxes();
            
            % Output Best Data To Right Text
            app.Toutput(['Algo: ', app.TData.Algorithms(1).Name]);
            app.Toutput(['Prob: ', app.TData.Problems(1).Name]);
            for t = 1:length(best_data)
                app.Toutput(['T', num2str(t), ' Obj: ', num2str(best_data{t}.Obj, '%.2e'), ...
                    ' CV: ', num2str(best_data{t}.CV, '%.2e')]);
            end
            app.Toutput('-------------------------------------------');
            
            app.TstartEnable(true);
        end

        % Button pushed function: TResetButton
        function TResetButtonPushed(app, event)
            app.TData = [];
            app.TupdateUIAxes();
            app.TstartEnable(true);
        end

        % Button pushed function: TSaveButton
        function TSaveButtonPushed(app, event)
            % check selected file name
            filter = {'*.eps'; '*.pdf';'*.png';};
            [file_name, dir_name] = uiputfile(filter);
            if file_name == 0
                return;
            end
            exportgraphics(app.TUIAxes, [dir_name, file_name]);
        end

        % Value changed function: ETaskTypeDropDown
        function ETaskTypeDropDownValueChanged(app, event)
            app.EloadAlgoProb();
        end

        % Value changed function: ESpecialTypeDropDown
        function ESpecialTypeDropDownValueChanged(app, event)
            app.EloadAlgoProb();
        end

        % Context menu opening function: AlgorithmsContextMenu
        function AlgorithmsContextMenuOpening(app, event)
            % select all algorithms
            
            if ~isempty(app.EAlgorithmsListBox.Items)
                app.EAlgorithmsListBox.Value = app.EAlgorithmsListBox.ItemsData;
            end
        end

        % Button pushed function: EAlgorithmsAddButton
        function EAlgorithmsAddButtonPushed(app, event)
            % add selected algorithms to selected algorithms tree
            
            algo_selected = app.EAlgorithmsListBox.Value;
            for i= 1:length(algo_selected)
                eval(['algo_obj = ', algo_selected{i}, '(''', strrep(algo_selected{i}, '_', '-'), ''');']);
                algo_node = uitreenode(app.EAlgorithmsTree);
                algo_node.Text = algo_obj.Name;
                algo_node.NodeData = algo_obj;
                algo_node.ContextMenu = app.SelectedAlgoContextMenu;
                
                % child parameter node
                parameter = algo_obj.getParameter();
                for p = 1:2:length(parameter)
                    para_name_node = uitreenode(algo_node);
                    para_name_node.Text = ['[ ', parameter{p}, ' ]'];
                    para_name_node.NodeData = para_name_node.Text;
                    para_name_node.ContextMenu = app.SelectedAlgoContextMenu;
                    para_value_node = uitreenode(algo_node);
                    para_value_node.Text = parameter{p+1};
                    para_value_node.ContextMenu = app.SelectedAlgoContextMenu;
                end
            end
            
            % collapse other node and expand this node
            all_node = algo_node.Parent.Children;
            for i = 1:length(all_node)
                collapse(all_node(i));
            end
            expand(algo_node);
        end

        % Menu selected function: ProblemsSelectAllMenu
        function EProblemsContextMenuOpening(app, event)
            % select all problems
            
            if ~isempty(app.EProblemsListBox.Items)
                app.EProblemsListBox.Value = app.EProblemsListBox.ItemsData;
            end
        end

        % Button pushed function: EProblemsAddButton
        function EProblemsAddButtonPushed(app, event)
            % add selected problems to selected problems tree
            
            prob_selected = app.EProblemsListBox.Value;
            for i= 1:length(prob_selected)
                eval(['prob_obj = ', prob_selected{i}, '(''', strrep(prob_selected{i}, '_', '-'), ''');']);
                prob_node = uitreenode(app.EProblemsTree);
                prob_node.Text = prob_obj.Name;
                prob_node.NodeData = prob_obj;
                prob_node.ContextMenu = app.SelectedProbContextMenu;
                
                % child parameter node
                parameter = prob_obj.getParameter();
                for p = 1:2:length(parameter)
                    para_name_node = uitreenode(prob_node);
                    para_name_node.Text = ['[ ', parameter{p}, ' ]'];
                    para_name_node.NodeData = para_name_node.Text;
                    para_name_node.ContextMenu = app.SelectedProbContextMenu;
                    para_value_node = uitreenode(prob_node);
                    para_value_node.Text = parameter{p+1};
                    para_value_node.ContextMenu = app.SelectedProbContextMenu;
                end
            end
            
            % collapse other node and expand this node
            all_node = prob_node.Parent.Children;
            for i = 1:length(all_node)
                collapse(all_node(i));
            end
            expand(prob_node);
        end

        % Button pushed function: EStartButton
        function EStartButtonPushed(app, event)
            % start this experiment
            
            % check selected
            algo_num = length(app.EAlgorithmsTree.Children);
            prob_num = length(app.EProblemsTree.Children);
            if algo_num == 0
                msg = 'Please select the Algorithm first';
                uiconfirm(app.MTOPlatformUIFigure, msg, 'error', 'Icon','warning');
                app.EstartEnable(true);
                return;
            end
            if prob_num == 0
                msg = 'Please select the Problem first';
                uiconfirm(app.MTOPlatformUIFigure, msg, 'error', 'Icon','warning');
                app.EstartEnable(true);
                return;
            end
            
            % off the start button
            app.EstartEnable(false);
            app.EStopFlag = false;
            app.EDataTypeDropDown.Value = 'Reps';
            
            % initialize data
            app.EData = [];
            MTOData.Reps = app.ERepsEditField.Value;
            MTOData.Problems = [];
            for prob = 1:prob_num
                MTOData.Problems(prob).Name = app.EProblemsTree.Children(prob).NodeData.Name;
                MTOData.Problems(prob).T = app.EProblemsTree.Children(prob).NodeData.T;
                MTOData.Problems(prob).M = app.EProblemsTree.Children(prob).NodeData.M;
                MTOData.Problems(prob).D = app.EProblemsTree.Children(prob).NodeData.D;
                MTOData.Problems(prob).N = app.EProblemsTree.Children(prob).NodeData.N;
                MTOData.Problems(prob).Fnc = app.EProblemsTree.Children(prob).NodeData.Fnc;
                MTOData.Problems(prob).Lb = app.EProblemsTree.Children(prob).NodeData.Lb;
                MTOData.Problems(prob).Ub = app.EProblemsTree.Children(prob).NodeData.Ub;
                MTOData.Problems(prob).maxFE = app.EProblemsTree.Children(prob).NodeData.maxFE;
            end
            problems_temp = MTOData.Problems;
            MTOData.Algorithms = [];
            for algo = 1:algo_num
                MTOData.Algorithms(algo).Name = app.EAlgorithmsTree.Children(algo).NodeData.Name;
                MTOData.Algorithms(algo).Para = app.EAlgorithmsTree.Children(algo).NodeData.getParameter();
            end
            MTOData.Results = [];
            MTOData.RunTimes = [];
            
            % reset table and convergence
            app.ETableReps = zeros(prob_num, algo_num);
            app.EupdateTableReps();
            app.EresetTable({MTOData.Problems.Name}, {MTOData.Algorithms.Name});
            app.EresetTableAlgorithmDropDown({MTOData.Algorithms.Name});
            cla(app.EConvergenceTrendUIAxes, 'reset');
            
            % main experiment loop
            tStart = tic;
            Results = [];
            % Run
            for prob = 1:prob_num
                for algo = 1:algo_num
                    % check pause and stop
                    algo_obj = app.EAlgorithmsTree.Children(algo).NodeData;
                    prob_obj = app.EProblemsTree.Children(prob).NodeData;
                    app.EcheckPauseStopStatus();
                    if app.EParallelDropDown.Value == 1
                        par_tool = Par(MTOData.Reps);
                        parfor rep = 1:MTOData.Reps
                            Par.tic
                            algo_obj.run(prob_obj);
                            tmp = algo_obj.getResult(prob_obj);
                            for t = 1:size(tmp, 1)
                                for g = 1:size(tmp,2)
                                    Results(prob, algo, rep).Obj(t, g) = tmp(t, g).Obj;
                                    Results(prob, algo, rep).CV(t, g) = tmp(t, g).CV;
                                    if isfield(tmp, 'Dec')
                                        Results(prob, algo, rep).Dec(t, g, :) = tmp(t, g).Dec;
                                    end
                                end
                            end
                            algo_obj.reset();
                            par_tool(rep) = Par.toc;
                        end
                        MTOData.RunTimes(prob, algo) = sum([par_tool.ItStop] - [par_tool.ItStart]);
                    else
                        t_temp = tic;
                        for rep = 1:MTOData.Reps
                            algo_obj.run(prob_obj);
                            tmp = algo_obj.getResult(prob_obj);
                            for t = 1:size(tmp, 1)
                                for g = 1:size(tmp,2)
                                    Results(prob, algo, rep).Obj(t, g) = tmp(t, g).Obj;
                                    Results(prob, algo, rep).CV(t, g) = tmp(t, g).CV;
                                    if isfield(tmp, 'Dec')
                                        Results(prob, algo, rep).Dec(t, g, :) = tmp(t, g).Dec;
                                    end
                                end
                            end
                            algo_obj.reset();
                            
                            app.ETableReps(prob, algo) = rep;
                            app.EupdateTableReps();
                        end
                        MTOData.RunTimes(prob, algo) = toc(t_temp);
                    end
                    app.ETableReps(prob, algo) = MTOData.Reps;
                    app.EupdateTableReps();
                    app.EcheckPauseStopStatus();
                end
                
                % save temporary data
                MTOData.Results = MakeGenEqual(Results);
                MTOData.Problems = problems_temp(1:prob);
                % save('MTOData_Temp', 'MTOData');
                app.EData = MTOData;
            end
            save('MTOData_Temp', 'MTOData');
            
            tEnd = toc(tStart);
            msg = ['All Use Time: ', char(duration([0, 0, tEnd]))];
            uiconfirm(app.MTOPlatformUIFigure, msg, 'success', 'Icon', 'success');
            
            app.EstartEnable(true);
            app.EupdateTable();
            app.EresetFigureData();
        end

        % Button pushed function: EPauseButton
        function EPauseButtonPushed(app, event)
            % pause or resume this experiment
            
            if strcmp(app.EPauseButton.Text, 'Pause')
                app.EStopButton.Enable = 'off';
                app.EPauseButton.Text = 'Resume';
            else
                app.EStopButton.Enable = 'on';
                app.EPauseButton.Text = 'Pause';
            end
        end

        % Button pushed function: EStopButton
        function EStopButtonPushed(app, event)
            % stop this experiment
            
            app.EstartEnable(true);
            app.EStopFlag = true;
        end

        % Context menu opening function: SelectedAlgoContextMenu
        function SelectedAlgoContextMenuOpening(app, event)
            % select all selected algorithms
            
            if ~isempty(app.EAlgorithmsTree.Children)
                app.EAlgorithmsTree.SelectedNodes = app.EAlgorithmsTree.Children;
            end
        end

        % Button pushed function: EAlgorithmsDelButton
        function EAlgorithmsDelButtonPushed(app, event)
            % delete selected algorithms from algorithms tree
            
            algo_selected = app.EAlgorithmsTree.SelectedNodes;
            if isempty(algo_selected)
                msg = 'Select Algorithm node in tree first';
                uiconfirm(app.MTOPlatformUIFigure, msg, 'error', 'Icon','warning');
            end
            
            for i = 1:length(algo_selected)
                if isa(algo_selected(i).Parent, 'matlab.ui.container.Tree')
                    algo_selected(i).delete;
                end
            end
        end

        % Node text changed function: EAlgorithmsTree
        function EAlgorithmsTreeNodeTextChanged(app, event)
            % update algorithm obj parameter
            
            node = event.Node;
            if isa(node.Parent, 'matlab.ui.container.Tree')
                % this is algorithm name node
                node.NodeData.name = node.Text;
            else
                % this is parameter node
                parameter = {};
                % the first node text is parameter name, can't change
                for x = 1:2:length(node.Parent.Children)
                    node.Parent.Children(x).Text = node.Parent.Children(x).NodeData;
                end
                % the second node text is parameter value
                for x = 2:2:length(node.Parent.Children)
                    parameter = [parameter, node.Parent.Children(x).Text];
                end
                node.Parent.NodeData.setParameter(parameter);
            end
        end

        % Menu selected function: SelectedProbSelectAllMenu
        function ESelectedProbContextMenuOpening(app, event)
            % select all selected problems
            
            if ~isempty(app.EProblemsTree.Children)
                app.EProblemsTree.SelectedNodes = app.EProblemsTree.Children;
            end
        end

        % Button pushed function: EProblemsDelButton
        function EProblemsDelButtonPushed(app, event)
            % delete selected problems from problems tree
            
            prob_selected = app.EProblemsTree.SelectedNodes;
            if isempty(prob_selected)
                msg = 'Select Problem node in tree first';
                uiconfirm(app.MTOPlatformUIFigure, msg, 'error', 'Icon','warning');
            end
            
            for i = 1:length(prob_selected)
                if isa(prob_selected(i).Parent, 'matlab.ui.container.Tree')
                    prob_selected(i).delete;
                end
            end
        end

        % Node text changed function: EProblemsTree
        function EProblemsTreeNodeTextChanged(app, event)
            % update problem obj parameter
            
            node = event.Node;
            if isa(node.Parent, 'matlab.ui.container.Tree')
                % this is problem node
                node.NodeData.name = node.Text;
            else
                % this is parameter node
                parameter = {};
                % the first node text is parameter name, can't change
                for x = 1:2:length(node.Parent.Children)
                    node.Parent.Children(x).Text = node.Parent.Children(x).NodeData;
                end
                % the second node text is parameter value
                for x = 2:2:length(node.Parent.Children)
                    parameter = [parameter, node.Parent.Children(x).Text];
                end
                node.Parent.NodeData.setParameter(parameter);
            end
        end

        % Button pushed function: ESaveDataButton
        function ESaveDataButtonPushed(app, event)
            % save data to folder
            
            % check data
            if isempty(app.EData)
                msg = 'Please run experiment first';
                uiconfirm(app.MTOPlatformUIFigure, msg, 'error', 'Icon','warning');
                return;
            end
            
            % check selected file name
            [file_name, dir_name] = uiputfile('MTOData.mat');
            figure(app.MTOPlatformUIFigure);
            if file_name == 0
                return;
            end
            
            % save data
            MTOData = app.EData;
            save([dir_name, file_name], 'MTOData');
        end

        % Value changed function: EDataFormatEditField
        function EDataFormatEditFieldValueChanged(app, event)
            app.EupdateTable();
        end

        % Value changed function: EDataTypeDropDown
        function EDataTypeDropDownValueChanged(app, event)
            app.EresetFormat();
            app.EupdateTable();
        end

        % Value changed function: EShowTypeDropDown
        function EShowTypeDropDownValueChanged(app, event)
            app.EresetFormat();
            app.EupdateTable();
        end

        % Value changed function: ETestTypeDropDown
        function ETestTypeDropDownValueChanged(app, event)
            app.EupdateTable();
        end

        % Value changed function: EAlgorithmDropDown
        function EAlgorithmDropDownValueChanged(app, event)
            app.EupdateTable();
        end

        % Value changed function: EHighlightTypeDropDown
        function EHighlightTypeDropDownValueChanged(app, event)
            app.EupdateTableHighlight();
        end

        % Value changed function: EFigureTypeDropDown
        function EFigureTypeDropDownValueChanged(app, event)
            app.EresetFigureData();
        end

        % Value changed function: EProblemsDropDown
        function EProblemsDropDownValueChanged(app, event)
            app.EupdateFigureAxes();
        end

        % Button pushed function: ELoadDataButton
        function ELoadDataButtonPushed(app, event)
            % load data from file
            
            % select mat file
            [file_name, pathname] = uigetfile('*.mat', 'Select Data', './');
            figure(app.MTOPlatformUIFigure);
            
            % check selected ile_name
            if file_name == 0
                return;
            end
            
            % load data to app's parameter
            load([pathname, file_name], 'MTOData');
            app.EData = MTOData;
            app.ETableReps = app.EData.Reps * ones([length(app.EData.Problems), length(app.EData.Algorithms)]);
            app.EresetTableAlgorithmDropDown({app.EData.Algorithms.Name});
            app.EupdateTable();
            app.EresetFigureData();
        end

        % Button pushed function: ESaveTableButton
        function ESaveTableButtonPushed(app, event)
            % save table
            
            % check selected file name
            filter = {'*.tex'; '*.xlsx';'*.csv';};
            [file_name, dir_name] = uiputfile(filter);
            % figure(app.MTOPlatformUIFigure);
            if file_name == 0
                return;
            end
            if contains(file_name, 'tex')
                hl = zeros(size(app.EUITable.Data));
                for row_i = 1:size(app.ETableData, 1)
                    if ~(sum(isnan(app.ETableData(row_i, :))) == size(app.ETableData, 2))
                        temp_data = app.ETableData(row_i, :);
                        min_data = min(temp_data);
                        temp_idx = temp_data == min_data;
                        x = 1:length(temp_idx);
                        x = x(temp_idx);
                        for xx = 1:length(x)
                            hl(row_i, x(xx)) = 1;
                        end
                    end
                end
                input.data = app.EUITable.Data;
                input.hl = hl;
                input.tableColLabels = app.EUITable.ColumnName(1:size(input.data, 2));
                input.tableRowLabels = app.EUITable.RowName(1:size(input.data, 1))';
                input.tableColumnAlignment = 'c';
                input.tableBorders = 0;
                input.dataNanString = '-';
                input.booktabs = 1;
                latex = latexTable(input);
                fid=fopen([dir_name, file_name],'w');
                [nrows, ncols] = size(latex);
                for row = 1:nrows
                    fprintf(fid,'%s\n',latex{row,:});
                end
                fclose(fid);
            else
                row_name = app.EUITable.RowName(1:size(app.EUITable.Data, 1));
                column_name = app.EUITable.ColumnName(1:size(app.EUITable.Data, 2))';
                cell_out = [[{''}; row_name], [column_name; app.EUITable.Data]];
                writecell(cell_out, [dir_name, file_name]);
            end
        end

        % Button pushed function: ESaveFigureButton
        function ESaveFigureButtonPushed(app, event)
            % save figure to folder
            
            % check data
            if isempty(app.EFigureData)
                return;
            end
            
            % check selected dir name
            dir_name = uigetdir('./', 'Select save path');
            figure(app.MTOPlatformUIFigure);
            if dir_name == 0
                return;
            end
            
            % save figure
            fig_dir_name = [dir_name, '/Figure/'];
            mkdir(fig_dir_name);
            
            for problem_index = 1:length(app.EFigureData.Problems)
                fig = figure('Visible', 'off');
                xlim_max = 0;
                xdata = app.EFigureData.XData(problem_index, :);
                ydata = app.EFigureData.YData(problem_index, :);
                
                for i = 1:length(xdata)
                    if i > length(app.EFigureData.MarkerType)
                        marker = '';
                    else
                        marker = app.EFigureData.MarkerType{i};
                    end
                    p = plot(xdata{i}, ydata{i}, ['-', marker]);
                    p.LineWidth = app.EFigureData.LineWidth;
                    indices = round(length(ydata{i})/app.EFigureData.MarkerNum);
                    p.MarkerIndices = indices:indices:length(ydata{i})-round(indices/2);
                    p.MarkerSize = app.EFigureData.MarkerSize;
                    hold on;
                    xlim_max = max(xlim_max, xdata{i}(end));
                end
                
                xlim([1, xlim_max]);
                xlabel(app.EFigureData.XLabel);
                ylabel(app.EFigureData.YLabel);
                legend(strrep(app.EFigureData.Legend, '_', '\_'));
                grid(app.EFigureData.GridType);
                
                file_name = [fig_dir_name, app.EFigureData.Problems{problem_index}, '.', app.ESaveFigureTypeDropDown.Value];
                exportgraphics(fig, file_name);
            end
        end

        % Context menu opening function: DDataContextMenu
        function DDataContextMenuOpening(app, event)
            % select all data
            
            if ~isempty(app.DDataTree.Children)
                app.DDataTree.SelectedNodes = app.DDataTree.Children;
            end
        end

        % Button pushed function: DLoadDataButton
        function DLoadDataButtonPushed(app, event)
            % load data from mat files
            
            % select mat file
            file_name_list = {};
            [file_name, pathname] = uigetfile('*.mat', 'select the data mat', './', 'MultiSelect', 'on');
            figure(app.MTOPlatformUIFigure);
            file_name_list = [file_name_list, file_name];
            
            % check selected file_name
            if file_name_list{1} == 0
                return;
            end
            
            %load data mat files
            for i = 1:length(file_name_list)
                load([pathname, file_name_list{i}], 'MTOData');
                app.DputDataNode(file_name_list{i}(1:end-4), MTOData);
                drawnow;
            end
        end

        % Button pushed function: DDeleteDataButton
        function DDeleteDataButtonPushed(app, event)
            % delete selected data from tree
            
            data_selected = app.DDataTree.SelectedNodes;
            data_mark = [];
            data_num = 0;
            for i = 1:length(data_selected)
                if isa(data_selected(i).Parent, 'matlab.ui.container.Tree')
                    data_num = data_num + 1;
                    data_mark(i) = 1;
                else
                    data_mark(i) = 0;
                end
            end
            if data_num == 0
                msg = 'Select data node in tree first';
                uiconfirm(app.MTOPlatformUIFigure, msg, 'error', 'Icon','warning');
            end
            
            data_selected = data_selected(data_mark == 1);
            for i = 1:length(data_selected)
                data_selected(i).delete();
                drawnow;
            end
        end

        % Button pushed function: DSaveDataButton
        function DSaveDataButtonPushed(app, event)
            % save selected data from tree
            
            data_selected = app.DDataTree.SelectedNodes;
            data_mark = [];
            data_num = 0;
            for i = 1:length(data_selected)
                if isa(data_selected(i).Parent, 'matlab.ui.container.Tree')
                    data_num = data_num + 1;
                    data_mark(i) = 1;
                else
                    data_mark(i) = 0;
                end
            end
            if data_num == 0
                msg = 'Select data node in tree first';
                uiconfirm(app.MTOPlatformUIFigure, msg, 'error', 'Icon','warning');
            end
            
            data_selected = data_selected(data_mark == 1);
            for i = 1:length(data_selected)
                app.DsaveData(data_selected(i).NodeData);
            end
        end

        % Button pushed function: DRepsSplitButton
        function DRepsSplitButtonPushed(app, event)
            % split reps
            
            if ~app.DcheckSplitData()
                return;
            end
            
            % split
            data_selected = app.DDataTree.SelectedNodes;
            data_selected = data_selected(app.DDataFlag == 1);
            
            for i = 1:length(data_selected)
                if data_selected(i).NodeData.Reps <= 1
                    msg = ['The ', data_selected(i).Text, '''s reps <= 1'];
                    uiconfirm(app.MTOPlatformUIFigure, msg, 'error', 'Icon','warning');
                    continue;
                end
                for rep = 1:data_selected(i).NodeData.Reps
                    MTOData.Reps = 1;
                    MTOData.Algorithms = data_selected(i).NodeData.Algorithms;
                    MTOData.Problems = data_selected(i).NodeData.Problems;
                    MTOData.Results(:,:,:) = data_selected(i).NodeData.Results(:,:,rep);
                    app.DputDataNode([data_selected(i).Text, ' (Split Rep: ', num2str(rep), ')'], MTOData);
                    drawnow;
                end
            end
        end

        % Button pushed function: DAlgorithmsSplitButton
        function DAlgorithmsSplitButtonPushed(app, event)
            % split algorithms
            
            if ~app.DcheckSplitData()
                return;
            end
            
            % split
            data_selected = app.DDataTree.SelectedNodes;
            data_selected = data_selected(app.DDataFlag == 1);
            
            for i = 1:length(data_selected)
                if length(data_selected(i).NodeData.Algorithms) <= 1
                    msg = ['The ', data_selected(i).Text, '''s algorithms <= 1'];
                    uiconfirm(app.MTOPlatformUIFigure, msg, 'error', 'Icon','warning');
                    continue;
                end
                for algo = 1:length(data_selected(i).NodeData.Algorithms)
                    MTOData.Reps = data_selected(i).NodeData.Reps;
                    MTOData.Algorithms(1) = data_selected(i).NodeData.Algorithms(algo);
                    MTOData.Problems = data_selected(i).NodeData.Problems;
                    MTOData.Results(:,:,:) = data_selected(i).NodeData.Results(:,algo,:);
                    app.DputDataNode([data_selected(i).Text, ' (Split Algorithm: ', MTOData.Algorithms(1).Name, ')'], MTOData);
                    drawnow;
                end
            end
        end

        % Button pushed function: DProblemsSplitButton
        function DProblemsSplitButtonPushed(app, event)
            % split algorithms
            
            if ~app.DcheckSplitData()
                return;
            end
            
            % split
            data_selected = app.DDataTree.SelectedNodes;
            data_selected = data_selected(app.DDataFlag == 1);
            
            for i = 1:length(data_selected)
                if length(data_selected(i).NodeData.Problems) <= 1
                    msg = ['The ', data_selected(i).Text, '''s problems <= 1'];
                    uiconfirm(app.MTOPlatformUIFigure, msg, 'error', 'Icon','warning');
                    continue;
                end
                for prob = 1:length(data_selected(i).NodeData.Problems)
                    MTOData.Reps = data_selected(i).NodeData.Reps;
                    MTOData.Algorithms = data_selected(i).NodeData.Algorithms;
                    MTOData.Problems(1) = data_selected(i).NodeData.Problems(prob);
                    MTOData.Results(:,:,:) = data_selected(i).NodeData.Results(prob,:,:);
                    app.DputDataNode([data_selected(i).Text, ' (Split Problem: ', MTOData.Problems(1).Name, ')'], MTOData);
                    drawnow;
                end
            end
        end

        % Button pushed function: DRepsMergeButton
        function DRepsMergeButtonPushed(app, event)
            % merge reps, with same pop, evaluate, algorithms and problems
            
            if ~app.DcheckMergeData() || ~app.DcheckMergeAlgorithms() || ~app.DcheckMergeProblems()
                return;
            end
            
            % merge
            data_selected = app.DDataTree.SelectedNodes;
            data_selected = data_selected(app.DDataFlag == 1);
            MTOData.Reps = 0;
            MTOData.Algorithms = data_selected(1).NodeData.Algorithms;
            MTOData.Problems = data_selected(1).NodeData.Problems;
            for i = 1:length(data_selected)
                MTOData.Results(:,:,MTOData.Reps+1:MTOData.Reps+data_selected(i).NodeData.Reps) = ...
                    data_selected(i).NodeData.Results(:,:,:);
                MTOData.Reps = MTOData.Reps + data_selected(i).NodeData.Reps;
            end
            
            app.DputDataNode('data (Merge Reps)', MTOData);
            drawnow;
        end

        % Button pushed function: DAlgorithmsMergeButton
        function DAlgorithmsMergeButtonPushed(app, event)
            % merge algorithms, with same pop, evaluate, reps and problems
            
            if ~app.DcheckMergeData() || ~app.DcheckMergeReps() || ~app.DcheckMergeProblems()
                return;
            end
            
            % merge
            data_selected = app.DDataTree.SelectedNodes;
            data_selected = data_selected(app.DDataFlag == 1);
            MTOData.Reps = data_selected(1).NodeData.Reps;
            MTOData.Problems = data_selected(1).NodeData.Problems;
            idx = 0;
            for i = 1:length(data_selected)
                MTOData.Algorithms(idx+1:idx+length(data_selected(i).NodeData.Algorithms)) = ...
                    data_selected(i).NodeData.Algorithms;
                MTOData.Results(:,idx+1:idx+length(data_selected(i).NodeData.Algorithms),:) = ...
                    data_selected(i).NodeData.Results(:,:,:);
                idx = idx + length(data_selected(i).NodeData.Algorithms);
            end
            
            app.DputDataNode('data (Merge Algorithms)', MTOData);
            drawnow;
        end

        % Button pushed function: DProblemsMergeButton
        function DProblemsMergeButtonPushed(app, event)
            % merge problems, with same pop, evaluate, reps and algorithms
            
            if ~app.DcheckMergeData() || ~app.DcheckMergeReps() || ~app.DcheckMergeAlgorithms()
                return;
            end
            
            % merge
            data_selected = app.DDataTree.SelectedNodes;
            data_selected = data_selected(app.DDataFlag == 1);
            MTOData.Reps = data_selected(1).NodeData.Reps;
            MTOData.Algorithms = data_selected(1).NodeData.Algorithms;
            idx = 0;
            for i = 1:length(data_selected)
                MTOData.Problems(idx+1:idx+length(data_selected(i).NodeData.Problems)) = ...
                    data_selected(i).NodeData.Problems;
                MTOData.Results(idx+1:idx+length(data_selected(i).NodeData.Problems),:,:) = ...
                    data_selected(i).NodeData.Results(:,:,:);
                idx = idx + length(data_selected(i).NodeData.Problems);
            end
            
            app.DputDataNode('data (Merge Problems)', MTOData);
            drawnow;
        end

        % Node text changed function: DDataTree
        function DDataTreeNodeTextChanged(app, event)
            % update data text
            
            node = event.Node;
            if isa(node.Parent, 'matlab.ui.container.Tree')
                % this is data text node
                node.NodeData.name = node.Text;
            else
                % this is data parameter node, can't change
                node.Text = node.NodeData;
            end
        end

        % Button pushed function: DUpButton
        function DUpButtonPushed(app, event)
            data_selected = app.DDataTree.SelectedNodes;
            data_mark = [];
            data_num = 0;
            for i = 1:length(data_selected)
                if isa(data_selected(i).Parent, 'matlab.ui.container.Tree')
                    data_num = data_num + 1;
                    data_mark(i) = 1;
                else
                    data_mark(i) = 0;
                end
            end
            data_selected = sort(app.DDataTree.SelectedNodes, 'descend');
            data_selected = data_selected(data_mark == 1);
            selected = [];
            
            % move up
            for i = 1:length(data_selected)
                parent = data_selected(i).Parent;
                for j = 1:length(parent.Children)
                    if parent.Children(j) == data_selected(i) && j > 1
                        move(parent.Children(j), parent.Children(j-1),'before');
                        selected = [selected, parent.Children(j-1)];
                        break;
                    elseif parent.Children(j) == data_selected(i) && j == 1
                        selected = [selected, parent.Children(j)];
                    end
                end
            end
            
            % change selected node
            app.DDataTree.SelectedNodes = selected;
            drawnow;
        end

        % Button pushed function: DDownButton
        function DDownButtonPushed(app, event)
            data_selected = app.DDataTree.SelectedNodes;
            
            data_mark = [];
            data_num = 0;
            for i = 1:length(data_selected)
                if isa(data_selected(i).Parent, 'matlab.ui.container.Tree')
                    data_num = data_num + 1;
                    data_mark(i) = 1;
                else
                    data_mark(i) = 0;
                end
            end
            data_selected = app.DDataTree.SelectedNodes;
            data_selected = sort(data_selected(data_mark == 1), 'descend');
            selected = [];
            
            % move down
            for i = length(data_selected):-1:1
                parent = data_selected(i).Parent;
                for j = 1:length(parent.Children)
                    if parent.Children(j) == data_selected(i) && j < length(parent.Children)
                        move(parent.Children(j), parent.Children(j+1));
                        selected = [selected, parent.Children(j+1)];
                        break;
                    elseif parent.Children(j) == data_selected(i) && j == length(parent.Children)
                        selected = [selected, parent.Children(j)];
                    end
                end
            end
            
            % change selected node
            app.DDataTree.SelectedNodes = selected;
            drawnow;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create MTOPlatformUIFigure and hide until all components are created
            app.MTOPlatformUIFigure = uifigure('Visible', 'off');
            app.MTOPlatformUIFigure.Color = [1 1 1];
            app.MTOPlatformUIFigure.Position = [100 100 1026 680];
            app.MTOPlatformUIFigure.Name = 'MTO Platform';
            app.MTOPlatformUIFigure.WindowStyle = 'modal';

            % Create MTOPlatformGridLayout
            app.MTOPlatformGridLayout = uigridlayout(app.MTOPlatformUIFigure);
            app.MTOPlatformGridLayout.ColumnWidth = {'1x'};
            app.MTOPlatformGridLayout.RowHeight = {'1x'};
            app.MTOPlatformGridLayout.Padding = [0 0 0 0];
            app.MTOPlatformGridLayout.BackgroundColor = [1 1 1];

            % Create MTOPlatformTabGroup
            app.MTOPlatformTabGroup = uitabgroup(app.MTOPlatformGridLayout);
            app.MTOPlatformTabGroup.Layout.Row = 1;
            app.MTOPlatformTabGroup.Layout.Column = 1;

            % Create TestTab
            app.TestTab = uitab(app.MTOPlatformTabGroup);
            app.TestTab.Title = 'Test';
            app.TestTab.BackgroundColor = [1 1 1];

            % Create TestGridLayout
            app.TestGridLayout = uigridlayout(app.TestTab);
            app.TestGridLayout.ColumnWidth = {170, '3x', '1x'};
            app.TestGridLayout.RowHeight = {'1x'};
            app.TestGridLayout.ColumnSpacing = 5;
            app.TestGridLayout.BackgroundColor = [1 1 1];

            % Create TPanel1
            app.TPanel1 = uipanel(app.TestGridLayout);
            app.TPanel1.BackgroundColor = [1 1 1];
            app.TPanel1.Layout.Row = 1;
            app.TPanel1.Layout.Column = 1;

            % Create TP1GridLayout
            app.TP1GridLayout = uigridlayout(app.TPanel1);
            app.TP1GridLayout.ColumnWidth = {'fit', '1x'};
            app.TP1GridLayout.RowHeight = {'fit', 'fit', 'fit', '1x', 'fit', '1x'};
            app.TP1GridLayout.ColumnSpacing = 5;
            app.TP1GridLayout.Padding = [5 5 5 5];
            app.TP1GridLayout.BackgroundColor = [1 1 1];

            % Create AlgorithmDropDownLabel
            app.AlgorithmDropDownLabel = uilabel(app.TP1GridLayout);
            app.AlgorithmDropDownLabel.FontWeight = 'bold';
            app.AlgorithmDropDownLabel.Layout.Row = 3;
            app.AlgorithmDropDownLabel.Layout.Column = 1;
            app.AlgorithmDropDownLabel.Text = 'Algorithm';

            % Create TAlgorithmDropDown
            app.TAlgorithmDropDown = uidropdown(app.TP1GridLayout);
            app.TAlgorithmDropDown.Items = {};
            app.TAlgorithmDropDown.DropDownOpeningFcn = createCallbackFcn(app, @TAlgorithmDropDownOpening, true);
            app.TAlgorithmDropDown.ValueChangedFcn = createCallbackFcn(app, @TAlgorithmDropDownValueChanged, true);
            app.TAlgorithmDropDown.Tooltip = {'Select algorithm'};
            app.TAlgorithmDropDown.FontWeight = 'bold';
            app.TAlgorithmDropDown.BackgroundColor = [1 1 1];
            app.TAlgorithmDropDown.Layout.Row = 3;
            app.TAlgorithmDropDown.Layout.Column = 2;
            app.TAlgorithmDropDown.Value = {};

            % Create TAlgorithmTree
            app.TAlgorithmTree = uitree(app.TP1GridLayout);
            app.TAlgorithmTree.Multiselect = 'on';
            app.TAlgorithmTree.NodeTextChangedFcn = createCallbackFcn(app, @TAlgorithmTreeNodeTextChanged, true);
            app.TAlgorithmTree.Editable = 'on';
            app.TAlgorithmTree.Layout.Row = 4;
            app.TAlgorithmTree.Layout.Column = [1 2];

            % Create TProblemTree
            app.TProblemTree = uitree(app.TP1GridLayout);
            app.TProblemTree.Multiselect = 'on';
            app.TProblemTree.NodeTextChangedFcn = createCallbackFcn(app, @TProblemTreeNodeTextChanged, true);
            app.TProblemTree.Editable = 'on';
            app.TProblemTree.Layout.Row = 6;
            app.TProblemTree.Layout.Column = [1 2];

            % Create TProblemDropDown
            app.TProblemDropDown = uidropdown(app.TP1GridLayout);
            app.TProblemDropDown.Items = {};
            app.TProblemDropDown.DropDownOpeningFcn = createCallbackFcn(app, @TProblemDropDownOpening, true);
            app.TProblemDropDown.ValueChangedFcn = createCallbackFcn(app, @TProblemDropDownValueChanged, true);
            app.TProblemDropDown.Tooltip = {'Select problem'};
            app.TProblemDropDown.FontWeight = 'bold';
            app.TProblemDropDown.BackgroundColor = [1 1 1];
            app.TProblemDropDown.Layout.Row = 5;
            app.TProblemDropDown.Layout.Column = 2;
            app.TProblemDropDown.Value = {};

            % Create ProblemDropDownLabel
            app.ProblemDropDownLabel = uilabel(app.TP1GridLayout);
            app.ProblemDropDownLabel.FontWeight = 'bold';
            app.ProblemDropDownLabel.Layout.Row = 5;
            app.ProblemDropDownLabel.Layout.Column = 1;
            app.ProblemDropDownLabel.Text = 'Problem';

            % Create TTaskTypeDropDown
            app.TTaskTypeDropDown = uidropdown(app.TP1GridLayout);
            app.TTaskTypeDropDown.Items = {'MT-SO', 'MaT-SO', 'ST-SO'};
            app.TTaskTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @TTaskTypeDropDownValueChanged, true);
            app.TTaskTypeDropDown.FontWeight = 'bold';
            app.TTaskTypeDropDown.BackgroundColor = [1 1 1];
            app.TTaskTypeDropDown.Layout.Row = 1;
            app.TTaskTypeDropDown.Layout.Column = 2;
            app.TTaskTypeDropDown.Value = 'MT-SO';

            % Create TaskLabel_2
            app.TaskLabel_2 = uilabel(app.TP1GridLayout);
            app.TaskLabel_2.FontWeight = 'bold';
            app.TaskLabel_2.Tooltip = {'Single-task EA Option'};
            app.TaskLabel_2.Layout.Row = 1;
            app.TaskLabel_2.Layout.Column = 1;
            app.TaskLabel_2.Text = 'Task';

            % Create SpecialLabel_2
            app.SpecialLabel_2 = uilabel(app.TP1GridLayout);
            app.SpecialLabel_2.FontWeight = 'bold';
            app.SpecialLabel_2.Tooltip = {'Single-task EA Option'};
            app.SpecialLabel_2.Layout.Row = 2;
            app.SpecialLabel_2.Layout.Column = 1;
            app.SpecialLabel_2.Text = 'Special';

            % Create TSpecialTypeDropDown
            app.TSpecialTypeDropDown = uidropdown(app.TP1GridLayout);
            app.TSpecialTypeDropDown.Items = {'None', 'Competitive', 'Constrained'};
            app.TSpecialTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @TSpecialTypeDropDownValueChanged, true);
            app.TSpecialTypeDropDown.FontWeight = 'bold';
            app.TSpecialTypeDropDown.BackgroundColor = [1 1 1];
            app.TSpecialTypeDropDown.Layout.Row = 2;
            app.TSpecialTypeDropDown.Layout.Column = 2;
            app.TSpecialTypeDropDown.Value = 'None';

            % Create TPanel2
            app.TPanel2 = uipanel(app.TestGridLayout);
            app.TPanel2.BackgroundColor = [1 1 1];
            app.TPanel2.Layout.Row = 1;
            app.TPanel2.Layout.Column = 2;

            % Create TP2GridLayout
            app.TP2GridLayout = uigridlayout(app.TPanel2);
            app.TP2GridLayout.ColumnWidth = {'1x'};
            app.TP2GridLayout.RowHeight = {'fit', '1x', 'fit'};
            app.TP2GridLayout.Padding = [5 5 5 5];
            app.TP2GridLayout.BackgroundColor = [1 1 1];

            % Create TP21GridLayout
            app.TP21GridLayout = uigridlayout(app.TP2GridLayout);
            app.TP21GridLayout.ColumnWidth = {'1x', 'fit', 'fit'};
            app.TP21GridLayout.RowHeight = {'1x'};
            app.TP21GridLayout.ColumnSpacing = 5;
            app.TP21GridLayout.Padding = [0 0 0 0];
            app.TP21GridLayout.Layout.Row = 1;
            app.TP21GridLayout.Layout.Column = 1;
            app.TP21GridLayout.BackgroundColor = [1 1 1];

            % Create TShowTypeDropDown
            app.TShowTypeDropDown = uidropdown(app.TP21GridLayout);
            app.TShowTypeDropDown.Items = {'Tasks Figure (1D Unified)', 'Tasks Figure (1D Real)', 'Feasible Region (2D)'};
            app.TShowTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @TShowTypeDropDownValueChanged, true);
            app.TShowTypeDropDown.Tooltip = {'Show type'};
            app.TShowTypeDropDown.FontWeight = 'bold';
            app.TShowTypeDropDown.BackgroundColor = [1 1 1];
            app.TShowTypeDropDown.Layout.Row = 1;
            app.TShowTypeDropDown.Layout.Column = 3;
            app.TShowTypeDropDown.Value = 'Tasks Figure (1D Unified)';

            % Create TSaveButton
            app.TSaveButton = uibutton(app.TP21GridLayout, 'push');
            app.TSaveButton.ButtonPushedFcn = createCallbackFcn(app, @TSaveButtonPushed, true);
            app.TSaveButton.BusyAction = 'cancel';
            app.TSaveButton.BackgroundColor = [0.6706 0.949 0.6706];
            app.TSaveButton.FontWeight = 'bold';
            app.TSaveButton.Tooltip = {''};
            app.TSaveButton.Layout.Row = 1;
            app.TSaveButton.Layout.Column = 2;
            app.TSaveButton.Text = 'Save';

            % Create TP24GridLayout
            app.TP24GridLayout = uigridlayout(app.TP2GridLayout);
            app.TP24GridLayout.ColumnWidth = {'1x', 70, 70, '1x'};
            app.TP24GridLayout.RowHeight = {'1x'};
            app.TP24GridLayout.Padding = [0 0 0 0];
            app.TP24GridLayout.Layout.Row = 3;
            app.TP24GridLayout.Layout.Column = 1;
            app.TP24GridLayout.BackgroundColor = [1 1 1];

            % Create TStartButton
            app.TStartButton = uibutton(app.TP24GridLayout, 'push');
            app.TStartButton.ButtonPushedFcn = createCallbackFcn(app, @TStartButtonPushed, true);
            app.TStartButton.BusyAction = 'cancel';
            app.TStartButton.BackgroundColor = [0.6706 0.949 0.6706];
            app.TStartButton.FontWeight = 'bold';
            app.TStartButton.Tooltip = {''};
            app.TStartButton.Layout.Row = 1;
            app.TStartButton.Layout.Column = 2;
            app.TStartButton.Text = 'Start';

            % Create TResetButton
            app.TResetButton = uibutton(app.TP24GridLayout, 'push');
            app.TResetButton.ButtonPushedFcn = createCallbackFcn(app, @TResetButtonPushed, true);
            app.TResetButton.BusyAction = 'cancel';
            app.TResetButton.BackgroundColor = [1 1 0.702];
            app.TResetButton.FontWeight = 'bold';
            app.TResetButton.Tooltip = {''};
            app.TResetButton.Layout.Row = 1;
            app.TResetButton.Layout.Column = 3;
            app.TResetButton.Text = 'Reset';

            % Create TUIAxes
            app.TUIAxes = uiaxes(app.TP2GridLayout);
            app.TUIAxes.PlotBoxAspectRatio = [1.14506769825919 1 1];
            app.TUIAxes.Layout.Row = 2;
            app.TUIAxes.Layout.Column = 1;

            % Create TPanel3
            app.TPanel3 = uipanel(app.TestGridLayout);
            app.TPanel3.BackgroundColor = [1 1 1];
            app.TPanel3.Layout.Row = 1;
            app.TPanel3.Layout.Column = 3;

            % Create TP3GridLayout
            app.TP3GridLayout = uigridlayout(app.TPanel3);
            app.TP3GridLayout.ColumnWidth = {'1x'};
            app.TP3GridLayout.RowHeight = {'fit', '1x', 'fit'};
            app.TP3GridLayout.ColumnSpacing = 5;
            app.TP3GridLayout.RowSpacing = 5;
            app.TP3GridLayout.Padding = [5 5 5 5];
            app.TP3GridLayout.BackgroundColor = [1 1 1];

            % Create OutputTextAreaLabel
            app.OutputTextAreaLabel = uilabel(app.TP3GridLayout);
            app.OutputTextAreaLabel.FontWeight = 'bold';
            app.OutputTextAreaLabel.Layout.Row = 1;
            app.OutputTextAreaLabel.Layout.Column = 1;
            app.OutputTextAreaLabel.Text = 'Output';

            % Create TOutputTextArea
            app.TOutputTextArea = uitextarea(app.TP3GridLayout);
            app.TOutputTextArea.Editable = 'off';
            app.TOutputTextArea.WordWrap = 'off';
            app.TOutputTextArea.FontWeight = 'bold';
            app.TOutputTextArea.Layout.Row = 2;
            app.TOutputTextArea.Layout.Column = 1;

            % Create MTOPlatformv020YanchiLiLabel
            app.MTOPlatformv020YanchiLiLabel = uilabel(app.TP3GridLayout);
            app.MTOPlatformv020YanchiLiLabel.HorizontalAlignment = 'center';
            app.MTOPlatformv020YanchiLiLabel.FontWeight = 'bold';
            app.MTOPlatformv020YanchiLiLabel.Layout.Row = 3;
            app.MTOPlatformv020YanchiLiLabel.Layout.Column = 1;
            app.MTOPlatformv020YanchiLiLabel.Text = 'MTO-Platform v0.2.0  Yanchi Li';

            % Create ExperimentTab
            app.ExperimentTab = uitab(app.MTOPlatformTabGroup);
            app.ExperimentTab.Title = 'Experiment';
            app.ExperimentTab.BackgroundColor = [1 1 1];

            % Create ExperimentsGridLayout
            app.ExperimentsGridLayout = uigridlayout(app.ExperimentTab);
            app.ExperimentsGridLayout.ColumnWidth = {155, 160, '1.3x'};
            app.ExperimentsGridLayout.RowHeight = {'1x'};
            app.ExperimentsGridLayout.ColumnSpacing = 5;
            app.ExperimentsGridLayout.BackgroundColor = [1 1 1];

            % Create EPanel3
            app.EPanel3 = uipanel(app.ExperimentsGridLayout);
            app.EPanel3.AutoResizeChildren = 'off';
            app.EPanel3.BackgroundColor = [1 1 1];
            app.EPanel3.Layout.Row = 1;
            app.EPanel3.Layout.Column = 3;

            % Create EP3GridLayout
            app.EP3GridLayout = uigridlayout(app.EPanel3);
            app.EP3GridLayout.ColumnWidth = {'1x'};
            app.EP3GridLayout.RowHeight = {'1x'};
            app.EP3GridLayout.Padding = [0 0 0 0];
            app.EP3GridLayout.BackgroundColor = [1 1 1];

            % Create ETableTabGroup
            app.ETableTabGroup = uitabgroup(app.EP3GridLayout);
            app.ETableTabGroup.Layout.Row = 1;
            app.ETableTabGroup.Layout.Column = 1;

            % Create ETableTab
            app.ETableTab = uitab(app.ETableTabGroup);
            app.ETableTab.Title = 'Table';
            app.ETableTab.BackgroundColor = [1 1 1];

            % Create EP3TGridLayout
            app.EP3TGridLayout = uigridlayout(app.ETableTab);
            app.EP3TGridLayout.ColumnWidth = {'1x'};
            app.EP3TGridLayout.RowHeight = {'fit', '1x'};
            app.EP3TGridLayout.RowSpacing = 0;
            app.EP3TGridLayout.Padding = [5 5 5 5];
            app.EP3TGridLayout.BackgroundColor = [1 1 1];

            % Create EP3T1GridLayout
            app.EP3T1GridLayout = uigridlayout(app.EP3TGridLayout);
            app.EP3T1GridLayout.ColumnWidth = {90, '1x', 90, 90, 90, 90, 90, 90};
            app.EP3T1GridLayout.RowHeight = {'fit'};
            app.EP3T1GridLayout.ColumnSpacing = 5;
            app.EP3T1GridLayout.Padding = [0 5 0 0];
            app.EP3T1GridLayout.Layout.Row = 1;
            app.EP3T1GridLayout.Layout.Column = 1;
            app.EP3T1GridLayout.BackgroundColor = [1 1 1];

            % Create ETestTypeDropDown
            app.ETestTypeDropDown = uidropdown(app.EP3T1GridLayout);
            app.ETestTypeDropDown.Items = {'None', 'Rank sum test', 'Signed rank test'};
            app.ETestTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @ETestTypeDropDownValueChanged, true);
            app.ETestTypeDropDown.Tooltip = {'Statistical Analysis (Only for Objective value)'};
            app.ETestTypeDropDown.FontWeight = 'bold';
            app.ETestTypeDropDown.BackgroundColor = [1 1 1];
            app.ETestTypeDropDown.Layout.Row = 1;
            app.ETestTypeDropDown.Layout.Column = 6;
            app.ETestTypeDropDown.Value = 'None';

            % Create EAlgorithmDropDown
            app.EAlgorithmDropDown = uidropdown(app.EP3T1GridLayout);
            app.EAlgorithmDropDown.Items = {'Algorithm'};
            app.EAlgorithmDropDown.ValueChangedFcn = createCallbackFcn(app, @EAlgorithmDropDownValueChanged, true);
            app.EAlgorithmDropDown.Tooltip = {'Statistical Analysis main Algorithm (Only for Objective value)'};
            app.EAlgorithmDropDown.FontWeight = 'bold';
            app.EAlgorithmDropDown.BackgroundColor = [1 1 1];
            app.EAlgorithmDropDown.Layout.Row = 1;
            app.EAlgorithmDropDown.Layout.Column = 7;
            app.EAlgorithmDropDown.Value = 'Algorithm';

            % Create EShowTypeDropDown
            app.EShowTypeDropDown = uidropdown(app.EP3T1GridLayout);
            app.EShowTypeDropDown.Items = {'Mean', 'Mean&Std', 'Std', 'Median', 'Best', 'Worst'};
            app.EShowTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @EShowTypeDropDownValueChanged, true);
            app.EShowTypeDropDown.Tooltip = {'Data Type (Only for Objective value)'};
            app.EShowTypeDropDown.FontWeight = 'bold';
            app.EShowTypeDropDown.BackgroundColor = [1 1 1];
            app.EShowTypeDropDown.Layout.Row = 1;
            app.EShowTypeDropDown.Layout.Column = 5;
            app.EShowTypeDropDown.Value = 'Mean';

            % Create EDataTypeDropDown
            app.EDataTypeDropDown = uidropdown(app.EP3T1GridLayout);
            app.EDataTypeDropDown.Items = {'Reps'};
            app.EDataTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @EDataTypeDropDownValueChanged, true);
            app.EDataTypeDropDown.Tooltip = {'Show Type'};
            app.EDataTypeDropDown.FontWeight = 'bold';
            app.EDataTypeDropDown.BackgroundColor = [1 1 1];
            app.EDataTypeDropDown.Layout.Row = 1;
            app.EDataTypeDropDown.Layout.Column = 4;
            app.EDataTypeDropDown.Value = 'Reps';

            % Create EHighlightTypeDropDown
            app.EHighlightTypeDropDown = uidropdown(app.EP3T1GridLayout);
            app.EHighlightTypeDropDown.Items = {'None', 'Best', 'Best&Worst'};
            app.EHighlightTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @EHighlightTypeDropDownValueChanged, true);
            app.EHighlightTypeDropDown.Tooltip = {'Highlight type'};
            app.EHighlightTypeDropDown.FontWeight = 'bold';
            app.EHighlightTypeDropDown.BackgroundColor = [1 1 1];
            app.EHighlightTypeDropDown.Layout.Row = 1;
            app.EHighlightTypeDropDown.Layout.Column = 8;
            app.EHighlightTypeDropDown.Value = 'Best&Worst';

            % Create ESaveTableButton
            app.ESaveTableButton = uibutton(app.EP3T1GridLayout, 'push');
            app.ESaveTableButton.ButtonPushedFcn = createCallbackFcn(app, @ESaveTableButtonPushed, true);
            app.ESaveTableButton.BackgroundColor = [0.702 1 0.702];
            app.ESaveTableButton.FontWeight = 'bold';
            app.ESaveTableButton.Tooltip = {'Save current table to file'};
            app.ESaveTableButton.Layout.Row = 1;
            app.ESaveTableButton.Layout.Column = 1;
            app.ESaveTableButton.Text = 'Save';

            % Create EDataFormatEditField
            app.EDataFormatEditField = uieditfield(app.EP3T1GridLayout, 'text');
            app.EDataFormatEditField.ValueChangedFcn = createCallbackFcn(app, @EDataFormatEditFieldValueChanged, true);
            app.EDataFormatEditField.HorizontalAlignment = 'center';
            app.EDataFormatEditField.Tooltip = {'Data Format Str'};
            app.EDataFormatEditField.Layout.Row = 1;
            app.EDataFormatEditField.Layout.Column = 3;
            app.EDataFormatEditField.Value = '%d';

            % Create EUITable
            app.EUITable = uitable(app.EP3TGridLayout);
            app.EUITable.ColumnName = '';
            app.EUITable.RowName = {};
            app.EUITable.Layout.Row = 2;
            app.EUITable.Layout.Column = 1;

            % Create EFigureTab
            app.EFigureTab = uitab(app.ETableTabGroup);
            app.EFigureTab.Title = 'Figure';
            app.EFigureTab.BackgroundColor = [1 1 1];

            % Create EP3FGridLayout
            app.EP3FGridLayout = uigridlayout(app.EFigureTab);
            app.EP3FGridLayout.ColumnWidth = {'1x'};
            app.EP3FGridLayout.RowHeight = {'fit', '1x'};
            app.EP3FGridLayout.Padding = [5 5 5 5];
            app.EP3FGridLayout.BackgroundColor = [1 1 1];

            % Create EP3F1GridLayout
            app.EP3F1GridLayout = uigridlayout(app.EP3FGridLayout);
            app.EP3F1GridLayout.ColumnWidth = {90, 90, '1x', 150, 150};
            app.EP3F1GridLayout.RowHeight = {'fit'};
            app.EP3F1GridLayout.ColumnSpacing = 5;
            app.EP3F1GridLayout.Padding = [0 0 0 0];
            app.EP3F1GridLayout.Layout.Row = 1;
            app.EP3F1GridLayout.Layout.Column = 1;
            app.EP3F1GridLayout.BackgroundColor = [1 1 1];

            % Create EProblemsDropDown
            app.EProblemsDropDown = uidropdown(app.EP3F1GridLayout);
            app.EProblemsDropDown.Items = {'Problem '};
            app.EProblemsDropDown.ValueChangedFcn = createCallbackFcn(app, @EProblemsDropDownValueChanged, true);
            app.EProblemsDropDown.Tooltip = {'Problem or Task'};
            app.EProblemsDropDown.FontWeight = 'bold';
            app.EProblemsDropDown.BackgroundColor = [1 1 1];
            app.EProblemsDropDown.Layout.Row = 1;
            app.EProblemsDropDown.Layout.Column = 5;
            app.EProblemsDropDown.Value = 'Problem ';

            % Create ESaveFigureButton
            app.ESaveFigureButton = uibutton(app.EP3F1GridLayout, 'push');
            app.ESaveFigureButton.ButtonPushedFcn = createCallbackFcn(app, @ESaveFigureButtonPushed, true);
            app.ESaveFigureButton.BackgroundColor = [0.702 1 0.702];
            app.ESaveFigureButton.FontWeight = 'bold';
            app.ESaveFigureButton.Tooltip = {'Select save dir and it will save all figures to ''dir/Figure/'''};
            app.ESaveFigureButton.Layout.Row = 1;
            app.ESaveFigureButton.Layout.Column = 1;
            app.ESaveFigureButton.Text = 'Save';

            % Create ESaveFigureTypeDropDown
            app.ESaveFigureTypeDropDown = uidropdown(app.EP3F1GridLayout);
            app.ESaveFigureTypeDropDown.Items = {'eps', 'png', 'pdf'};
            app.ESaveFigureTypeDropDown.Tooltip = {'Save Figure Type'};
            app.ESaveFigureTypeDropDown.FontWeight = 'bold';
            app.ESaveFigureTypeDropDown.BackgroundColor = [1 1 1];
            app.ESaveFigureTypeDropDown.Layout.Row = 1;
            app.ESaveFigureTypeDropDown.Layout.Column = 2;
            app.ESaveFigureTypeDropDown.Value = 'eps';

            % Create EFigureTypeDropDown
            app.EFigureTypeDropDown = uidropdown(app.EP3F1GridLayout);
            app.EFigureTypeDropDown.Items = {'Figure Type'};
            app.EFigureTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @EFigureTypeDropDownValueChanged, true);
            app.EFigureTypeDropDown.Tooltip = {'Data Type'};
            app.EFigureTypeDropDown.FontWeight = 'bold';
            app.EFigureTypeDropDown.BackgroundColor = [1 1 1];
            app.EFigureTypeDropDown.Layout.Row = 1;
            app.EFigureTypeDropDown.Layout.Column = 4;
            app.EFigureTypeDropDown.Value = 'Figure Type';

            % Create EConvergenceTrendUIAxes
            app.EConvergenceTrendUIAxes = uiaxes(app.EP3FGridLayout);
            xlabel(app.EConvergenceTrendUIAxes, 'Evaluation')
            ylabel(app.EConvergenceTrendUIAxes, 'Objective Value')
            app.EConvergenceTrendUIAxes.PlotBoxAspectRatio = [1.37847866419295 1 1];
            app.EConvergenceTrendUIAxes.Layout.Row = 2;
            app.EConvergenceTrendUIAxes.Layout.Column = 1;

            % Create EPanel1
            app.EPanel1 = uipanel(app.ExperimentsGridLayout);
            app.EPanel1.BackgroundColor = [1 1 1];
            app.EPanel1.Layout.Row = 1;
            app.EPanel1.Layout.Column = 1;

            % Create EP1GridLayout
            app.EP1GridLayout = uigridlayout(app.EPanel1);
            app.EP1GridLayout.ColumnWidth = {'fit', '1x', 55};
            app.EP1GridLayout.RowHeight = {'fit', 'fit', 'fit', 'fit', 'fit', '1x', 'fit', '1x', 'fit'};
            app.EP1GridLayout.ColumnSpacing = 5;
            app.EP1GridLayout.Padding = [5 5 5 5];
            app.EP1GridLayout.BackgroundColor = [1 1 1];

            % Create EProblemsAddButton
            app.EProblemsAddButton = uibutton(app.EP1GridLayout, 'push');
            app.EProblemsAddButton.ButtonPushedFcn = createCallbackFcn(app, @EProblemsAddButtonPushed, true);
            app.EProblemsAddButton.VerticalAlignment = 'top';
            app.EProblemsAddButton.BackgroundColor = [0.702 1 0.702];
            app.EProblemsAddButton.FontWeight = 'bold';
            app.EProblemsAddButton.Tooltip = {'Add selected problems'};
            app.EProblemsAddButton.Layout.Row = 7;
            app.EProblemsAddButton.Layout.Column = 3;
            app.EProblemsAddButton.Text = 'Add';

            % Create EAlgorithmsAddButton
            app.EAlgorithmsAddButton = uibutton(app.EP1GridLayout, 'push');
            app.EAlgorithmsAddButton.ButtonPushedFcn = createCallbackFcn(app, @EAlgorithmsAddButtonPushed, true);
            app.EAlgorithmsAddButton.VerticalAlignment = 'top';
            app.EAlgorithmsAddButton.BackgroundColor = [0.702 1 0.702];
            app.EAlgorithmsAddButton.FontWeight = 'bold';
            app.EAlgorithmsAddButton.Tooltip = {'Add selected algorithms'};
            app.EAlgorithmsAddButton.Layout.Row = 5;
            app.EAlgorithmsAddButton.Layout.Column = 3;
            app.EAlgorithmsAddButton.Text = 'Add';

            % Create ERepsEditField
            app.ERepsEditField = uieditfield(app.EP1GridLayout, 'numeric');
            app.ERepsEditField.Limits = [1 Inf];
            app.ERepsEditField.RoundFractionalValues = 'on';
            app.ERepsEditField.ValueDisplayFormat = '%d';
            app.ERepsEditField.HorizontalAlignment = 'center';
            app.ERepsEditField.FontWeight = 'bold';
            app.ERepsEditField.Layout.Row = 1;
            app.ERepsEditField.Layout.Column = [2 3];
            app.ERepsEditField.Value = 30;

            % Create ERunTimesEditFieldLabel
            app.ERunTimesEditFieldLabel = uilabel(app.EP1GridLayout);
            app.ERunTimesEditFieldLabel.FontWeight = 'bold';
            app.ERunTimesEditFieldLabel.Layout.Row = 1;
            app.ERunTimesEditFieldLabel.Layout.Column = 1;
            app.ERunTimesEditFieldLabel.Text = 'Reps';

            % Create EAlgorithmsListBox
            app.EAlgorithmsListBox = uilistbox(app.EP1GridLayout);
            app.EAlgorithmsListBox.Items = {};
            app.EAlgorithmsListBox.Multiselect = 'on';
            app.EAlgorithmsListBox.Layout.Row = 6;
            app.EAlgorithmsListBox.Layout.Column = [1 3];
            app.EAlgorithmsListBox.Value = {};

            % Create AlgorithmsLabel
            app.AlgorithmsLabel = uilabel(app.EP1GridLayout);
            app.AlgorithmsLabel.FontWeight = 'bold';
            app.AlgorithmsLabel.Layout.Row = 5;
            app.AlgorithmsLabel.Layout.Column = [1 2];
            app.AlgorithmsLabel.Text = 'Algorithms';

            % Create EProblemsListBox
            app.EProblemsListBox = uilistbox(app.EP1GridLayout);
            app.EProblemsListBox.Items = {};
            app.EProblemsListBox.Multiselect = 'on';
            app.EProblemsListBox.Layout.Row = 8;
            app.EProblemsListBox.Layout.Column = [1 3];
            app.EProblemsListBox.Value = {};

            % Create ProblemsLabel
            app.ProblemsLabel = uilabel(app.EP1GridLayout);
            app.ProblemsLabel.FontWeight = 'bold';
            app.ProblemsLabel.Layout.Row = 7;
            app.ProblemsLabel.Layout.Column = [1 2];
            app.ProblemsLabel.Text = 'Problems';

            % Create ParallelDropDownLabel
            app.ParallelDropDownLabel = uilabel(app.EP1GridLayout);
            app.ParallelDropDownLabel.FontWeight = 'bold';
            app.ParallelDropDownLabel.Layout.Row = 2;
            app.ParallelDropDownLabel.Layout.Column = 1;
            app.ParallelDropDownLabel.Text = 'Parallel';

            % Create EParallelDropDown
            app.EParallelDropDown = uidropdown(app.EP1GridLayout);
            app.EParallelDropDown.Items = {'Enable', 'Disable'};
            app.EParallelDropDown.ItemsData = [1 0];
            app.EParallelDropDown.FontWeight = 'bold';
            app.EParallelDropDown.BackgroundColor = [1 1 1];
            app.EParallelDropDown.Layout.Row = 2;
            app.EParallelDropDown.Layout.Column = [2 3];
            app.EParallelDropDown.Value = 1;

            % Create TypeLabel
            app.TypeLabel = uilabel(app.EP1GridLayout);
            app.TypeLabel.FontWeight = 'bold';
            app.TypeLabel.Tooltip = {'Single-task EA Option'};
            app.TypeLabel.Layout.Row = 3;
            app.TypeLabel.Layout.Column = 1;
            app.TypeLabel.Text = 'Type';

            % Create ETaskTypeDropDown
            app.ETaskTypeDropDown = uidropdown(app.EP1GridLayout);
            app.ETaskTypeDropDown.Items = {'MT-SO', 'MaT-SO', 'ST-SO'};
            app.ETaskTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @ETaskTypeDropDownValueChanged, true);
            app.ETaskTypeDropDown.FontWeight = 'bold';
            app.ETaskTypeDropDown.BackgroundColor = [1 1 1];
            app.ETaskTypeDropDown.Layout.Row = 3;
            app.ETaskTypeDropDown.Layout.Column = [2 3];
            app.ETaskTypeDropDown.Value = 'MT-SO';

            % Create ELoadDataButton
            app.ELoadDataButton = uibutton(app.EP1GridLayout, 'push');
            app.ELoadDataButton.ButtonPushedFcn = createCallbackFcn(app, @ELoadDataButtonPushed, true);
            app.ELoadDataButton.BackgroundColor = [0.502 0.702 1];
            app.ELoadDataButton.FontWeight = 'bold';
            app.ELoadDataButton.Tooltip = {'Load MTOData.mat to show detials'};
            app.ELoadDataButton.Layout.Row = 9;
            app.ELoadDataButton.Layout.Column = [1 3];
            app.ELoadDataButton.Text = 'Load Data';

            % Create SpecialLabel
            app.SpecialLabel = uilabel(app.EP1GridLayout);
            app.SpecialLabel.FontWeight = 'bold';
            app.SpecialLabel.Tooltip = {'Single-task EA Option'};
            app.SpecialLabel.Layout.Row = 4;
            app.SpecialLabel.Layout.Column = 1;
            app.SpecialLabel.Text = 'Special';

            % Create ESpecialTypeDropDown
            app.ESpecialTypeDropDown = uidropdown(app.EP1GridLayout);
            app.ESpecialTypeDropDown.Items = {'None', 'Competitive', 'Constrained'};
            app.ESpecialTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @ESpecialTypeDropDownValueChanged, true);
            app.ESpecialTypeDropDown.FontWeight = 'bold';
            app.ESpecialTypeDropDown.BackgroundColor = [1 1 1];
            app.ESpecialTypeDropDown.Layout.Row = 4;
            app.ESpecialTypeDropDown.Layout.Column = [2 3];
            app.ESpecialTypeDropDown.Value = 'None';

            % Create EPanel2
            app.EPanel2 = uipanel(app.ExperimentsGridLayout);
            app.EPanel2.BackgroundColor = [1 1 1];
            app.EPanel2.Layout.Row = 1;
            app.EPanel2.Layout.Column = 2;

            % Create EP2GridLayout
            app.EP2GridLayout = uigridlayout(app.EPanel2);
            app.EP2GridLayout.ColumnWidth = {'2x', 55};
            app.EP2GridLayout.RowHeight = {'fit', 'fit', 'fit', 'fit', '1x', 'fit', '1x', 'fit'};
            app.EP2GridLayout.ColumnSpacing = 5;
            app.EP2GridLayout.Padding = [5 5 5 5];
            app.EP2GridLayout.BackgroundColor = [1 1 1];

            % Create EStartButton
            app.EStartButton = uibutton(app.EP2GridLayout, 'push');
            app.EStartButton.ButtonPushedFcn = createCallbackFcn(app, @EStartButtonPushed, true);
            app.EStartButton.BusyAction = 'cancel';
            app.EStartButton.BackgroundColor = [0.6706 0.949 0.6706];
            app.EStartButton.FontWeight = 'bold';
            app.EStartButton.Layout.Row = 1;
            app.EStartButton.Layout.Column = [1 2];
            app.EStartButton.Text = 'Start';

            % Create EPauseButton
            app.EPauseButton = uibutton(app.EP2GridLayout, 'push');
            app.EPauseButton.ButtonPushedFcn = createCallbackFcn(app, @EPauseButtonPushed, true);
            app.EPauseButton.BusyAction = 'cancel';
            app.EPauseButton.BackgroundColor = [1 1 0.502];
            app.EPauseButton.FontWeight = 'bold';
            app.EPauseButton.Enable = 'off';
            app.EPauseButton.Layout.Row = 2;
            app.EPauseButton.Layout.Column = [1 2];
            app.EPauseButton.Text = 'Pause';

            % Create EStopButton
            app.EStopButton = uibutton(app.EP2GridLayout, 'push');
            app.EStopButton.ButtonPushedFcn = createCallbackFcn(app, @EStopButtonPushed, true);
            app.EStopButton.BusyAction = 'cancel';
            app.EStopButton.BackgroundColor = [1 0.6 0.6];
            app.EStopButton.FontWeight = 'bold';
            app.EStopButton.Enable = 'off';
            app.EStopButton.Layout.Row = 3;
            app.EStopButton.Layout.Column = [1 2];
            app.EStopButton.Text = 'Stop';

            % Create EAlgorithmsTree
            app.EAlgorithmsTree = uitree(app.EP2GridLayout);
            app.EAlgorithmsTree.Multiselect = 'on';
            app.EAlgorithmsTree.NodeTextChangedFcn = createCallbackFcn(app, @EAlgorithmsTreeNodeTextChanged, true);
            app.EAlgorithmsTree.Editable = 'on';
            app.EAlgorithmsTree.Layout.Row = 5;
            app.EAlgorithmsTree.Layout.Column = [1 2];

            % Create EProblemsTree
            app.EProblemsTree = uitree(app.EP2GridLayout);
            app.EProblemsTree.Multiselect = 'on';
            app.EProblemsTree.NodeTextChangedFcn = createCallbackFcn(app, @EProblemsTreeNodeTextChanged, true);
            app.EProblemsTree.Editable = 'on';
            app.EProblemsTree.Layout.Row = 7;
            app.EProblemsTree.Layout.Column = [1 2];

            % Create ESelectedAlgorithmsLabel
            app.ESelectedAlgorithmsLabel = uilabel(app.EP2GridLayout);
            app.ESelectedAlgorithmsLabel.FontWeight = 'bold';
            app.ESelectedAlgorithmsLabel.Layout.Row = 4;
            app.ESelectedAlgorithmsLabel.Layout.Column = 1;
            app.ESelectedAlgorithmsLabel.Text = 'Selected Algo';

            % Create ESelectedProblemsLabel
            app.ESelectedProblemsLabel = uilabel(app.EP2GridLayout);
            app.ESelectedProblemsLabel.FontWeight = 'bold';
            app.ESelectedProblemsLabel.Layout.Row = 6;
            app.ESelectedProblemsLabel.Layout.Column = 1;
            app.ESelectedProblemsLabel.Text = 'Selected Prob';

            % Create EAlgorithmsDelButton
            app.EAlgorithmsDelButton = uibutton(app.EP2GridLayout, 'push');
            app.EAlgorithmsDelButton.ButtonPushedFcn = createCallbackFcn(app, @EAlgorithmsDelButtonPushed, true);
            app.EAlgorithmsDelButton.BackgroundColor = [1 1 0.702];
            app.EAlgorithmsDelButton.FontWeight = 'bold';
            app.EAlgorithmsDelButton.Tooltip = {'Delete selected algorithms'};
            app.EAlgorithmsDelButton.Layout.Row = 4;
            app.EAlgorithmsDelButton.Layout.Column = 2;
            app.EAlgorithmsDelButton.Text = 'Delete';

            % Create EProblemsDelButton
            app.EProblemsDelButton = uibutton(app.EP2GridLayout, 'push');
            app.EProblemsDelButton.ButtonPushedFcn = createCallbackFcn(app, @EProblemsDelButtonPushed, true);
            app.EProblemsDelButton.BackgroundColor = [1 1 0.702];
            app.EProblemsDelButton.FontWeight = 'bold';
            app.EProblemsDelButton.Tooltip = {'Delete selected problems'};
            app.EProblemsDelButton.Layout.Row = 6;
            app.EProblemsDelButton.Layout.Column = 2;
            app.EProblemsDelButton.Text = 'Delete';

            % Create ESaveDataButton
            app.ESaveDataButton = uibutton(app.EP2GridLayout, 'push');
            app.ESaveDataButton.ButtonPushedFcn = createCallbackFcn(app, @ESaveDataButtonPushed, true);
            app.ESaveDataButton.BackgroundColor = [0.702 1 0.702];
            app.ESaveDataButton.FontWeight = 'bold';
            app.ESaveDataButton.Tooltip = {'Save finished data to mat file'};
            app.ESaveDataButton.Layout.Row = 8;
            app.ESaveDataButton.Layout.Column = [1 2];
            app.ESaveDataButton.Text = 'Save Data';

            % Create DataProcessTab
            app.DataProcessTab = uitab(app.MTOPlatformTabGroup);
            app.DataProcessTab.Title = 'Data Process';
            app.DataProcessTab.BackgroundColor = [1 1 1];

            % Create DataProcessGridLayout
            app.DataProcessGridLayout = uigridlayout(app.DataProcessTab);
            app.DataProcessGridLayout.ColumnWidth = {380, '1x'};
            app.DataProcessGridLayout.RowHeight = {'1x'};
            app.DataProcessGridLayout.ColumnSpacing = 5;
            app.DataProcessGridLayout.BackgroundColor = [1 1 1];

            % Create DPanel1
            app.DPanel1 = uipanel(app.DataProcessGridLayout);
            app.DPanel1.BackgroundColor = [1 1 1];
            app.DPanel1.Layout.Row = 1;
            app.DPanel1.Layout.Column = 1;

            % Create DP1GridLayout
            app.DP1GridLayout = uigridlayout(app.DPanel1);
            app.DP1GridLayout.ColumnWidth = {'1x'};
            app.DP1GridLayout.RowHeight = {'fit', 'fit', 'fit', 'fit', 'fit'};
            app.DP1GridLayout.RowSpacing = 20;
            app.DP1GridLayout.Padding = [10 10 10 20];
            app.DP1GridLayout.BackgroundColor = [1 1 1];

            % Create DDataProcessModuleLabel
            app.DDataProcessModuleLabel = uilabel(app.DP1GridLayout);
            app.DDataProcessModuleLabel.HorizontalAlignment = 'center';
            app.DDataProcessModuleLabel.FontSize = 18;
            app.DDataProcessModuleLabel.FontWeight = 'bold';
            app.DDataProcessModuleLabel.Layout.Row = 1;
            app.DDataProcessModuleLabel.Layout.Column = 1;
            app.DDataProcessModuleLabel.Text = 'Data Process Module';

            % Create DP1Panel1
            app.DP1Panel1 = uipanel(app.DP1GridLayout);
            app.DP1Panel1.BackgroundColor = [1 1 1];
            app.DP1Panel1.Layout.Row = 2;
            app.DP1Panel1.Layout.Column = 1;

            % Create DP1P1GridLayout
            app.DP1P1GridLayout = uigridlayout(app.DP1Panel1);
            app.DP1P1GridLayout.ColumnWidth = {'1x', '1x', '1x'};
            app.DP1P1GridLayout.RowHeight = {'fit', 'fit'};
            app.DP1P1GridLayout.Padding = [10 20 10 20];
            app.DP1P1GridLayout.BackgroundColor = [1 1 1];

            % Create DLoadDataButton
            app.DLoadDataButton = uibutton(app.DP1P1GridLayout, 'push');
            app.DLoadDataButton.ButtonPushedFcn = createCallbackFcn(app, @DLoadDataButtonPushed, true);
            app.DLoadDataButton.BackgroundColor = [0.502 0.702 1];
            app.DLoadDataButton.FontWeight = 'bold';
            app.DLoadDataButton.Layout.Row = 2;
            app.DLoadDataButton.Layout.Column = 1;
            app.DLoadDataButton.Text = 'Load Data';

            % Create DDeleteDataButton
            app.DDeleteDataButton = uibutton(app.DP1P1GridLayout, 'push');
            app.DDeleteDataButton.ButtonPushedFcn = createCallbackFcn(app, @DDeleteDataButtonPushed, true);
            app.DDeleteDataButton.BackgroundColor = [1 1 0.702];
            app.DDeleteDataButton.FontWeight = 'bold';
            app.DDeleteDataButton.Layout.Row = 2;
            app.DDeleteDataButton.Layout.Column = 2;
            app.DDeleteDataButton.Text = 'Delete Data';

            % Create DSaveDataButton
            app.DSaveDataButton = uibutton(app.DP1P1GridLayout, 'push');
            app.DSaveDataButton.ButtonPushedFcn = createCallbackFcn(app, @DSaveDataButtonPushed, true);
            app.DSaveDataButton.BackgroundColor = [0.6706 0.949 0.6706];
            app.DSaveDataButton.FontWeight = 'bold';
            app.DSaveDataButton.Layout.Row = 2;
            app.DSaveDataButton.Layout.Column = 3;
            app.DSaveDataButton.Text = 'Save Data';

            % Create DLoadDataorSelectandDeleteSaveDataLabel_3
            app.DLoadDataorSelectandDeleteSaveDataLabel_3 = uilabel(app.DP1P1GridLayout);
            app.DLoadDataorSelectandDeleteSaveDataLabel_3.HorizontalAlignment = 'center';
            app.DLoadDataorSelectandDeleteSaveDataLabel_3.Layout.Row = 1;
            app.DLoadDataorSelectandDeleteSaveDataLabel_3.Layout.Column = [2 3];
            app.DLoadDataorSelectandDeleteSaveDataLabel_3.Text = 'Select data node, click Delete/Save';

            % Create DLoadDataorSelectandDeleteSaveDataLabel_4
            app.DLoadDataorSelectandDeleteSaveDataLabel_4 = uilabel(app.DP1P1GridLayout);
            app.DLoadDataorSelectandDeleteSaveDataLabel_4.HorizontalAlignment = 'center';
            app.DLoadDataorSelectandDeleteSaveDataLabel_4.Layout.Row = 1;
            app.DLoadDataorSelectandDeleteSaveDataLabel_4.Layout.Column = 1;
            app.DLoadDataorSelectandDeleteSaveDataLabel_4.Text = 'Load data to tree';

            % Create DP1Panel2
            app.DP1Panel2 = uipanel(app.DP1GridLayout);
            app.DP1Panel2.BackgroundColor = [1 1 1];
            app.DP1Panel2.Layout.Row = 3;
            app.DP1Panel2.Layout.Column = 1;

            % Create DP1P2GridLayout
            app.DP1P2GridLayout = uigridlayout(app.DP1Panel2);
            app.DP1P2GridLayout.ColumnWidth = {'1x', '1x', '1x'};
            app.DP1P2GridLayout.RowHeight = {'fit', 'fit'};
            app.DP1P2GridLayout.Padding = [10 20 10 20];
            app.DP1P2GridLayout.BackgroundColor = [1 1 1];

            % Create DSelectandSplitDataLabel
            app.DSelectandSplitDataLabel = uilabel(app.DP1P2GridLayout);
            app.DSelectandSplitDataLabel.HorizontalAlignment = 'center';
            app.DSelectandSplitDataLabel.Layout.Row = 1;
            app.DSelectandSplitDataLabel.Layout.Column = [1 3];
            app.DSelectandSplitDataLabel.Text = 'Select data node, click Split button';

            % Create DRepsSplitButton
            app.DRepsSplitButton = uibutton(app.DP1P2GridLayout, 'push');
            app.DRepsSplitButton.ButtonPushedFcn = createCallbackFcn(app, @DRepsSplitButtonPushed, true);
            app.DRepsSplitButton.BackgroundColor = [0.902 0.902 0.902];
            app.DRepsSplitButton.FontWeight = 'bold';
            app.DRepsSplitButton.Layout.Row = 2;
            app.DRepsSplitButton.Layout.Column = 1;
            app.DRepsSplitButton.Text = 'Reps Split';

            % Create DAlgorithmsSplitButton
            app.DAlgorithmsSplitButton = uibutton(app.DP1P2GridLayout, 'push');
            app.DAlgorithmsSplitButton.ButtonPushedFcn = createCallbackFcn(app, @DAlgorithmsSplitButtonPushed, true);
            app.DAlgorithmsSplitButton.BackgroundColor = [0.902 0.902 0.902];
            app.DAlgorithmsSplitButton.FontWeight = 'bold';
            app.DAlgorithmsSplitButton.Layout.Row = 2;
            app.DAlgorithmsSplitButton.Layout.Column = 2;
            app.DAlgorithmsSplitButton.Text = 'Algorithm Split';

            % Create DProblemsSplitButton
            app.DProblemsSplitButton = uibutton(app.DP1P2GridLayout, 'push');
            app.DProblemsSplitButton.ButtonPushedFcn = createCallbackFcn(app, @DProblemsSplitButtonPushed, true);
            app.DProblemsSplitButton.BackgroundColor = [0.902 0.902 0.902];
            app.DProblemsSplitButton.FontWeight = 'bold';
            app.DProblemsSplitButton.Layout.Row = 2;
            app.DProblemsSplitButton.Layout.Column = 3;
            app.DProblemsSplitButton.Text = 'Problem Split';

            % Create DP1Panel3
            app.DP1Panel3 = uipanel(app.DP1GridLayout);
            app.DP1Panel3.BackgroundColor = [1 1 1];
            app.DP1Panel3.Layout.Row = 4;
            app.DP1Panel3.Layout.Column = 1;

            % Create DP1P3GridLayout
            app.DP1P3GridLayout = uigridlayout(app.DP1Panel3);
            app.DP1P3GridLayout.ColumnWidth = {'1x', '1x', '1x'};
            app.DP1P3GridLayout.RowHeight = {'fit', 'fit'};
            app.DP1P3GridLayout.Padding = [10 20 10 20];
            app.DP1P3GridLayout.BackgroundColor = [1 1 1];

            % Create DSelectandMergeDataLabel
            app.DSelectandMergeDataLabel = uilabel(app.DP1P3GridLayout);
            app.DSelectandMergeDataLabel.HorizontalAlignment = 'center';
            app.DSelectandMergeDataLabel.Layout.Row = 1;
            app.DSelectandMergeDataLabel.Layout.Column = [1 3];
            app.DSelectandMergeDataLabel.Text = 'Select data node, click Merge button';

            % Create DRepsMergeButton
            app.DRepsMergeButton = uibutton(app.DP1P3GridLayout, 'push');
            app.DRepsMergeButton.ButtonPushedFcn = createCallbackFcn(app, @DRepsMergeButtonPushed, true);
            app.DRepsMergeButton.BackgroundColor = [0.902 0.902 0.902];
            app.DRepsMergeButton.FontWeight = 'bold';
            app.DRepsMergeButton.Layout.Row = 2;
            app.DRepsMergeButton.Layout.Column = 1;
            app.DRepsMergeButton.Text = 'Reps Merge';

            % Create DAlgorithmsMergeButton
            app.DAlgorithmsMergeButton = uibutton(app.DP1P3GridLayout, 'push');
            app.DAlgorithmsMergeButton.ButtonPushedFcn = createCallbackFcn(app, @DAlgorithmsMergeButtonPushed, true);
            app.DAlgorithmsMergeButton.BackgroundColor = [0.902 0.902 0.902];
            app.DAlgorithmsMergeButton.FontWeight = 'bold';
            app.DAlgorithmsMergeButton.Layout.Row = 2;
            app.DAlgorithmsMergeButton.Layout.Column = 2;
            app.DAlgorithmsMergeButton.Text = 'Algorithm Merge';

            % Create DProblemsMergeButton
            app.DProblemsMergeButton = uibutton(app.DP1P3GridLayout, 'push');
            app.DProblemsMergeButton.ButtonPushedFcn = createCallbackFcn(app, @DProblemsMergeButtonPushed, true);
            app.DProblemsMergeButton.BackgroundColor = [0.902 0.902 0.902];
            app.DProblemsMergeButton.FontWeight = 'bold';
            app.DProblemsMergeButton.Layout.Row = 2;
            app.DProblemsMergeButton.Layout.Column = 3;
            app.DProblemsMergeButton.Text = 'Problem Merge';

            % Create DP1Panel4
            app.DP1Panel4 = uipanel(app.DP1GridLayout);
            app.DP1Panel4.BackgroundColor = [1 1 1];
            app.DP1Panel4.Layout.Row = 5;
            app.DP1Panel4.Layout.Column = 1;

            % Create DP1P4GridLayout
            app.DP1P4GridLayout = uigridlayout(app.DP1Panel4);
            app.DP1P4GridLayout.ColumnWidth = {'1x', '1x', '1x'};
            app.DP1P4GridLayout.RowHeight = {'fit', 'fit'};
            app.DP1P4GridLayout.Padding = [10 20 10 20];
            app.DP1P4GridLayout.BackgroundColor = [1 1 1];

            % Create DUpandDownDataLabel
            app.DUpandDownDataLabel = uilabel(app.DP1P4GridLayout);
            app.DUpandDownDataLabel.HorizontalAlignment = 'center';
            app.DUpandDownDataLabel.Layout.Row = 1;
            app.DUpandDownDataLabel.Layout.Column = [1 3];
            app.DUpandDownDataLabel.Text = 'Select data node, click Up or Down button';

            % Create DUpButton
            app.DUpButton = uibutton(app.DP1P4GridLayout, 'push');
            app.DUpButton.ButtonPushedFcn = createCallbackFcn(app, @DUpButtonPushed, true);
            app.DUpButton.BackgroundColor = [0.902 0.902 0.902];
            app.DUpButton.FontWeight = 'bold';
            app.DUpButton.Layout.Row = 2;
            app.DUpButton.Layout.Column = 1;
            app.DUpButton.Text = 'UP';

            % Create DDownButton
            app.DDownButton = uibutton(app.DP1P4GridLayout, 'push');
            app.DDownButton.ButtonPushedFcn = createCallbackFcn(app, @DDownButtonPushed, true);
            app.DDownButton.BackgroundColor = [0.902 0.902 0.902];
            app.DDownButton.FontWeight = 'bold';
            app.DDownButton.Layout.Row = 2;
            app.DDownButton.Layout.Column = 3;
            app.DDownButton.Text = 'Down';

            % Create DPanel2
            app.DPanel2 = uipanel(app.DataProcessGridLayout);
            app.DPanel2.BackgroundColor = [1 1 1];
            app.DPanel2.Layout.Row = 1;
            app.DPanel2.Layout.Column = 2;

            % Create DP2GridLayout
            app.DP2GridLayout = uigridlayout(app.DPanel2);
            app.DP2GridLayout.ColumnWidth = {'1x'};
            app.DP2GridLayout.RowHeight = {'1x'};
            app.DP2GridLayout.Padding = [0 0 0 0];
            app.DP2GridLayout.BackgroundColor = [1 1 1];

            % Create DDataTree
            app.DDataTree = uitree(app.DP2GridLayout);
            app.DDataTree.Multiselect = 'on';
            app.DDataTree.NodeTextChangedFcn = createCallbackFcn(app, @DDataTreeNodeTextChanged, true);
            app.DDataTree.Editable = 'on';
            app.DDataTree.Layout.Row = 1;
            app.DDataTree.Layout.Column = 1;

            % Create SelectedAlgoContextMenu
            app.SelectedAlgoContextMenu = uicontextmenu(app.MTOPlatformUIFigure);
            app.SelectedAlgoContextMenu.ContextMenuOpeningFcn = createCallbackFcn(app, @SelectedAlgoContextMenuOpening, true);
            
            % Assign app.SelectedAlgoContextMenu
            app.TAlgorithmTree.ContextMenu = app.SelectedAlgoContextMenu;
            app.EAlgorithmsTree.ContextMenu = app.SelectedAlgoContextMenu;

            % Create SelectedAlgoSelectAllMenu
            app.SelectedAlgoSelectAllMenu = uimenu(app.SelectedAlgoContextMenu);
            app.SelectedAlgoSelectAllMenu.Text = 'Select All';

            % Create DDataContextMenu
            app.DDataContextMenu = uicontextmenu(app.MTOPlatformUIFigure);
            app.DDataContextMenu.ContextMenuOpeningFcn = createCallbackFcn(app, @DDataContextMenuOpening, true);
            
            % Assign app.DDataContextMenu
            app.DDataTree.ContextMenu = app.DDataContextMenu;

            % Create SelectedAlgoSelectAllMenu_2
            app.SelectedAlgoSelectAllMenu_2 = uimenu(app.DDataContextMenu);
            app.SelectedAlgoSelectAllMenu_2.Text = 'Select All';

            % Create SelectedProbContextMenu
            app.SelectedProbContextMenu = uicontextmenu(app.MTOPlatformUIFigure);
            
            % Assign app.SelectedProbContextMenu
            app.TProblemTree.ContextMenu = app.SelectedProbContextMenu;
            app.EProblemsTree.ContextMenu = app.SelectedProbContextMenu;

            % Create SelectedProbSelectAllMenu
            app.SelectedProbSelectAllMenu = uimenu(app.SelectedProbContextMenu);
            app.SelectedProbSelectAllMenu.MenuSelectedFcn = createCallbackFcn(app, @ESelectedProbContextMenuOpening, true);
            app.SelectedProbSelectAllMenu.Text = 'Select All';

            % Create AlgorithmsContextMenu
            app.AlgorithmsContextMenu = uicontextmenu(app.MTOPlatformUIFigure);
            app.AlgorithmsContextMenu.ContextMenuOpeningFcn = createCallbackFcn(app, @AlgorithmsContextMenuOpening, true);
            
            % Assign app.AlgorithmsContextMenu
            app.EAlgorithmsListBox.ContextMenu = app.AlgorithmsContextMenu;

            % Create AlgorithmsSelectAllMenu
            app.AlgorithmsSelectAllMenu = uimenu(app.AlgorithmsContextMenu);
            app.AlgorithmsSelectAllMenu.Text = 'Select All';

            % Create ProblemsContextMenu
            app.ProblemsContextMenu = uicontextmenu(app.MTOPlatformUIFigure);
            
            % Assign app.ProblemsContextMenu
            app.EProblemsListBox.ContextMenu = app.ProblemsContextMenu;

            % Create ProblemsSelectAllMenu
            app.ProblemsSelectAllMenu = uimenu(app.ProblemsContextMenu);
            app.ProblemsSelectAllMenu.MenuSelectedFcn = createCallbackFcn(app, @EProblemsContextMenuOpening, true);
            app.ProblemsSelectAllMenu.Text = 'Select All';

            % Show the figure after all components are created
            app.MTOPlatformUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = MTO_GUI

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.MTOPlatformUIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.MTOPlatformUIFigure)
        end
    end
end