classdef MTO_Platform_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        MTOPlatformUIFigure          matlab.ui.Figure
        MTOPlatformGridLayout        matlab.ui.container.GridLayout
        MTOPlatformTabGroup          matlab.ui.container.TabGroup
        TestTab                      matlab.ui.container.Tab
        TestGridLayout               matlab.ui.container.GridLayout
        TPanel1                      matlab.ui.container.Panel
        TP1GridLayout                matlab.ui.container.GridLayout
        TPopSizeEditField            matlab.ui.control.NumericEditField
        TPopSizeEditFieldLabel       matlab.ui.control.Label
        TEndNumEditField             matlab.ui.control.NumericEditField
        TEndNumEditFieldLabel        matlab.ui.control.Label
        AlgorithmDropDownLabel       matlab.ui.control.Label
        TAlgorithmDropDown           matlab.ui.control.DropDown
        TAlgorithmTree               matlab.ui.container.Tree
        TProblemTree                 matlab.ui.container.Tree
        TProblemDropDown             matlab.ui.control.DropDown
        ProblemDropDownLabel         matlab.ui.control.Label
        EndTypeLabel_2               matlab.ui.control.Label
        TEndTypeDropDown             matlab.ui.control.DropDown
        TPanel2                      matlab.ui.container.Panel
        TP2GridLayout                matlab.ui.container.GridLayout
        TP21GridLayout               matlab.ui.container.GridLayout
        TShowTypeDropDown            matlab.ui.control.DropDown
        TP24GridLayout               matlab.ui.container.GridLayout
        TStartButton                 matlab.ui.control.Button
        TUIAxes                      matlab.ui.control.UIAxes
        TPanel3                      matlab.ui.container.Panel
        TP3GridLayout                matlab.ui.container.GridLayout
        OutputTextAreaLabel          matlab.ui.control.Label
        TOutputTextArea              matlab.ui.control.TextArea
        ExperimentTab                matlab.ui.container.Tab
        ExperimentsGridLayout        matlab.ui.container.GridLayout
        EPanel3                      matlab.ui.container.Panel
        EP3GridLayout                matlab.ui.container.GridLayout
        ETableTabGroup               matlab.ui.container.TabGroup
        ETableTab                    matlab.ui.container.Tab
        EP3TGridLayout               matlab.ui.container.GridLayout
        EP3T1GridLayout              matlab.ui.container.GridLayout
        ETestTypeDropDown            matlab.ui.control.DropDown
        EAlgorithmDropDown           matlab.ui.control.DropDown
        EShowTypeDropDown            matlab.ui.control.DropDown
        EDataTypeDropDown            matlab.ui.control.DropDown
        EHighlightTypeDropDown       matlab.ui.control.DropDown
        ESaveTableButton             matlab.ui.control.Button
        EUITable                     matlab.ui.control.Table
        EFigureTab                   matlab.ui.container.Tab
        EP3FGridLayout               matlab.ui.container.GridLayout
        EP3F1GridLayout              matlab.ui.container.GridLayout
        EProblemsDropDown            matlab.ui.control.DropDown
        EYLimTypeDropDown            matlab.ui.control.DropDown
        ESaveAllFigureButton         matlab.ui.control.Button
        EFigureTypeDropDown          matlab.ui.control.DropDown
        EConvergenceTrendUIAxes      matlab.ui.control.UIAxes
        EPanel1                      matlab.ui.container.Panel
        EP1GridLayout                matlab.ui.container.GridLayout
        EProblemsAddButton           matlab.ui.control.Button
        EAlgorithmsAddButton         matlab.ui.control.Button
        ERepsEditField               matlab.ui.control.NumericEditField
        ERunTimesEditFieldLabel      matlab.ui.control.Label
        EEndNumEditField             matlab.ui.control.NumericEditField
        EEndNumEditFieldLabel        matlab.ui.control.Label
        EPopSizeEditField            matlab.ui.control.NumericEditField
        EPopSizeEditFieldLabel       matlab.ui.control.Label
        EAlgorithmsListBox           matlab.ui.control.ListBox
        AlgorithmsListBox_2Label     matlab.ui.control.Label
        EProblemsListBox             matlab.ui.control.ListBox
        ProblemsListBox_2Label       matlab.ui.control.Label
        EndTypeLabel                 matlab.ui.control.Label
        EEndTypeDropDown             matlab.ui.control.DropDown
        ELoadDataButton              matlab.ui.control.Button
        ESaveDataButton              matlab.ui.control.Button
        EPanel2                      matlab.ui.container.Panel
        EP2GridLayout                matlab.ui.container.GridLayout
        EStartButton                 matlab.ui.control.Button
        EPauseButton                 matlab.ui.control.Button
        EStopButton                  matlab.ui.control.Button
        EAlgorithmsTree              matlab.ui.container.Tree
        EProblemsTree                matlab.ui.container.Tree
        ESelectedAlgorithmsLabel     matlab.ui.control.Label
        ESelectedProblemsLabel       matlab.ui.control.Label
        EAlgorithmsDelButton         matlab.ui.control.Button
        EProblemsDelButton           matlab.ui.control.Button
        DataProcessTab               matlab.ui.container.Tab
        DataProcessGridLayout        matlab.ui.container.GridLayout
        DPanel1                      matlab.ui.container.Panel
        DP1GridLayout                matlab.ui.container.GridLayout
        DDataProcessModuleLabel      matlab.ui.control.Label
        DP1Panel1                    matlab.ui.container.Panel
        DP1P1GridLayout              matlab.ui.container.GridLayout
        DLoadDataButton              matlab.ui.control.Button
        DDeleteDataButton            matlab.ui.control.Button
        DSaveDataButton              matlab.ui.control.Button
        DLoadDataorSelectandDeleteSaveDataLabel_3  matlab.ui.control.Label
        DLoadDataorSelectandDeleteSaveDataLabel_4  matlab.ui.control.Label
        DP1Panel2                    matlab.ui.container.Panel
        DP1P2GridLayout              matlab.ui.container.GridLayout
        DSelectandSplitDataLabel     matlab.ui.control.Label
        DRepsSplitButton             matlab.ui.control.Button
        DAlgorithmsSplitButton       matlab.ui.control.Button
        DProblemsSplitButton         matlab.ui.control.Button
        DP1Panel3                    matlab.ui.container.Panel
        DP1P3GridLayout              matlab.ui.container.GridLayout
        DSelectandMergeDataLabel     matlab.ui.control.Label
        DRepsMergeButton             matlab.ui.control.Button
        DAlgorithmsMergeButton       matlab.ui.control.Button
        DProblemsMergeButton         matlab.ui.control.Button
        DP1Panel4                    matlab.ui.container.Panel
        DP1P4GridLayout              matlab.ui.container.GridLayout
        DUpandDownDataLabel          matlab.ui.control.Label
        DUpButton                    matlab.ui.control.Button
        DDownButton                  matlab.ui.control.Button
        DPanel2                      matlab.ui.container.Panel
        DP2GridLayout                matlab.ui.container.GridLayout
        DDataTree                    matlab.ui.container.Tree
        ESelectedAlgoContextMenu     matlab.ui.container.ContextMenu
        SelectedAlgoSelectAllMenu    matlab.ui.container.Menu
        DDataContextMenu             matlab.ui.container.ContextMenu
        SelectedAlgoSelectAllMenu_2  matlab.ui.container.Menu
        ESelectedProbContextMenu     matlab.ui.container.ContextMenu
        SelectedProbSelectAllMenu    matlab.ui.container.Menu
        EAlgorithmsContextMenu       matlab.ui.container.ContextMenu
        AlgorithmsSelectAllMenu      matlab.ui.container.Menu
        EProblemsContextMenu         matlab.ui.container.ContextMenu
        ProblemsSelectAllMenu        matlab.ui.container.Menu
    end

    properties (Access = public)
        algo_load % cell of algorithms loaded from folder
        prob_load % cell of problems loaded from folder
        
        % convergence axes set
        line_width = 1.5
        marker_list = {'o', '*', 'x', '^', '+', 'p', 'v', 's', 'd', '<', '>', 'h'}
        marker_size = 7
        marker_num = 10
        
        % Test Module
        Tdata % data
        
        % Experiment Module
        Edata % data
        Estop_flag % stop button clicked flag
        Efitness % fitness calculated
        Etime_used % time_used calculated
        Etable_data % table data for calculate
        Etable_view % table data view
        Etable_view_test % table data view test
        Etable_reps % table reps
        
        % Data Process Module
        Ddata_mark % legal data node index
    end
    
    methods (Access = public)
        
        function readAlgoProb(app)
            % load the algorithms and problems list
            
            app.algo_load = {};
            app.prob_load = {};
            
            % read algorithms
            algo_folders = split(genpath(fullfile(fileparts(mfilename('fullpath')),'Algorithms')),pathsep);
            for i = 1:length(algo_folders)
                files = what(algo_folders{i});
                files = files.m;
                for j = 1:length(files)
                    f = fopen(files{j});
                    str = regexp(fgetl(f),'<\s{0,}.*','match');
                    if contains(str, 'Algorithm')
                        app.algo_load = [app.algo_load, files{j}(1:end-2)];
                    end
                end
            end
            
            % read problems
            prob_folders = split(genpath(fullfile(fileparts(mfilename('fullpath')),'Problems')),pathsep);
            for i = 1:length(prob_folders)
                files = what(prob_folders{i});
                files = files.m;
                for j = 1:length(files)
                    f = fopen(files{j});
                    str = regexp(fgetl(f),'<\s{0,}.*','match');
                    if contains(str, 'Problem')
                        app.prob_load = [app.prob_load, files{j}(1:end-2)];
                    end
                end
            end
            
        end
        
        function TloadAlgoProb(app)
            % load the algorithms and problems in Test module
            
            app.TAlgorithmDropDown.Items = {};
            app.TProblemDropDown.Items = {};
            app.TAlgorithmDropDown.Items = app.algo_load;
            app.TProblemDropDown.Items = app.prob_load;
        end
        
        function EloadAlgoProb(app)
            % load the algorithms and problems in Experiment module
            
            app.EAlgorithmsListBox.Items(:) = [];
            app.EProblemsListBox.Items(:) = [];
            app.EAlgorithmsListBox.Items = app.algo_load;
            app.EProblemsListBox.Items = app.prob_load;
        end
        
        function TstartEnable(app, value)
            % change controler enable when start button pused and end
            % in Test module
            
            app.TStartButton.Enable = value;
            app.TPopSizeEditField.Enable = value;
            app.TEndTypeDropDown.Enable = value;
            app.TEndNumEditField.Enable = value;
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
            app.EPopSizeEditField.Enable = value;
            app.EEndTypeDropDown.Enable = value;
            app.EEndNumEditField.Enable = value;
            app.EAlgorithmsAddButton.Enable = value;
            app.EProblemsAddButton.Enable = value;
            app.EAlgorithmsListBox.Enable = value;
            app.EProblemsListBox.Enable = value;
            app.EAlgorithmsDelButton.Enable = value;
            app.EProblemsDelButton.Enable = value;
            app.EAlgorithmsTree.Enable = value;
            app.EProblemsTree.Enable = value;
            app.ELoadDataButton.Enable = value;
            app.EPauseButton.Enable = ~value;
            app.EStopButton.Enable = ~value;
        end
        
        function EcheckPauseStopStatus(app)
            % This function can be called at any time to check that status of the pause and stop buttons.
            % If paused, it will wait until un-paused.
            % If stopped, it will throw an error to break execution. The error will not be thrown.
            
            if app.Estop_flag
                app.EstartEnable(true);
                error('User Stop');
            end
            
            if strcmp(app.EPauseButton.Text, 'Resume')
                waitfor(app.EPauseButton,'Text', 'Pause');
            end
        end
        
        function TupdateAlgorithm(app)
            % update algorithm tree in Test module
            
            app.TAlgorithmTree.Children.delete;
            
            algo_name = app.TAlgorithmDropDown.Value;
            eval(['algo_obj = ', algo_name, '("', algo_name, '");']);
            algo_node = uitreenode(app.TAlgorithmTree);
            algo_node.Text = algo_obj.getName();
            algo_node.NodeData = algo_obj;
            algo_node.ContextMenu = app.ESelectedProbContextMenu;
            
            % child parameter node
            parameter = algo_obj.getParameter();
            for p = 1:2:length(parameter)
                para_name_node = uitreenode(algo_node);
                para_name_node.Text = ['[ ', parameter{p}, ' ]'];
                para_name_node.NodeData = para_name_node.Text;
                para_name_node.ContextMenu = app.ESelectedAlgoContextMenu;
                para_value_node = uitreenode(algo_node);
                para_value_node.Text = parameter{p+1};
                para_value_node.ContextMenu = app.ESelectedAlgoContextMenu;
            end
        end
        
        function TupdateProblem(app)
            % update problem tree in Test module
            
            app.TProblemTree.Children.delete;
            
            prob_name = app.TProblemDropDown.Value;
            eval(['prob_obj = ', prob_name, '("',prob_name, '");']);
            prob_node = uitreenode(app.TProblemTree);
            prob_node.Text = prob_obj.getName();
            prob_node.NodeData = prob_obj;
            prob_node.ContextMenu = app.ESelectedProbContextMenu;
            
            
            % child parameter node
            parameter = prob_obj.getParameter();
            for p = 1:2:length(parameter)
                para_name_node = uitreenode(prob_node);
                para_name_node.Text = ['[ ', parameter{p}, ' ]'];
                para_name_node.NodeData = para_name_node.Text;
                para_name_node.ContextMenu = app.ESelectedProbContextMenu;
                para_value_node = uitreenode(prob_node);
                para_value_node.Text = parameter{p+1};
                para_value_node.ContextMenu = app.ESelectedProbContextMenu;
            end
        end
        
        function TupdateUIAxes(app)
            % update UI Axes in Test module
            
            cla(app.TUIAxes, 'reset');
            type = app.TShowTypeDropDown.Value;
            switch type
                case 'Tasks Figure (1D)'
                    app.TupdateTasksFigure();
                case 'Convergence'
                    app.TupdateConvergence();
            end
        end
        
        function TupdateTasksFigure(app)
            % update selected problem tasks figure in Test module
            
            Tasks = app.TProblemTree.Children(1).NodeData.getTasks();
            no_of_tasks = length(Tasks);
            
            x = 0:1/1000:1;
            f = zeros(size(x));
            
            legend_cell = {};
            plot_handle = {};
            color = colororder;
            for no = 1:no_of_tasks
                
                for i = 1:length(x)
                    minrange = Tasks(no).Lb(1);
                    maxrange = Tasks(no).Ub(1);
                    y = maxrange - minrange;
                    vars = y .* x(i) + minrange;
                    f(i) = Tasks(no).fnc(vars);
                end
                
                fmin = min(f);
                fmax = max(f);
                f = (f - fmin) / (fmax - fmin);
                p1 = plot(app.TUIAxes, x, f);
                p1.Color = color(mod(no-1, size(color, 1))+1, :);
                p1.LineWidth = 1;
                hold(app.TUIAxes, 'on');
                
                xmin = x(f == min(f));
                fmin = min(f);
                p2 = plot(app.TUIAxes, xmin, fmin, '^');
                p2.MarkerSize = 8;
                p2.MarkerFaceColor = p1.Color;
                p2.MarkerEdgeColor = p1.Color;
                hold(app.TUIAxes, 'on');
                
                legend_cell = [legend_cell, ['T', num2str(no)]];
                plot_handle = [plot_handle, p1];
            end
            legend(app.TUIAxes, plot_handle, legend_cell);
            % legend(app.TUIAxes, legend_cell);
        end
        
        function TupdateConvergence(app)
            % update convergence in Test module
            
            % check app.Edata
            if isempty(app.Tdata)
                return;
            end
            
            % draw
            tasks_name = {};
            for task = 1:app.Tdata.tasks_num
                convergence = app.Tdata.convergence(task, :);
                x = 1:size(convergence,2);
                y = log(convergence);
                if task > length(app.marker_list)
                    marker = '';
                else
                    marker = app.marker_list{task};
                end
                
                p = plot(app.TUIAxes, x, y, ['-', marker]);
                p.LineWidth = app.line_width;
                p.MarkerIndices = 1:round(x(end)/app.marker_num):x(end);
                p.MarkerSize = app.marker_size;
                hold(app.TUIAxes, 'on');
                
                xlabel(app.TUIAxes, 'Iteration');
                ylabel(app.TUIAxes, 'log(fitness)');
                grid(app.TUIAxes, 'on');
                tasks_name = [tasks_name, ['T', num2str(task)]];
            end
            legend(app.TUIAxes, tasks_name);
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
        
        function EresetTable(app, algo_cell, prob_cell, tasks_num_list)
            % reset table in Experiment module
            
            app.EUITable.Data = {};
            app.Etable_data = {};
            app.Etable_view = {};
            app.Etable_view_test = {};
            drawnow;
            prob_row_cell = {};
            for prob = 1:length(prob_cell)
                for task = 1:tasks_num_list(prob)
                    prob_row_cell = [prob_row_cell, [prob_cell{prob}, '_T', num2str(task)]];
                end
            end
            
            switch app.EDataTypeDropDown.Value
                case 'Fitness'
                    app.EUITable.RowName = prob_row_cell;
                    app.EUITable.RowName = [app.EUITable.RowName; '+/-/='];
                otherwise
                    app.EUITable.RowName = prob_cell;
            end
            app.EUITable.ColumnName = algo_cell;
        end
        
        function EcalculatePre(app)
            % calculate fitness, std, time used
            
            if isempty(app.Edata)
                return
            end
            
            app.Efitness = [];
            app.Etime_used = [];
            % calculate fitness
            for algo = 1:length(app.Edata.algo_cell)
                row_i = 1;
                for prob = 1:length(app.Edata.prob_cell)
                    tasks_num = app.Edata.tasks_num_list(prob);
                    for task = 1:tasks_num
                        convergence_task = app.Edata.result(prob, algo).convergence(task:tasks_num:end, :);
                        app.Efitness(row_i, algo, :) = convergence_task(:, end);
                        row_i = row_i + 1;
                    end
                    app.Etime_used(prob, algo) = app.Edata.result(prob, algo).clock_time;
                end
            end
        end
        
        function EupdateTableReps(app)
            % update table reps per run
            
            if ~strcmp(app.EDataTypeDropDown.Value, 'Reps')
                return;
            end
            app.EUITable.Data = sprintfc('%d', app.Etable_reps);
            drawnow;
        end
        
        function EupdateTableFitness(app)
            % update table fitness
            
            if ~strcmp(app.EDataTypeDropDown.Value, 'Fitness')
                return;
            end
            show_type = app.EShowTypeDropDown.Value;
            
            if strcmp(show_type, 'Mean')
                fitness_mean = mean(app.Efitness, 3);
                app.Etable_data = fitness_mean;
                app.Etable_view = sprintfc('%.2d', fitness_mean);
            elseif strcmp(show_type, 'Mean (Std)')
                fitness_mean = mean(app.Efitness, 3);
                fitness_std = std(app.Efitness, 0, 3);
                app.Etable_data = fitness_mean;
                x = zeros([size(fitness_mean, 1), 2*size(fitness_mean, 2)]);
                x(:, 1:2:end) = fitness_mean;
                x(:, 2:2:end) = fitness_std;
                app.Etable_view = sprintfc('%.2d (%.2d)', x);
            elseif strcmp(show_type, 'Median')
                fitness_median = median(app.Efitness, 3);
                app.Etable_data = fitness_median;
                app.Etable_view = sprintfc('%.2d', fitness_median);
            elseif strcmp(show_type, 'Median (Std)')
                fitness_median = median(app.Efitness, 3);
                fitness_std = std(app.Efitness, 0, 3);
                app.Etable_data = fitness_median;
                x = zeros([size(fitness_median, 1), 2*size(fitness_median, 2)]);
                x(:, 1:2:end) = fitness_median;
                x(:, 2:2:end) = fitness_std;
                app.Etable_view = sprintfc('%.2d (%.2d)', x);
            end
            
            if ~isempty(app.Etable_view_test)
                for algo = 1:size(app.Etable_data, 2)
                    for row_i = 1:size(app.Etable_data, 1)
                        if size(app.Etable_view_test, 2) < algo
                            app.EUITable.Data{row_i, algo} = app.Etable_view{row_i, algo};
                        else
                            app.EUITable.Data{row_i, algo} = [app.Etable_view{row_i, algo}, ' ', app.Etable_view_test{row_i, algo}];
                        end
                        drawnow;
                    end
                    if size(app.Etable_view_test, 2) < algo
                        app.EUITable.Data{size(app.Etable_data, 1)+1, algo} = '';
                    else
                        app.EUITable.Data{size(app.Etable_data, 1)+1, algo} = app.Etable_view_test{size(app.Etable_data, 1)+1, algo};
                    end
                end
            else
                app.EUITable.Data = app.Etable_view;
            end
            drawnow;
        end
        
        function EupdateTableTimeUsed(app)
            % update table time used
            
            time_used = app.Etime_used;
            app.Etable_data = time_used;
            app.EUITable.Data = time_used;
            drawnow;
        end
        
        function EupdateTableTest(app)
            % update table fitness test
            
            if ~strcmp(app.EDataTypeDropDown.Value, 'Fitness')
                return;
            end
            test_type = app.ETestTypeDropDown.Value;
            algo_selected = app.EAlgorithmDropDown.Value;
            app.Etable_view_test = {};
            
            if strcmp(test_type, 'None')
                app.EUITable.Data = app.Etable_view;
                return;
            end
            
            for algo = 1:size(app.Etable_data, 2)
                if algo == algo_selected
                    continue;
                end
                sign_p = [0 0 0];
                for row_i = 1:size(app.Etable_data, 1)
                    x1 = reshape(app.Efitness(row_i, algo, :), 1, length(app.Efitness(row_i, algo, :)));
                    x2 = reshape(app.Efitness(row_i, algo_selected, :), 1, length(app.Efitness(row_i, algo_selected, :)));
                    p = 1;
                    if strcmp(test_type, 'Rank sum test')
                        p = ranksum(x1, x2);
                    elseif strcmp(test_type, 'Signed rank test')
                        p = signrank(x1, x2);
                    end
                    if p < 0.05
                        if app.Etable_data(row_i, algo) < app.Etable_data(row_i, algo_selected)
                            app.Etable_view_test{row_i, algo} = '+';
                            sign_p(1) = sign_p(1) + 1;
                        else
                            app.Etable_view_test{row_i, algo} = '-';
                            sign_p(2) = sign_p(2) + 1;
                        end
                    else
                        app.Etable_view_test{row_i, algo} = '=';
                        sign_p(3) = sign_p(3) + 1;
                    end
                end
                app.Etable_view_test{size(app.Etable_data, 1)+1, algo} = sprintf('%d/%d/%d', sign_p);
            end
            for algo = 1:size(app.Etable_data, 2)
                for row_i = 1:size(app.Etable_data, 1)
                    if size(app.Etable_view_test, 2) < algo
                        app.EUITable.Data{row_i, algo} = app.Etable_view{row_i, algo};
                    else
                        app.EUITable.Data{row_i, algo} = [app.Etable_view{row_i, algo}, ' ', app.Etable_view_test{row_i, algo}];
                    end
                    drawnow;
                end
                if size(app.Etable_view_test, 2) < algo
                    app.EUITable.Data{size(app.Etable_data, 1)+1, algo} = '';
                else
                    app.EUITable.Data{size(app.Etable_data, 1)+1, algo} = app.Etable_view_test{size(app.Etable_data, 1)+1, algo};
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
            for row_i = 1:size(app.Etable_data, 1)
                % best
                if ~strcmp(highlight_type, 'None')
                    [~, index] = min(app.Etable_data(row_i, :));
                    app.EUITable.addStyle(high_color, 'cell', [row_i, index]);
                    app.EUITable.addStyle(font_bold, 'cell', [row_i, index]);
                end
                % worst
                if strcmp(highlight_type, 'Highlight best worst')
                    [~, index] = max(app.Etable_data(row_i, :));
                    app.EUITable.addStyle(low_color, 'cell', [row_i, index]);
                end
                drawnow;
            end
        end
        
        function EupdateTable(app)
            % update table in Experiment module
            
            app.EUITable.Data = {};
            if isempty(app.Edata) || isempty(app.Efitness)
                return;
            end
            app.EresetTable(app.Edata.algo_cell, app.Edata.prob_cell, app.Edata.tasks_num_list);
            switch app.EDataTypeDropDown.Value
                case 'Reps'
                    app.EupdateTableReps();
                case 'Fitness'
                    app.EupdateTableFitness();
                    app.EupdateTableTest();
                case 'Time used'
                    app.EupdateTableTimeUsed();
            end
            app.EupdateTableHighlight();
        end
        
        function EresetConvergenceProblemsDropDown(app)
            % reset convergence problems drop down in Experiment module
            
            prob_row_cell = {};
            prob_row_index = {};
            for prob = 1:length(app.Edata.prob_cell)
                for task = 1:app.Edata.tasks_num_list(prob)
                    prob_row_cell = [prob_row_cell, [app.Edata.prob_cell{prob}, '_T', num2str(task)]];
                    prob_row_index = [prob_row_index, [prob, task]];
                end
            end
            app.EProblemsDropDown.Items = prob_row_cell;
            app.EProblemsDropDown.ItemsData = prob_row_index;
            app.EProblemsDropDown.Value = [1 1];
        end
        
        function EupdateConvergenceAxes(app)
            % update convergence axes
            
            % clear axes
            cla(app.EConvergenceTrendUIAxes, 'reset');
            
            % check app.Edata
            if isempty(app.Edata)
                return;
            end
            
            % draw
            value = app.EProblemsDropDown.Value;
            prob = value(1);
            task = value(2);
            tasks_num = app.Edata.tasks_num_list(prob);
            for algo = 1:length(app.Edata.algo_cell)
                convergence_task = app.Edata.result(prob, algo).convergence(task:tasks_num:end, :);
                convergence = mean(convergence_task, 1);
                x_cell{algo} = 1:size(convergence,2);
                y_cell{algo} = convergence;
            end
            switch app.EYLimTypeDropDown.Value
                case 'log(fitness)'
                    for i = 1:length(y_cell)
                        y_cell{i} = log(y_cell{i});
                    end
            end
            max_x = 0;
            for i = 1:length(x_cell)
                if x_cell{i}(end) > max_x
                    max_x = x_cell{i}(end);
                end
            end
            for i = 1:length(x_cell)
                if i > length(app.marker_list)
                    marker = '';
                else
                    marker = app.marker_list{i};
                end
                p = plot(app.EConvergenceTrendUIAxes, x_cell{i}, y_cell{i}, ['-', marker]);
                p.LineWidth = app.line_width;
                p.MarkerIndices = 1:round(max_x/app.marker_num):max_x;
                p.MarkerSize = app.marker_size;
                hold(app.EConvergenceTrendUIAxes, 'on');
            end
            legend(app.EConvergenceTrendUIAxes, strrep(app.Edata.algo_cell, '_', '\_'));
            xlabel(app.EConvergenceTrendUIAxes, 'Iteration');
            ylabel(app.EConvergenceTrendUIAxes, app.EYLimTypeDropDown.Value);
            xlim(app.EConvergenceTrendUIAxes, [1, max_x]);
            grid(app.EConvergenceTrendUIAxes, 'on');
        end
        
        function result = DcheckSplitData(app)
            % check and reproduce split data
            
            data_selected = app.DDataTree.SelectedNodes;
            app.Ddata_mark = [];
            data_num = 0;
            for i = 1:length(data_selected)
                if isa(data_selected(i).Parent, 'matlab.ui.container.Tree')
                    data_num = data_num + 1;
                    app.Ddata_mark(i) = 1;
                else
                    app.Ddata_mark(i) = 0;
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
            app.Ddata_mark = [];
            data_num = 0;
            for i = 1:length(data_selected)
                if isa(data_selected(i).Parent, 'matlab.ui.container.Tree')
                    data_num = data_num + 1;
                    app.Ddata_mark(i) = 1;
                else
                    app.Ddata_mark(i) = 0;
                end
            end
            if data_num < 2
                msg = 'Select at least 2 data node to merge';
                uiconfirm(app.MTOPlatformUIFigure, msg, 'error', 'Icon','warning');
                result = false;
                return;
            end
            
            data_selected = data_selected(app.Ddata_mark == 1);
            % check pop, iteration and evaluate
            pop_size = data_selected(1).NodeData.pop_size;
            iter_num = data_selected(1).NodeData.iter_num;
            eva_num = data_selected(1).NodeData.eva_num;
            for i = 2:data_num
                if data_selected(i).NodeData.pop_size ~= pop_size || ...
                        data_selected(i).NodeData.iter_num ~= iter_num || ...
                        data_selected(i).NodeData.eva_num ~= eva_num
                msg = 'The data''s pop_size or iter_num or eva_num not equal';
                uiconfirm(app.MTOPlatformUIFigure, msg, 'error', 'Icon','warning');
                result = false;
                return;
                end
            end
            result = true;
        end
        
        function result = DcheckMergeReps(app)
            % check merge reps
            
            data_num = sum(app.Ddata_mark);
            data_selected = app.DDataTree.SelectedNodes;
            data_selected = data_selected(app.Ddata_mark == 1);
            reps = data_selected(1).NodeData.reps;
            for i = 2:data_num
                if data_selected(i).NodeData.reps ~= reps
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
            
            data_num = sum(app.Ddata_mark);
            data_selected = app.DDataTree.SelectedNodes;
            data_selected = data_selected(app.Ddata_mark == 1);
            algo_cell = data_selected(1).NodeData.algo_cell;
            for i = 2:data_num
                if length(algo_cell) ~= length(data_selected(i).NodeData.algo_cell)
                    msg = 'The data''s algorithms not equal';
                    uiconfirm(app.MTOPlatformUIFigure, msg, 'error', 'Icon','warning');
                    result = false;
                    return;
                end
                for algo = 1:length(algo_cell)
                    if ~strcmp(data_selected(i).NodeData.algo_cell{algo}, algo_cell{algo})
                        msg = 'The data''s algorithms not equal';
                        uiconfirm(app.MTOPlatformUIFigure, msg, 'error', 'Icon','warning');
                        result = false;
                        return;
                    end
                end
            end
            result = true;
        end
        
        function result = DcheckMergeProblems(app)
            % check merge problems
            
            data_num = sum(app.Ddata_mark);
            data_selected = app.DDataTree.SelectedNodes;
            data_selected = data_selected(app.Ddata_mark == 1);
            prob_cell = data_selected(1).NodeData.prob_cell;
            for i = 2:data_num
                if length(prob_cell) ~= length(data_selected(i).NodeData.prob_cell)
                    msg = 'The data''s problems not equal';
                    uiconfirm(app.MTOPlatformUIFigure, msg, 'error', 'Icon','warning');
                    result = false;
                    return;
                end
                for prob = 1:length(prob_cell)
                    if ~strcmp(data_selected(i).NodeData.prob_cell{prob}, prob_cell{prob})
                        msg = 'The data''s problems not equal';
                        uiconfirm(app.MTOPlatformUIFigure, msg, 'error', 'Icon','warning');
                        result = false;
                        return;
                    end
                end
            end
            result = true;
        end
        
        function DputDataNode(app, name, data_save)
            % add data to tree in Data process module
            
            data_node = uitreenode(app.DDataTree);
            data_node.Text = name;
            data_node.NodeData = data_save;
            data_node.ContextMenu = app.DDataContextMenu;
            
            % child node
            reps_node = uitreenode(data_node);
            reps_node.Text = ['Reps: ', num2str(data_node.NodeData.reps)];
            reps_node.NodeData = reps_node.Text;
            reps_node.ContextMenu = app.DDataContextMenu;
            
            algo_node = uitreenode(data_node);
            algo_node.Text = 'Algorithms:';
            algo_node.NodeData = algo_node.Text;
            algo_node.ContextMenu = app.DDataContextMenu;
            for algo = 1:length(data_node.NodeData.algo_cell)
                algo_child_node = uitreenode(algo_node);
                algo_child_node.Text = data_node.NodeData.algo_cell{algo};
                algo_child_node.NodeData = algo_child_node.Text;
                algo_child_node.ContextMenu = app.DDataContextMenu;
            end
            
            prob_node = uitreenode(data_node);
            prob_node.Text = 'Problems:';
            prob_node.ContextMenu = app.DDataContextMenu;
            for prob = 1:length(data_node.NodeData.prob_cell)
                prob_child_node = uitreenode(prob_node);
                prob_child_node.Text = data_node.NodeData.prob_cell{prob};
                prob_child_node.NodeData = prob_child_node.Text;
                prob_child_node.ContextMenu = app.DDataContextMenu;
            end
            
            pop_node = uitreenode(data_node);
            pop_node.Text = ['Pop Size: ', num2str(data_node.NodeData.pop_size)];
            pop_node.NodeData = pop_node.Text;
            pop_node.ContextMenu = app.DDataContextMenu;
            
            iter_node = uitreenode(data_node);
            iter_node.Text = ['Iteration Num: ', num2str(data_node.NodeData.iter_num)];
            iter_node.NodeData = iter_node.Text;
            iter_node.ContextMenu = app.DDataContextMenu;
            
            eva_node = uitreenode(data_node);
            eva_node.Text = ['Evaluation Num: ', num2str(data_node.NodeData.eva_num)];
            eva_node.NodeData = eva_node.Text;
            eva_node.ContextMenu = app.DDataContextMenu;
        end
        
        function DsaveData(app, data_save)
            % save data to folder in Data process module
            
            % check selected file name
            [file_name, dir_name] = uiputfile('data_save.mat');
            figure(app.MTOPlatformUIFigure);
            if file_name == 0
                return;
            end
            
            % save data
            save([dir_name, file_name], 'data_save');
        end
        
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            % App startup function
            
            % add path
            addpath(genpath('./Algorithms/'));
            addpath(genpath('./Problems/'));
            addpath(genpath('./Utils/'));
            
            app.readAlgoProb();
            app.EloadAlgoProb();
            app.TloadAlgoProb();
            app.TupdateAlgorithm();
            app.TupdateProblem();
            app.TupdateUIAxes();
        end

        % Value changed function: TAlgorithmDropDown
        function TAlgorithmDropDownValueChanged(app, event)
            app.TupdateAlgorithm();
            app.Tdata = [];
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
            app.Tdata = [];
            app.TupdateUIAxes();
        end

        % Value changed function: TProblemDropDown
        function TProblemDropDownValueChanged(app, event)
            app.TupdateProblem();
            app.Tdata = [];
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
            
            app.Tdata = [];
            app.TupdateUIAxes();
        end

        % Value changed function: TShowTypeDropDown
        function TShowTypeDropDownValueChanged(app, event)
            app.TupdateUIAxes();
        end

        % Callback function
        function TValueDropDownValueChanged(app, event)
            app.TupdateValueUIAxes();
        end

        % Button pushed function: TStartButton
        function TStartButtonPushed(app, event)
            % start this test
            
            % off the start button
            app.TstartEnable(false);
            
            % clear the temporary data
            app.Tdata = [];
            
            % read selected algorithms and problems
            algo_name = app.TAlgorithmTree.Children(1).Text;
            prob_name = app.TProblemTree.Children(1).Text;
            tasks_num = length(app.TProblemTree.Children(1).NodeData.getTasks());
            
            % get this experiment's parameters
            switch app.TEndTypeDropDown.Value
                case 'Iteration'
                    iter_num = app.TEndNumEditField.Value;
                    eva_num = inf;
                case 'Evaluation'
                    iter_num = inf;
                    eva_num = app.TEndNumEditField.Value;
            end
            pre_run_list = [app.TPopSizeEditField.Value, iter_num, eva_num];
            
            % run
            app.Tdata = singleRun(app.TAlgorithmTree.Children(1).NodeData, app.TProblemTree.Children(1).NodeData, pre_run_list);
            app.Tdata.algo_name = algo_name;
            app.Tdata.prob_name = prob_name;
            app.Tdata.tasks_num = tasks_num;
            app.TupdateUIAxes();
            best_obj = num2str(app.Tdata.convergence(:, end)','%.2e, ');
            app.Toutput([best_obj(1:end-1), ' (', prob_name, '-', algo_name, ')']);
            
            app.TstartEnable(true);
        end

        % Context menu opening function: EAlgorithmsContextMenu
        function EAlgorithmsContextMenuOpening(app, event)
            % select all algorithms
            
            if ~isempty(app.EAlgorithmsListBox.Items)
                app.EAlgorithmsListBox.Value = app.EAlgorithmsListBox.Items;
            end
        end

        % Button pushed function: EAlgorithmsAddButton
        function EAlgorithmsAddButtonPushed(app, event)
            % add selected algorithms to selected algorithms tree
            
            algo_selected = app.EAlgorithmsListBox.Value;
            for i= 1:length(algo_selected)
                eval(['algo_obj = ', algo_selected{i}, '("', algo_selected{i}, '");']);
                algo_node = uitreenode(app.EAlgorithmsTree);
                algo_node.Text = algo_obj.getName();
                algo_node.NodeData = algo_obj;
                algo_node.ContextMenu = app.ESelectedAlgoContextMenu;
                
                % child parameter node
                parameter = algo_obj.getParameter();
                for p = 1:2:length(parameter)
                    para_name_node = uitreenode(algo_node);
                    para_name_node.Text = ['[ ', parameter{p}, ' ]'];
                    para_name_node.NodeData = para_name_node.Text;
                    para_name_node.ContextMenu = app.ESelectedAlgoContextMenu;
                    para_value_node = uitreenode(algo_node);
                    para_value_node.Text = parameter{p+1};
                    para_value_node.ContextMenu = app.ESelectedAlgoContextMenu;
                end
            end
        end

        % Menu selected function: ProblemsSelectAllMenu
        function EProblemsContextMenuOpening(app, event)
            % select all problems
            
            if ~isempty(app.EProblemsListBox.Items)
                app.EProblemsListBox.Value = app.EProblemsListBox.Items;
            end
        end

        % Button pushed function: EProblemsAddButton
        function EProblemsAddButtonPushed(app, event)
            % add selected problems to selected problems tree
            
            prob_selected = app.EProblemsListBox.Value;
            for i= 1:length(prob_selected)
                eval(['prob_obj = ', prob_selected{i}, '("',prob_selected{i}, '");']);
                prob_node = uitreenode(app.EProblemsTree);
                prob_node.Text = prob_obj.getName();
                prob_node.NodeData = prob_obj;
                prob_node.ContextMenu = app.ESelectedProbContextMenu;
                
                % child parameter node
                parameter = prob_obj.getParameter();
                for p = 1:2:length(parameter)
                    para_name_node = uitreenode(prob_node);
                    para_name_node.Text = ['[ ', parameter{p}, ' ]'];
                    para_name_node.NodeData = para_name_node.Text;
                    para_name_node.ContextMenu = app.ESelectedProbContextMenu;
                    para_value_node = uitreenode(prob_node);
                    para_value_node.Text = parameter{p+1};
                    para_value_node.ContextMenu = app.ESelectedProbContextMenu;
                end
            end
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
            app.Estop_flag = false;
            
            % read selected algorithms and problems
            algo_cell = {};
            for algo = 1:algo_num
                algo_cell{algo} = app.EAlgorithmsTree.Children(algo).Text;
            end
            prob_cell = {};
            for prob = 1:prob_num
                prob_cell{prob} = app.EProblemsTree.Children(prob).Text;
                tasks_num_list(prob) = length(app.EProblemsTree.Children(prob).NodeData.getTasks());
            end
            
            % clear the temporary data
            app.Edata = [];
            app.EDataTypeDropDown.Value = 'Reps';
            
            % initialize data
            for algo = 1:algo_num
                for prob = 1:prob_num
                    app.Edata.result(prob, algo).clock_time = 0;
                    app.Edata.result(prob, algo).convergence = [];
                end
            end
            % get this experiment's parameters
            switch app.EEndTypeDropDown.Value
                case 'Iteration'
                    iter_num = app.EEndNumEditField.Value;
                    eva_num = inf;
                case 'Evaluation'
                    iter_num = inf;
                    eva_num = app.EEndNumEditField.Value;
            end
            pre_run_list = [app.EPopSizeEditField.Value, iter_num, eva_num];
            app.Edata.reps = 0;
            app.Edata.pop_size = app.EPopSizeEditField.Value;
            app.Edata.iter_num = iter_num;
            app.Edata.eva_num = eva_num;
            app.Edata.algo_cell = algo_cell;
            app.Edata.prob_cell = prob_cell';
            app.Edata.tasks_num_list = tasks_num_list;
            
            % reset table and convergence
            app.Etable_reps = zeros(length(prob_cell), length(algo_cell));
            app.EupdateTableReps();
            app.EresetTable(algo_cell, prob_cell, tasks_num_list);
            app.EresetTableAlgorithmDropDown(algo_cell);
            cla(app.EConvergenceTrendUIAxes, 'reset');
            
            % main experiment loop
            tStart = tic;
            for rep = 1:app.ERepsEditField.Value
                
                for prob = 1:prob_num
                    for algo = 1:algo_num
                        % check pause and stop
                        app.EcheckPauseStopStatus();
                        
                        % run
                        data = singleRun(app.EAlgorithmsTree.Children(algo).NodeData, app.EProblemsTree.Children(prob).NodeData, pre_run_list);
                        app.Edata.result(prob, algo).clock_time = app.Edata.result(prob, algo).clock_time + data.clock_time;
                        % BUG: when p_il ~= 0, convergence vartical not same
                        app.Edata.result(prob, algo).convergence = [app.Edata.result(prob, algo).convergence; data.convergence];
                        
                        app.Etable_reps(prob, algo) = rep;
                        app.EupdateTableReps();
                    end
                end
                app.Edata.reps = rep;
                app.EcalculatePre();
                app.EupdateTable();
                app.EresetConvergenceProblemsDropDown();
                app.EupdateConvergenceAxes();
            end
            
            tEnd = toc(tStart);
            msg = ['All Use Time: ', char(duration([0, 0, tEnd]))];
            uiconfirm(app.MTOPlatformUIFigure, msg, 'success', 'Icon', 'success');
            
            app.EstartEnable(true);
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
            app.Estop_flag = true;
        end

        % Context menu opening function: ESelectedAlgoContextMenu
        function ESelectedAlgoContextMenuOpening(app, event)
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
            if isempty(app.Edata)
                msg = 'Please run experiment first';
                uiconfirm(app.MTOPlatformUIFigure, msg, 'error', 'Icon','warning');
                return;
            end
            
            % check selected file name
            [file_name, dir_name] = uiputfile('data_save.mat');
            figure(app.MTOPlatformUIFigure);
            if file_name == 0
                return;
            end
            
            % save data
            data_save = app.Edata;
            save([dir_name, file_name], 'data_save');
        end

        % Value changed function: EDataTypeDropDown
        function EDataTypeDropDownValueChanged(app, event)
            app.EupdateTable();
        end

        % Value changed function: EShowTypeDropDown
        function EShowTypeDropDownValueChanged(app, event)
            app.EupdateTableFitness();
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

        % Value changed function: EYLimTypeDropDown
        function EYLimTypeDropDownValueChanged(app, event)
            app.EupdateConvergenceAxes();
        end

        % Value changed function: EProblemsDropDown
        function EProblemsDropDownValueChanged(app, event)
            app.EupdateConvergenceAxes();
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
            load([pathname, file_name], 'data_save');
            app.Edata = data_save;
            app.Etable_reps = app.Edata.reps * ones([length(app.Edata.prob_cell), length(app.Edata.algo_cell)]);
            app.EresetTableAlgorithmDropDown(app.Edata.algo_cell);
            app.EcalculatePre();
            app.EupdateTable();
            app.EresetConvergenceProblemsDropDown();
            app.EupdateConvergenceAxes();
        end

        % Button pushed function: ESaveTableButton
        function ESaveTableButtonPushed(app, event)
            % save table
            
            % check selected file name
            filter = {'*.csv';'*.xlsx';'*.txt';'*.*'};
            [file_name, dir_name] = uiputfile(filter);
            figure(app.MTOPlatformUIFigure);
            if file_name == 0
                return;
            end
            row_name = app.EUITable.RowName(1:size(app.EUITable.Data, 1));
            column_name = app.EUITable.ColumnName(1:size(app.EUITable.Data, 2))';
            cell_out = [[{''}; row_name], [column_name; app.EUITable.Data]];
            writecell(cell_out, [dir_name, file_name]);
        end

        % Button pushed function: ESaveAllFigureButton
        function ESaveAllFigureButtonPushed(app, event)
            % save figure to folder
            
            % check data
            if isempty(app.Edata)
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
            draw_obj = drawFigure;
            for prob = 1:length(app.Edata.prob_cell)
                tasks_num = app.Edata.tasks_num_list(prob);
                for task = 1:tasks_num
                    for algo = 1:length(app.Edata.algo_cell)
                        convergence_task = app.Edata.result(prob, algo).convergence(task:tasks_num:end, :);
                        convergence = mean(convergence_task, 1);
                        x_cell{algo} = 1:size(convergence,2);
                        y_cell{algo} = convergence;
                    end
                    switch app.EYLimTypeDropDown.Value
                        case 'log(fitness)'
                            for i = 1:length(y_cell)
                                y_cell{i} = log(y_cell{i});
                            end
                    end
                    draw_obj.setXY(x_cell, y_cell);
                    draw_obj.setXYlabel('Generation', app.EYLimTypeDropDown.Value);
                    draw_obj.setLegend(app.Edata.algo_cell);
                    draw_obj.setTitle([app.Edata.prob_cell{prob}, '_T', num2str(task)]);
                    draw_obj.setSaveDir(fig_dir_name);
                    draw_obj.setFigureType(app.EFigureTypeDropDown.Value);
                    draw_obj.save();
                end
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
                load([pathname, file_name_list{i}], 'data_save');
                app.DputDataNode(file_name_list{i}(1:end-4), data_save);
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
            data_selected = data_selected(app.Ddata_mark == 1);
            
            for i = 1:length(data_selected)
                if data_selected(i).NodeData.reps <= 1
                    msg = ['The ', data_selected(i).Text, '''s reps <= 1'];
                    uiconfirm(app.MTOPlatformUIFigure, msg, 'error', 'Icon','warning');
                    continue;
                end
                for rep = 1:data_selected(i).NodeData.reps
                    data_save.reps = 0;
                    data_save.tasks_num_list = data_selected(i).NodeData.tasks_num_list;
                    data_save.pop_size = data_selected(i).NodeData.pop_size;
                    data_save.iter_num = data_selected(i).NodeData.iter_num;
                    data_save.eva_num = data_selected(i).NodeData.eva_num;
                    data_save.algo_cell = data_selected(i).NodeData.algo_cell;
                    data_save.prob_cell = data_selected(i).NodeData.prob_cell;
                    data_save.reps = 1;
                    data_save.result = [];
                    for prob = 1:length(data_save.prob_cell)
                        task_num = data_selected(i).NodeData.tasks_num_list(prob);
                        for algo = 1:length(data_save.algo_cell)
                            data_save.result(prob, algo).clock_time = data_selected(i).NodeData.result(prob, algo).clock_time / data_selected(i).NodeData.reps;
                            data_save.result(prob, algo).convergence = data_selected(i).NodeData.result(prob, algo).convergence((rep-1)*task_num+1 : rep*task_num, :);
                        end
                    end
                    app.DputDataNode([data_selected(i).Text, ' (Split Rep: ', num2str(rep), ')'], data_save);
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
            data_selected = data_selected(app.Ddata_mark == 1);
            
            for i = 1:length(data_selected)
                if length(data_selected(i).NodeData.algo_cell) <= 1
                    msg = ['The ', data_selected(i).Text, '''s algorithms <= 1'];
                    uiconfirm(app.MTOPlatformUIFigure, msg, 'error', 'Icon','warning');
                    continue;
                end
                for algo = 1:length(data_selected(i).NodeData.algo_cell)
                    data_save.reps = data_selected(i).NodeData.reps;
                    data_save.tasks_num_list = data_selected(i).NodeData.tasks_num_list;
                    data_save.pop_size = data_selected(i).NodeData.pop_size;
                    data_save.iter_num = data_selected(i).NodeData.iter_num;
                    data_save.eva_num = data_selected(i).NodeData.eva_num;
                    data_save.prob_cell = data_selected(i).NodeData.prob_cell;
                    data_save.algo_cell = data_selected(i).NodeData.algo_cell(algo);
                    data_save.result = data_selected(i).NodeData.result(:, algo);
                    
                    app.DputDataNode([data_selected(i).Text, ' (Split Algorithm: ', data_save.algo_cell{1}, ')'], data_save);
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
            data_selected = data_selected(app.Ddata_mark == 1);
            
            for i = 1:length(data_selected)
                if length(data_selected(i).NodeData.prob_cell) <= 1
                    msg = ['The ', data_selected(i).Text, '''s problems <= 1'];
                    uiconfirm(app.MTOPlatformUIFigure, msg, 'error', 'Icon','warning');
                    continue;
                end
                for prob = 1:length(data_selected(i).NodeData.prob_cell)
                    data_save.reps = data_selected(i).NodeData.reps;
                    data_save.pop_size = data_selected(i).NodeData.pop_size;
                    data_save.iter_num = data_selected(i).NodeData.iter_num;
                    data_save.eva_num = data_selected(i).NodeData.eva_num;
                    data_save.algo_cell = data_selected(i).NodeData.algo_cell;
                    data_save.prob_cell = data_selected(i).NodeData.prob_cell(prob);
                    data_save.tasks_num_list = [[], data_selected(i).NodeData.tasks_num_list(prob)];
                    data_save.result = data_selected(i).NodeData.result(prob, :);
                    
                    app.DputDataNode([data_selected(i).Text, ' (Split Problem: ', data_save.prob_cell{1}, ')'], data_save);
                    drawnow;
                end
            end
        end

        % Button pushed function: DRepsMergeButton
        function DRepsMergeButtonPushed(app, event)
            % merge reps, with same pop, iteration, evaluate, algorithms and problems
            
            if ~app.DcheckMergeData() || ~app.DcheckMergeAlgorithms() || ~app.DcheckMergeProblems()
                return;
            end
            
            % merge
            data_selected = app.DDataTree.SelectedNodes;
            data_selected = data_selected(app.Ddata_mark == 1);
            data_save.reps = 0;
            data_save.tasks_num_list = data_selected(1).NodeData.tasks_num_list;
            data_save.pop_size = data_selected(1).NodeData.pop_size;
            data_save.iter_num = data_selected(1).NodeData.iter_num;
            data_save.eva_num = data_selected(1).NodeData.eva_num;
            data_save.algo_cell = data_selected(1).NodeData.algo_cell;
            data_save.prob_cell = data_selected(1).NodeData.prob_cell;
            for prob = 1:length(data_save.prob_cell)
                for algo = 1:length(data_save.algo_cell)
                    data_save.result(prob, algo).clock_time = 0;
                    data_save.result(prob, algo).convergence = [];
                end
            end
            for i = 1:length(data_selected)
                data_save.reps = data_save.reps + data_selected(i).NodeData.reps;
                for prob = 1:length(data_save.prob_cell)
                    for algo = 1:length(data_save.algo_cell)
                        data_save.result(prob, algo).clock_time = data_save.result(prob, algo).clock_time + data_selected(i).NodeData.result(prob, algo).clock_time;
                        % BUG: when p_il ~= 0, convergence vartical not same
                        data_save.result(prob, algo).convergence = [data_save.result(prob, algo).convergence; data_selected(i).NodeData.result(prob, algo).convergence];
                    end
                end
            end
            
            app.DputDataNode('data (Merge Reps)', data_save);
            drawnow;
        end

        % Button pushed function: DAlgorithmsMergeButton
        function DAlgorithmsMergeButtonPushed(app, event)
            % merge algorithms, with same pop, iteration, evaluate, reps and problems
            
            if ~app.DcheckMergeData() || ~app.DcheckMergeReps() || ~app.DcheckMergeProblems()
                return;
            end
            
            % merge
            data_selected = app.DDataTree.SelectedNodes;
            data_selected = data_selected(app.Ddata_mark == 1);
            data_save.reps = data_selected(1).NodeData.reps;
            data_save.tasks_num_list = data_selected(1).NodeData.tasks_num_list;
            data_save.pop_size = data_selected(1).NodeData.pop_size;
            data_save.iter_num = data_selected(1).NodeData.iter_num;
            data_save.eva_num = data_selected(1).NodeData.eva_num;
            data_save.prob_cell = data_selected(1).NodeData.prob_cell;
            data_save.algo_cell = {};
            for i = 1:length(data_selected)
                algo_start = length(data_save.algo_cell) + 1;
                data_save.algo_cell = [data_save.algo_cell, data_selected(i).NodeData.algo_cell];
                algo_end = length(data_save.algo_cell);
                data_save.result(:, algo_start:algo_end) = data_selected(i).NodeData.result;
            end
            
            app.DputDataNode('data (Merge Algorithms)', data_save);
            drawnow;
        end

        % Button pushed function: DProblemsMergeButton
        function DProblemsMergeButtonPushed(app, event)
            % merge problems, with same pop, iteration, evaluate, reps and algorithms
            
            if ~app.DcheckMergeData() || ~app.DcheckMergeReps() || ~app.DcheckMergeAlgorithms()
                return;
            end
            
            % merge
            data_selected = app.DDataTree.SelectedNodes;
            data_selected = data_selected(app.Ddata_mark == 1);
            data_save.reps = data_selected(1).NodeData.reps;
            data_save.pop_size = data_selected(1).NodeData.pop_size;
            data_save.iter_num = data_selected(1).NodeData.iter_num;
            data_save.eva_num = data_selected(1).NodeData.eva_num;
            data_save.algo_cell = data_selected(1).NodeData.algo_cell;
            data_save.prob_cell = {};
            data_save.tasks_num_list = [];
            for i = 1:length(data_selected)
                data_save.tasks_num_list = [data_save.tasks_num_list, data_selected(i).NodeData.tasks_num_list];
                prob_start = length(data_save.prob_cell) + 1;
                data_save.prob_cell = [data_save.prob_cell; data_selected(i).NodeData.prob_cell];
                prob_end = length(data_save.prob_cell);
                data_save.result(prob_start:prob_end, :) = data_selected(i).NodeData.result;
            end
            
            app.DputDataNode('data (Merge Problems)', data_save);
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
            data_selected = app.DDataTree.SelectedNodes;
            data_selected = data_selected(data_mark == 1);
            selected = [];
            
            % move up
            for i = 1:length(data_selected)
                parent = data_selected(i).Parent;
                for j = 1:length(parent.Children)
                    if parent.Children(j) == data_selected(i) && j > 1
                        text = parent.Children(j).Text;
                        nodedata = parent.Children(j).NodeData;
                        parent.Children(j).Text = parent.Children(j-1).Text;
                        parent.Children(j).NodeData = parent.Children(j-1).NodeData;
                        parent.Children(j-1).Text = text;
                        parent.Children(j-1).NodeData = nodedata;
                        selected = [selected, parent.Children(j-1)];
                    elseif parent.Children(j) == data_selected(i) && j == 1
                        selected = [selected, parent.Children(j)];
                    end
                end
            end
            
            % change selected node
            app.DDataTree.SelectedNodes = selected;
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
            data_selected = data_selected(data_mark == 1);
            selected = [];
            
            % move down
            for i = 1:length(data_selected)
                parent = data_selected(i).Parent;
                for j = 1:length(parent.Children)
                    if parent.Children(j) == data_selected(i) && j < length(parent.Children)
                        text = parent.Children(j).Text;
                        nodedata = parent.Children(j).NodeData;
                        parent.Children(j).Text = parent.Children(j+1).Text;
                        parent.Children(j).NodeData = parent.Children(j+1).NodeData;
                        parent.Children(j+1).Text = text;
                        parent.Children(j+1).NodeData = nodedata;
                        selected = [selected, parent.Children(j+1)];
                    elseif parent.Children(j) == data_selected(i) && j == length(parent.Children)
                        selected = [selected, parent.Children(j)];
                    end
                end
            end
            
            % change selected node
            app.DDataTree.SelectedNodes = selected;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create MTOPlatformUIFigure and hide until all components are created
            app.MTOPlatformUIFigure = uifigure('Visible', 'off');
            app.MTOPlatformUIFigure.Color = [1 1 1];
            app.MTOPlatformUIFigure.Position = [100 100 1216 709];
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
            app.TestGridLayout.ColumnWidth = {210, '2.5x', 250};
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
            app.TP1GridLayout.RowHeight = {'fit', 'fit', 'fit', 'fit', '1x', 'fit', '1x'};
            app.TP1GridLayout.ColumnSpacing = 5;
            app.TP1GridLayout.Padding = [5 5 5 5];
            app.TP1GridLayout.BackgroundColor = [1 1 1];

            % Create TPopSizeEditField
            app.TPopSizeEditField = uieditfield(app.TP1GridLayout, 'numeric');
            app.TPopSizeEditField.HorizontalAlignment = 'center';
            app.TPopSizeEditField.Layout.Row = 1;
            app.TPopSizeEditField.Layout.Column = 2;
            app.TPopSizeEditField.Value = 100;

            % Create TPopSizeEditFieldLabel
            app.TPopSizeEditFieldLabel = uilabel(app.TP1GridLayout);
            app.TPopSizeEditFieldLabel.FontWeight = 'bold';
            app.TPopSizeEditFieldLabel.Layout.Row = 1;
            app.TPopSizeEditFieldLabel.Layout.Column = 1;
            app.TPopSizeEditFieldLabel.Text = 'Pop Size';

            % Create TEndNumEditField
            app.TEndNumEditField = uieditfield(app.TP1GridLayout, 'numeric');
            app.TEndNumEditField.HorizontalAlignment = 'center';
            app.TEndNumEditField.Layout.Row = 3;
            app.TEndNumEditField.Layout.Column = 2;
            app.TEndNumEditField.Value = 100;

            % Create TEndNumEditFieldLabel
            app.TEndNumEditFieldLabel = uilabel(app.TP1GridLayout);
            app.TEndNumEditFieldLabel.FontWeight = 'bold';
            app.TEndNumEditFieldLabel.Layout.Row = 3;
            app.TEndNumEditFieldLabel.Layout.Column = 1;
            app.TEndNumEditFieldLabel.Text = 'End Num';

            % Create AlgorithmDropDownLabel
            app.AlgorithmDropDownLabel = uilabel(app.TP1GridLayout);
            app.AlgorithmDropDownLabel.FontWeight = 'bold';
            app.AlgorithmDropDownLabel.Layout.Row = 4;
            app.AlgorithmDropDownLabel.Layout.Column = 1;
            app.AlgorithmDropDownLabel.Text = 'Algorithm';

            % Create TAlgorithmDropDown
            app.TAlgorithmDropDown = uidropdown(app.TP1GridLayout);
            app.TAlgorithmDropDown.Items = {};
            app.TAlgorithmDropDown.ValueChangedFcn = createCallbackFcn(app, @TAlgorithmDropDownValueChanged, true);
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
            app.TProblemDropDown.ValueChangedFcn = createCallbackFcn(app, @TProblemDropDownValueChanged, true);
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

            % Create EndTypeLabel_2
            app.EndTypeLabel_2 = uilabel(app.TP1GridLayout);
            app.EndTypeLabel_2.FontWeight = 'bold';
            app.EndTypeLabel_2.Layout.Row = 2;
            app.EndTypeLabel_2.Layout.Column = 1;
            app.EndTypeLabel_2.Text = 'End Type';

            % Create TEndTypeDropDown
            app.TEndTypeDropDown = uidropdown(app.TP1GridLayout);
            app.TEndTypeDropDown.Items = {'Iteration', 'Evaluation'};
            app.TEndTypeDropDown.BackgroundColor = [1 1 1];
            app.TEndTypeDropDown.Layout.Row = 2;
            app.TEndTypeDropDown.Layout.Column = 2;
            app.TEndTypeDropDown.Value = 'Iteration';

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
            app.TP21GridLayout.ColumnWidth = {'1x', 'fit'};
            app.TP21GridLayout.RowHeight = {'1x'};
            app.TP21GridLayout.ColumnSpacing = 5;
            app.TP21GridLayout.Padding = [0 0 0 0];
            app.TP21GridLayout.Layout.Row = 1;
            app.TP21GridLayout.Layout.Column = 1;
            app.TP21GridLayout.BackgroundColor = [1 1 1];

            % Create TShowTypeDropDown
            app.TShowTypeDropDown = uidropdown(app.TP21GridLayout);
            app.TShowTypeDropDown.Items = {'Tasks Figure (1D)', 'Convergence'};
            app.TShowTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @TShowTypeDropDownValueChanged, true);
            app.TShowTypeDropDown.FontWeight = 'bold';
            app.TShowTypeDropDown.BackgroundColor = [1 1 1];
            app.TShowTypeDropDown.Layout.Row = 1;
            app.TShowTypeDropDown.Layout.Column = 2;
            app.TShowTypeDropDown.Value = 'Tasks Figure (1D)';

            % Create TP24GridLayout
            app.TP24GridLayout = uigridlayout(app.TP2GridLayout);
            app.TP24GridLayout.ColumnWidth = {'1x', 70, '1x'};
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
            app.TStartButton.Layout.Row = 1;
            app.TStartButton.Layout.Column = 2;
            app.TStartButton.Text = 'Start';

            % Create TUIAxes
            app.TUIAxes = uiaxes(app.TP2GridLayout);
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
            app.TP3GridLayout.RowHeight = {'fit', '1x'};
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

            % Create ExperimentTab
            app.ExperimentTab = uitab(app.MTOPlatformTabGroup);
            app.ExperimentTab.Title = 'Experiment';
            app.ExperimentTab.BackgroundColor = [1 1 1];

            % Create ExperimentsGridLayout
            app.ExperimentsGridLayout = uigridlayout(app.ExperimentTab);
            app.ExperimentsGridLayout.ColumnWidth = {170, 210, '1.3x'};
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
            app.EP3T1GridLayout.ColumnWidth = {'fit', '1x', 'fit', 'fit', 'fit', 'fit', 'fit'};
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
            app.ETestTypeDropDown.BackgroundColor = [1 1 1];
            app.ETestTypeDropDown.Layout.Row = 1;
            app.ETestTypeDropDown.Layout.Column = 5;
            app.ETestTypeDropDown.Value = 'None';

            % Create EAlgorithmDropDown
            app.EAlgorithmDropDown = uidropdown(app.EP3T1GridLayout);
            app.EAlgorithmDropDown.Items = {'Algorithm'};
            app.EAlgorithmDropDown.ValueChangedFcn = createCallbackFcn(app, @EAlgorithmDropDownValueChanged, true);
            app.EAlgorithmDropDown.BackgroundColor = [1 1 1];
            app.EAlgorithmDropDown.Layout.Row = 1;
            app.EAlgorithmDropDown.Layout.Column = 6;
            app.EAlgorithmDropDown.Value = 'Algorithm';

            % Create EShowTypeDropDown
            app.EShowTypeDropDown = uidropdown(app.EP3T1GridLayout);
            app.EShowTypeDropDown.Items = {'Mean', 'Mean (Std)', 'Median', 'Median (Std)'};
            app.EShowTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @EShowTypeDropDownValueChanged, true);
            app.EShowTypeDropDown.BackgroundColor = [1 1 1];
            app.EShowTypeDropDown.Layout.Row = 1;
            app.EShowTypeDropDown.Layout.Column = 4;
            app.EShowTypeDropDown.Value = 'Mean';

            % Create EDataTypeDropDown
            app.EDataTypeDropDown = uidropdown(app.EP3T1GridLayout);
            app.EDataTypeDropDown.Items = {'Reps', 'Fitness', 'Time used'};
            app.EDataTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @EDataTypeDropDownValueChanged, true);
            app.EDataTypeDropDown.BackgroundColor = [1 1 1];
            app.EDataTypeDropDown.Layout.Row = 1;
            app.EDataTypeDropDown.Layout.Column = 3;
            app.EDataTypeDropDown.Value = 'Reps';

            % Create EHighlightTypeDropDown
            app.EHighlightTypeDropDown = uidropdown(app.EP3T1GridLayout);
            app.EHighlightTypeDropDown.Items = {'None', 'Highlight best', 'Highlight best worst'};
            app.EHighlightTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @EHighlightTypeDropDownValueChanged, true);
            app.EHighlightTypeDropDown.BackgroundColor = [1 1 1];
            app.EHighlightTypeDropDown.Layout.Row = 1;
            app.EHighlightTypeDropDown.Layout.Column = 7;
            app.EHighlightTypeDropDown.Value = 'None';

            % Create ESaveTableButton
            app.ESaveTableButton = uibutton(app.EP3T1GridLayout, 'push');
            app.ESaveTableButton.ButtonPushedFcn = createCallbackFcn(app, @ESaveTableButtonPushed, true);
            app.ESaveTableButton.BackgroundColor = [0.702 1 0.702];
            app.ESaveTableButton.FontWeight = 'bold';
            app.ESaveTableButton.Layout.Row = 1;
            app.ESaveTableButton.Layout.Column = 1;
            app.ESaveTableButton.Text = 'Save';

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
            app.EP3F1GridLayout.ColumnWidth = {'fit', '1x', 'fit', 'fit', 'fit'};
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
            app.EProblemsDropDown.BackgroundColor = [1 1 1];
            app.EProblemsDropDown.Layout.Row = 1;
            app.EProblemsDropDown.Layout.Column = 5;
            app.EProblemsDropDown.Value = 'Problem ';

            % Create EYLimTypeDropDown
            app.EYLimTypeDropDown = uidropdown(app.EP3F1GridLayout);
            app.EYLimTypeDropDown.Items = {'log(fitness)', 'fitness'};
            app.EYLimTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @EYLimTypeDropDownValueChanged, true);
            app.EYLimTypeDropDown.BackgroundColor = [1 1 1];
            app.EYLimTypeDropDown.Layout.Row = 1;
            app.EYLimTypeDropDown.Layout.Column = 4;
            app.EYLimTypeDropDown.Value = 'log(fitness)';

            % Create ESaveAllFigureButton
            app.ESaveAllFigureButton = uibutton(app.EP3F1GridLayout, 'push');
            app.ESaveAllFigureButton.ButtonPushedFcn = createCallbackFcn(app, @ESaveAllFigureButtonPushed, true);
            app.ESaveAllFigureButton.BackgroundColor = [0.702 1 0.702];
            app.ESaveAllFigureButton.FontWeight = 'bold';
            app.ESaveAllFigureButton.Layout.Row = 1;
            app.ESaveAllFigureButton.Layout.Column = 1;
            app.ESaveAllFigureButton.Text = 'Save All Figure';

            % Create EFigureTypeDropDown
            app.EFigureTypeDropDown = uidropdown(app.EP3F1GridLayout);
            app.EFigureTypeDropDown.Items = {'eps', 'png', 'pdf'};
            app.EFigureTypeDropDown.BackgroundColor = [1 1 1];
            app.EFigureTypeDropDown.Layout.Row = 1;
            app.EFigureTypeDropDown.Layout.Column = 3;
            app.EFigureTypeDropDown.Value = 'eps';

            % Create EConvergenceTrendUIAxes
            app.EConvergenceTrendUIAxes = uiaxes(app.EP3FGridLayout);
            xlabel(app.EConvergenceTrendUIAxes, 'Iteration')
            ylabel(app.EConvergenceTrendUIAxes, 'fitness')
            app.EConvergenceTrendUIAxes.Layout.Row = 2;
            app.EConvergenceTrendUIAxes.Layout.Column = 1;

            % Create EPanel1
            app.EPanel1 = uipanel(app.ExperimentsGridLayout);
            app.EPanel1.BackgroundColor = [1 1 1];
            app.EPanel1.Layout.Row = 1;
            app.EPanel1.Layout.Column = 1;

            % Create EP1GridLayout
            app.EP1GridLayout = uigridlayout(app.EPanel1);
            app.EP1GridLayout.ColumnWidth = {'fit', '1x', 70};
            app.EP1GridLayout.RowHeight = {'fit', 'fit', 'fit', 'fit', 'fit', 'fit', 'fit', '1x', 'fit', '1x'};
            app.EP1GridLayout.ColumnSpacing = 5;
            app.EP1GridLayout.Padding = [5 5 5 5];
            app.EP1GridLayout.BackgroundColor = [1 1 1];

            % Create EProblemsAddButton
            app.EProblemsAddButton = uibutton(app.EP1GridLayout, 'push');
            app.EProblemsAddButton.ButtonPushedFcn = createCallbackFcn(app, @EProblemsAddButtonPushed, true);
            app.EProblemsAddButton.VerticalAlignment = 'top';
            app.EProblemsAddButton.BackgroundColor = [0.702 1 0.702];
            app.EProblemsAddButton.FontWeight = 'bold';
            app.EProblemsAddButton.Layout.Row = 9;
            app.EProblemsAddButton.Layout.Column = 3;
            app.EProblemsAddButton.Text = 'Add';

            % Create EAlgorithmsAddButton
            app.EAlgorithmsAddButton = uibutton(app.EP1GridLayout, 'push');
            app.EAlgorithmsAddButton.ButtonPushedFcn = createCallbackFcn(app, @EAlgorithmsAddButtonPushed, true);
            app.EAlgorithmsAddButton.VerticalAlignment = 'top';
            app.EAlgorithmsAddButton.BackgroundColor = [0.702 1 0.702];
            app.EAlgorithmsAddButton.FontWeight = 'bold';
            app.EAlgorithmsAddButton.Layout.Row = 7;
            app.EAlgorithmsAddButton.Layout.Column = 3;
            app.EAlgorithmsAddButton.Text = 'Add';

            % Create ERepsEditField
            app.ERepsEditField = uieditfield(app.EP1GridLayout, 'numeric');
            app.ERepsEditField.HorizontalAlignment = 'center';
            app.ERepsEditField.Layout.Row = 3;
            app.ERepsEditField.Layout.Column = [2 3];
            app.ERepsEditField.Value = 20;

            % Create ERunTimesEditFieldLabel
            app.ERunTimesEditFieldLabel = uilabel(app.EP1GridLayout);
            app.ERunTimesEditFieldLabel.FontWeight = 'bold';
            app.ERunTimesEditFieldLabel.Layout.Row = 3;
            app.ERunTimesEditFieldLabel.Layout.Column = 1;
            app.ERunTimesEditFieldLabel.Text = 'Run Times';

            % Create EEndNumEditField
            app.EEndNumEditField = uieditfield(app.EP1GridLayout, 'numeric');
            app.EEndNumEditField.HorizontalAlignment = 'center';
            app.EEndNumEditField.Layout.Row = 6;
            app.EEndNumEditField.Layout.Column = [2 3];
            app.EEndNumEditField.Value = 1000;

            % Create EEndNumEditFieldLabel
            app.EEndNumEditFieldLabel = uilabel(app.EP1GridLayout);
            app.EEndNumEditFieldLabel.FontWeight = 'bold';
            app.EEndNumEditFieldLabel.Layout.Row = 6;
            app.EEndNumEditFieldLabel.Layout.Column = 1;
            app.EEndNumEditFieldLabel.Text = 'End Num';

            % Create EPopSizeEditField
            app.EPopSizeEditField = uieditfield(app.EP1GridLayout, 'numeric');
            app.EPopSizeEditField.HorizontalAlignment = 'center';
            app.EPopSizeEditField.Layout.Row = 4;
            app.EPopSizeEditField.Layout.Column = [2 3];
            app.EPopSizeEditField.Value = 100;

            % Create EPopSizeEditFieldLabel
            app.EPopSizeEditFieldLabel = uilabel(app.EP1GridLayout);
            app.EPopSizeEditFieldLabel.FontWeight = 'bold';
            app.EPopSizeEditFieldLabel.Layout.Row = 4;
            app.EPopSizeEditFieldLabel.Layout.Column = 1;
            app.EPopSizeEditFieldLabel.Text = 'Pop Size';

            % Create EAlgorithmsListBox
            app.EAlgorithmsListBox = uilistbox(app.EP1GridLayout);
            app.EAlgorithmsListBox.Items = {};
            app.EAlgorithmsListBox.Multiselect = 'on';
            app.EAlgorithmsListBox.Layout.Row = 8;
            app.EAlgorithmsListBox.Layout.Column = [1 3];
            app.EAlgorithmsListBox.Value = {};

            % Create AlgorithmsListBox_2Label
            app.AlgorithmsListBox_2Label = uilabel(app.EP1GridLayout);
            app.AlgorithmsListBox_2Label.FontWeight = 'bold';
            app.AlgorithmsListBox_2Label.Layout.Row = 7;
            app.AlgorithmsListBox_2Label.Layout.Column = 1;
            app.AlgorithmsListBox_2Label.Text = 'Algorithms';

            % Create EProblemsListBox
            app.EProblemsListBox = uilistbox(app.EP1GridLayout);
            app.EProblemsListBox.Items = {};
            app.EProblemsListBox.Multiselect = 'on';
            app.EProblemsListBox.Layout.Row = 10;
            app.EProblemsListBox.Layout.Column = [1 3];
            app.EProblemsListBox.Value = {};

            % Create ProblemsListBox_2Label
            app.ProblemsListBox_2Label = uilabel(app.EP1GridLayout);
            app.ProblemsListBox_2Label.FontWeight = 'bold';
            app.ProblemsListBox_2Label.Layout.Row = 9;
            app.ProblemsListBox_2Label.Layout.Column = 1;
            app.ProblemsListBox_2Label.Text = 'Problems';

            % Create EndTypeLabel
            app.EndTypeLabel = uilabel(app.EP1GridLayout);
            app.EndTypeLabel.FontWeight = 'bold';
            app.EndTypeLabel.Layout.Row = 5;
            app.EndTypeLabel.Layout.Column = 1;
            app.EndTypeLabel.Text = 'End Type';

            % Create EEndTypeDropDown
            app.EEndTypeDropDown = uidropdown(app.EP1GridLayout);
            app.EEndTypeDropDown.Items = {'Iteration', 'Evaluation'};
            app.EEndTypeDropDown.BackgroundColor = [1 1 1];
            app.EEndTypeDropDown.Layout.Row = 5;
            app.EEndTypeDropDown.Layout.Column = [2 3];
            app.EEndTypeDropDown.Value = 'Iteration';

            % Create ELoadDataButton
            app.ELoadDataButton = uibutton(app.EP1GridLayout, 'push');
            app.ELoadDataButton.ButtonPushedFcn = createCallbackFcn(app, @ELoadDataButtonPushed, true);
            app.ELoadDataButton.BackgroundColor = [0.502 0.702 1];
            app.ELoadDataButton.FontWeight = 'bold';
            app.ELoadDataButton.Layout.Row = 1;
            app.ELoadDataButton.Layout.Column = [1 3];
            app.ELoadDataButton.Text = 'Load Data';

            % Create ESaveDataButton
            app.ESaveDataButton = uibutton(app.EP1GridLayout, 'push');
            app.ESaveDataButton.ButtonPushedFcn = createCallbackFcn(app, @ESaveDataButtonPushed, true);
            app.ESaveDataButton.BackgroundColor = [0.702 1 0.702];
            app.ESaveDataButton.FontWeight = 'bold';
            app.ESaveDataButton.Layout.Row = 2;
            app.ESaveDataButton.Layout.Column = [1 3];
            app.ESaveDataButton.Text = 'Save Data';

            % Create EPanel2
            app.EPanel2 = uipanel(app.ExperimentsGridLayout);
            app.EPanel2.BackgroundColor = [1 1 1];
            app.EPanel2.Layout.Row = 1;
            app.EPanel2.Layout.Column = 2;

            % Create EP2GridLayout
            app.EP2GridLayout = uigridlayout(app.EPanel2);
            app.EP2GridLayout.ColumnWidth = {'2x', 70};
            app.EP2GridLayout.RowHeight = {'fit', 'fit', 'fit', 'fit', '1x', 'fit', '1x'};
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
            app.ESelectedAlgorithmsLabel.Text = 'Selected Algorithms';

            % Create ESelectedProblemsLabel
            app.ESelectedProblemsLabel = uilabel(app.EP2GridLayout);
            app.ESelectedProblemsLabel.FontWeight = 'bold';
            app.ESelectedProblemsLabel.Layout.Row = 6;
            app.ESelectedProblemsLabel.Layout.Column = 1;
            app.ESelectedProblemsLabel.Text = 'Selected Problems';

            % Create EAlgorithmsDelButton
            app.EAlgorithmsDelButton = uibutton(app.EP2GridLayout, 'push');
            app.EAlgorithmsDelButton.ButtonPushedFcn = createCallbackFcn(app, @EAlgorithmsDelButtonPushed, true);
            app.EAlgorithmsDelButton.BackgroundColor = [1 1 0.702];
            app.EAlgorithmsDelButton.FontWeight = 'bold';
            app.EAlgorithmsDelButton.Layout.Row = 4;
            app.EAlgorithmsDelButton.Layout.Column = 2;
            app.EAlgorithmsDelButton.Text = 'Delete';

            % Create EProblemsDelButton
            app.EProblemsDelButton = uibutton(app.EP2GridLayout, 'push');
            app.EProblemsDelButton.ButtonPushedFcn = createCallbackFcn(app, @EProblemsDelButtonPushed, true);
            app.EProblemsDelButton.BackgroundColor = [1 1 0.702];
            app.EProblemsDelButton.FontWeight = 'bold';
            app.EProblemsDelButton.Layout.Row = 6;
            app.EProblemsDelButton.Layout.Column = 2;
            app.EProblemsDelButton.Text = 'Delete';

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

            % Create ESelectedAlgoContextMenu
            app.ESelectedAlgoContextMenu = uicontextmenu(app.MTOPlatformUIFigure);
            app.ESelectedAlgoContextMenu.ContextMenuOpeningFcn = createCallbackFcn(app, @ESelectedAlgoContextMenuOpening, true);
            
            % Assign app.ESelectedAlgoContextMenu
            app.TAlgorithmTree.ContextMenu = app.ESelectedAlgoContextMenu;
            app.EAlgorithmsTree.ContextMenu = app.ESelectedAlgoContextMenu;

            % Create SelectedAlgoSelectAllMenu
            app.SelectedAlgoSelectAllMenu = uimenu(app.ESelectedAlgoContextMenu);
            app.SelectedAlgoSelectAllMenu.Text = 'Select All';

            % Create DDataContextMenu
            app.DDataContextMenu = uicontextmenu(app.MTOPlatformUIFigure);
            app.DDataContextMenu.ContextMenuOpeningFcn = createCallbackFcn(app, @DDataContextMenuOpening, true);
            
            % Assign app.DDataContextMenu
            app.DDataTree.ContextMenu = app.DDataContextMenu;

            % Create SelectedAlgoSelectAllMenu_2
            app.SelectedAlgoSelectAllMenu_2 = uimenu(app.DDataContextMenu);
            app.SelectedAlgoSelectAllMenu_2.Text = 'Select All';

            % Create ESelectedProbContextMenu
            app.ESelectedProbContextMenu = uicontextmenu(app.MTOPlatformUIFigure);
            
            % Assign app.ESelectedProbContextMenu
            app.TProblemTree.ContextMenu = app.ESelectedProbContextMenu;
            app.EProblemsTree.ContextMenu = app.ESelectedProbContextMenu;

            % Create SelectedProbSelectAllMenu
            app.SelectedProbSelectAllMenu = uimenu(app.ESelectedProbContextMenu);
            app.SelectedProbSelectAllMenu.MenuSelectedFcn = createCallbackFcn(app, @ESelectedProbContextMenuOpening, true);
            app.SelectedProbSelectAllMenu.Text = 'Select All';

            % Create EAlgorithmsContextMenu
            app.EAlgorithmsContextMenu = uicontextmenu(app.MTOPlatformUIFigure);
            app.EAlgorithmsContextMenu.ContextMenuOpeningFcn = createCallbackFcn(app, @EAlgorithmsContextMenuOpening, true);
            
            % Assign app.EAlgorithmsContextMenu
            app.EAlgorithmsListBox.ContextMenu = app.EAlgorithmsContextMenu;

            % Create AlgorithmsSelectAllMenu
            app.AlgorithmsSelectAllMenu = uimenu(app.EAlgorithmsContextMenu);
            app.AlgorithmsSelectAllMenu.Text = 'Select All';

            % Create EProblemsContextMenu
            app.EProblemsContextMenu = uicontextmenu(app.MTOPlatformUIFigure);
            
            % Assign app.EProblemsContextMenu
            app.EProblemsListBox.ContextMenu = app.EProblemsContextMenu;

            % Create ProblemsSelectAllMenu
            app.ProblemsSelectAllMenu = uimenu(app.EProblemsContextMenu);
            app.ProblemsSelectAllMenu.MenuSelectedFcn = createCallbackFcn(app, @EProblemsContextMenuOpening, true);
            app.ProblemsSelectAllMenu.Text = 'Select All';

            % Show the figure after all components are created
            app.MTOPlatformUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = MTO_Platform_exported

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