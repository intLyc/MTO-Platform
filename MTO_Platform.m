classdef MTO_Platform < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        MTOPlatformUIFigure        matlab.ui.Figure
        GridLayout                 matlab.ui.container.GridLayout
        Panel_1                    matlab.ui.container.Panel
        GridLayout3                matlab.ui.container.GridLayout
        ProblemsAddButton          matlab.ui.control.Button
        AlgorithmsAddButton        matlab.ui.control.Button
        RepsEditField              matlab.ui.control.NumericEditField
        RunTimesEditFieldLabel     matlab.ui.control.Label
        EndNumEditField            matlab.ui.control.NumericEditField
        EndNumEditFieldLabel       matlab.ui.control.Label
        PopSizeEditField           matlab.ui.control.NumericEditField
        PopSizeEditFieldLabel      matlab.ui.control.Label
        AlgorithmsListBox          matlab.ui.control.ListBox
        AlgorithmsListBoxLabel     matlab.ui.control.Label
        ProblemsListBox            matlab.ui.control.ListBox
        ProblemsListBoxLabel       matlab.ui.control.Label
        ButtonGroup                matlab.ui.container.ButtonGroup
        IterationButton            matlab.ui.control.RadioButton
        EvaluationButton           matlab.ui.control.RadioButton
        EndConditionLabel          matlab.ui.control.Label
        Panel_2                    matlab.ui.container.Panel
        GridLayout2                matlab.ui.container.GridLayout
        StartButton                matlab.ui.control.Button
        PauseButton                matlab.ui.control.Button
        StopButton                 matlab.ui.control.Button
        AlgorithmsTree             matlab.ui.container.Tree
        ProblemsTree               matlab.ui.container.Tree
        SelectedAlgoLabel          matlab.ui.control.Label
        SelectedProbLabel          matlab.ui.control.Label
        AlgorithmsDelButton        matlab.ui.control.Button
        ProblemsDelButton          matlab.ui.control.Button
        Panel_3                    matlab.ui.container.Panel
        GridLayout5                matlab.ui.container.GridLayout
        TabGroup                   matlab.ui.container.TabGroup
        FitnessTab                 matlab.ui.container.Tab
        GridLayout8_2              matlab.ui.container.GridLayout
        FitnessUITable             matlab.ui.control.Table
        ScoreTab                   matlab.ui.container.Tab
        GridLayout8_3              matlab.ui.container.GridLayout
        ScoreUITable               matlab.ui.control.Table
        TimeUsedTab                matlab.ui.container.Tab
        GridLayout8                matlab.ui.container.GridLayout
        TimeUITable                matlab.ui.control.Table
        Panel_4                    matlab.ui.container.Panel
        GridLayout6                matlab.ui.container.GridLayout
        LogsTextAreaLabel          matlab.ui.control.Label
        LogsTextArea               matlab.ui.control.TextArea
        LogsClearButton            matlab.ui.control.Button
        SaveResultButton           matlab.ui.control.Button
        FigureTypeEditFieldLabel   matlab.ui.control.Label
        FigureTypeEditField        matlab.ui.control.EditField
        LoadDataButton             matlab.ui.control.Button
        SelectedAlgoContextMenu    matlab.ui.container.ContextMenu
        SelectedAlgoSelectAllMenu  matlab.ui.container.Menu
        SelectedProbContextMenu    matlab.ui.container.ContextMenu
        SelectedProbSelectAllMenu  matlab.ui.container.Menu
        AlgorithmsContextMenu      matlab.ui.container.ContextMenu
        AlgorithmsSelectAllMenu    matlab.ui.container.Menu
        ProblemsContextMenu        matlab.ui.container.ContextMenu
        ProblemsSelectAllMenu      matlab.ui.container.Menu
    end

    
    properties (Access = public)
        reps
        pop_size
        end_num
        result
        stop_flag
        algo_cell
        prob_cell
        tasks_num_list
        data
    end
    
    methods (Access = public)
        
        function printlog(app, str)
            if strcmp(app.LogsTextArea.Value, '')
                app.LogsTextArea.Value = str;
            else
                app.LogsTextArea.Value = [app.LogsTextArea.Value; str];
            end
            drawnow;
            scroll(app.LogsTextArea, 'bottom');
        end
        
        function loadAlgoProb(app)
            % load the algorithms and problems to list
            app.AlgorithmsListBox.Items(:) = [];
            app.ProblemsListBox.Items(:) = [];
            algo_load = {};
            prob_load = {};
            algo_dir = dir('Algorithms/*m');
            prob_dir = dir('Problems/*.m');
            
            % Algorithms name is folder's name
            for i=1:length(algo_dir)
                algo_load  = [algo_load, algo_dir(i).name(1:end-2)];
            end
            algo_load(strcmp(algo_load, 'Algorithm')) = [];
            app.AlgorithmsListBox.Items = algo_load;
            
            % Problems name is .m files name
            for i=1:length(prob_dir)
                prob_load  = [prob_load, prob_dir(i).name(1:end-2)];
            end
            prob_load(strcmp(prob_load, 'Problem')) = [];
            app.ProblemsListBox.Items = prob_load;
        end
        
        function checkPauseStopStatus(app)
            % This function can be called at any time to check that status of the pause and stop buttons.
            % If paused, it will wait until un-paused.
            % If stopped, it will throw an error to break execution. The error will not be thrown.
            
            if app.stop_flag
                app.StartButton.Enable = true;
                error('User Stop')
            end
            
            if strcmp(app.PauseButton.Text, 'Resume')
                waitfor(app.PauseButton,'Text', 'Pause')
            end
        end
        
        function updateTable(app)
            for algo = 1:app.algo_cell
                for prob = 1:app.prob_cell
                    
                end
            end
        end
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            % add path
            addpath(genpath('./Algorithms/'));
            addpath(genpath('./Problems/'));
            addpath(genpath('./Utils/'));
            
            app.loadAlgoProb();
            
            % read default value
            app.reps = app.RepsEditField.Value;
            app.pop_size = app.PopSizeEditField.Value;
            app.end_num = app.EndNumEditField.Value;
        end

        % Button pushed function: StartButton
        function StartButtonPushed(app, event)
            % off the start button
            app.StartButton.Enable = false;
            app.stop_flag = false;
            
            algo_num = length(app.AlgorithmsTree.Children);
            prob_num = length(app.ProblemsTree.Children);
            
            if algo_num == 0
                app.printlog('!!! Please select the Algorithm first !!!');
                app.StartButton.Enable = true;
                return;
            end
            if prob_num ==0
                app.printlog('!!! Please select the Problem first !!!');
                app.StartButton.Enable = true;
                return;
            end
            
            % initialize the result properties
            for algo = 1:algo_num
                for prob = 1:prob_num
                    app.result(prob, algo).clock_time = 0;
                    app.result(prob, algo).convergence = [];
                end
            end
            
            for algo = 1:algo_num
                app.algo_cell{algo} = app.AlgorithmsTree.Children(algo).Text;
            end
            
            for prob = 1:prob_num
                app.prob_cell{prob} = app.ProblemsTree.Children(prob).Text;
                app.tasks_num_list(prob) = app.ProblemsTree.Children(prob).NodeData.getTasksNumber();
            end
            
            % main test loop
            app.printlog([newline, '#========= Test Start =========#'])
            tStart = tic;
            for rep = 1:app.reps
                app.printlog(['<========== Rep: ', num2str(rep), ' ==========>']);
                for prob = 1:prob_num
                    app.printlog(['-------- Problem: ', app.ProblemsTree.Children(prob).Text, ' --------']);
                    for algo = 1:algo_num
                        % check pause and stop
                        app.checkPauseStopStatus();
                        
                        app.printlog([app.AlgorithmsTree.Children(algo).Text, ' is running']);
                        if app.IterationButton.Value
                            iter_num = app.end_num;
                            eva_num = inf;
                        elseif app.EvaluationButton.Value
                            iter_num = inf;
                            eva_num = app.end_num;
                        end
                        pre_run_list = [app.pop_size, iter_num, eva_num];
                        data = singleRun(app.AlgorithmsTree.Children(algo).NodeData, app.ProblemsTree.Children(prob).NodeData, pre_run_list);
                        app.result(prob, algo).clock_time = app.result(prob, algo).clock_time + data.clock_time;
                        app.result(prob, algo).convergence = [app.result(prob, algo).convergence; data.convergence];
                    end
                end
            end
            
            tEnd = toc(tStart);
            app.printlog(['<------ All Use Time: ', char(duration([0, 0, tEnd])), ' ------>']);
            app.printlog(['#======== Test Finished ========#', newline]);
            
            % save data
            app.data.reps = app.reps;
            app.data.tasks_num_list = app.tasks_num_list;
            app.data.pop_size = app.pop_size;
            app.data.iter_num = iter_num;
            app.data.eva_num = eva_num;
            app.data.algo_cell = app.algo_cell;
            app.data.prob_cell = app.prob_cell';
            app.data.result = app.result;
            data_save = app.data;
            save('./data_save', 'data_save');
            
            app.StartButton.Enable = true;
        end

        % Button pushed function: AlgorithmsAddButton
        function AlgorithmsAddButtonPushed(app, event)
            algo_selected = app.AlgorithmsListBox.Value;
            for i= 1:length(algo_selected)
                eval(['algo_obj = ', algo_selected{i}, '("',algo_selected{i}, '");']);
                algo_node = uitreenode(app.AlgorithmsTree);
                algo_node.Text = algo_obj.getName();
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
        end

        % Button pushed function: ProblemsAddButton
        function ProblemsAddButtonPushed(app, event)
            prob_selected = app.ProblemsListBox.Value;
            for i= 1:length(prob_selected)
                eval(['prob_obj = ', prob_selected{i}, '("',prob_selected{i}, '");']);
                prob_node = uitreenode(app.ProblemsTree);
                prob_node.Text = prob_obj.getName();
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
        end

        % Button pushed function: AlgorithmsDelButton
        function AlgorithmsDelButtonPushed(app, event)
            algo_selected = app.AlgorithmsTree.SelectedNodes;
            for i = 1:length(algo_selected)
                if isa(algo_selected(i).Parent, 'matlab.ui.container.Tree')
                    algo_selected(i).delete;
                end
            end
        end

        % Button pushed function: ProblemsDelButton
        function ProblemsDelButtonPushed(app, event)
            prob_selected = app.ProblemsTree.SelectedNodes;
            for i = 1:length(prob_selected)
                if isa(prob_selected(i).Parent, 'matlab.ui.container.Tree')
                    prob_selected(i).delete;
                end
            end
        end

        % Button pushed function: PauseButton
        function PauseButtonPushed(app, event)
            if strcmp(app.PauseButton.Text, 'Pause')
                app.StopButton.Enable = 'off';
                app.PauseButton.Text = 'Resume';
                app.printlog('########### Paused! ###########');
            else
                app.StopButton.Enable = 'on';
                app.PauseButton.Text = 'Pause';
                app.printlog('########## Resumed! ##########');
            end
        end

        % Button pushed function: StopButton
        function StopButtonPushed(app, event)
            app.stop_flag = true;
            app.printlog('#======== Test Stopped ========#');
        end

        % Button pushed function: LogsClearButton
        function LogsClearButtonPushed(app, event)
            app.LogsTextArea.Value = '';
        end

        % Value changed function: RepsEditField
        function RepsEditFieldValueChanged(app, event)
            app.reps = app.RepsEditField.Value;
        end

        % Value changed function: PopSizeEditField
        function PopSizeEditFieldValueChanged(app, event)
            app.pop_size = app.PopSizeEditField.Value;
        end

        % Value changed function: EndNumEditField
        function EndNumEditFieldValueChanged(app, event)
            app.end_num = app.EndNumEditField.Value;
        end

        % Node text changed function: AlgorithmsTree
        function AlgorithmsTreeNodeTextChanged(app, event)
            node = event.Node;
            if isa(node.Parent, 'matlab.ui.container.Tree')
                % Algorithm node
                node.NodeData.name = node.Text;
            else
                % Parameter node
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

        % Node text changed function: ProblemsTree
        function ProblemsTreeNodeTextChanged(app, event)
            node = event.Node;
            if isa(node.Parent, 'matlab.ui.container.Tree')
                % Problem node
                node.NodeData.name = node.Text;
            else
                % Parameter node
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

        % Context menu opening function: SelectedAlgoContextMenu
        function SelectedAlgoContextMenuOpening(app, event)
            if ~isempty(app.AlgorithmsTree.Children)
                app.AlgorithmsTree.SelectedNodes = app.AlgorithmsTree.Children;
            end
        end

        % Menu selected function: SelectedProbSelectAllMenu
        function SelectedProbSelectAllMenuSelected(app, event)
            if ~isempty(app.ProblemsTree.Children)
                app.ProblemsTree.SelectedNodes = app.ProblemsTree.Children;
            end
        end

        % Context menu opening function: AlgorithmsContextMenu
        function AlgorithmsContextMenuOpening(app, event)
            if ~isempty(app.AlgorithmsListBox.Items)
                app.AlgorithmsListBox.Value = app.AlgorithmsListBox.Items;
            end
        end

        % Menu selected function: ProblemsSelectAllMenu
        function ProblemsSelectAllMenuSelected(app, event)
            if ~isempty(app.ProblemsListBox.Items)
                app.ProblemsListBox.Value = app.ProblemsListBox.Items;
            end
        end

        % Button pushed function: SaveResultButton
        function SaveResultButtonPushed(app, event)
            if isempty(app.data)
                app.printlog('!!!  Please Run Test First !!! ');
                return;
            end
            
            dir_name = uigetdir('./');
            if dir_name == 0
                app.printlog('!!! User Select Canceled !!! ');
            else
                % save data
                data_save = app.data;
                save([dir_name, '/data_save'], 'data_save');
                
                % save figure
                fig_dir_name = [dir_name, '/data_Figure/'];
                mkdir(fig_dir_name);
                draw_obj = drawFigure;
                for prob = 1:length(data_save.prob_cell)
                    tasks_num = data_save.tasks_num_list(prob);
                    for task = 1:tasks_num
                        for algo = 1:length(data_save.algo_cell)
                            convergence_task = data_save.result(prob, algo).convergence(task:tasks_num:end, :);
                            convergence = mean(convergence_task, 1);
                            x_cell{algo} = 1:size(convergence,2);
                            y_cell{algo} = log(convergence);
                        end
                        draw_obj.setXY(x_cell, y_cell);
                        draw_obj.setXYlabel('Generation', 'log(fitness)');
                        draw_obj.setLegend(data_save.algo_cell);
                        draw_obj.setTitle([data_save.prob_cell{prob}, ' T', num2str(task)]);
                        draw_obj.setSaveDir(fig_dir_name);
                        draw_obj.setFigureType(app.FigureTypeEditField.Value);
                        draw_obj.draw();
                    end
                end
                app.printlog(['Save To: "', dir_name, '"']);
            end
        end

        % Button pushed function: LoadDataButton
        function LoadDataButtonPushed(app, event)
            [file_name, pathname] = uigetfile('data_save.mat', 'select the data_save.mat', './');
            if file_name == 0
                app.printlog('!!! User Select Canceled !!! ');
            else
                load([pathname, file_name], 'data_save');
                app.printlog(['Load Data: "', [pathname, file_name], '"']);
                app.data = data_save;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create MTOPlatformUIFigure and hide until all components are created
            app.MTOPlatformUIFigure = uifigure('Visible', 'off');
            app.MTOPlatformUIFigure.Position = [100 100 1203 772];
            app.MTOPlatformUIFigure.Name = 'MTO Platform';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.MTOPlatformUIFigure);
            app.GridLayout.ColumnWidth = {170, 250, '1x', 250};
            app.GridLayout.RowHeight = {'1x'};

            % Create Panel_1
            app.Panel_1 = uipanel(app.GridLayout);
            app.Panel_1.BorderType = 'none';
            app.Panel_1.Layout.Row = 1;
            app.Panel_1.Layout.Column = 1;
            app.Panel_1.FontWeight = 'bold';
            app.Panel_1.FontSize = 18;

            % Create GridLayout3
            app.GridLayout3 = uigridlayout(app.Panel_1);
            app.GridLayout3.ColumnWidth = {'1.2x', '1x'};
            app.GridLayout3.RowHeight = {'fit', 'fit', 'fit', 15, 'fit', 'fit', '1x', 'fit', '1x'};
            app.GridLayout3.RowSpacing = 9;
            app.GridLayout3.Padding = [10 9 10 9];

            % Create ProblemsAddButton
            app.ProblemsAddButton = uibutton(app.GridLayout3, 'push');
            app.ProblemsAddButton.ButtonPushedFcn = createCallbackFcn(app, @ProblemsAddButtonPushed, true);
            app.ProblemsAddButton.VerticalAlignment = 'top';
            app.ProblemsAddButton.BackgroundColor = [0.702 1 0.702];
            app.ProblemsAddButton.Layout.Row = 8;
            app.ProblemsAddButton.Layout.Column = 2;
            app.ProblemsAddButton.Text = 'Add';

            % Create AlgorithmsAddButton
            app.AlgorithmsAddButton = uibutton(app.GridLayout3, 'push');
            app.AlgorithmsAddButton.ButtonPushedFcn = createCallbackFcn(app, @AlgorithmsAddButtonPushed, true);
            app.AlgorithmsAddButton.VerticalAlignment = 'top';
            app.AlgorithmsAddButton.BackgroundColor = [0.702 1 0.702];
            app.AlgorithmsAddButton.Layout.Row = 6;
            app.AlgorithmsAddButton.Layout.Column = 2;
            app.AlgorithmsAddButton.Text = 'Add';

            % Create RepsEditField
            app.RepsEditField = uieditfield(app.GridLayout3, 'numeric');
            app.RepsEditField.ValueChangedFcn = createCallbackFcn(app, @RepsEditFieldValueChanged, true);
            app.RepsEditField.HorizontalAlignment = 'center';
            app.RepsEditField.Layout.Row = 1;
            app.RepsEditField.Layout.Column = 2;
            app.RepsEditField.Value = 20;

            % Create RunTimesEditFieldLabel
            app.RunTimesEditFieldLabel = uilabel(app.GridLayout3);
            app.RunTimesEditFieldLabel.FontWeight = 'bold';
            app.RunTimesEditFieldLabel.Layout.Row = 1;
            app.RunTimesEditFieldLabel.Layout.Column = 1;
            app.RunTimesEditFieldLabel.Text = 'Run Times';

            % Create EndNumEditField
            app.EndNumEditField = uieditfield(app.GridLayout3, 'numeric');
            app.EndNumEditField.ValueChangedFcn = createCallbackFcn(app, @EndNumEditFieldValueChanged, true);
            app.EndNumEditField.HorizontalAlignment = 'center';
            app.EndNumEditField.Layout.Row = 5;
            app.EndNumEditField.Layout.Column = 2;
            app.EndNumEditField.Value = 1000;

            % Create EndNumEditFieldLabel
            app.EndNumEditFieldLabel = uilabel(app.GridLayout3);
            app.EndNumEditFieldLabel.FontWeight = 'bold';
            app.EndNumEditFieldLabel.Layout.Row = 5;
            app.EndNumEditFieldLabel.Layout.Column = 1;
            app.EndNumEditFieldLabel.Text = 'End Num';

            % Create PopSizeEditField
            app.PopSizeEditField = uieditfield(app.GridLayout3, 'numeric');
            app.PopSizeEditField.ValueChangedFcn = createCallbackFcn(app, @PopSizeEditFieldValueChanged, true);
            app.PopSizeEditField.HorizontalAlignment = 'center';
            app.PopSizeEditField.Layout.Row = 2;
            app.PopSizeEditField.Layout.Column = 2;
            app.PopSizeEditField.Value = 100;

            % Create PopSizeEditFieldLabel
            app.PopSizeEditFieldLabel = uilabel(app.GridLayout3);
            app.PopSizeEditFieldLabel.FontWeight = 'bold';
            app.PopSizeEditFieldLabel.Layout.Row = 2;
            app.PopSizeEditFieldLabel.Layout.Column = 1;
            app.PopSizeEditFieldLabel.Text = 'Pop Size';

            % Create AlgorithmsListBox
            app.AlgorithmsListBox = uilistbox(app.GridLayout3);
            app.AlgorithmsListBox.Items = {};
            app.AlgorithmsListBox.Multiselect = 'on';
            app.AlgorithmsListBox.Layout.Row = 7;
            app.AlgorithmsListBox.Layout.Column = [1 2];
            app.AlgorithmsListBox.Value = {};

            % Create AlgorithmsListBoxLabel
            app.AlgorithmsListBoxLabel = uilabel(app.GridLayout3);
            app.AlgorithmsListBoxLabel.FontWeight = 'bold';
            app.AlgorithmsListBoxLabel.Layout.Row = 6;
            app.AlgorithmsListBoxLabel.Layout.Column = 1;
            app.AlgorithmsListBoxLabel.Text = 'Algorithms';

            % Create ProblemsListBox
            app.ProblemsListBox = uilistbox(app.GridLayout3);
            app.ProblemsListBox.Items = {};
            app.ProblemsListBox.Multiselect = 'on';
            app.ProblemsListBox.Layout.Row = 9;
            app.ProblemsListBox.Layout.Column = [1 2];
            app.ProblemsListBox.Value = {};

            % Create ProblemsListBoxLabel
            app.ProblemsListBoxLabel = uilabel(app.GridLayout3);
            app.ProblemsListBoxLabel.FontWeight = 'bold';
            app.ProblemsListBoxLabel.Layout.Row = 8;
            app.ProblemsListBoxLabel.Layout.Column = 1;
            app.ProblemsListBoxLabel.Text = 'Problems';

            % Create ButtonGroup
            app.ButtonGroup = uibuttongroup(app.GridLayout3);
            app.ButtonGroup.Tooltip = {''};
            app.ButtonGroup.BorderType = 'none';
            app.ButtonGroup.Layout.Row = 4;
            app.ButtonGroup.Layout.Column = [1 2];

            % Create IterationButton
            app.IterationButton = uiradiobutton(app.ButtonGroup);
            app.IterationButton.Text = 'Iteration';
            app.IterationButton.FontSize = 2;
            app.IterationButton.Position = [3 -2 66 22];
            app.IterationButton.Value = true;

            % Create EvaluationButton
            app.EvaluationButton = uiradiobutton(app.ButtonGroup);
            app.EvaluationButton.Text = 'Evaluation';
            app.EvaluationButton.Position = [71 -2 78 22];

            % Create EndConditionLabel
            app.EndConditionLabel = uilabel(app.GridLayout3);
            app.EndConditionLabel.FontWeight = 'bold';
            app.EndConditionLabel.Layout.Row = 3;
            app.EndConditionLabel.Layout.Column = [1 2];
            app.EndConditionLabel.Text = 'End Condition';

            % Create Panel_2
            app.Panel_2 = uipanel(app.GridLayout);
            app.Panel_2.BorderType = 'none';
            app.Panel_2.Layout.Row = 1;
            app.Panel_2.Layout.Column = 2;

            % Create GridLayout2
            app.GridLayout2 = uigridlayout(app.Panel_2);
            app.GridLayout2.ColumnWidth = {'2x', '1x'};
            app.GridLayout2.RowHeight = {'fit', 'fit', 'fit', 'fit', '1x', 'fit', '1x'};
            app.GridLayout2.Padding = [19.5 10 19.5 10];

            % Create StartButton
            app.StartButton = uibutton(app.GridLayout2, 'push');
            app.StartButton.ButtonPushedFcn = createCallbackFcn(app, @StartButtonPushed, true);
            app.StartButton.BackgroundColor = [0.6745 0.949 0.6745];
            app.StartButton.Layout.Row = 1;
            app.StartButton.Layout.Column = [1 2];
            app.StartButton.Text = 'Start';

            % Create PauseButton
            app.PauseButton = uibutton(app.GridLayout2, 'push');
            app.PauseButton.ButtonPushedFcn = createCallbackFcn(app, @PauseButtonPushed, true);
            app.PauseButton.BackgroundColor = [1 1 0.502];
            app.PauseButton.Layout.Row = 2;
            app.PauseButton.Layout.Column = [1 2];
            app.PauseButton.Text = 'Pause';

            % Create StopButton
            app.StopButton = uibutton(app.GridLayout2, 'push');
            app.StopButton.ButtonPushedFcn = createCallbackFcn(app, @StopButtonPushed, true);
            app.StopButton.BackgroundColor = [1 0.6 0.6];
            app.StopButton.Layout.Row = 3;
            app.StopButton.Layout.Column = [1 2];
            app.StopButton.Text = 'Stop';

            % Create AlgorithmsTree
            app.AlgorithmsTree = uitree(app.GridLayout2);
            app.AlgorithmsTree.Multiselect = 'on';
            app.AlgorithmsTree.NodeTextChangedFcn = createCallbackFcn(app, @AlgorithmsTreeNodeTextChanged, true);
            app.AlgorithmsTree.Editable = 'on';
            app.AlgorithmsTree.Layout.Row = 5;
            app.AlgorithmsTree.Layout.Column = [1 2];

            % Create ProblemsTree
            app.ProblemsTree = uitree(app.GridLayout2);
            app.ProblemsTree.Multiselect = 'on';
            app.ProblemsTree.NodeTextChangedFcn = createCallbackFcn(app, @ProblemsTreeNodeTextChanged, true);
            app.ProblemsTree.Editable = 'on';
            app.ProblemsTree.Layout.Row = 7;
            app.ProblemsTree.Layout.Column = [1 2];

            % Create SelectedAlgoLabel
            app.SelectedAlgoLabel = uilabel(app.GridLayout2);
            app.SelectedAlgoLabel.FontWeight = 'bold';
            app.SelectedAlgoLabel.Layout.Row = 4;
            app.SelectedAlgoLabel.Layout.Column = 1;
            app.SelectedAlgoLabel.Text = 'Selected Algo';

            % Create SelectedProbLabel
            app.SelectedProbLabel = uilabel(app.GridLayout2);
            app.SelectedProbLabel.FontWeight = 'bold';
            app.SelectedProbLabel.Layout.Row = 6;
            app.SelectedProbLabel.Layout.Column = 1;
            app.SelectedProbLabel.Text = 'Selected Prob';

            % Create AlgorithmsDelButton
            app.AlgorithmsDelButton = uibutton(app.GridLayout2, 'push');
            app.AlgorithmsDelButton.ButtonPushedFcn = createCallbackFcn(app, @AlgorithmsDelButtonPushed, true);
            app.AlgorithmsDelButton.BackgroundColor = [1 1 0.702];
            app.AlgorithmsDelButton.Layout.Row = 4;
            app.AlgorithmsDelButton.Layout.Column = 2;
            app.AlgorithmsDelButton.Text = 'Del';

            % Create ProblemsDelButton
            app.ProblemsDelButton = uibutton(app.GridLayout2, 'push');
            app.ProblemsDelButton.ButtonPushedFcn = createCallbackFcn(app, @ProblemsDelButtonPushed, true);
            app.ProblemsDelButton.BackgroundColor = [1 1 0.702];
            app.ProblemsDelButton.Layout.Row = 6;
            app.ProblemsDelButton.Layout.Column = 2;
            app.ProblemsDelButton.Text = 'Del';

            % Create Panel_3
            app.Panel_3 = uipanel(app.GridLayout);
            app.Panel_3.BorderType = 'none';
            app.Panel_3.Layout.Row = 1;
            app.Panel_3.Layout.Column = 3;

            % Create GridLayout5
            app.GridLayout5 = uigridlayout(app.Panel_3);
            app.GridLayout5.ColumnWidth = {'5x'};
            app.GridLayout5.RowHeight = {'1x'};

            % Create TabGroup
            app.TabGroup = uitabgroup(app.GridLayout5);
            app.TabGroup.Layout.Row = 1;
            app.TabGroup.Layout.Column = 1;

            % Create FitnessTab
            app.FitnessTab = uitab(app.TabGroup);
            app.FitnessTab.Title = 'Fitness';

            % Create GridLayout8_2
            app.GridLayout8_2 = uigridlayout(app.FitnessTab);
            app.GridLayout8_2.ColumnWidth = {'1x'};
            app.GridLayout8_2.RowHeight = {'1x'};

            % Create FitnessUITable
            app.FitnessUITable = uitable(app.GridLayout8_2);
            app.FitnessUITable.ColumnName = {'Column 1'; 'Column 2'; 'Column 3'; 'Column 4'};
            app.FitnessUITable.RowName = {};
            app.FitnessUITable.Layout.Row = 1;
            app.FitnessUITable.Layout.Column = 1;

            % Create ScoreTab
            app.ScoreTab = uitab(app.TabGroup);
            app.ScoreTab.Title = 'Score';

            % Create GridLayout8_3
            app.GridLayout8_3 = uigridlayout(app.ScoreTab);
            app.GridLayout8_3.ColumnWidth = {'1x'};
            app.GridLayout8_3.RowHeight = {'1x'};

            % Create ScoreUITable
            app.ScoreUITable = uitable(app.GridLayout8_3);
            app.ScoreUITable.ColumnName = {'Column 1'; 'Column 2'; 'Column 3'; 'Column 4'};
            app.ScoreUITable.RowName = {};
            app.ScoreUITable.Layout.Row = 1;
            app.ScoreUITable.Layout.Column = 1;

            % Create TimeUsedTab
            app.TimeUsedTab = uitab(app.TabGroup);
            app.TimeUsedTab.Title = 'Time Used';

            % Create GridLayout8
            app.GridLayout8 = uigridlayout(app.TimeUsedTab);
            app.GridLayout8.ColumnWidth = {'1x'};
            app.GridLayout8.RowHeight = {'1x'};

            % Create TimeUITable
            app.TimeUITable = uitable(app.GridLayout8);
            app.TimeUITable.ColumnName = {'Column 1'; 'Column 2'; 'Column 3'; 'Column 4'};
            app.TimeUITable.RowName = {};
            app.TimeUITable.Layout.Row = 1;
            app.TimeUITable.Layout.Column = 1;

            % Create Panel_4
            app.Panel_4 = uipanel(app.GridLayout);
            app.Panel_4.BorderType = 'none';
            app.Panel_4.Layout.Row = 1;
            app.Panel_4.Layout.Column = 4;

            % Create GridLayout6
            app.GridLayout6 = uigridlayout(app.Panel_4);
            app.GridLayout6.RowHeight = {'fit', '1x', 'fit', 'fit'};

            % Create LogsTextAreaLabel
            app.LogsTextAreaLabel = uilabel(app.GridLayout6);
            app.LogsTextAreaLabel.FontWeight = 'bold';
            app.LogsTextAreaLabel.Layout.Row = 1;
            app.LogsTextAreaLabel.Layout.Column = 1;
            app.LogsTextAreaLabel.Text = 'Logs';

            % Create LogsTextArea
            app.LogsTextArea = uitextarea(app.GridLayout6);
            app.LogsTextArea.Editable = 'off';
            app.LogsTextArea.HorizontalAlignment = 'center';
            app.LogsTextArea.WordWrap = 'off';
            app.LogsTextArea.Layout.Row = 2;
            app.LogsTextArea.Layout.Column = [1 2];

            % Create LogsClearButton
            app.LogsClearButton = uibutton(app.GridLayout6, 'push');
            app.LogsClearButton.ButtonPushedFcn = createCallbackFcn(app, @LogsClearButtonPushed, true);
            app.LogsClearButton.VerticalAlignment = 'top';
            app.LogsClearButton.BackgroundColor = [1 1 0.502];
            app.LogsClearButton.Layout.Row = 1;
            app.LogsClearButton.Layout.Column = 2;
            app.LogsClearButton.Text = 'Clear';

            % Create SaveResultButton
            app.SaveResultButton = uibutton(app.GridLayout6, 'push');
            app.SaveResultButton.ButtonPushedFcn = createCallbackFcn(app, @SaveResultButtonPushed, true);
            app.SaveResultButton.BackgroundColor = [0.702 1 0.702];
            app.SaveResultButton.Layout.Row = 4;
            app.SaveResultButton.Layout.Column = 2;
            app.SaveResultButton.Text = 'Save Result';

            % Create FigureTypeEditFieldLabel
            app.FigureTypeEditFieldLabel = uilabel(app.GridLayout6);
            app.FigureTypeEditFieldLabel.FontWeight = 'bold';
            app.FigureTypeEditFieldLabel.Layout.Row = 3;
            app.FigureTypeEditFieldLabel.Layout.Column = 1;
            app.FigureTypeEditFieldLabel.Text = 'Figure Type';

            % Create FigureTypeEditField
            app.FigureTypeEditField = uieditfield(app.GridLayout6, 'text');
            app.FigureTypeEditField.HorizontalAlignment = 'center';
            app.FigureTypeEditField.Layout.Row = 3;
            app.FigureTypeEditField.Layout.Column = 2;
            app.FigureTypeEditField.Value = 'png';

            % Create LoadDataButton
            app.LoadDataButton = uibutton(app.GridLayout6, 'push');
            app.LoadDataButton.ButtonPushedFcn = createCallbackFcn(app, @LoadDataButtonPushed, true);
            app.LoadDataButton.BackgroundColor = [0.502 0.702 1];
            app.LoadDataButton.Layout.Row = 4;
            app.LoadDataButton.Layout.Column = 1;
            app.LoadDataButton.Text = 'Load Data';

            % Create SelectedAlgoContextMenu
            app.SelectedAlgoContextMenu = uicontextmenu(app.MTOPlatformUIFigure);
            app.SelectedAlgoContextMenu.ContextMenuOpeningFcn = createCallbackFcn(app, @SelectedAlgoContextMenuOpening, true);
            
            % Assign app.SelectedAlgoContextMenu
            app.AlgorithmsTree.ContextMenu = app.SelectedAlgoContextMenu;

            % Create SelectedAlgoSelectAllMenu
            app.SelectedAlgoSelectAllMenu = uimenu(app.SelectedAlgoContextMenu);
            app.SelectedAlgoSelectAllMenu.Text = 'Select All';

            % Create SelectedProbContextMenu
            app.SelectedProbContextMenu = uicontextmenu(app.MTOPlatformUIFigure);
            
            % Assign app.SelectedProbContextMenu
            app.ProblemsTree.ContextMenu = app.SelectedProbContextMenu;

            % Create SelectedProbSelectAllMenu
            app.SelectedProbSelectAllMenu = uimenu(app.SelectedProbContextMenu);
            app.SelectedProbSelectAllMenu.MenuSelectedFcn = createCallbackFcn(app, @SelectedProbSelectAllMenuSelected, true);
            app.SelectedProbSelectAllMenu.Text = 'Select All';

            % Create AlgorithmsContextMenu
            app.AlgorithmsContextMenu = uicontextmenu(app.MTOPlatformUIFigure);
            app.AlgorithmsContextMenu.ContextMenuOpeningFcn = createCallbackFcn(app, @AlgorithmsContextMenuOpening, true);
            
            % Assign app.AlgorithmsContextMenu
            app.AlgorithmsListBox.ContextMenu = app.AlgorithmsContextMenu;

            % Create AlgorithmsSelectAllMenu
            app.AlgorithmsSelectAllMenu = uimenu(app.AlgorithmsContextMenu);
            app.AlgorithmsSelectAllMenu.Text = 'Select All';

            % Create ProblemsContextMenu
            app.ProblemsContextMenu = uicontextmenu(app.MTOPlatformUIFigure);
            
            % Assign app.ProblemsContextMenu
            app.ProblemsListBox.ContextMenu = app.ProblemsContextMenu;

            % Create ProblemsSelectAllMenu
            app.ProblemsSelectAllMenu = uimenu(app.ProblemsContextMenu);
            app.ProblemsSelectAllMenu.MenuSelectedFcn = createCallbackFcn(app, @ProblemsSelectAllMenuSelected, true);
            app.ProblemsSelectAllMenu.Text = 'Select All';

            % Show the figure after all components are created
            app.MTOPlatformUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = MTO_Platform

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