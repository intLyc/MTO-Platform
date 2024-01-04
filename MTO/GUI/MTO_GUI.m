classdef MTO_GUI < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        MTOPlatformMToPv11UIFigure      matlab.ui.Figure
        MTOPlatformGridLayout           matlab.ui.container.GridLayout
        MTOPlatformTabGroup             matlab.ui.container.TabGroup
        TestModuleTab                   matlab.ui.container.Tab
        TestGridLayout                  matlab.ui.container.GridLayout
        TPanel1                         matlab.ui.container.Panel
        TP1GridLayout                   matlab.ui.container.GridLayout
        AlgorithmDropDownLabel          matlab.ui.control.Label
        TAlgorithmDropDown              matlab.ui.control.DropDown
        TAlgorithmTree                  matlab.ui.container.Tree
        TProblemTree                    matlab.ui.container.Tree
        TProblemDropDown                matlab.ui.control.DropDown
        ProblemDropDownLabel            matlab.ui.control.Label
        TTaskTypeDropDown               matlab.ui.control.DropDown
        TaskLabel                       matlab.ui.control.Label
        SpecialLabel_2                  matlab.ui.control.Label
        TSpecialTypeDropDown            matlab.ui.control.DropDown
        TObjectiveTypeDropDown          matlab.ui.control.DropDown
        ObjectiveLabel                  matlab.ui.control.Label
        TPanel2                         matlab.ui.container.Panel
        TP2GridLayout                   matlab.ui.container.GridLayout
        TP21GridLayout                  matlab.ui.container.GridLayout
        TShowTypeDropDown               matlab.ui.control.DropDown
        TSaveButton                     matlab.ui.control.Button
        TP24GridLayout                  matlab.ui.container.GridLayout
        TStartButton                    matlab.ui.control.Button
        TResetButton                    matlab.ui.control.Button
        TUIAxes                         matlab.ui.control.UIAxes
        TPanel3                         matlab.ui.container.Panel
        TP3GridLayout                   matlab.ui.container.GridLayout
        TOutputTextArea                 matlab.ui.control.TextArea
        MTOPlatformMToPbyYanchiLiLabel  matlab.ui.control.Label
        ExperimentModuleTab             matlab.ui.container.Tab
        ExperimentsGridLayout           matlab.ui.container.GridLayout
        EPanel1                         matlab.ui.container.Panel
        EP1GridLayout                   matlab.ui.container.GridLayout
        EProblemsAddButton              matlab.ui.control.Button
        EAlgorithmsAddButton            matlab.ui.control.Button
        EAlgorithmsListBox              matlab.ui.control.ListBox
        AlgorithmsLabel                 matlab.ui.control.Label
        EProblemsListBox                matlab.ui.control.ListBox
        ProblemsLabel                   matlab.ui.control.Label
        ParallelLabel                   matlab.ui.control.Label
        EParallelDropDown               matlab.ui.control.DropDown
        TaskLabel_2                     matlab.ui.control.Label
        ETaskTypeDropDown               matlab.ui.control.DropDown
        SpecialLabel                    matlab.ui.control.Label
        ESpecialTypeDropDown            matlab.ui.control.DropDown
        ObjectiveLabel_2                matlab.ui.control.Label
        EObjectiveTypeDropDown          matlab.ui.control.DropDown
        GridLayout5                     matlab.ui.container.GridLayout
        ERepsEditField                  matlab.ui.control.NumericEditField
        EResultsNumEditField            matlab.ui.control.NumericEditField
        ERunTimesEditFieldLabel         matlab.ui.control.Label
        EResultsNumEditFieldLabel       matlab.ui.control.Label
        SaveDecLabel                    matlab.ui.control.Label
        ESaveDecDropDown                matlab.ui.control.DropDown
        EPanel2                         matlab.ui.container.Panel
        EP2GridLayout                   matlab.ui.container.GridLayout
        EAlgorithmsTree                 matlab.ui.container.Tree
        EProblemsTree                   matlab.ui.container.Tree
        GridLayout2                     matlab.ui.container.GridLayout
        EStartButton                    matlab.ui.control.Button
        EPauseButton                    matlab.ui.control.Button
        EStopButton                     matlab.ui.control.Button
        GridLayout3                     matlab.ui.container.GridLayout
        ESelectedAlgorithmsLabel        matlab.ui.control.Label
        EAlgorithmsDelButton            matlab.ui.control.Button
        GridLayout4                     matlab.ui.container.GridLayout
        ESelectedProblemsLabel          matlab.ui.control.Label
        EProblemsDelButton              matlab.ui.control.Button
        GridLayout                      matlab.ui.container.GridLayout
        ESaveDataButton                 matlab.ui.control.Button
        ELoadDataButton                 matlab.ui.control.Button
        EPanel3                         matlab.ui.container.Panel
        EP3GridLayout                   matlab.ui.container.GridLayout
        EP3TGridLayout                  matlab.ui.container.GridLayout
        EP3T1GridLayout                 matlab.ui.container.GridLayout
        ETestTypeDropDown               matlab.ui.control.DropDown
        EAlgorithmDropDown              matlab.ui.control.DropDown
        EShowTypeDropDown               matlab.ui.control.DropDown
        EDataTypeDropDown               matlab.ui.control.DropDown
        EHighlightTypeDropDown          matlab.ui.control.DropDown
        ESaveTableButton                matlab.ui.control.Button
        EDataFormatEditField            matlab.ui.control.EditField
        EConvergeButton                 matlab.ui.control.Button
        EParetoButton                   matlab.ui.control.Button
        EConvergeTypeDropDown           matlab.ui.control.DropDown
        EUITable                        matlab.ui.control.Table
        DataProcessModuleTab            matlab.ui.container.Tab
        DataProcessGridLayout           matlab.ui.container.GridLayout
        DPanel1                         matlab.ui.container.Panel
        DP1GridLayout                   matlab.ui.container.GridLayout
        DDataProcessModuleLabel         matlab.ui.control.Label
        DP1Panel1                       matlab.ui.container.Panel
        DP1P1GridLayout                 matlab.ui.container.GridLayout
        DLoadDataButton                 matlab.ui.control.Button
        DDeleteDataButton               matlab.ui.control.Button
        DSaveDataButton                 matlab.ui.control.Button
        DLoadDataorSelectandDeleteSaveDataLabel_3  matlab.ui.control.Label
        DLoadDataorSelectandDeleteSaveDataLabel_4  matlab.ui.control.Label
        DP1Panel2                       matlab.ui.container.Panel
        DP1P2GridLayout                 matlab.ui.container.GridLayout
        DSelectandSplitDataLabel        matlab.ui.control.Label
        DRepsSplitButton                matlab.ui.control.Button
        DAlgorithmsSplitButton          matlab.ui.control.Button
        DProblemsSplitButton            matlab.ui.control.Button
        DP1Panel3                       matlab.ui.container.Panel
        DP1P3GridLayout                 matlab.ui.container.GridLayout
        DSelectandMergeDataLabel        matlab.ui.control.Label
        DRepsMergeButton                matlab.ui.control.Button
        DAlgorithmsMergeButton          matlab.ui.control.Button
        DProblemsMergeButton            matlab.ui.control.Button
        DP1Panel4                       matlab.ui.container.Panel
        DP1P4GridLayout                 matlab.ui.container.GridLayout
        DUpandDownDataLabel             matlab.ui.control.Label
        DUpButton                       matlab.ui.control.Button
        DDownButton                     matlab.ui.control.Button
        DDataProcessModuleLabel_2       matlab.ui.control.Label
        DPanel2                         matlab.ui.container.Panel
        DP2GridLayout                   matlab.ui.container.GridLayout
        DDataTree                       matlab.ui.container.Tree
        SelectedAlgoContextMenu         matlab.ui.container.ContextMenu
        SelectedAlgoSelectAllMenu       matlab.ui.container.Menu
        DDataContextMenu                matlab.ui.container.ContextMenu
        SelectedAlgoSelectAllMenu_2     matlab.ui.container.Menu
        SelectedProbContextMenu         matlab.ui.container.ContextMenu
        SelectedProbSelectAllMenu       matlab.ui.container.Menu
        AlgorithmsContextMenu           matlab.ui.container.ContextMenu
        AlgorithmsSelectAllMenu         matlab.ui.container.Menu
        ProblemsContextMenu             matlab.ui.container.ContextMenu
        ProblemsSelectAllMenu           matlab.ui.container.Menu
    end

    properties (Access = public)
        AlgoLoad % cell of algorithms loaded from folder
        ProbLoad % cell of problems loaded from folder
        MetricLoad % cell of metrics loaded from folder
        
        % convergence axes set
        DefaultLineWidth = 1.5
        DefaultMarkerList = {'o', '*', 'x', '^', '+', 'p', 'v', 's', 'd', '<', '>', 'h'}
        DefaultMarkerSize = 7
        DefaultMarkerNum = 10
        
        % Test Module
        TData % data
        
        % Experiment Module
        EData % data
        EStopFlag % stop button clicked flag
        
        ETableSelected % selected table cell index
        EMetricMin = true % default metric min
        EResultConvergeData % results converge corresponding to metric
        EResultParetoData % results pareto corresponding to metric
        EResultTableData % results data corresponding to metric
        
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
        
        function readMetric(app, label_str)
            % load the metrics
            
            app.MetricLoad = app.readList('../Metrics', {'Metric', label_str});
            app.MetricLoad = sort_nat(app.MetricLoad);
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
            
            label_str = {app.TTaskTypeDropDown.Value, app.TObjectiveTypeDropDown.Value, app.TSpecialTypeDropDown.Value};
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
            
            label_str = {app.ETaskTypeDropDown.Value, app.EObjectiveTypeDropDown.Value, app.ESpecialTypeDropDown.Value};
            app.readAlgoProb(label_str);
            app.EAlgorithmsListBox.Items(:) = [];
            app.EProblemsListBox.Items(:) = [];
            app.EAlgorithmsListBox.Items = strrep(app.AlgoLoad, '_', '-');
            app.EAlgorithmsListBox.ItemsData = app.AlgoLoad;
            app.EProblemsListBox.Items = strrep(app.ProbLoad, '_', '-');
            app.EProblemsListBox.ItemsData = app.ProbLoad;
        end
        
        function EloadMetric(app, label_str)
            % load the algorithms and problems in Experiment module
            
            app.readMetric(label_str);
            app.EDataTypeDropDown.Items(:) = [];
            items = ['Reps', app.MetricLoad];
            app.EDataTypeDropDown.Items = strrep(items, '_', '-');
            app.EDataTypeDropDown.ItemsData = items;
        end
        
        function TstartEnable(app, value)
            % change controler enable when start button pused and end
            % in Test module
            
            app.TStartButton.Enable = value;
            app.TTaskTypeDropDown.Enable = value;
            app.TObjectiveTypeDropDown.Enable = value;
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
            app.EResultsNumEditField.Enable = value;
            app.ESaveDecDropDown.Enable = value;
            app.EParallelDropDown.Enable = value;
            app.ETaskTypeDropDown.Enable = value;
            app.EObjectiveTypeDropDown.Enable = value;
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
                case 'Tasks Figure (2D Unified)' % Tasks Figure (2D unified)
                    app.TupdateTasksFigure2D();
                case 'Tasks Figure (2D Real)' % Tasks Figure (2D unified)
                    app.TupdateTasksFigure2D();
                case 'Tasks Figure (1D Real)' % Tasks Figure (1D real)
                    app.TupdateTasksFigure();
                case 'Feasible Region (2D)' % Feasible Region (2D)
                    app.TupdateFeasibleRegion();
                case 'Convergence'
                    app.TupdateConvergence();
                case 'Pareto Front'
                    app.TupdateParetoFront();
            end
        end
        
        function TupdateTasksFigure(app)
            % update selected problem tasks figure in Test module
            try
                x = 0:1/1000:1;
                
                legend_cell = {};
                plot_handle = {};
                color = colororder;
                for no = 1:app.TProblemTree.Children(1).NodeData.T
                    minrange = app.TProblemTree.Children(1).NodeData.Lb{no}(1);
                    maxrange = app.TProblemTree.Children(1).NodeData.Ub{no}(1);
                    vars = (maxrange - minrange) .* x' + minrange;
                    [f, con] = app.TProblemTree.Children(1).NodeData.Fnc{no}(vars);
                    f(sum(con, 2)>0, :) = NaN;
                    
                    if strcmp(app.TShowTypeDropDown.Value, 'Tasks Figure (1D Unified)') % unified
                        fmin = min(f);
                        fmax = max(f);
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
                legend(app.TUIAxes, plot_handle, legend_cell, 'Location', 'best');
            catch ME
                return;
            end
        end
        
        function TupdateTasksFigure2D(app)
            % update selected problem tasks figure in Test module
            try
                x = 0:1/99:1;
                
                legend_cell = {};
                plot_handle = {};
                
                color = colororder;
                for no = 1:app.TProblemTree.Children(1).NodeData.T
                    minrange = app.TProblemTree.Children(1).NodeData.Lb{no}(1:2);
                    maxrange = app.TProblemTree.Children(1).NodeData.Ub{no}(1:2);
                    
                    [vars1, vars2] = meshgrid(x);
                    vars = [vars1(:), vars2(:)];
                    vars = (maxrange - minrange) .* vars + minrange;
                    [ff, con] = app.TProblemTree.Children(1).NodeData.Fnc{no}(vars);

                    ff(sum(con, 2) > 0) = NaN;
                    if strcmp(app.TShowTypeDropDown.Value, 'Tasks Figure (2D Unified)') % unified
                        fmin = min(ff);
                        fmax = max(ff);
                        ff = (ff - fmin) / (fmax - fmin);
                    end
                    ff = reshape(ff, size(vars1));
                    
                    p1 = mesh(app.TUIAxes, vars1, vars2, ff);
                    p1.FaceAlpha = 0.15;
                    p1.FaceColor = color(mod(no-1, size(color, 1))+1, :);
                    p1.EdgeColor = color(mod(no-1, size(color, 1))+1, :);
                    p1.LineStyle = '-';
                    hold(app.TUIAxes, 'on');
                    
                    legend_cell = [legend_cell, ['T', num2str(no)]];
                    plot_handle = [plot_handle, p1];
                end
                xlim(app.TUIAxes, [0, 1]);
                ylim(app.TUIAxes, [0, 1]);
                legend(app.TUIAxes, plot_handle, legend_cell, 'Location', 'best');
                xlabel(app.TUIAxes, 'X');
                ylabel(app.TUIAxes, 'Y');
                zlabel(app.TUIAxes, 'Obj');
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
                    minrange = app.TProblemTree.Children(1).NodeData.Lb{no}(1:2);
                    maxrange = app.TProblemTree.Children(1).NodeData.Ub{no}(1:2);
                    
                    [vars1, vars2] = meshgrid(x);
                    vars1 = vars1(:);
                    vars2 = vars2(:);
                    vars = [vars1, vars2];
                    vars = (maxrange - minrange) .* vars + minrange;
                    [~, con] = app.TProblemTree.Children(1).NodeData.Fnc{no}(vars);
                    
                    vars1(sum(con, 2) > 0) = [];
                    vars2(sum(con, 2) > 0) = [];
                    
                    p1 = scatter(app.TUIAxes, vars1, vars2, 6, 'filled');
                    p1.MarkerFaceAlpha = 0.6;
                    p1.MarkerEdgeAlpha = 0.6;
                    p1.MarkerEdgeColor = color(mod(no-1, size(color, 1))+1, :);
                    hold(app.TUIAxes, 'on');
                    
                    legend_cell = [legend_cell, ['T', num2str(no)]];
                    plot_handle = [plot_handle, p1];
                end
                xlim(app.TUIAxes, [0, 1]);
                ylim(app.TUIAxes, [0, 1]);
                legend(app.TUIAxes, plot_handle, legend_cell, 'Location', 'best');
            catch ME
                return;
            end
        end
        
        function TupdateConvergence(app)
            % update figure axes
            
            if isempty(app.TData)
                return;
            end
            
            cla(app.TUIAxes, 'reset');
            
            if max(app.TData.Problems(1).M) == 1
                result = Obj(app.TData);
            else
                result = IGD(app.TData);
            end
            
            xlim_min = inf;
            xlim_max = 0;
            tasks_name = {};
            converge_x = result.ConvergeData.X;
            converge_y = result.ConvergeData.Y;
            for j = 1:size(converge_x, 1)
                if j > length(app.DefaultMarkerList)
                    marker = '';
                else
                    marker = app.DefaultMarkerList{j};
                end
                
                y = squeeze(converge_y(j, 1, 1, :))';
                x = squeeze(converge_x(j, 1, 1, :))';
                p = plot(app.TUIAxes, x, y, ['-', marker]);
                p.LineWidth = app.DefaultLineWidth;
                indices = round(length(y)/app.DefaultMarkerNum);
                p.MarkerIndices = indices:indices:length(y)-round(indices/2);
                p.MarkerSize = app.DefaultMarkerSize;
                xlim_max = max(xlim_max, x(end));
                xlim_min = min(xlim_min, x(1));
                hold(app.TUIAxes, 'on');
                tasks_name = [tasks_name, ['T', num2str(j)]];
            end
            
            xlim(app.TUIAxes, [xlim_min, xlim_max]);
            if max(app.TData.Problems(1).M) == 1
                ylabel(app.TUIAxes, 'Obj');
            else
                ylabel(app.TUIAxes, 'IGD');
            end
            xlabel(app.TUIAxes, 'Evaluation');
            legend(app.TUIAxes, tasks_name, 'Location', 'best');
            grid(app.TUIAxes, 'on');
        end
        
        function TupdateParetoFront(app)
            % update figure axes
            
            if isempty(app.TData)
                return;
            end
            
            cla(app.TUIAxes, 'reset');
            
            if max(app.TData.Problems(1).M) ~= 2 || min(app.TData.Problems(1).M) ~= 2
                return;
            end
            
            result = IGD(app.TData);
            
            tasks_name = {};
            color_list = colororder;
            for j = 1:size(result.ParetoData.Obj, 1)
                if ~isempty(result.ParetoData.Optimum)
                    % draw optimum
                    x = squeeze(result.ParetoData.Optimum{j}(:, 1));
                    y = squeeze(result.ParetoData.Optimum{j}(:, 2));
                    s = scatter(app.TUIAxes, x, y);
                    s.MarkerEdgeColor = color_list(j,:);
                    s.MarkerFaceAlpha = 0.65;
                    s.MarkerFaceColor = color_list(j,:);
                    s.SizeData = 3;
                    hold(app.TUIAxes, 'on');
                    
                    % draw population
                    x = squeeze(result.ParetoData.Obj{j, 1, 1}(:, 1));
                    y = squeeze(result.ParetoData.Obj{j, 1, 1}(:, 2));
                    s = scatter(app.TUIAxes, x, y);
                    s.MarkerEdgeColor = color_list(j,:);
                    s.MarkerFaceAlpha = 0.65;
                    s.MarkerFaceColor = color_list(j,:);
                    s.SizeData = 40;
                    hold(app.TUIAxes, 'on');
                end
                tasks_name = [tasks_name, ['T', num2str(j), ' Pareto Front'], ['T', num2str(j), ' Population']];
            end
            
            xlabel(app.TUIAxes, '$f_1$', 'interpreter', 'latex');
            ylabel(app.TUIAxes, '$f_2$', 'interpreter', 'latex');
            legend(app.TUIAxes, tasks_name, 'Location', 'best');
            grid(app.TUIAxes, 'on');
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
        
        function EreloadTableData(app)
            % reload table data in Experiment module
            
            app.EresetFormat();
            switch app.EDataTypeDropDown.Value
                case 'Reps'
                    app.EresetTable({app.EData.Problems.Name}, {app.EData.Algorithms.Name});
                    app.EupdateTableReps();
                    app.EupdateTableData();
                    app.EupdateTableTest();
                    app.EupdateTableHighlight();
                otherwise
                    is_calculate = true;
                    if isfield(app.EData, 'Metrics')
                        metric_idx = find(ismember({app.EData.Metrics.Name}, app.EDataTypeDropDown.Value));
                        if ~isempty(metric_idx)
                            is_calculate = false;
                        end
                    end
                    if is_calculate
                        eval(['result = ', app.EDataTypeDropDown.Value, '(app.EData, ', num2str(app.EParallelDropDown.Value) ,');']);
                        metric.Name = app.EDataTypeDropDown.Value;
                        metric.Result = result;
                        if ~isfield(app.EData, 'Metrics')
                            app.EData.Metrics = struct.empty();
                        end
                        app.EData.Metrics = [app.EData.Metrics, metric];
                    else
                        result = app.EData.Metrics(metric_idx).Result;
                    end
                    if isfield(result, 'ConvergeData')
                        app.EResultConvergeData = result.ConvergeData;
                    else
                        app.EResultConvergeData = [];
                    end
                    if isfield(result, 'ParetoData')
                        app.EResultParetoData = result.ParetoData;
                    else
                        app.EResultParetoData = [];
                    end
                    switch result.Metric
                        case 'Min'
                            app.EMetricMin = true;
                        case 'Max'
                            app.EMetricMin = false;
                    end
                    app.EResultTableData = result.TableData;
                    app.EresetTable(result.RowName, result.ColumnName);
                    app.EupdateTableData();
                    app.EupdateTableTest();
            end
        end
        
        function EupdateTableReps(app)
            % update table reps per run
            
            app.ETableData = app.ETableReps;
            app.EUITable.Data = sprintfc('%d', app.ETableReps);
            drawnow;
        end
        
        function EupdateTableData(app)
            % update table data
            
            if strcmp(app.EDataTypeDropDown.Value, 'Reps')
                return;
            end
            
            table_data = app.EResultTableData;
            show_type = app.EShowTypeDropDown.Value;
            format_str = app.EDataFormatEditField.Value;
            app.EUITable.Data = {};
            app.ETableData = [];
            app.ETableView = {};
            
            switch show_type
                case 'Mean' % Mean
                    data_mean = mean(table_data, 3, 'omitnan');
                    app.ETableData = data_mean;
                    app.ETableView = sprintfc(format_str, data_mean);
                case 'Mean&Std' % Mean&Std
                    data_mean = mean(table_data, 3, 'omitnan');
                    data_std = std(table_data, 0, 3, 'omitnan');
                    app.ETableData = data_mean;
                    x = zeros([size(data_mean, 1), 2*size(data_mean, 2)]);
                    x(:, 1:2:end) = data_mean;
                    x(:, 2:2:end) = data_std;
                    app.ETableView = sprintfc(format_str, x);
                case 'Std'
                    data_std = std(table_data, 0, 3, 'omitnan');
                    app.ETableData = data_std;
                    app.ETableView = sprintfc(format_str, data_std);
                case 'Median'
                    data_median = median(table_data, 3, 'omitnan');
                    app.ETableData = data_median;
                    app.ETableView = sprintfc(format_str, data_median);
                case 'Best'
                    if app.EMetricMin
                        data_best = min(table_data, [], 3);
                    else
                        data_best = max(table_data, [], 3);
                    end
                    app.ETableData = data_best;
                    app.ETableView = sprintfc(format_str, data_best);
                case 'Worst'
                    data_nan = max(isnan(table_data), [], 3);
                    if app.EMetricMin
                        data_worst = max(table_data, [], 3);
                    else
                        data_worst = min(table_data, [], 3);
                    end
                    data_worst(data_nan == 1) = NaN;
                    app.ETableData = data_worst;
                    app.ETableView = sprintfc(format_str, data_worst);
            end
            app.EUITable.Data = app.ETableView;
            drawnow;
            app.EupdateTableHighlight();
        end
        
        function EupdateTableTest(app)
            % update table test
            
            if strcmp(app.EDataTypeDropDown.Value, 'Reps')
                return;
            end
            
            table_data = app.EResultTableData;
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
            
            app.EUITable.RowName{size(app.ETableData, 1)+1} = '+ / - / =';
            
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
                    x1(isnan(x1)) = 1e15; % big number replace NaN
                    x2(isnan(x2)) = 1e15; % big number replace NaN
                    if strcmp(test_type, 'Rank sum test')
                        p = ranksum(x1, x2);
                    elseif strcmp(test_type, 'Signed rank test')
                        p = signrank(x1, x2);
                    end
                    if p < 0.05
                        data1 = app.ETableData(row_i, algo);
                        data1(isnan(data1)) = Inf;
                        data2 = app.ETableData(row_i, algo_selected);
                        data2(isnan(data2)) = Inf;
                        if (app.EMetricMin && data1 < data2) || (~app.EMetricMin && data1 > data2)
                            app.ETableTest{row_i, algo} = '+';
                            sign_p(1) = sign_p(1) + 1;
                        elseif (app.EMetricMin && data1 > data2) || (~app.EMetricMin && data1 < data2)
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
                app.ETableTest{size(app.ETableData, 1)+1, algo} = sprintf('%d / %d / %d', sign_p);
            end
            app.EUITable.Data = cellstr(strcat(app.ETableView, " ", app.ETableTest(1:end-1, :)));
            app.EUITable.Data(size(app.ETableData, 1)+1,:) = app.ETableTest(size(app.ETableData, 1)+1,:);
            drawnow;
        end
        
        function EupdateTableHighlight(app)
            % update table highlight
            
            % highlight best value
            app.EUITable.removeStyle();
            high_color = uistyle('BackgroundColor', [0.67,0.95,0.67]);
            font_bold = uistyle('FontWeight', 'bold');
            low_color = uistyle('BackgroundColor', [1.00,0.60,0.60]);
            if strcmp(app.EDataTypeDropDown.Value, 'Reps') || isempty(app.ETableData) || size(app.ETableData, 2) <= 1
                drawnow;
                return;
            end
            best_matrix = [];
            worst_matrix = [];
            for row_i = 1:size(app.ETableData, 1)
                if strcmp(app.EHighlightTypeDropDown.Value, 'None')
                    drawnow;
                    return;
                end
                % best
                if ~(sum(isnan(app.ETableData(row_i, :))) == size(app.ETableData, 2))
                    temp_data = app.ETableData(row_i, :);
                    if app.EMetricMin
                        best_data = min(temp_data);
                    else
                        best_data = max(temp_data);
                    end
                    temp_idx = find(temp_data == best_data)';
                    row_idx = ones(length(temp_idx),1) .* row_i;
                    best_matrix = [best_matrix; [row_idx, temp_idx]];
                end
                % worst
                if strcmp(app.EHighlightTypeDropDown.Value, 'Best&Worst')
                    isnan_temp = isnan(app.ETableData(row_i, :));
                    if sum(isnan_temp)
                        temp_idx = find(isnan_temp)';
                        row_idx = ones(length(temp_idx),1) .* row_i;
                        worst_matrix = [worst_matrix; [row_idx, temp_idx]];
                    else
                        if app.EMetricMin
                            worst_data = max(app.ETableData(row_i, :));
                        else
                            worst_data = min(app.ETableData(row_i, :));
                        end
                        temp_idx = find(temp_data == worst_data)';
                        row_idx = ones(length(temp_idx),1) .* row_i;
                        worst_matrix = [worst_matrix; [row_idx, temp_idx]];
                    end
                end
            end
            if ~isempty(worst_matrix)
                app.EUITable.addStyle(low_color, 'cell', worst_matrix);
            end
            if ~isempty(best_matrix)
                app.EUITable.addStyle(high_color, 'cell', best_matrix);
                app.EUITable.addStyle(font_bold, 'cell', best_matrix);
            end
            drawnow;
        end
        
        function EresetFormat(app)
            format_str = app.EDataFormatEditField.Value;
            
            switch app.EShowTypeDropDown.Value
                case 'Mean'
                    format_str = '%.4e';
                case 'Mean&Std'
                    format_str = '%.4e (%.2e)';
                case 'Std'
                    format_str = '%.2e';
                case 'Median'
                    format_str = '%.4e';
                case 'Best'
                    format_str = '%.4e';
                case 'Worst'
                    format_str = '%.4e';
            end
            
            app.EDataFormatEditField.Value = format_str;
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
                uiconfirm(app.MTOPlatformMToPv11UIFigure, msg, 'error', 'Icon','warning');
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
                uiconfirm(app.MTOPlatformMToPv11UIFigure, msg, 'error', 'Icon','warning');
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
                    uiconfirm(app.MTOPlatformMToPv11UIFigure, msg, 'error', 'Icon','warning');
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
                    uiconfirm(app.MTOPlatformMToPv11UIFigure, msg, 'error', 'Icon','warning');
                    result = false;
                    return;
                end
                for algo = 1:length(algorithms)
                    % check algo name
                    if ~strcmp(data_selected(i).NodeData.Algorithms(algo).Name, algorithms(algo).Name)
                        msg = 'The data''s algorithms not equal';
                        uiconfirm(app.MTOPlatformMToPv11UIFigure, msg, 'error', 'Icon','warning');
                        result = false;
                        return;
                    end
                    % check algo para length
                    if length(algorithms(algo).Para) ~= length(data_selected(i).NodeData.Algorithms(algo).Para)
                        msg = 'The data''s algorithms not equal';
                        uiconfirm(app.MTOPlatformMToPv11UIFigure, msg, 'error', 'Icon','warning');
                        result = false;
                        return;
                    end
                    for pa = 1:length(algorithms(algo).Para)
                        % check algo para name
                        if ~strcmp(data_selected(i).NodeData.Algorithms(algo).Para{pa}, algorithms(algo).Para{pa})
                            msg = 'The data''s algorithms not equal';
                            uiconfirm(app.MTOPlatformMToPv11UIFigure, msg, 'error', 'Icon','warning');
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
                    uiconfirm(app.MTOPlatformMToPv11UIFigure, msg, 'error', 'Icon','warning');
                    result = false;
                    return;
                end
                for prob = 1:length(problems)
                    % check prob name
                    if ~strcmp(data_selected(i).NodeData.Problems(prob).Name, problems(prob).Name) || ...
                            data_selected(i).NodeData.Problems(prob).T ~= problems(prob).T || ...
                            sum(data_selected(i).NodeData.Problems(prob).M ~= problems(prob).M) || ...
                            sum(data_selected(i).NodeData.Problems(prob).D ~= problems(prob).D) || ...
                            data_selected(i).NodeData.Problems(prob).N ~= problems(prob).N || ...
                            data_selected(i).NodeData.Problems(prob).maxFE ~= problems(prob).maxFE
                    msg = 'The data''s problems not equal';
                    uiconfirm(app.MTOPlatformMToPv11UIFigure, msg, 'error', 'Icon','warning');
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
            figure(app.MTOPlatformMToPv11UIFigure);
            if file_name == 0
                return;
            end
            
            % save data
            save([dir_name, file_name], 'MTOData');
        end
        
        function NewResults = DReduceResults(app, Results, N, M)
            results_num = size(Results(1, 1, 1).CV, 2);
            if results_num <= N
                NewResults = Results;
                return;
            end
            % process CV
            NewResults = [];
            for i = 1:size(Results, 1)
                for j = 1:size(Results, 2)
                    for k = 1:size(Results, 3)
                        NewResults(i,j,k).CV(:,:,:) = app.DReduceResultNum(Results(i,j,k).CV(:,:,:), 2, 3, N);
                        if M == 1
                            NewResults(i,j,k).Obj(:,:,:) = app.DReduceResultNum(Results(i,j,k).Obj(:,:,:), 2, 3, N);
                        else
                            for t = 1:size(Results(i,j,k).CV, 1)
                                NewResults(i,j,k).Obj{t} = app.DReduceResultNum(Results(i,j,k).Obj{t}, 1, 3, N);
                            end
                        end
                    end
                end
            end
        end
        
        function NewResult = DReduceResultNum(app, Result, D, Dim, N)
            Gap = size(Result,D) ./ (N);
            if Dim == 3
                if D == 1
                    NewResult = Result(1:N,:,:);
                elseif D == 2
                    NewResult = Result(:,1:N,:);
                end
            elseif Dim == 4
                if D == 4
                    NewResult = Result(:,:,:,1:N);
                end
            end
            
            idx = 1;
            i = 1;
            while i <= size(Result,D)
                if i >= ((idx) * Gap)
                    if Dim == 3
                        if D == 1
                            NewResult(idx,:,:) = Result(i,:,:);
                        elseif D == 2
                            NewResult(:,idx,:) = Result(:,i,:);
                        end
                    elseif Dim == 4
                        if D == 4
                            NewResult(:,:,:,idx) = Result(:,:,:,i);
                        end
                    end
                    idx = idx + 1;
                else
                    i = i + 1;
                end
                if idx > N
                    break;
                end
            end
            if Dim == 3
                if D == 1
                    NewResult(1,:,:) = Result(1,:,:);
                    NewResult(end,:,:) = Result(end,:,:);
                elseif D == 2
                    NewResult(:,1,:) = Result(:,1,:);
                    NewResult(:,end,:) = Result(:,end,:);
                end
            elseif Dim == 4
                if D == 4
                    NewResult(:,:,:,1) = Result(:,:,:,1);
                    NewResult(:,:,:,end) = Result(:,:,:,end);
                end
            end
            if idx - 1 < N
                for x = idx - 1:N
                    if Dim == 3
                        if D == 1
                            NewResult(x,:,:) = Result(end,:,:);
                        elseif D == 2
                            NewResult(:,x,:) = Result(:,end,:);
                        end
                    elseif Dim == 4
                        if D == 4
                            NewResult(:,:,:,x) = Result(:,:,:,end);
                        end
                    end
                end
            end
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
            % app.TupdateUIAxes();
            app.EloadAlgoProb();
            app.EloadMetric('none');
            app.MTOPlatformTabGroup.SelectedTab = app.ExperimentModuleTab;
        end

        % Value changed function: TTaskTypeDropDown
        function TTaskTypeDropDownValueChanged(app, event)
            app.TloadAlgoProb();
        end

        % Value changed function: TObjectiveTypeDropDown
        function TObjectiveTypeDropDownValueChanged(app, event)
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
                node.NodeData.Name = node.Text;
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
                % update child parameter node
                parameter = node.Parent.NodeData.getParameter();
                for x = 2:2:length(node.Parent.Children)
                    node.Parent.Children(x).Text = parameter{x};
                end
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
                node.NodeData.Name = node.Text;
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
                % update child parameter node
                parameter = node.Parent.NodeData.getParameter();
                for x = 2:2:length(node.Parent.Children)
                    node.Parent.Children(x).Text = parameter{x};
                end
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
            if max(app.TData.Problems(1).M) > 1
                app.TData.Problems(1).Optimum = app.TProblemTree.Children(1).NodeData.getOptimum();
            end
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
            app.TAlgorithmTree.Children(1).NodeData.Result_Num = 50;
            app.TAlgorithmTree.Children(1).NodeData.Save_Dec = 0;
            app.TAlgorithmTree.Children(1).NodeData.reset();
            app.TAlgorithmTree.Children(1).NodeData.run(app.TProblemTree.Children(1).NodeData);
            tmp = app.TAlgorithmTree.Children(1).NodeData.getResult(app.TProblemTree.Children(1).NodeData);
            for t = 1:size(tmp, 1)
                for g = 1:size(tmp,2)
                    if max(app.TData.Problems(1).M) > 1
                        app.TData.Results(1,1,1).Obj{t}(g, :, :) = tmp(t, g).Obj(:, :);
                    else
                        app.TData.Results(1,1,1).Obj(t, g, :, :) = tmp(t, g).Obj(:, :);
                    end
                    app.TData.Results(1,1,1).CV(t, g, :) = tmp(t, g).CV;
                end
            end
            best_data = app.TAlgorithmTree.Children(1).NodeData.Best;
            
            app.TupdateUIAxes();
            
            % Output Best Data To Right Text
            app.Toutput(['Algo: ', app.TData.Algorithms(1).Name]);
            app.Toutput(['Prob: ', app.TData.Problems(1).Name]);
            if max(app.TData.Problems(1).M) == 1
                for t = 1:length(best_data)
                    app.Toutput(['T', num2str(t), ' Obj: ', num2str(best_data{t}.Obj, '%.2e'), ...
                        ' CV: ', num2str(best_data{t}.CV, '%.2e')]);
                end
            else
                result = IGD(app.TData);
                for t = 1:size(result.TableData, 1)
                    app.Toutput(['T', num2str(t), ' IGD: ', num2str(result.TableData(t, 1, 1), '%.2e')]);
                end
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

        % Value changed function: EObjectiveTypeDropDown
        function EObjectiveTypeDropDownValueChanged(app, event)
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
                uiconfirm(app.MTOPlatformMToPv11UIFigure, msg, 'error', 'Icon','warning');
                app.EstartEnable(true);
                return;
            end
            if prob_num == 0
                msg = 'Please select the Problem first';
                uiconfirm(app.MTOPlatformMToPv11UIFigure, msg, 'error', 'Icon','warning');
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
                if max(MTOData.Problems(prob).M) > 1
                    MTOData.Problems(prob).Optimum = app.EProblemsTree.Children(prob).NodeData.getOptimum();
                end
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
            app.EloadMetric('none');
            app.ETableReps = zeros(prob_num, algo_num);
            app.EupdateTableReps();
            app.EresetTable({MTOData.Problems.Name}, {MTOData.Algorithms.Name});
            app.EresetTableAlgorithmDropDown({MTOData.Algorithms.Name});
            % cla(app.EConvergenceTrendUIAxes, 'reset');

            % main experiment loop
            tStart = tic;
            Results = [];
            % Run
            for prob = 1:prob_num
                for algo = 1:algo_num
                    % check pause and stop
                    algo_obj = app.EAlgorithmsTree.Children(algo).NodeData;
                    algo_obj.Result_Num = app.EResultsNumEditField.Value;
                    algo_obj.Save_Dec = app.ESaveDecDropDown.Value;
                    prob_obj = app.EProblemsTree.Children(prob).NodeData;
                    app.EcheckPauseStopStatus();
                    if app.EParallelDropDown.Value == 1
                        par_tool = Par(MTOData.Reps);
                        parfor rep = 1:MTOData.Reps
                            Par.tic
                            algo_obj.reset();
                            algo_obj.run(prob_obj);
                            tmp = algo_obj.getResult(prob_obj);
                            for t = 1:size(tmp, 1)
                                for g = 1:size(tmp,2)
                                    if max(prob_obj.M) > 1
                                        Results(prob, algo, rep).Obj{t}(g, :, :) = tmp(t, g).Obj;
                                        if isfield(tmp, 'Dec')
                                            Results(prob, algo, rep).Dec(t, g, :, :) = tmp(t, g).Dec;
                                        end
                                    else
                                        Results(prob, algo, rep).Obj(t, g, :) = tmp(t, g).Obj;
                                        if isfield(tmp, 'Dec')
                                            Results(prob, algo, rep).Dec(t, g, :) = tmp(t, g).Dec;
                                        end
                                    end
                                    Results(prob, algo, rep).CV(t, g, :) = tmp(t, g).CV;
                                end
                            end
                            par_tool(rep) = Par.toc;
                        end
                        MTOData.RunTimes(prob, algo, :) = [par_tool.ItStop] - [par_tool.ItStart];
                    else
                        t_temp = [];
                        for rep = 1:MTOData.Reps
                            tstart = tic;
                            algo_obj.reset();
                            algo_obj.run(prob_obj);
                            tmp = algo_obj.getResult(prob_obj);
                            for t = 1:size(tmp, 1)
                                for g = 1:size(tmp,2)
                                    if max(prob_obj.M) > 1
                                        Results(prob, algo, rep).Obj{t}(g, :, :) = tmp(t, g).Obj;
                                        if isfield(tmp, 'Dec')
                                            Results(prob, algo, rep).Dec(t, g, :, :) = tmp(t, g).Dec;
                                        end
                                    else
                                        Results(prob, algo, rep).Obj(t, g, :) = tmp(t, g).Obj;
                                        if isfield(tmp, 'Dec')
                                            Results(prob, algo, rep).Dec(t, g, :) = tmp(t, g).Dec;
                                        end
                                    end
                                    Results(prob, algo, rep).CV(t, g, :) = tmp(t, g).CV;
                                end
                            end
                            t_temp(rep) = toc(tstart);
                            
                            app.ETableReps(prob, algo) = rep;
                            app.EupdateTableReps();
                        end
                        MTOData.RunTimes(prob, algo, :) = t_temp;
                    end
                    app.ETableReps(prob, algo) = MTOData.Reps;
                    app.EupdateTableReps();
                    app.EcheckPauseStopStatus();
                end
                
                % save temporary data
                MTOData.Results = MakeGenEqual(Results);
                MTOData.Problems = problems_temp(1:prob);
                save('MTOData_Temp', 'MTOData');
                app.EData = MTOData;
            end
            %             save('MTOData_Temp', 'MTOData');
            
            m = [MTOData.Problems.M];
            if all(m==1)
                app.EloadMetric('Single-objective')
            elseif all(m>1)
                app.EloadMetric('Multi-objective')
            else
                app.EloadMetric({'Single-objective', 'Multi-objective'})
            end
            
            tEnd = toc(tStart);
            msg = ['All Use Time: ', char(duration([0, 0, tEnd]))];
            uiconfirm(app.MTOPlatformMToPv11UIFigure, msg, 'success', 'Icon', 'success');
            
            app.EstartEnable(true);
            app.EreloadTableData();
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
                uiconfirm(app.MTOPlatformMToPv11UIFigure, msg, 'error', 'Icon','warning');
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
                node.NodeData.Name = node.Text;
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
                % update child parameter node
                parameter = node.Parent.NodeData.getParameter();
                for x = 2:2:length(node.Parent.Children)
                    node.Parent.Children(x).Text = parameter{x};
                end
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
                uiconfirm(app.MTOPlatformMToPv11UIFigure, msg, 'error', 'Icon','warning');
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
                node.NodeData.Name = node.Text;
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
                % update child parameter node
                parameter = node.Parent.NodeData.getParameter();
                for x = 2:2:length(node.Parent.Children)
                    node.Parent.Children(x).Text = parameter{x};
                end
            end
        end

        % Button pushed function: ESaveDataButton
        function ESaveDataButtonPushed(app, event)
            % save data to folder
            
            % check data
            if isempty(app.EData)
                msg = 'Please run experiment first';
                uiconfirm(app.MTOPlatformMToPv11UIFigure, msg, 'error', 'Icon','warning');
                return;
            end
            
            % check selected file name
            [file_name, dir_name] = uiputfile('MTOData.mat');
            figure(app.MTOPlatformMToPv11UIFigure);
            if file_name == 0
                return;
            end
            
            % save data
            MTOData = app.EData;
            save([dir_name, file_name], 'MTOData');
        end

        % Value changed function: EDataTypeDropDown
        function EDataTypeDropDownValueChanged(app, event)
            app.EreloadTableData();
        end

        % Value changed function: EDataFormatEditField
        function EDataFormatEditFieldValueChanged(app, event)
            app.EupdateTableData();
            app.EupdateTableTest();
        end

        % Value changed function: EShowTypeDropDown
        function EShowTypeDropDownValueChanged(app, event)
            app.EresetFormat();
            app.EupdateTableData();
            app.EupdateTableTest();
        end

        % Value changed function: ETestTypeDropDown
        function ETestTypeDropDownValueChanged(app, event)
            app.EupdateTableTest();
        end

        % Value changed function: EAlgorithmDropDown
        function EAlgorithmDropDownValueChanged(app, event)
            app.EupdateTableTest();
        end

        % Value changed function: EHighlightTypeDropDown
        function EHighlightTypeDropDownValueChanged(app, event)
            app.EupdateTableHighlight();
        end

        % Button pushed function: ELoadDataButton
        function ELoadDataButtonPushed(app, event)
            % load data from file
            
            % select mat file
            [file_name, pathname] = uigetfile('*.mat', 'Select Data', './');
            figure(app.MTOPlatformMToPv11UIFigure);
            
            % check selected ile_name
            if file_name == 0
                return;
            end
            
            % load data to app's parameter
            load([pathname, file_name], 'MTOData');
            app.EData = MTOData;
            m = [app.EData.Problems.M];
            if all(m==1)
                app.EloadMetric('Single-objective')
            elseif all(m>1)
                app.EloadMetric('Multi-objective')
            else
                app.EloadMetric({'Single-objective', 'Multi-objective'})
            end
            app.ETableReps = app.EData.Reps * ones([length(app.EData.Problems), length(app.EData.Algorithms)]);
            app.EresetTableAlgorithmDropDown({app.EData.Algorithms.Name});
            app.EreloadTableData();
        end

        % Button pushed function: ESaveTableButton
        function ESaveTableButtonPushed(app, event)
            % save table
            
            % check selected file name
            filter = {'*.tex'; '*.xlsx';'*.csv';};
            [file_name, dir_name] = uiputfile(filter);
            % figure(app.MTOPlatformMToPv11UIFigure);
            if file_name == 0
                return;
            end
            if contains(file_name, 'tex')
                hl = zeros(size(app.EUITable.Data));
                if ~strcmp(app.EHighlightTypeDropDown.Value, 'None')
                    for row_i = 1:size(app.ETableData, 1)
                        if ~(sum(isnan(app.ETableData(row_i, :))) == size(app.ETableData, 2))
                            temp_data = app.ETableData(row_i, :);
                            if app.EMetricMin
                                best_data = min(temp_data);
                            else
                                best_data = max(temp_data);
                            end
                            temp_idx = temp_data == best_data;
                            x = 1:length(temp_idx);
                            x = x(temp_idx);
                            for xx = 1:length(x)
                                hl(row_i, x(xx)) = 1;
                            end
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
            figure(app.MTOPlatformMToPv11UIFigure);
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
                uiconfirm(app.MTOPlatformMToPv11UIFigure, msg, 'error', 'Icon','warning');
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
                uiconfirm(app.MTOPlatformMToPv11UIFigure, msg, 'error', 'Icon','warning');
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
                    uiconfirm(app.MTOPlatformMToPv11UIFigure, msg, 'error', 'Icon','warning');
                    continue;
                end
                for rep = 1:data_selected(i).NodeData.Reps
                    MTOData.Reps = 1;
                    MTOData.Algorithms = data_selected(i).NodeData.Algorithms;
                    MTOData.Problems = data_selected(i).NodeData.Problems;
                    MTOData.Results(1:length(MTOData.Problems),1:length(MTOData.Algorithms),1) = data_selected(i).NodeData.Results(:,:,rep);
                    MTOData.RunTimes(1:length(MTOData.Problems),1:length(MTOData.Algorithms),1) = data_selected(i).NodeData.RunTimes(:,:,rep);
                    if isfield(data_selected(i).NodeData, 'Metrics')
                        del_metric_idx = [];
                        MTOData.Metrics = data_selected(i).NodeData.Metrics;
                        for m = 1:length(MTOData.Metrics)
                            if (size(MTOData.Metrics(m).Result.TableData,3) == 1 && rep > 1) || isempty(MTOData.Metrics(m).Result.TableData)
                                del_metric_idx = [del_metric_idx, m];
                                continue;
                            end
                            MTOData.Metrics(m).Result.TableData = MTOData.Metrics(m).Result.TableData(:,:,rep);
                            if isfield(MTOData.Metrics(m).Result, 'ConvergeData')
                                MTOData.Metrics(m).Result.ConvergeData.X = MTOData.Metrics(m).Result.ConvergeData.X(:,:,rep,:);
                                MTOData.Metrics(m).Result.ConvergeData.Y = MTOData.Metrics(m).Result.ConvergeData.Y(:,:,rep,:);
                            end
                            if isfield(MTOData.Metrics(m).Result, 'ParetoData')
                                MTOData.Metrics(m).Result.ParetoData.Obj = MTOData.Metrics(m).Result.ParetoData.Obj(:,:,rep);
                            end
                        end
                        MTOData.Metrics(del_metric_idx) = [];
                    end
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
                    uiconfirm(app.MTOPlatformMToPv11UIFigure, msg, 'error', 'Icon','warning');
                    continue;
                end
                for algo = 1:length(data_selected(i).NodeData.Algorithms)
                    MTOData.Reps = data_selected(i).NodeData.Reps;
                    MTOData.Algorithms(1) = data_selected(i).NodeData.Algorithms(algo);
                    MTOData.Problems = data_selected(i).NodeData.Problems;
                    MTOData.Results(1:length(MTOData.Problems),1,1:MTOData.Reps) = data_selected(i).NodeData.Results(:,algo,:);
                    MTOData.RunTimes(1:length(MTOData.Problems),1,1:MTOData.Reps) = data_selected(i).NodeData.RunTimes(:,algo,:);
                    if isfield(data_selected(i).NodeData, 'Metrics')
                        del_metric_idx = [];
                        MTOData.Metrics = data_selected(i).NodeData.Metrics;
                        for m = 1:length(MTOData.Metrics)
                            if isempty(MTOData.Metrics(m).Result.TableData)
                                del_metric_idx = [del_metric_idx, m];
                                continue;
                            end
                            MTOData.Metrics(m).Result.ColumnName = MTOData.Metrics(m).Result.ColumnName(algo);
                            MTOData.Metrics(m).Result.TableData = MTOData.Metrics(m).Result.TableData(:,algo,:);
                            if isfield(MTOData.Metrics(m).Result, 'ConvergeData')
                                MTOData.Metrics(m).Result.ConvergeData.X = MTOData.Metrics(m).Result.ConvergeData.X(:,algo,:,:);
                                MTOData.Metrics(m).Result.ConvergeData.Y = MTOData.Metrics(m).Result.ConvergeData.Y(:,algo,:,:);
                            end
                            if isfield(MTOData.Metrics(m).Result, 'ParetoData')
                                MTOData.Metrics(m).Result.ParetoData.Obj = MTOData.Metrics(m).Result.ParetoData.Obj(:,algo,:);
                            end
                        end
                        MTOData.Metrics(del_metric_idx) = [];
                    end
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
                    uiconfirm(app.MTOPlatformMToPv11UIFigure, msg, 'error', 'Icon','warning');
                    continue;
                end
                task = [data_selected(i).NodeData.Problems.T];
                for prob = 1:length(data_selected(i).NodeData.Problems)
                    MTOData.Reps = data_selected(i).NodeData.Reps;
                    MTOData.Algorithms = data_selected(i).NodeData.Algorithms;
                    MTOData.Problems(1) = data_selected(i).NodeData.Problems(prob);
                    MTOData.Results(1,1:length(MTOData.Algorithms),1:MTOData.Reps) = data_selected(i).NodeData.Results(prob,:,:);
                    MTOData.RunTimes(1,1:length(MTOData.Algorithms),1:MTOData.Reps) = data_selected(i).NodeData.RunTimes(prob,:,:);
                    if isfield(data_selected(i).NodeData, 'Metrics')
                        del_metric_idx = [];
                        MTOData.Metrics = data_selected(i).NodeData.Metrics;
                        for m = 1:length(MTOData.Metrics)
                            if isempty(MTOData.Metrics(m).Result.TableData)
                                del_metric_idx = [del_metric_idx, m];
                                continue;
                            end
                            if length(MTOData.Metrics(m).Result.RowName) == length(data_selected(i).NodeData.Problems)
                                idx = prob;
                                idx2 = prob;
                            elseif length(MTOData.Metrics(m).Result.RowName) == sum(task)
                                idx = sum(task(1:prob-1))+1;
                                idx2 = idx+task(prob)-1;
                            else
                                return;
                            end
                            MTOData.Metrics(m).Result.RowName = MTOData.Metrics(m).Result.RowName(idx:idx2);
                            MTOData.Metrics(m).Result.TableData = MTOData.Metrics(m).Result.TableData(idx:idx2,:,:);
                            if isfield(MTOData.Metrics(m).Result, 'ConvergeData')
                                MTOData.Metrics(m).Result.ConvergeData.X = MTOData.Metrics(m).Result.ConvergeData.X(idx:idx2,:,:,:);
                                MTOData.Metrics(m).Result.ConvergeData.Y = MTOData.Metrics(m).Result.ConvergeData.Y(idx:idx2,:,:,:);
                            end
                            if isfield(MTOData.Metrics(m).Result, 'ParetoData')
                                MTOData.Metrics(m).Result.ParetoData.Optimum = MTOData.Metrics(m).Result.ParetoData.Optimum(idx:idx2);
                                MTOData.Metrics(m).Result.ParetoData.Obj = MTOData.Metrics(m).Result.ParetoData.Obj(idx:idx2,:,:);
                            end
                        end
                        MTOData.Metrics(del_metric_idx) = [];
                    end
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
            % merge results
            results_num = [];
            for i = 1:length(data_selected)
                results_num(i) = size(data_selected(i).NodeData.Results(1, 1, 1).CV, 2);
            end
            min_results_num = min(results_num);
            M =  max([data_selected(i).NodeData.Problems.M]);
            for i = 1:length(data_selected)
                results_temp = app.DReduceResults(data_selected(i).NodeData.Results, min_results_num, M);
                MTOData.Results(1:length(MTOData.Problems),1:length(MTOData.Algorithms),MTOData.Reps+1:MTOData.Reps+data_selected(i).NodeData.Reps) = ...
                    results_temp(:,:,:);
                MTOData.RunTimes(1:length(MTOData.Problems),1:length(MTOData.Algorithms),MTOData.Reps+1:MTOData.Reps+data_selected(i).NodeData.Reps) = ...
                    data_selected(i).NodeData.RunTimes(:,:,:);
                MTOData.Reps = MTOData.Reps + data_selected(i).NodeData.Reps;
            end
            % merge metric
            if isfield(data_selected(1).NodeData,'Metrics')
                metric_name = {data_selected(1).NodeData.Metrics.Name};
            else
                metric_name = {};
            end
            for i = 2:length(data_selected)
                if isfield(data_selected(i).NodeData,'Metrics')
                    metric_name = intersect(metric_name, {data_selected(i).NodeData.Metrics.Name});
                else
                    metric_name = intersect(metric_name, {});
                end
            end
            del_metric_idx = [];
            for i = 1:length(metric_name)
                flag = true;
                idx = find(strcmp({data_selected(1).NodeData.Metrics.Name}, metric_name{i}));
                MTOData.Metrics(i).Name = metric_name{i};
                MTOData.Metrics(i).Result.Metric = data_selected(1).NodeData.Metrics(idx).Result.Metric;
                MTOData.Metrics(i).Result.RowName = data_selected(1).NodeData.Metrics(idx).Result.RowName;
                MTOData.Metrics(i).Result.ColumnName = data_selected(1).NodeData.Metrics(idx).Result.ColumnName;
                reps = 0;
                for j = 1:length(data_selected)
                    idx = find(strcmp({data_selected(j).NodeData.Metrics.Name}, metric_name{i}));
                    if size(data_selected(j).NodeData.Metrics(idx).Result.TableData,3) == 1 && data_selected(j).NodeData.Reps > 1
                        del_metric_idx = [del_metric_idx, i];
                        flag = false;
                        break;
                    end
                    MTOData.Metrics(i).Result.TableData(1:length(MTOData.Metrics(i).Result.RowName),...
                        1:length(MTOData.Metrics(i).Result.ColumnName),...
                        reps+1:reps+data_selected(j).NodeData.Reps) = ...
                        data_selected(j).NodeData.Metrics(idx).Result.TableData;
                    reps = reps + data_selected(j).NodeData.Reps;
                end
                if ~flag
                    continue;
                end
                idx = find(strcmp({data_selected(1).NodeData.Metrics.Name}, metric_name{i}));
                if isfield(data_selected(1).NodeData.Metrics(idx).Result, 'ConvergeData')
                    reps = 0;
                    for j = 1:length(data_selected)
                        idx = find(strcmp({data_selected(j).NodeData.Metrics.Name}, metric_name{i}));
                        temp_x = app.DReduceResultNum(data_selected(j).NodeData.Metrics(idx).Result.ConvergeData.X,4,4,min_results_num);
                        temp_y = app.DReduceResultNum(data_selected(j).NodeData.Metrics(idx).Result.ConvergeData.Y,4,4,min_results_num);
                        MTOData.Metrics(i).Result.ConvergeData.X(1:length(MTOData.Metrics(i).Result.RowName),...
                            1:length(MTOData.Metrics(i).Result.ColumnName),...
                            reps+1:reps+data_selected(j).NodeData.Reps,1:size(temp_x,4)) = ...
                            temp_x(:,:,:,:);
                        MTOData.Metrics(i).Result.ConvergeData.Y(1:length(MTOData.Metrics(i).Result.RowName),...
                            1:length(MTOData.Metrics(i).Result.ColumnName),...
                            reps+1:reps+data_selected(j).NodeData.Reps,1:size(temp_y,4)) = ...
                            temp_y(:,:,:,:);
                        reps = reps + data_selected(j).NodeData.Reps;
                    end
                end
                idx = find(strcmp({data_selected(1).NodeData.Metrics.Name}, metric_name{i}));
                if isfield(data_selected(1).NodeData.Metrics(idx).Result, 'ParetoData')
                    idx = find(strcmp({data_selected(1).NodeData.Metrics.Name}, metric_name{i}));
                    MTOData.Metrics(i).Result.ParetoData.Optimum = data_selected(1).NodeData.Metrics(idx).Result.ParetoData.Optimum;
                    reps = 0;
                    for j = 1:length(data_selected)
                        idx = find(strcmp({data_selected(j).NodeData.Metrics.Name}, metric_name{i}));
                        MTOData.Metrics(i).Result.ParetoData.Obj(1:length(MTOData.Metrics(i).Result.RowName),...
                            1:length(MTOData.Metrics(i).Result.ColumnName),...
                            reps+1:reps+data_selected(j).NodeData.Reps) = ...
                            data_selected(j).NodeData.Metrics(idx).Result.ParetoData.Obj;
                        reps = reps + data_selected(j).NodeData.Reps;
                    end
                end
            end
            if isfield(MTOData,'Metrics')
                MTOData.Metrics(del_metric_idx) = [];
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
            % merge results
            results_num = [];
            for i = 1:length(data_selected)
                results_num(i) = size(data_selected(i).NodeData.Results(1, 1, 1).CV, 2);
            end
            min_results_num = min(results_num);
            M =  max([data_selected(i).NodeData.Problems.M]);
            for i = 1:length(data_selected)
                results_temp = app.DReduceResults(data_selected(i).NodeData.Results, min_results_num, M);
                MTOData.Algorithms(idx+1:idx+length(data_selected(i).NodeData.Algorithms)) = ...
                    data_selected(i).NodeData.Algorithms;
                MTOData.Results(1:length(MTOData.Problems),idx+1:idx+length(data_selected(i).NodeData.Algorithms),1:MTOData.Reps) = ...
                    results_temp(:,:,:);
                MTOData.RunTimes(1:length(MTOData.Problems),idx+1:idx+length(data_selected(i).NodeData.Algorithms),1:MTOData.Reps) = ...
                    data_selected(i).NodeData.RunTimes(:,:,:);
                idx = idx + length(data_selected(i).NodeData.Algorithms);
            end
            % merge metric
            if isfield(data_selected(1).NodeData,'Metrics')
                metric_name = {data_selected(1).NodeData.Metrics.Name};
            else
                metric_name = {};
            end
            for i = 2:length(data_selected)
                if isfield(data_selected(i).NodeData,'Metrics')
                    metric_name = intersect(metric_name, {data_selected(i).NodeData.Metrics.Name});
                else
                    metric_name = intersect(metric_name, {});
                end
            end
            del_metric_idx = [];
            for i = 1:length(metric_name)
                flag = true;
                idx = find(strcmp({data_selected(1).NodeData.Metrics.Name}, metric_name{i}));
                MTOData.Metrics(i).Name = metric_name{i};
                MTOData.Metrics(i).Result.Metric = data_selected(1).NodeData.Metrics(idx).Result.Metric;
                MTOData.Metrics(i).Result.RowName = data_selected(1).NodeData.Metrics(idx).Result.RowName;
                algo = 0;
                for j = 1:length(data_selected)
                    idx = find(strcmp({data_selected(j).NodeData.Metrics.Name}, metric_name{i}));
                    if size(data_selected(j).NodeData.Metrics(idx).Result.TableData,3) == 1 && data_selected(j).NodeData.Reps > 1
                        del_metric_idx = [del_metric_idx, i];
                        flag = false;
                        break;
                    end
                    idx = find(strcmp({data_selected(j).NodeData.Metrics.Name}, metric_name{i}));
                    MTOData.Metrics(i).Result.ColumnName(algo+1:algo+length(data_selected(j).NodeData.Metrics(idx).Result.ColumnName)) = ...
                        data_selected(j).NodeData.Metrics(idx).Result.ColumnName;
                    MTOData.Metrics(i).Result.TableData(1:length(MTOData.Metrics(i).Result.RowName),...
                        algo+1:algo+length(data_selected(j).NodeData.Metrics(idx).Result.ColumnName),...
                        1:MTOData.Reps) = ...
                        data_selected(j).NodeData.Metrics(idx).Result.TableData;
                    algo = algo + length(data_selected(j).NodeData.Metrics(idx).Result.ColumnName);
                end
                if ~flag
                    continue;
                end
                idx = find(strcmp({data_selected(1).NodeData.Metrics.Name}, metric_name{i}));
                if isfield(data_selected(1).NodeData.Metrics(idx).Result, 'ConvergeData')
                    algo = 0;
                    for j = 1:length(data_selected)
                        idx = find(strcmp({data_selected(j).NodeData.Metrics.Name}, metric_name{i}));
                        temp_x = app.DReduceResultNum(data_selected(j).NodeData.Metrics(idx).Result.ConvergeData.X,4,4,min_results_num);
                        temp_y = app.DReduceResultNum(data_selected(j).NodeData.Metrics(idx).Result.ConvergeData.Y,4,4,min_results_num);
                        MTOData.Metrics(i).Result.ConvergeData.X(1:length(MTOData.Metrics(i).Result.RowName),...
                            algo+1:algo+length(data_selected(j).NodeData.Metrics(idx).Result.ColumnName),...
                            1:MTOData.Reps,1:size(temp_x,4)) = ...
                            temp_x(:,:,:,:);
                        MTOData.Metrics(i).Result.ConvergeData.Y(1:length(MTOData.Metrics(i).Result.RowName),...
                            algo+1:algo+length(data_selected(j).NodeData.Metrics(idx).Result.ColumnName),...
                            1:MTOData.Reps,1:size(temp_y,4)) = ...
                            temp_y(:,:,:,:);
                        algo = algo + length(data_selected(j).NodeData.Metrics(idx).Result.ColumnName);
                    end
                end
                idx = find(strcmp({data_selected(1).NodeData.Metrics.Name}, metric_name{i}));
                if isfield(data_selected(1).NodeData.Metrics(idx).Result, 'ParetoData')
                    idx = find(strcmp({data_selected(1).NodeData.Metrics.Name}, metric_name{i}));
                    MTOData.Metrics(i).Result.ParetoData.Optimum = data_selected(1).NodeData.Metrics(idx).Result.ParetoData.Optimum;
                    algo = 0;
                    for j = 1:length(data_selected)
                        idx = find(strcmp({data_selected(j).NodeData.Metrics.Name}, metric_name{i}));
                        MTOData.Metrics(i).Result.ParetoData.Obj(1:length(MTOData.Metrics(i).Result.RowName),...
                            algo+1:algo+length(data_selected(j).NodeData.Metrics(idx).Result.ColumnName),...
                            1:MTOData.Reps) = ...
                            data_selected(j).NodeData.Metrics(idx).Result.ParetoData.Obj;
                        algo = algo + length(data_selected(j).NodeData.Metrics(idx).Result.ColumnName);
                    end
                end
            end
            if isfield(MTOData,'Metrics')
                MTOData.Metrics(del_metric_idx) = [];
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
            % merge results
            results_num = [];
            for i = 1:length(data_selected)
                results_num(i) = size(data_selected(i).NodeData.Results(1, 1, 1).CV, 2);
            end
            min_results_num = min(results_num);
            M =  max([data_selected(i).NodeData.Problems.M]);
            for i = 1:length(data_selected)
                results_temp = app.DReduceResults(data_selected(i).NodeData.Results, min_results_num, M);
                MTOData.Problems(idx+1:idx+length(data_selected(i).NodeData.Problems)) = ...
                    data_selected(i).NodeData.Problems;
                MTOData.Results(idx+1:idx+length(data_selected(i).NodeData.Problems),1:length(MTOData.Algorithms),1:MTOData.Reps) = ...
                    results_temp(:,:,:);
                MTOData.RunTimes(idx+1:idx+length(data_selected(i).NodeData.Problems),1:length(MTOData.Algorithms),1:MTOData.Reps) = ...
                    data_selected(i).NodeData.RunTimes(:,:,:);
                idx = idx + length(data_selected(i).NodeData.Problems);
            end
            % merge metric
            if isfield(data_selected(1).NodeData,'Metrics')
                metric_name = {data_selected(1).NodeData.Metrics.Name};
            else
                metric_name = {};
            end
            for i = 2:length(data_selected)
                if isfield(data_selected(i).NodeData,'Metrics')
                    metric_name = intersect(metric_name, {data_selected(i).NodeData.Metrics.Name});
                else
                    metric_name = intersect(metric_name, {});
                end
            end
            del_metric_idx = [];
            for i = 1:length(metric_name)
                flag = true;
                idx = find(strcmp({data_selected(1).NodeData.Metrics.Name}, metric_name{i}));
                MTOData.Metrics(i).Name = metric_name{i};
                MTOData.Metrics(i).Result.Metric = data_selected(1).NodeData.Metrics(idx).Result.Metric;
                MTOData.Metrics(i).Result.ColumnName = data_selected(1).NodeData.Metrics(idx).Result.ColumnName;
                prob = 0;
                for j = 1:length(data_selected)
                    idx = find(strcmp({data_selected(j).NodeData.Metrics.Name}, metric_name{i}));
                    if size(data_selected(j).NodeData.Metrics(idx).Result.TableData,3) == 1 && data_selected(j).NodeData.Reps > 1
                        del_metric_idx = [del_metric_idx, i];
                        flag = false;
                        break;
                    end
                    MTOData.Metrics(i).Result.RowName(prob+1:prob+length(data_selected(j).NodeData.Metrics(idx).Result.RowName)) = ...
                        data_selected(j).NodeData.Metrics(idx).Result.RowName;
                    MTOData.Metrics(i).Result.TableData(prob+1:prob+length(data_selected(j).NodeData.Metrics(idx).Result.RowName),...
                        1:length(MTOData.Metrics(i).Result.ColumnName),...
                        1:MTOData.Reps) = ...
                        data_selected(j).NodeData.Metrics(idx).Result.TableData;
                    prob = prob + length(data_selected(j).NodeData.Metrics(idx).Result.RowName);
                end
                if ~flag
                    continue
                end
                idx = find(strcmp({data_selected(1).NodeData.Metrics.Name}, metric_name{i}));
                if isfield(data_selected(1).NodeData.Metrics(idx).Result, 'ConvergeData')
                    prob = 0;
                    for j = 1:length(data_selected)
                        idx = find(strcmp({data_selected(j).NodeData.Metrics.Name}, metric_name{i}));
                        temp_x = app.DReduceResultNum(data_selected(j).NodeData.Metrics(idx).Result.ConvergeData.X,4,4,min_results_num);
                        temp_y = app.DReduceResultNum(data_selected(j).NodeData.Metrics(idx).Result.ConvergeData.Y,4,4,min_results_num);
                        MTOData.Metrics(i).Result.ConvergeData.X(prob+1:prob+length(data_selected(j).NodeData.Metrics(idx).Result.RowName),...
                            1:length(MTOData.Metrics(i).Result.ColumnName),...
                            1:MTOData.Reps,1:size(temp_x,4)) = ...
                            temp_x(:,:,:,:);
                        MTOData.Metrics(i).Result.ConvergeData.Y(prob+1:prob+length(data_selected(j).NodeData.Metrics(idx).Result.RowName),...
                            1:length(MTOData.Metrics(i).Result.ColumnName),...
                            1:MTOData.Reps,1:size(temp_y,4)) = ...
                            temp_y(:,:,:,:);
                        prob = prob + length(data_selected(j).NodeData.Metrics(idx).Result.RowName);
                    end
                end
                idx = find(strcmp({data_selected(1).NodeData.Metrics.Name}, metric_name{i}));
                if isfield(data_selected(1).NodeData.Metrics(idx).Result, 'ParetoData')
                    prob = 0;
                    for j = 1:length(data_selected)
                        idx = find(strcmp({data_selected(j).NodeData.Metrics.Name}, metric_name{i}));
                        MTOData.Metrics(i).Result.ParetoData.Optimum(prob+1:prob+length(data_selected(j).NodeData.Metrics(idx).Result.RowName)) = ...
                            data_selected(j).NodeData.Metrics(idx).Result.ParetoData.Optimum;
                        MTOData.Metrics(i).Result.ParetoData.Obj(prob+1:prob+length(data_selected(j).NodeData.Metrics(idx).Result.RowName),...
                            1:length(MTOData.Metrics(i).Result.ColumnName),...
                            1:MTOData.Reps) = ...
                            data_selected(j).NodeData.Metrics(idx).Result.ParetoData.Obj;
                        prob = prob + length(data_selected(j).NodeData.Metrics(idx).Result.RowName);
                    end
                end
            end
            if isfield(MTOData,'Metrics')
                MTOData.Metrics(del_metric_idx) = [];
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
                node.NodeData.Name = node.Text;
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

        % Cell selection callback: EUITable
        function EUITableCellSelection(app, event)
            app.ETableSelected = event.Indices;
        end

        % Button pushed function: EConvergeButton
        function EConvergeButtonPushed(app, event)
            if strcmp(app.EDataTypeDropDown.Value, 'Reps') || ...
                    isempty(app.EResultConvergeData) || ...
                    isempty(app.ETableSelected)
            return;
            end
            
            prob_list = unique(app.ETableSelected(:, 1));
            for i = 1:length(prob_list)
                idx = find(app.ETableSelected(:, 1) == prob_list(i));
                algo_list = app.ETableSelected(idx, 2);
                fig = figure();
                ax = axes(fig);
                xlim_min = inf;
                xlim_max = 0;
                
                for j = 1:length(algo_list)
                    if j > length(app.DefaultMarkerList)
                        marker = '';
                    else
                        marker = app.DefaultMarkerList{j};
                    end
                    
                    y = squeeze(mean(app.EResultConvergeData.Y(prob_list(i), algo_list(j), :, :),3))';
                    if strcmp(app.EConvergeTypeDropDown.Value, 'Log')
                        y = log(y);
                    end
                    
                    x = squeeze(mean(app.EResultConvergeData.X(prob_list(i), algo_list(j), :, :),3))';
                    p = plot(ax, x, y, ['-', marker]);
                    p.LineWidth = app.DefaultLineWidth;
                    indices = round(length(y)/min(app.DefaultMarkerNum,length(y)));
                    if length(x) <= 3
                        p.MarkerIndices = indices:indices:length(y);
                    elseif length(y) < app.DefaultMarkerNum
                        p.MarkerIndices = indices+1:indices:length(y)-round(indices/2);
                    else
                        p.MarkerIndices = indices:indices:length(y)-round(indices/2);
                    end
                    p.MarkerSize = app.DefaultMarkerSize;
                    xlim_max = max(xlim_max, x(end));
                    xlim_min = min(xlim_min, x(1));
                    hold(ax, 'on');
                end
                
                if xlim_min ~= xlim_max
                    xlim(ax, [xlim_min, xlim_max]);
                end
                if strcmp(app.EConvergeTypeDropDown.Value, 'Log')
                    ylabel(ax, ['Log - ', strrep(app.EDataTypeDropDown.Value, '_', ' ')]);
                else
                    ylabel(ax, strrep(app.EDataTypeDropDown.Value, '_', ' '));
                end
                xlabel(ax, 'Evaluation');
                legend(ax, strrep(app.EUITable.ColumnName(algo_list), '_', '\_'), 'Location', 'best');
                title(ax, strrep(app.EUITable.RowName(prob_list(i)), '_', '\_'))
                grid(ax, 'on');
            end
        end

        % Button pushed function: EParetoButton
        function EParetoButtonPushed(app, event)
            if strcmp(app.EDataTypeDropDown.Value, 'Reps') || ...
                    isempty(app.EResultParetoData) || ...
                    isempty(app.ETableSelected)
            return;
            end
            
            prob_list = unique(app.ETableSelected(:, 1));
            for i = 1:length(prob_list)
                idx = find(app.ETableSelected(:, 1) == prob_list(i));
                algo_list = app.ETableSelected(idx, 2);
                fig = figure();
                ax = axes(fig);
                
                M = size(app.EResultParetoData.Obj{prob_list(i),1,1}, 2);
                if M == 2
                    if ~isempty(app.EResultParetoData.Optimum)
                        % draw optimum
                        x = squeeze(app.EResultParetoData.Optimum{prob_list(i)}(:, 1));
                        y = squeeze(app.EResultParetoData.Optimum{prob_list(i)}(:, 2));
                        s = scatter(ax, x, y);
                        s.MarkerEdgeColor = 'none';
                        s.MarkerFaceAlpha = 0.65;
                        s.MarkerFaceColor = [.2,.2,.2];
                        s.SizeData = 3;
                        hold(ax, 'on');
                    end
                    
                    % draw each algorithm
                    color_list = colororder;
                    for j = 1:length(algo_list)
                        metric_data = squeeze(app.EResultTableData(prob_list(i), algo_list(j), :));
                        [~, rank] = sort(metric_data);
                        mid_idx = rank(ceil(end / 2));
                        x = squeeze(app.EResultParetoData.Obj{prob_list(i), algo_list(j), mid_idx}(:, 1));
                        y = squeeze(app.EResultParetoData.Obj{prob_list(i), algo_list(j), mid_idx}(:, 2));
                        s = scatter(ax, x, y);
                        s.MarkerEdgeColor = color_list(j,:);
                        s.MarkerFaceAlpha = 0.65;
                        s.MarkerFaceColor = color_list(j,:);
                        s.SizeData = 40;
                        hold(ax, 'on');
                    end
                    
                    xlabel(ax, '$f_1$', 'interpreter', 'latex');
                    ylabel(ax, '$f_2$', 'interpreter', 'latex');
                    
                    if ~isempty(app.EResultParetoData.Optimum)
                        legend(ax, ['Pareto Front'; strrep(app.EUITable.ColumnName(algo_list), '_', '\_')], 'Location', 'best');
                    else
                        legend(ax, strrep(app.EUITable.ColumnName(algo_list), '_', '\_'), 'Location', 'best');
                    end
                    
                    title(ax, strrep(app.EUITable.RowName(prob_list(i)), '_', '\_'))
                    grid(ax, 'on');
                elseif M == 3
                    if ~isempty(app.EResultParetoData.Optimum)
                        % draw optimum
                        x = squeeze(app.EResultParetoData.Optimum{prob_list(i)}(:, 1));
                        y = squeeze(app.EResultParetoData.Optimum{prob_list(i)}(:, 2));
                        z = squeeze(app.EResultParetoData.Optimum{prob_list(i)}(:, 3));
                        s = scatter3(ax, x, y, z);
                        s.MarkerEdgeColor = 'none';
                        s.MarkerFaceAlpha = 0.65;
                        s.MarkerFaceColor = [.5,.5,.5];
                        s.SizeData = 3;
                        hold(ax, 'on');
                    end
                    
                    % draw each algorithm
                    color_list = colororder;
                    for j = 1:length(algo_list)
                        metric_data = squeeze(app.EResultTableData(prob_list(i), algo_list(j), :));
                        [~, rank] = sort(metric_data);
                        mid_idx = rank(ceil(end / 2));
                        x = squeeze(app.EResultParetoData.Obj{prob_list(i), algo_list(j), mid_idx}(:, 1));
                        y = squeeze(app.EResultParetoData.Obj{prob_list(i), algo_list(j), mid_idx}(:, 2));
                        z = squeeze(app.EResultParetoData.Obj{prob_list(i), algo_list(j), mid_idx}(:, 3));
                        s = scatter3(ax, x, y, z);
                        s.MarkerEdgeColor = color_list(j,:);
                        s.MarkerFaceAlpha = 0.65;
                        s.MarkerFaceColor = color_list(j,:);
                        s.SizeData = 40;
                        hold(ax, 'on');
                    end
                    
                    xlabel(ax, '$f_1$', 'interpreter', 'latex');
                    ylabel(ax, '$f_2$', 'interpreter', 'latex');
                    zlabel(ax, '$f_3$', 'interpreter', 'latex');
                    
                    if ~isempty(app.EResultParetoData.Optimum)
                        legend(ax, ['Pareto Front'; strrep(app.EUITable.ColumnName(algo_list), '_', '\_')], 'Location', 'best');
                    else
                        legend(ax, strrep(app.EUITable.ColumnName(algo_list), '_', '\_'), 'Location', 'best');
                    end
                    
                    title(ax, strrep(app.EUITable.RowName(prob_list(i)), '_', '\_'))
                    view(ax,[135 30]);
                    grid(ax, 'on');
                else % M > 3
                    % draw each algorithm
                    color_list = colororder;
                    min_data = []; max_data = [];
                    for j = 1:size(app.EResultTableData, 2)
                        metric_data = squeeze(app.EResultTableData(prob_list(i), j, :));
                        [~, rank] = sort(metric_data);
                        mid_idx = rank(ceil(end / 2));
                        
                        data = app.EResultParetoData.Obj{prob_list(i), j, mid_idx};
                        min_data = min([data; min_data],[],1);
                        max_data = max([data; max_data],[],1);
                    end
                    for j = 1:length(algo_list)
                        metric_data = squeeze(app.EResultTableData(prob_list(i), algo_list(j), :));
                        [~, rank] = sort(metric_data);
                        mid_idx = rank(ceil(end / 2));
                        
                        % Unify
                        data = app.EResultParetoData.Obj{prob_list(i), algo_list(j), mid_idx};
                        data = (data - min_data) ./ (max_data - min_data);
                        for k = 1:size(app.EResultParetoData.Obj{prob_list(i), algo_list(j), mid_idx}, 1)
                            p(j) = plot(ax, data(k,:));
                            p(j).Color = color_list(j,:);
                            p(j).LineWidth = 1.5;
                            hold(ax, 'on');
                        end
                    end
                    
                    ylim([0,1]);
                    xlabel(ax, 'Dimension', 'interpreter', 'latex');
                    ylabel(ax, 'Unified $f$', 'interpreter', 'latex');
                    if length(algo_list) > 1
                        legend(ax, p, strrep(app.EUITable.ColumnName(algo_list), '_', '\_'), 'Location', 'best');
                    end
                    title(ax, strrep(app.EUITable.RowName(prob_list(i)), '_', '\_'))
                    grid(ax, 'on');
                end
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create MTOPlatformMToPv11UIFigure and hide until all components are created
            app.MTOPlatformMToPv11UIFigure = uifigure('Visible', 'off');
            app.MTOPlatformMToPv11UIFigure.Color = [1 1 1];
            app.MTOPlatformMToPv11UIFigure.Position = [100 100 1067 761];
            app.MTOPlatformMToPv11UIFigure.Name = 'MTO-Platform (MToP) v1.2';

            % Create MTOPlatformGridLayout
            app.MTOPlatformGridLayout = uigridlayout(app.MTOPlatformMToPv11UIFigure);
            app.MTOPlatformGridLayout.ColumnWidth = {'1x'};
            app.MTOPlatformGridLayout.RowHeight = {'1x'};
            app.MTOPlatformGridLayout.ColumnSpacing = 5;
            app.MTOPlatformGridLayout.RowSpacing = 5;
            app.MTOPlatformGridLayout.Padding = [0 0 0 0];
            app.MTOPlatformGridLayout.BackgroundColor = [1 1 1];

            % Create MTOPlatformTabGroup
            app.MTOPlatformTabGroup = uitabgroup(app.MTOPlatformGridLayout);
            app.MTOPlatformTabGroup.Layout.Row = 1;
            app.MTOPlatformTabGroup.Layout.Column = 1;

            % Create TestModuleTab
            app.TestModuleTab = uitab(app.MTOPlatformTabGroup);
            app.TestModuleTab.Title = 'Test Module';
            app.TestModuleTab.BackgroundColor = [1 1 1];

            % Create TestGridLayout
            app.TestGridLayout = uigridlayout(app.TestModuleTab);
            app.TestGridLayout.ColumnWidth = {160, '3x', 230};
            app.TestGridLayout.RowHeight = {'1x'};
            app.TestGridLayout.BackgroundColor = [1 1 1];

            % Create TPanel1
            app.TPanel1 = uipanel(app.TestGridLayout);
            app.TPanel1.BorderType = 'none';
            app.TPanel1.BackgroundColor = [1 1 1];
            app.TPanel1.Layout.Row = 1;
            app.TPanel1.Layout.Column = 1;

            % Create TP1GridLayout
            app.TP1GridLayout = uigridlayout(app.TPanel1);
            app.TP1GridLayout.ColumnWidth = {'fit', '1x'};
            app.TP1GridLayout.RowHeight = {'fit', 'fit', 'fit', 'fit', '1x', 'fit', '1x'};
            app.TP1GridLayout.ColumnSpacing = 5;
            app.TP1GridLayout.RowSpacing = 7;
            app.TP1GridLayout.Padding = [0 0 0 0];
            app.TP1GridLayout.BackgroundColor = [1 1 1];

            % Create AlgorithmDropDownLabel
            app.AlgorithmDropDownLabel = uilabel(app.TP1GridLayout);
            app.AlgorithmDropDownLabel.FontWeight = 'bold';
            app.AlgorithmDropDownLabel.Layout.Row = 4;
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
            app.TAlgorithmDropDown.Layout.Row = 4;
            app.TAlgorithmDropDown.Layout.Column = 2;
            app.TAlgorithmDropDown.Value = {};

            % Create TAlgorithmTree
            app.TAlgorithmTree = uitree(app.TP1GridLayout);
            app.TAlgorithmTree.Multiselect = 'on';
            app.TAlgorithmTree.NodeTextChangedFcn = createCallbackFcn(app, @TAlgorithmTreeNodeTextChanged, true);
            app.TAlgorithmTree.Editable = 'on';
            app.TAlgorithmTree.Layout.Row = 5;
            app.TAlgorithmTree.Layout.Column = [1 2];

            % Create TProblemTree
            app.TProblemTree = uitree(app.TP1GridLayout);
            app.TProblemTree.Multiselect = 'on';
            app.TProblemTree.NodeTextChangedFcn = createCallbackFcn(app, @TProblemTreeNodeTextChanged, true);
            app.TProblemTree.Editable = 'on';
            app.TProblemTree.Layout.Row = 7;
            app.TProblemTree.Layout.Column = [1 2];

            % Create TProblemDropDown
            app.TProblemDropDown = uidropdown(app.TP1GridLayout);
            app.TProblemDropDown.Items = {};
            app.TProblemDropDown.DropDownOpeningFcn = createCallbackFcn(app, @TProblemDropDownOpening, true);
            app.TProblemDropDown.ValueChangedFcn = createCallbackFcn(app, @TProblemDropDownValueChanged, true);
            app.TProblemDropDown.Tooltip = {'Select problem'};
            app.TProblemDropDown.FontWeight = 'bold';
            app.TProblemDropDown.BackgroundColor = [1 1 1];
            app.TProblemDropDown.Layout.Row = 6;
            app.TProblemDropDown.Layout.Column = 2;
            app.TProblemDropDown.Value = {};

            % Create ProblemDropDownLabel
            app.ProblemDropDownLabel = uilabel(app.TP1GridLayout);
            app.ProblemDropDownLabel.FontWeight = 'bold';
            app.ProblemDropDownLabel.Layout.Row = 6;
            app.ProblemDropDownLabel.Layout.Column = 1;
            app.ProblemDropDownLabel.Text = 'Problem';

            % Create TTaskTypeDropDown
            app.TTaskTypeDropDown = uidropdown(app.TP1GridLayout);
            app.TTaskTypeDropDown.Items = {'Multi', 'Many', 'Single'};
            app.TTaskTypeDropDown.ItemsData = {'Multi-task', 'Many-task', 'Single-task'};
            app.TTaskTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @TTaskTypeDropDownValueChanged, true);
            app.TTaskTypeDropDown.FontWeight = 'bold';
            app.TTaskTypeDropDown.BackgroundColor = [1 1 1];
            app.TTaskTypeDropDown.Layout.Row = 1;
            app.TTaskTypeDropDown.Layout.Column = 2;
            app.TTaskTypeDropDown.Value = 'Multi-task';

            % Create TaskLabel
            app.TaskLabel = uilabel(app.TP1GridLayout);
            app.TaskLabel.FontWeight = 'bold';
            app.TaskLabel.Tooltip = {'Single-task EA Option'};
            app.TaskLabel.Layout.Row = 1;
            app.TaskLabel.Layout.Column = 1;
            app.TaskLabel.Text = 'Task';

            % Create SpecialLabel_2
            app.SpecialLabel_2 = uilabel(app.TP1GridLayout);
            app.SpecialLabel_2.FontWeight = 'bold';
            app.SpecialLabel_2.Tooltip = {'Single-task EA Option'};
            app.SpecialLabel_2.Layout.Row = 3;
            app.SpecialLabel_2.Layout.Column = 1;
            app.SpecialLabel_2.Text = 'Special';

            % Create TSpecialTypeDropDown
            app.TSpecialTypeDropDown = uidropdown(app.TP1GridLayout);
            app.TSpecialTypeDropDown.Items = {'None', 'Competitive', 'Constrained'};
            app.TSpecialTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @TSpecialTypeDropDownValueChanged, true);
            app.TSpecialTypeDropDown.FontWeight = 'bold';
            app.TSpecialTypeDropDown.BackgroundColor = [1 1 1];
            app.TSpecialTypeDropDown.Layout.Row = 3;
            app.TSpecialTypeDropDown.Layout.Column = 2;
            app.TSpecialTypeDropDown.Value = 'None';

            % Create TObjectiveTypeDropDown
            app.TObjectiveTypeDropDown = uidropdown(app.TP1GridLayout);
            app.TObjectiveTypeDropDown.Items = {'Single', 'Multi'};
            app.TObjectiveTypeDropDown.ItemsData = {'Single-objective', 'Multi-objective'};
            app.TObjectiveTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @TObjectiveTypeDropDownValueChanged, true);
            app.TObjectiveTypeDropDown.FontWeight = 'bold';
            app.TObjectiveTypeDropDown.BackgroundColor = [1 1 1];
            app.TObjectiveTypeDropDown.Layout.Row = 2;
            app.TObjectiveTypeDropDown.Layout.Column = 2;
            app.TObjectiveTypeDropDown.Value = 'Single-objective';

            % Create ObjectiveLabel
            app.ObjectiveLabel = uilabel(app.TP1GridLayout);
            app.ObjectiveLabel.FontWeight = 'bold';
            app.ObjectiveLabel.Tooltip = {'Single-task EA Option'};
            app.ObjectiveLabel.Layout.Row = 2;
            app.ObjectiveLabel.Layout.Column = 1;
            app.ObjectiveLabel.Text = 'Objective';

            % Create TPanel2
            app.TPanel2 = uipanel(app.TestGridLayout);
            app.TPanel2.BorderType = 'none';
            app.TPanel2.BackgroundColor = [1 1 1];
            app.TPanel2.Layout.Row = 1;
            app.TPanel2.Layout.Column = 2;

            % Create TP2GridLayout
            app.TP2GridLayout = uigridlayout(app.TPanel2);
            app.TP2GridLayout.ColumnWidth = {'1x'};
            app.TP2GridLayout.RowHeight = {'fit', '1x', 'fit'};
            app.TP2GridLayout.ColumnSpacing = 5;
            app.TP2GridLayout.RowSpacing = 7;
            app.TP2GridLayout.Padding = [0 0 0 0];
            app.TP2GridLayout.BackgroundColor = [1 1 1];

            % Create TP21GridLayout
            app.TP21GridLayout = uigridlayout(app.TP2GridLayout);
            app.TP21GridLayout.ColumnWidth = {'1x', 'fit', 'fit'};
            app.TP21GridLayout.RowHeight = {'1x'};
            app.TP21GridLayout.ColumnSpacing = 5;
            app.TP21GridLayout.RowSpacing = 7;
            app.TP21GridLayout.Padding = [0 0 0 0];
            app.TP21GridLayout.Layout.Row = 1;
            app.TP21GridLayout.Layout.Column = 1;
            app.TP21GridLayout.BackgroundColor = [1 1 1];

            % Create TShowTypeDropDown
            app.TShowTypeDropDown = uidropdown(app.TP21GridLayout);
            app.TShowTypeDropDown.Items = {'Tasks Figure (1D Unified)', 'Tasks Figure (1D Real)', 'Tasks Figure (2D Unified)', 'Tasks Figure (2D Real)', 'Feasible Region (2D)', 'Convergence', 'Pareto Front'};
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
            app.TSaveButton.BackgroundColor = [1 1 1];
            app.TSaveButton.FontWeight = 'bold';
            app.TSaveButton.Tooltip = {''};
            app.TSaveButton.Layout.Row = 1;
            app.TSaveButton.Layout.Column = 2;
            app.TSaveButton.Text = 'Save Figure';

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
            app.TStartButton.BackgroundColor = [0.7882 1 0.7882];
            app.TStartButton.FontWeight = 'bold';
            app.TStartButton.Tooltip = {''};
            app.TStartButton.Layout.Row = 1;
            app.TStartButton.Layout.Column = 2;
            app.TStartButton.Text = 'Start';

            % Create TResetButton
            app.TResetButton = uibutton(app.TP24GridLayout, 'push');
            app.TResetButton.ButtonPushedFcn = createCallbackFcn(app, @TResetButtonPushed, true);
            app.TResetButton.BusyAction = 'cancel';
            app.TResetButton.BackgroundColor = [1 1 0.7608];
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
            app.TPanel3.BorderType = 'none';
            app.TPanel3.BackgroundColor = [1 1 1];
            app.TPanel3.Layout.Row = 1;
            app.TPanel3.Layout.Column = 3;

            % Create TP3GridLayout
            app.TP3GridLayout = uigridlayout(app.TPanel3);
            app.TP3GridLayout.ColumnWidth = {'1x'};
            app.TP3GridLayout.RowHeight = {'1x', 'fit'};
            app.TP3GridLayout.ColumnSpacing = 5;
            app.TP3GridLayout.RowSpacing = 7;
            app.TP3GridLayout.Padding = [0 0 0 0];
            app.TP3GridLayout.BackgroundColor = [1 1 1];

            % Create TOutputTextArea
            app.TOutputTextArea = uitextarea(app.TP3GridLayout);
            app.TOutputTextArea.Editable = 'off';
            app.TOutputTextArea.WordWrap = 'off';
            app.TOutputTextArea.FontWeight = 'bold';
            app.TOutputTextArea.Layout.Row = 1;
            app.TOutputTextArea.Layout.Column = 1;

            % Create MTOPlatformMToPbyYanchiLiLabel
            app.MTOPlatformMToPbyYanchiLiLabel = uilabel(app.TP3GridLayout);
            app.MTOPlatformMToPbyYanchiLiLabel.HorizontalAlignment = 'center';
            app.MTOPlatformMToPbyYanchiLiLabel.FontWeight = 'bold';
            app.MTOPlatformMToPbyYanchiLiLabel.Layout.Row = 2;
            app.MTOPlatformMToPbyYanchiLiLabel.Layout.Column = 1;
            app.MTOPlatformMToPbyYanchiLiLabel.Text = 'MTO-Platform (MToP) by Yanchi Li';

            % Create ExperimentModuleTab
            app.ExperimentModuleTab = uitab(app.MTOPlatformTabGroup);
            app.ExperimentModuleTab.Title = 'Experiment Module';
            app.ExperimentModuleTab.BackgroundColor = [1 1 1];

            % Create ExperimentsGridLayout
            app.ExperimentsGridLayout = uigridlayout(app.ExperimentModuleTab);
            app.ExperimentsGridLayout.ColumnWidth = {140, 160, '4x'};
            app.ExperimentsGridLayout.RowHeight = {'1x'};
            app.ExperimentsGridLayout.BackgroundColor = [1 1 1];

            % Create EPanel1
            app.EPanel1 = uipanel(app.ExperimentsGridLayout);
            app.EPanel1.ForegroundColor = [1 1 1];
            app.EPanel1.BorderType = 'none';
            app.EPanel1.BackgroundColor = [1 1 1];
            app.EPanel1.Layout.Row = 1;
            app.EPanel1.Layout.Column = 1;

            % Create EP1GridLayout
            app.EP1GridLayout = uigridlayout(app.EPanel1);
            app.EP1GridLayout.ColumnWidth = {'2x', '1x', '1.2x'};
            app.EP1GridLayout.RowHeight = {'fit', 'fit', 'fit', 'fit', 'fit', 'fit', 'fit', '1x', 'fit', '1x'};
            app.EP1GridLayout.ColumnSpacing = 5;
            app.EP1GridLayout.RowSpacing = 7;
            app.EP1GridLayout.Padding = [0 0 0 0];
            app.EP1GridLayout.BackgroundColor = [1 1 1];

            % Create EProblemsAddButton
            app.EProblemsAddButton = uibutton(app.EP1GridLayout, 'push');
            app.EProblemsAddButton.ButtonPushedFcn = createCallbackFcn(app, @EProblemsAddButtonPushed, true);
            app.EProblemsAddButton.VerticalAlignment = 'top';
            app.EProblemsAddButton.BackgroundColor = [1 1 1];
            app.EProblemsAddButton.FontWeight = 'bold';
            app.EProblemsAddButton.Tooltip = {'Add selected problems'};
            app.EProblemsAddButton.Layout.Row = 9;
            app.EProblemsAddButton.Layout.Column = 3;
            app.EProblemsAddButton.Text = 'Add';

            % Create EAlgorithmsAddButton
            app.EAlgorithmsAddButton = uibutton(app.EP1GridLayout, 'push');
            app.EAlgorithmsAddButton.ButtonPushedFcn = createCallbackFcn(app, @EAlgorithmsAddButtonPushed, true);
            app.EAlgorithmsAddButton.VerticalAlignment = 'top';
            app.EAlgorithmsAddButton.BackgroundColor = [1 1 1];
            app.EAlgorithmsAddButton.FontWeight = 'bold';
            app.EAlgorithmsAddButton.Tooltip = {'Add selected algorithms'};
            app.EAlgorithmsAddButton.Layout.Row = 7;
            app.EAlgorithmsAddButton.Layout.Column = 3;
            app.EAlgorithmsAddButton.Text = 'Add';

            % Create EAlgorithmsListBox
            app.EAlgorithmsListBox = uilistbox(app.EP1GridLayout);
            app.EAlgorithmsListBox.Items = {};
            app.EAlgorithmsListBox.Multiselect = 'on';
            app.EAlgorithmsListBox.Layout.Row = 8;
            app.EAlgorithmsListBox.Layout.Column = [1 3];
            app.EAlgorithmsListBox.Value = {};

            % Create AlgorithmsLabel
            app.AlgorithmsLabel = uilabel(app.EP1GridLayout);
            app.AlgorithmsLabel.FontWeight = 'bold';
            app.AlgorithmsLabel.Layout.Row = 7;
            app.AlgorithmsLabel.Layout.Column = [1 2];
            app.AlgorithmsLabel.Text = 'Algorithms';

            % Create EProblemsListBox
            app.EProblemsListBox = uilistbox(app.EP1GridLayout);
            app.EProblemsListBox.Items = {};
            app.EProblemsListBox.Multiselect = 'on';
            app.EProblemsListBox.Layout.Row = 10;
            app.EProblemsListBox.Layout.Column = [1 3];
            app.EProblemsListBox.Value = {};

            % Create ProblemsLabel
            app.ProblemsLabel = uilabel(app.EP1GridLayout);
            app.ProblemsLabel.FontWeight = 'bold';
            app.ProblemsLabel.Layout.Row = 9;
            app.ProblemsLabel.Layout.Column = [1 2];
            app.ProblemsLabel.Text = 'Problems';

            % Create ParallelLabel
            app.ParallelLabel = uilabel(app.EP1GridLayout);
            app.ParallelLabel.FontWeight = 'bold';
            app.ParallelLabel.Layout.Row = 3;
            app.ParallelLabel.Layout.Column = 1;
            app.ParallelLabel.Text = 'Parallel';

            % Create EParallelDropDown
            app.EParallelDropDown = uidropdown(app.EP1GridLayout);
            app.EParallelDropDown.Items = {'Off', 'On'};
            app.EParallelDropDown.ItemsData = [0 1];
            app.EParallelDropDown.FontWeight = 'bold';
            app.EParallelDropDown.BackgroundColor = [1 1 1];
            app.EParallelDropDown.Layout.Row = 3;
            app.EParallelDropDown.Layout.Column = [2 3];
            app.EParallelDropDown.Value = 0;

            % Create TaskLabel_2
            app.TaskLabel_2 = uilabel(app.EP1GridLayout);
            app.TaskLabel_2.FontWeight = 'bold';
            app.TaskLabel_2.Tooltip = {'Single-task EA Option'};
            app.TaskLabel_2.Layout.Row = 4;
            app.TaskLabel_2.Layout.Column = 1;
            app.TaskLabel_2.Text = 'Task';

            % Create ETaskTypeDropDown
            app.ETaskTypeDropDown = uidropdown(app.EP1GridLayout);
            app.ETaskTypeDropDown.Items = {'Multi', 'Many', 'Single'};
            app.ETaskTypeDropDown.ItemsData = {'Multi-task', 'Many-task', 'Single-task'};
            app.ETaskTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @ETaskTypeDropDownValueChanged, true);
            app.ETaskTypeDropDown.FontWeight = 'bold';
            app.ETaskTypeDropDown.BackgroundColor = [1 1 1];
            app.ETaskTypeDropDown.Layout.Row = 4;
            app.ETaskTypeDropDown.Layout.Column = [2 3];
            app.ETaskTypeDropDown.Value = 'Multi-task';

            % Create SpecialLabel
            app.SpecialLabel = uilabel(app.EP1GridLayout);
            app.SpecialLabel.FontWeight = 'bold';
            app.SpecialLabel.Tooltip = {'Single-task EA Option'};
            app.SpecialLabel.Layout.Row = 6;
            app.SpecialLabel.Layout.Column = 1;
            app.SpecialLabel.Text = 'Special';

            % Create ESpecialTypeDropDown
            app.ESpecialTypeDropDown = uidropdown(app.EP1GridLayout);
            app.ESpecialTypeDropDown.Items = {'None', 'Competitive', 'Constrained'};
            app.ESpecialTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @ESpecialTypeDropDownValueChanged, true);
            app.ESpecialTypeDropDown.FontWeight = 'bold';
            app.ESpecialTypeDropDown.BackgroundColor = [1 1 1];
            app.ESpecialTypeDropDown.Layout.Row = 6;
            app.ESpecialTypeDropDown.Layout.Column = [2 3];
            app.ESpecialTypeDropDown.Value = 'None';

            % Create ObjectiveLabel_2
            app.ObjectiveLabel_2 = uilabel(app.EP1GridLayout);
            app.ObjectiveLabel_2.FontWeight = 'bold';
            app.ObjectiveLabel_2.Tooltip = {'Single-task EA Option'};
            app.ObjectiveLabel_2.Layout.Row = 5;
            app.ObjectiveLabel_2.Layout.Column = 1;
            app.ObjectiveLabel_2.Text = 'Objective';

            % Create EObjectiveTypeDropDown
            app.EObjectiveTypeDropDown = uidropdown(app.EP1GridLayout);
            app.EObjectiveTypeDropDown.Items = {'Single', 'Multi'};
            app.EObjectiveTypeDropDown.ItemsData = {'Single-objective', 'Multi-objective'};
            app.EObjectiveTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @EObjectiveTypeDropDownValueChanged, true);
            app.EObjectiveTypeDropDown.FontWeight = 'bold';
            app.EObjectiveTypeDropDown.BackgroundColor = [1 1 1];
            app.EObjectiveTypeDropDown.Layout.Row = 5;
            app.EObjectiveTypeDropDown.Layout.Column = [2 3];
            app.EObjectiveTypeDropDown.Value = 'Single-objective';

            % Create GridLayout5
            app.GridLayout5 = uigridlayout(app.EP1GridLayout);
            app.GridLayout5.ColumnWidth = {'2x', '1.2x'};
            app.GridLayout5.ColumnSpacing = 5;
            app.GridLayout5.RowSpacing = 7;
            app.GridLayout5.Padding = [0 0 0 0];
            app.GridLayout5.Layout.Row = 1;
            app.GridLayout5.Layout.Column = [1 3];
            app.GridLayout5.BackgroundColor = [1 1 1];

            % Create ERepsEditField
            app.ERepsEditField = uieditfield(app.GridLayout5, 'numeric');
            app.ERepsEditField.Limits = [1 Inf];
            app.ERepsEditField.RoundFractionalValues = 'on';
            app.ERepsEditField.ValueDisplayFormat = '%d';
            app.ERepsEditField.HorizontalAlignment = 'center';
            app.ERepsEditField.FontWeight = 'bold';
            app.ERepsEditField.Layout.Row = 1;
            app.ERepsEditField.Layout.Column = 2;
            app.ERepsEditField.Value = 1;

            % Create EResultsNumEditField
            app.EResultsNumEditField = uieditfield(app.GridLayout5, 'numeric');
            app.EResultsNumEditField.Limits = [1 Inf];
            app.EResultsNumEditField.RoundFractionalValues = 'on';
            app.EResultsNumEditField.ValueDisplayFormat = '%d';
            app.EResultsNumEditField.HorizontalAlignment = 'center';
            app.EResultsNumEditField.FontWeight = 'bold';
            app.EResultsNumEditField.Layout.Row = 2;
            app.EResultsNumEditField.Layout.Column = 2;
            app.EResultsNumEditField.Value = 50;

            % Create ERunTimesEditFieldLabel
            app.ERunTimesEditFieldLabel = uilabel(app.GridLayout5);
            app.ERunTimesEditFieldLabel.FontWeight = 'bold';
            app.ERunTimesEditFieldLabel.Layout.Row = 1;
            app.ERunTimesEditFieldLabel.Layout.Column = 1;
            app.ERunTimesEditFieldLabel.Text = 'No. of Runs';

            % Create EResultsNumEditFieldLabel
            app.EResultsNumEditFieldLabel = uilabel(app.GridLayout5);
            app.EResultsNumEditFieldLabel.FontWeight = 'bold';
            app.EResultsNumEditFieldLabel.Layout.Row = 2;
            app.EResultsNumEditFieldLabel.Layout.Column = 1;
            app.EResultsNumEditFieldLabel.Text = 'No. of Results';

            % Create SaveDecLabel
            app.SaveDecLabel = uilabel(app.EP1GridLayout);
            app.SaveDecLabel.FontWeight = 'bold';
            app.SaveDecLabel.Layout.Row = 2;
            app.SaveDecLabel.Layout.Column = 1;
            app.SaveDecLabel.Text = 'Save Dec';

            % Create ESaveDecDropDown
            app.ESaveDecDropDown = uidropdown(app.EP1GridLayout);
            app.ESaveDecDropDown.Items = {'Off', 'On'};
            app.ESaveDecDropDown.ItemsData = [0 1];
            app.ESaveDecDropDown.FontWeight = 'bold';
            app.ESaveDecDropDown.BackgroundColor = [1 1 1];
            app.ESaveDecDropDown.Layout.Row = 2;
            app.ESaveDecDropDown.Layout.Column = [2 3];
            app.ESaveDecDropDown.Value = 0;

            % Create EPanel2
            app.EPanel2 = uipanel(app.ExperimentsGridLayout);
            app.EPanel2.ForegroundColor = [1 1 1];
            app.EPanel2.BorderType = 'none';
            app.EPanel2.BackgroundColor = [1 1 1];
            app.EPanel2.Layout.Row = 1;
            app.EPanel2.Layout.Column = 2;

            % Create EP2GridLayout
            app.EP2GridLayout = uigridlayout(app.EPanel2);
            app.EP2GridLayout.ColumnWidth = {'1x'};
            app.EP2GridLayout.RowHeight = {'fit', 'fit', 'fit', '1x', 'fit', '1x'};
            app.EP2GridLayout.ColumnSpacing = 5;
            app.EP2GridLayout.RowSpacing = 7;
            app.EP2GridLayout.Padding = [0 0 0 0];
            app.EP2GridLayout.BackgroundColor = [1 1 1];

            % Create EAlgorithmsTree
            app.EAlgorithmsTree = uitree(app.EP2GridLayout);
            app.EAlgorithmsTree.Multiselect = 'on';
            app.EAlgorithmsTree.NodeTextChangedFcn = createCallbackFcn(app, @EAlgorithmsTreeNodeTextChanged, true);
            app.EAlgorithmsTree.Editable = 'on';
            app.EAlgorithmsTree.Layout.Row = 4;
            app.EAlgorithmsTree.Layout.Column = 1;

            % Create EProblemsTree
            app.EProblemsTree = uitree(app.EP2GridLayout);
            app.EProblemsTree.Multiselect = 'on';
            app.EProblemsTree.NodeTextChangedFcn = createCallbackFcn(app, @EProblemsTreeNodeTextChanged, true);
            app.EProblemsTree.Editable = 'on';
            app.EProblemsTree.Layout.Row = 6;
            app.EProblemsTree.Layout.Column = 1;

            % Create GridLayout2
            app.GridLayout2 = uigridlayout(app.EP2GridLayout);
            app.GridLayout2.ColumnWidth = {'1x', '1x', '1x'};
            app.GridLayout2.RowHeight = {'1x'};
            app.GridLayout2.ColumnSpacing = 5;
            app.GridLayout2.Padding = [0 0 0 0];
            app.GridLayout2.Layout.Row = 2;
            app.GridLayout2.Layout.Column = 1;
            app.GridLayout2.BackgroundColor = [1 1 1];

            % Create EStartButton
            app.EStartButton = uibutton(app.GridLayout2, 'push');
            app.EStartButton.ButtonPushedFcn = createCallbackFcn(app, @EStartButtonPushed, true);
            app.EStartButton.BusyAction = 'cancel';
            app.EStartButton.BackgroundColor = [0.7882 1 0.7882];
            app.EStartButton.FontWeight = 'bold';
            app.EStartButton.Layout.Row = 1;
            app.EStartButton.Layout.Column = 1;
            app.EStartButton.Text = 'Start';

            % Create EPauseButton
            app.EPauseButton = uibutton(app.GridLayout2, 'push');
            app.EPauseButton.ButtonPushedFcn = createCallbackFcn(app, @EPauseButtonPushed, true);
            app.EPauseButton.BusyAction = 'cancel';
            app.EPauseButton.BackgroundColor = [1 1 0.7608];
            app.EPauseButton.FontWeight = 'bold';
            app.EPauseButton.Enable = 'off';
            app.EPauseButton.Layout.Row = 1;
            app.EPauseButton.Layout.Column = 2;
            app.EPauseButton.Text = 'Pause';

            % Create EStopButton
            app.EStopButton = uibutton(app.GridLayout2, 'push');
            app.EStopButton.ButtonPushedFcn = createCallbackFcn(app, @EStopButtonPushed, true);
            app.EStopButton.BusyAction = 'cancel';
            app.EStopButton.BackgroundColor = [1 0.7294 0.7294];
            app.EStopButton.FontWeight = 'bold';
            app.EStopButton.Enable = 'off';
            app.EStopButton.Layout.Row = 1;
            app.EStopButton.Layout.Column = 3;
            app.EStopButton.Text = 'Stop';

            % Create GridLayout3
            app.GridLayout3 = uigridlayout(app.EP2GridLayout);
            app.GridLayout3.ColumnWidth = {'3x', '1x'};
            app.GridLayout3.RowHeight = {'1x'};
            app.GridLayout3.ColumnSpacing = 5;
            app.GridLayout3.Padding = [0 0 0 0];
            app.GridLayout3.Layout.Row = 3;
            app.GridLayout3.Layout.Column = 1;
            app.GridLayout3.BackgroundColor = [1 1 1];

            % Create ESelectedAlgorithmsLabel
            app.ESelectedAlgorithmsLabel = uilabel(app.GridLayout3);
            app.ESelectedAlgorithmsLabel.FontSize = 11;
            app.ESelectedAlgorithmsLabel.FontWeight = 'bold';
            app.ESelectedAlgorithmsLabel.Layout.Row = 1;
            app.ESelectedAlgorithmsLabel.Layout.Column = 1;
            app.ESelectedAlgorithmsLabel.Text = 'Added Algorithms';

            % Create EAlgorithmsDelButton
            app.EAlgorithmsDelButton = uibutton(app.GridLayout3, 'push');
            app.EAlgorithmsDelButton.ButtonPushedFcn = createCallbackFcn(app, @EAlgorithmsDelButtonPushed, true);
            app.EAlgorithmsDelButton.BackgroundColor = [1 1 1];
            app.EAlgorithmsDelButton.FontWeight = 'bold';
            app.EAlgorithmsDelButton.Tooltip = {'Delete selected algorithms'};
            app.EAlgorithmsDelButton.Layout.Row = 1;
            app.EAlgorithmsDelButton.Layout.Column = 2;
            app.EAlgorithmsDelButton.Text = 'Del';

            % Create GridLayout4
            app.GridLayout4 = uigridlayout(app.EP2GridLayout);
            app.GridLayout4.ColumnWidth = {'3x', '1x'};
            app.GridLayout4.RowHeight = {'1x'};
            app.GridLayout4.ColumnSpacing = 5;
            app.GridLayout4.Padding = [0 0 0 0];
            app.GridLayout4.Layout.Row = 5;
            app.GridLayout4.Layout.Column = 1;
            app.GridLayout4.BackgroundColor = [1 1 1];

            % Create ESelectedProblemsLabel
            app.ESelectedProblemsLabel = uilabel(app.GridLayout4);
            app.ESelectedProblemsLabel.FontSize = 11;
            app.ESelectedProblemsLabel.FontWeight = 'bold';
            app.ESelectedProblemsLabel.Layout.Row = 1;
            app.ESelectedProblemsLabel.Layout.Column = 1;
            app.ESelectedProblemsLabel.Text = 'Added Problems';

            % Create EProblemsDelButton
            app.EProblemsDelButton = uibutton(app.GridLayout4, 'push');
            app.EProblemsDelButton.ButtonPushedFcn = createCallbackFcn(app, @EProblemsDelButtonPushed, true);
            app.EProblemsDelButton.BackgroundColor = [1 1 1];
            app.EProblemsDelButton.FontWeight = 'bold';
            app.EProblemsDelButton.Tooltip = {'Delete selected problems'};
            app.EProblemsDelButton.Layout.Row = 1;
            app.EProblemsDelButton.Layout.Column = 2;
            app.EProblemsDelButton.Text = 'Del';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.EP2GridLayout);
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 5;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Layout.Row = 1;
            app.GridLayout.Layout.Column = 1;
            app.GridLayout.BackgroundColor = [1 1 1];

            % Create ESaveDataButton
            app.ESaveDataButton = uibutton(app.GridLayout, 'push');
            app.ESaveDataButton.ButtonPushedFcn = createCallbackFcn(app, @ESaveDataButtonPushed, true);
            app.ESaveDataButton.BackgroundColor = [1 1 1];
            app.ESaveDataButton.FontWeight = 'bold';
            app.ESaveDataButton.Tooltip = {'Save finished data to mat file'};
            app.ESaveDataButton.Layout.Row = 1;
            app.ESaveDataButton.Layout.Column = 2;
            app.ESaveDataButton.Text = 'Save Data';

            % Create ELoadDataButton
            app.ELoadDataButton = uibutton(app.GridLayout, 'push');
            app.ELoadDataButton.ButtonPushedFcn = createCallbackFcn(app, @ELoadDataButtonPushed, true);
            app.ELoadDataButton.BackgroundColor = [1 1 1];
            app.ELoadDataButton.FontWeight = 'bold';
            app.ELoadDataButton.Tooltip = {'Load MTOData.mat to show detials'};
            app.ELoadDataButton.Layout.Row = 1;
            app.ELoadDataButton.Layout.Column = 1;
            app.ELoadDataButton.Text = 'Load Data';

            % Create EPanel3
            app.EPanel3 = uipanel(app.ExperimentsGridLayout);
            app.EPanel3.ForegroundColor = [1 1 1];
            app.EPanel3.BorderType = 'none';
            app.EPanel3.BackgroundColor = [1 1 1];
            app.EPanel3.Layout.Row = 1;
            app.EPanel3.Layout.Column = 3;

            % Create EP3GridLayout
            app.EP3GridLayout = uigridlayout(app.EPanel3);
            app.EP3GridLayout.ColumnWidth = {'1x'};
            app.EP3GridLayout.RowHeight = {'1x'};
            app.EP3GridLayout.Padding = [0 0 0 0];
            app.EP3GridLayout.BackgroundColor = [1 1 1];

            % Create EP3TGridLayout
            app.EP3TGridLayout = uigridlayout(app.EP3GridLayout);
            app.EP3TGridLayout.ColumnWidth = {'1x'};
            app.EP3TGridLayout.RowHeight = {'fit', '1x'};
            app.EP3TGridLayout.RowSpacing = 0;
            app.EP3TGridLayout.Padding = [0 0 0 0];
            app.EP3TGridLayout.Layout.Row = 1;
            app.EP3TGridLayout.Layout.Column = 1;
            app.EP3TGridLayout.BackgroundColor = [1 1 1];

            % Create EP3T1GridLayout
            app.EP3T1GridLayout = uigridlayout(app.EP3TGridLayout);
            app.EP3T1GridLayout.ColumnWidth = {'1x', '0.8x', '1x', '0.8x', '0.9x', '1x', '1x', '1x', '1x', '1x'};
            app.EP3T1GridLayout.RowHeight = {'fit'};
            app.EP3T1GridLayout.ColumnSpacing = 5;
            app.EP3T1GridLayout.RowSpacing = 7;
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
            app.ETestTypeDropDown.Layout.Column = 8;
            app.ETestTypeDropDown.Value = 'None';

            % Create EAlgorithmDropDown
            app.EAlgorithmDropDown = uidropdown(app.EP3T1GridLayout);
            app.EAlgorithmDropDown.Items = {'Algorithm'};
            app.EAlgorithmDropDown.ValueChangedFcn = createCallbackFcn(app, @EAlgorithmDropDownValueChanged, true);
            app.EAlgorithmDropDown.Tooltip = {'Statistical Analysis main Algorithm (Only for Objective value)'};
            app.EAlgorithmDropDown.FontWeight = 'bold';
            app.EAlgorithmDropDown.BackgroundColor = [1 1 1];
            app.EAlgorithmDropDown.Layout.Row = 1;
            app.EAlgorithmDropDown.Layout.Column = 9;
            app.EAlgorithmDropDown.Value = 'Algorithm';

            % Create EShowTypeDropDown
            app.EShowTypeDropDown = uidropdown(app.EP3T1GridLayout);
            app.EShowTypeDropDown.Items = {'Mean', 'Mean&Std', 'Std', 'Median', 'Best', 'Worst'};
            app.EShowTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @EShowTypeDropDownValueChanged, true);
            app.EShowTypeDropDown.Tooltip = {'Data Type (Only for Objective value)'};
            app.EShowTypeDropDown.FontWeight = 'bold';
            app.EShowTypeDropDown.BackgroundColor = [1 1 1];
            app.EShowTypeDropDown.Layout.Row = 1;
            app.EShowTypeDropDown.Layout.Column = 7;
            app.EShowTypeDropDown.Value = 'Mean';

            % Create EDataTypeDropDown
            app.EDataTypeDropDown = uidropdown(app.EP3T1GridLayout);
            app.EDataTypeDropDown.Items = {'Reps'};
            app.EDataTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @EDataTypeDropDownValueChanged, true);
            app.EDataTypeDropDown.Tooltip = {'Show Type'};
            app.EDataTypeDropDown.FontWeight = 'bold';
            app.EDataTypeDropDown.BackgroundColor = [1 1 1];
            app.EDataTypeDropDown.Layout.Row = 1;
            app.EDataTypeDropDown.Layout.Column = 6;
            app.EDataTypeDropDown.Value = 'Reps';

            % Create EHighlightTypeDropDown
            app.EHighlightTypeDropDown = uidropdown(app.EP3T1GridLayout);
            app.EHighlightTypeDropDown.Items = {'None', 'Best', 'Best&Worst'};
            app.EHighlightTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @EHighlightTypeDropDownValueChanged, true);
            app.EHighlightTypeDropDown.Tooltip = {'Highlight type'};
            app.EHighlightTypeDropDown.FontWeight = 'bold';
            app.EHighlightTypeDropDown.BackgroundColor = [1 1 1];
            app.EHighlightTypeDropDown.Layout.Row = 1;
            app.EHighlightTypeDropDown.Layout.Column = 10;
            app.EHighlightTypeDropDown.Value = 'Best&Worst';

            % Create ESaveTableButton
            app.ESaveTableButton = uibutton(app.EP3T1GridLayout, 'push');
            app.ESaveTableButton.ButtonPushedFcn = createCallbackFcn(app, @ESaveTableButtonPushed, true);
            app.ESaveTableButton.BackgroundColor = [1 1 1];
            app.ESaveTableButton.FontWeight = 'bold';
            app.ESaveTableButton.Tooltip = {'Save current table to file'};
            app.ESaveTableButton.Layout.Row = 1;
            app.ESaveTableButton.Layout.Column = 1;
            app.ESaveTableButton.Text = 'Save Table';

            % Create EDataFormatEditField
            app.EDataFormatEditField = uieditfield(app.EP3T1GridLayout, 'text');
            app.EDataFormatEditField.ValueChangedFcn = createCallbackFcn(app, @EDataFormatEditFieldValueChanged, true);
            app.EDataFormatEditField.HorizontalAlignment = 'center';
            app.EDataFormatEditField.Tooltip = {'Data Format Str'};
            app.EDataFormatEditField.Layout.Row = 1;
            app.EDataFormatEditField.Layout.Column = 5;
            app.EDataFormatEditField.Value = '%d';

            % Create EConvergeButton
            app.EConvergeButton = uibutton(app.EP3T1GridLayout, 'push');
            app.EConvergeButton.ButtonPushedFcn = createCallbackFcn(app, @EConvergeButtonPushed, true);
            app.EConvergeButton.BackgroundColor = [1 1 1];
            app.EConvergeButton.FontWeight = 'bold';
            app.EConvergeButton.Tooltip = {'Draw Convergence Plot'};
            app.EConvergeButton.Layout.Row = 1;
            app.EConvergeButton.Layout.Column = 3;
            app.EConvergeButton.Text = 'Converge';

            % Create EParetoButton
            app.EParetoButton = uibutton(app.EP3T1GridLayout, 'push');
            app.EParetoButton.ButtonPushedFcn = createCallbackFcn(app, @EParetoButtonPushed, true);
            app.EParetoButton.BackgroundColor = [1 1 1];
            app.EParetoButton.FontWeight = 'bold';
            app.EParetoButton.Tooltip = {'Draw Median Population Pareto Front'};
            app.EParetoButton.Layout.Row = 1;
            app.EParetoButton.Layout.Column = 4;
            app.EParetoButton.Text = 'Pareto';

            % Create EConvergeTypeDropDown
            app.EConvergeTypeDropDown = uidropdown(app.EP3T1GridLayout);
            app.EConvergeTypeDropDown.Items = {'Log', 'Normal'};
            app.EConvergeTypeDropDown.Tooltip = {'Show Type'};
            app.EConvergeTypeDropDown.FontWeight = 'bold';
            app.EConvergeTypeDropDown.BackgroundColor = [1 1 1];
            app.EConvergeTypeDropDown.Layout.Row = 1;
            app.EConvergeTypeDropDown.Layout.Column = 2;
            app.EConvergeTypeDropDown.Value = 'Log';

            % Create EUITable
            app.EUITable = uitable(app.EP3TGridLayout);
            app.EUITable.ColumnName = '';
            app.EUITable.RowName = {};
            app.EUITable.CellSelectionCallback = createCallbackFcn(app, @EUITableCellSelection, true);
            app.EUITable.Layout.Row = 2;
            app.EUITable.Layout.Column = 1;

            % Create DataProcessModuleTab
            app.DataProcessModuleTab = uitab(app.MTOPlatformTabGroup);
            app.DataProcessModuleTab.Title = 'Data Process Module';
            app.DataProcessModuleTab.BackgroundColor = [1 1 1];

            % Create DataProcessGridLayout
            app.DataProcessGridLayout = uigridlayout(app.DataProcessModuleTab);
            app.DataProcessGridLayout.ColumnWidth = {330, '2x'};
            app.DataProcessGridLayout.RowHeight = {'1x'};
            app.DataProcessGridLayout.BackgroundColor = [1 1 1];

            % Create DPanel1
            app.DPanel1 = uipanel(app.DataProcessGridLayout);
            app.DPanel1.BorderType = 'none';
            app.DPanel1.BackgroundColor = [1 1 1];
            app.DPanel1.Layout.Row = 1;
            app.DPanel1.Layout.Column = 1;

            % Create DP1GridLayout
            app.DP1GridLayout = uigridlayout(app.DPanel1);
            app.DP1GridLayout.ColumnWidth = {'1x'};
            app.DP1GridLayout.RowHeight = {'0.5x', '1x', '1x', '1x', '1x', '2x'};
            app.DP1GridLayout.RowSpacing = 20;
            app.DP1GridLayout.Padding = [0 0 0 0];
            app.DP1GridLayout.BackgroundColor = [1 1 1];

            % Create DDataProcessModuleLabel
            app.DDataProcessModuleLabel = uilabel(app.DP1GridLayout);
            app.DDataProcessModuleLabel.HorizontalAlignment = 'center';
            app.DDataProcessModuleLabel.VerticalAlignment = 'bottom';
            app.DDataProcessModuleLabel.FontSize = 18;
            app.DDataProcessModuleLabel.FontWeight = 'bold';
            app.DDataProcessModuleLabel.Layout.Row = 1;
            app.DDataProcessModuleLabel.Layout.Column = 1;
            app.DDataProcessModuleLabel.Text = 'Data Process for Experiment';

            % Create DP1Panel1
            app.DP1Panel1 = uipanel(app.DP1GridLayout);
            app.DP1Panel1.BorderType = 'none';
            app.DP1Panel1.BackgroundColor = [1 1 1];
            app.DP1Panel1.Layout.Row = 2;
            app.DP1Panel1.Layout.Column = 1;

            % Create DP1P1GridLayout
            app.DP1P1GridLayout = uigridlayout(app.DP1Panel1);
            app.DP1P1GridLayout.ColumnWidth = {'1x', '1x', '1x'};
            app.DP1P1GridLayout.RowHeight = {'1x', 'fit'};
            app.DP1P1GridLayout.Padding = [0 0 0 0];
            app.DP1P1GridLayout.BackgroundColor = [1 1 1];

            % Create DLoadDataButton
            app.DLoadDataButton = uibutton(app.DP1P1GridLayout, 'push');
            app.DLoadDataButton.ButtonPushedFcn = createCallbackFcn(app, @DLoadDataButtonPushed, true);
            app.DLoadDataButton.BackgroundColor = [0.7412 0.8392 1];
            app.DLoadDataButton.FontWeight = 'bold';
            app.DLoadDataButton.Layout.Row = 2;
            app.DLoadDataButton.Layout.Column = 1;
            app.DLoadDataButton.Text = 'Load Data';

            % Create DDeleteDataButton
            app.DDeleteDataButton = uibutton(app.DP1P1GridLayout, 'push');
            app.DDeleteDataButton.ButtonPushedFcn = createCallbackFcn(app, @DDeleteDataButtonPushed, true);
            app.DDeleteDataButton.BackgroundColor = [1 1 0.7608];
            app.DDeleteDataButton.FontWeight = 'bold';
            app.DDeleteDataButton.Layout.Row = 2;
            app.DDeleteDataButton.Layout.Column = 2;
            app.DDeleteDataButton.Text = 'Delete Data';

            % Create DSaveDataButton
            app.DSaveDataButton = uibutton(app.DP1P1GridLayout, 'push');
            app.DSaveDataButton.ButtonPushedFcn = createCallbackFcn(app, @DSaveDataButtonPushed, true);
            app.DSaveDataButton.BackgroundColor = [0.7882 1 0.7882];
            app.DSaveDataButton.FontWeight = 'bold';
            app.DSaveDataButton.Layout.Row = 2;
            app.DSaveDataButton.Layout.Column = 3;
            app.DSaveDataButton.Text = 'Save Data';

            % Create DLoadDataorSelectandDeleteSaveDataLabel_3
            app.DLoadDataorSelectandDeleteSaveDataLabel_3 = uilabel(app.DP1P1GridLayout);
            app.DLoadDataorSelectandDeleteSaveDataLabel_3.HorizontalAlignment = 'center';
            app.DLoadDataorSelectandDeleteSaveDataLabel_3.VerticalAlignment = 'bottom';
            app.DLoadDataorSelectandDeleteSaveDataLabel_3.Layout.Row = 1;
            app.DLoadDataorSelectandDeleteSaveDataLabel_3.Layout.Column = [2 3];
            app.DLoadDataorSelectandDeleteSaveDataLabel_3.Text = 'Select data node, click Delete/Save';

            % Create DLoadDataorSelectandDeleteSaveDataLabel_4
            app.DLoadDataorSelectandDeleteSaveDataLabel_4 = uilabel(app.DP1P1GridLayout);
            app.DLoadDataorSelectandDeleteSaveDataLabel_4.HorizontalAlignment = 'center';
            app.DLoadDataorSelectandDeleteSaveDataLabel_4.VerticalAlignment = 'bottom';
            app.DLoadDataorSelectandDeleteSaveDataLabel_4.Layout.Row = 1;
            app.DLoadDataorSelectandDeleteSaveDataLabel_4.Layout.Column = 1;
            app.DLoadDataorSelectandDeleteSaveDataLabel_4.Text = 'Load data to tree';

            % Create DP1Panel2
            app.DP1Panel2 = uipanel(app.DP1GridLayout);
            app.DP1Panel2.BorderType = 'none';
            app.DP1Panel2.BackgroundColor = [1 1 1];
            app.DP1Panel2.Layout.Row = 3;
            app.DP1Panel2.Layout.Column = 1;

            % Create DP1P2GridLayout
            app.DP1P2GridLayout = uigridlayout(app.DP1Panel2);
            app.DP1P2GridLayout.ColumnWidth = {'1x', '1x', '1x'};
            app.DP1P2GridLayout.RowHeight = {'1x', 'fit'};
            app.DP1P2GridLayout.Padding = [0 0 0 0];
            app.DP1P2GridLayout.BackgroundColor = [1 1 1];

            % Create DSelectandSplitDataLabel
            app.DSelectandSplitDataLabel = uilabel(app.DP1P2GridLayout);
            app.DSelectandSplitDataLabel.HorizontalAlignment = 'center';
            app.DSelectandSplitDataLabel.VerticalAlignment = 'bottom';
            app.DSelectandSplitDataLabel.Layout.Row = 1;
            app.DSelectandSplitDataLabel.Layout.Column = [1 3];
            app.DSelectandSplitDataLabel.Text = 'Select data node, click Split button';

            % Create DRepsSplitButton
            app.DRepsSplitButton = uibutton(app.DP1P2GridLayout, 'push');
            app.DRepsSplitButton.ButtonPushedFcn = createCallbackFcn(app, @DRepsSplitButtonPushed, true);
            app.DRepsSplitButton.BackgroundColor = [1 1 1];
            app.DRepsSplitButton.FontWeight = 'bold';
            app.DRepsSplitButton.Layout.Row = 2;
            app.DRepsSplitButton.Layout.Column = 1;
            app.DRepsSplitButton.Text = 'Reps Split';

            % Create DAlgorithmsSplitButton
            app.DAlgorithmsSplitButton = uibutton(app.DP1P2GridLayout, 'push');
            app.DAlgorithmsSplitButton.ButtonPushedFcn = createCallbackFcn(app, @DAlgorithmsSplitButtonPushed, true);
            app.DAlgorithmsSplitButton.BackgroundColor = [1 1 1];
            app.DAlgorithmsSplitButton.FontWeight = 'bold';
            app.DAlgorithmsSplitButton.Layout.Row = 2;
            app.DAlgorithmsSplitButton.Layout.Column = 2;
            app.DAlgorithmsSplitButton.Text = 'Algorithm Split';

            % Create DProblemsSplitButton
            app.DProblemsSplitButton = uibutton(app.DP1P2GridLayout, 'push');
            app.DProblemsSplitButton.ButtonPushedFcn = createCallbackFcn(app, @DProblemsSplitButtonPushed, true);
            app.DProblemsSplitButton.BackgroundColor = [1 1 1];
            app.DProblemsSplitButton.FontWeight = 'bold';
            app.DProblemsSplitButton.Layout.Row = 2;
            app.DProblemsSplitButton.Layout.Column = 3;
            app.DProblemsSplitButton.Text = 'Problem Split';

            % Create DP1Panel3
            app.DP1Panel3 = uipanel(app.DP1GridLayout);
            app.DP1Panel3.BorderType = 'none';
            app.DP1Panel3.BackgroundColor = [1 1 1];
            app.DP1Panel3.Layout.Row = 4;
            app.DP1Panel3.Layout.Column = 1;

            % Create DP1P3GridLayout
            app.DP1P3GridLayout = uigridlayout(app.DP1Panel3);
            app.DP1P3GridLayout.ColumnWidth = {'1x', '1x', '1x'};
            app.DP1P3GridLayout.RowHeight = {'1x', 'fit'};
            app.DP1P3GridLayout.Padding = [0 0 0 0];
            app.DP1P3GridLayout.BackgroundColor = [1 1 1];

            % Create DSelectandMergeDataLabel
            app.DSelectandMergeDataLabel = uilabel(app.DP1P3GridLayout);
            app.DSelectandMergeDataLabel.HorizontalAlignment = 'center';
            app.DSelectandMergeDataLabel.VerticalAlignment = 'bottom';
            app.DSelectandMergeDataLabel.Layout.Row = 1;
            app.DSelectandMergeDataLabel.Layout.Column = [1 3];
            app.DSelectandMergeDataLabel.Text = 'Select data node, click Merge button';

            % Create DRepsMergeButton
            app.DRepsMergeButton = uibutton(app.DP1P3GridLayout, 'push');
            app.DRepsMergeButton.ButtonPushedFcn = createCallbackFcn(app, @DRepsMergeButtonPushed, true);
            app.DRepsMergeButton.BackgroundColor = [1 1 1];
            app.DRepsMergeButton.FontWeight = 'bold';
            app.DRepsMergeButton.Layout.Row = 2;
            app.DRepsMergeButton.Layout.Column = 1;
            app.DRepsMergeButton.Text = 'Reps Merge';

            % Create DAlgorithmsMergeButton
            app.DAlgorithmsMergeButton = uibutton(app.DP1P3GridLayout, 'push');
            app.DAlgorithmsMergeButton.ButtonPushedFcn = createCallbackFcn(app, @DAlgorithmsMergeButtonPushed, true);
            app.DAlgorithmsMergeButton.BackgroundColor = [1 1 1];
            app.DAlgorithmsMergeButton.FontWeight = 'bold';
            app.DAlgorithmsMergeButton.Layout.Row = 2;
            app.DAlgorithmsMergeButton.Layout.Column = 2;
            app.DAlgorithmsMergeButton.Text = 'Algorithm Merge';

            % Create DProblemsMergeButton
            app.DProblemsMergeButton = uibutton(app.DP1P3GridLayout, 'push');
            app.DProblemsMergeButton.ButtonPushedFcn = createCallbackFcn(app, @DProblemsMergeButtonPushed, true);
            app.DProblemsMergeButton.BackgroundColor = [1 1 1];
            app.DProblemsMergeButton.FontWeight = 'bold';
            app.DProblemsMergeButton.Layout.Row = 2;
            app.DProblemsMergeButton.Layout.Column = 3;
            app.DProblemsMergeButton.Text = 'Problem Merge';

            % Create DP1Panel4
            app.DP1Panel4 = uipanel(app.DP1GridLayout);
            app.DP1Panel4.BorderType = 'none';
            app.DP1Panel4.BackgroundColor = [1 1 1];
            app.DP1Panel4.Layout.Row = 5;
            app.DP1Panel4.Layout.Column = 1;

            % Create DP1P4GridLayout
            app.DP1P4GridLayout = uigridlayout(app.DP1Panel4);
            app.DP1P4GridLayout.RowHeight = {'1x', 'fit'};
            app.DP1P4GridLayout.Padding = [0 0 0 0];
            app.DP1P4GridLayout.BackgroundColor = [1 1 1];

            % Create DUpandDownDataLabel
            app.DUpandDownDataLabel = uilabel(app.DP1P4GridLayout);
            app.DUpandDownDataLabel.HorizontalAlignment = 'center';
            app.DUpandDownDataLabel.VerticalAlignment = 'bottom';
            app.DUpandDownDataLabel.Layout.Row = 1;
            app.DUpandDownDataLabel.Layout.Column = [1 2];
            app.DUpandDownDataLabel.Text = 'Select data node, click Up or Down button';

            % Create DUpButton
            app.DUpButton = uibutton(app.DP1P4GridLayout, 'push');
            app.DUpButton.ButtonPushedFcn = createCallbackFcn(app, @DUpButtonPushed, true);
            app.DUpButton.BackgroundColor = [1 1 1];
            app.DUpButton.FontWeight = 'bold';
            app.DUpButton.Layout.Row = 2;
            app.DUpButton.Layout.Column = 1;
            app.DUpButton.Text = 'UP';

            % Create DDownButton
            app.DDownButton = uibutton(app.DP1P4GridLayout, 'push');
            app.DDownButton.ButtonPushedFcn = createCallbackFcn(app, @DDownButtonPushed, true);
            app.DDownButton.BackgroundColor = [1 1 1];
            app.DDownButton.FontWeight = 'bold';
            app.DDownButton.Layout.Row = 2;
            app.DDownButton.Layout.Column = 2;
            app.DDownButton.Text = 'Down';

            % Create DDataProcessModuleLabel_2
            app.DDataProcessModuleLabel_2 = uilabel(app.DP1GridLayout);
            app.DDataProcessModuleLabel_2.HorizontalAlignment = 'center';
            app.DDataProcessModuleLabel_2.VerticalAlignment = 'bottom';
            app.DDataProcessModuleLabel_2.Layout.Row = 6;
            app.DDataProcessModuleLabel_2.Layout.Column = 1;
            app.DDataProcessModuleLabel_2.Text = 'MTO-Platform (MToP) by Yanchi Li';

            % Create DPanel2
            app.DPanel2 = uipanel(app.DataProcessGridLayout);
            app.DPanel2.BorderType = 'none';
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
            app.SelectedAlgoContextMenu = uicontextmenu(app.MTOPlatformMToPv11UIFigure);
            app.SelectedAlgoContextMenu.ContextMenuOpeningFcn = createCallbackFcn(app, @SelectedAlgoContextMenuOpening, true);
            
            % Assign app.SelectedAlgoContextMenu
            app.EAlgorithmsTree.ContextMenu = app.SelectedAlgoContextMenu;

            % Create SelectedAlgoSelectAllMenu
            app.SelectedAlgoSelectAllMenu = uimenu(app.SelectedAlgoContextMenu);
            app.SelectedAlgoSelectAllMenu.Checked = 'on';
            app.SelectedAlgoSelectAllMenu.Text = 'Select All';

            % Create DDataContextMenu
            app.DDataContextMenu = uicontextmenu(app.MTOPlatformMToPv11UIFigure);
            app.DDataContextMenu.ContextMenuOpeningFcn = createCallbackFcn(app, @DDataContextMenuOpening, true);
            
            % Assign app.DDataContextMenu
            app.DDataTree.ContextMenu = app.DDataContextMenu;

            % Create SelectedAlgoSelectAllMenu_2
            app.SelectedAlgoSelectAllMenu_2 = uimenu(app.DDataContextMenu);
            app.SelectedAlgoSelectAllMenu_2.Checked = 'on';
            app.SelectedAlgoSelectAllMenu_2.Text = 'Select All';

            % Create SelectedProbContextMenu
            app.SelectedProbContextMenu = uicontextmenu(app.MTOPlatformMToPv11UIFigure);
            
            % Assign app.SelectedProbContextMenu
            app.EProblemsTree.ContextMenu = app.SelectedProbContextMenu;

            % Create SelectedProbSelectAllMenu
            app.SelectedProbSelectAllMenu = uimenu(app.SelectedProbContextMenu);
            app.SelectedProbSelectAllMenu.MenuSelectedFcn = createCallbackFcn(app, @ESelectedProbContextMenuOpening, true);
            app.SelectedProbSelectAllMenu.Checked = 'on';
            app.SelectedProbSelectAllMenu.Text = 'Select All';

            % Create AlgorithmsContextMenu
            app.AlgorithmsContextMenu = uicontextmenu(app.MTOPlatformMToPv11UIFigure);
            app.AlgorithmsContextMenu.ContextMenuOpeningFcn = createCallbackFcn(app, @AlgorithmsContextMenuOpening, true);
            
            % Assign app.AlgorithmsContextMenu
            app.EAlgorithmsListBox.ContextMenu = app.AlgorithmsContextMenu;

            % Create AlgorithmsSelectAllMenu
            app.AlgorithmsSelectAllMenu = uimenu(app.AlgorithmsContextMenu);
            app.AlgorithmsSelectAllMenu.Checked = 'on';
            app.AlgorithmsSelectAllMenu.Text = 'Select All';

            % Create ProblemsContextMenu
            app.ProblemsContextMenu = uicontextmenu(app.MTOPlatformMToPv11UIFigure);
            
            % Assign app.ProblemsContextMenu
            app.EProblemsListBox.ContextMenu = app.ProblemsContextMenu;

            % Create ProblemsSelectAllMenu
            app.ProblemsSelectAllMenu = uimenu(app.ProblemsContextMenu);
            app.ProblemsSelectAllMenu.MenuSelectedFcn = createCallbackFcn(app, @EProblemsContextMenuOpening, true);
            app.ProblemsSelectAllMenu.Checked = 'on';
            app.ProblemsSelectAllMenu.Text = 'Select All';

            % Show the figure after all components are created
            app.MTOPlatformMToPv11UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = MTO_GUI

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.MTOPlatformMToPv11UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.MTOPlatformMToPv11UIFigure)
        end
    end
end