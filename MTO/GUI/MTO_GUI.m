classdef MTO_GUI < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        MToPv111UIFigure             matlab.ui.Figure
        MTOPlatformGridLayout        matlab.ui.container.GridLayout
        MTOPlatformTabGroup          matlab.ui.container.TabGroup
        TestModuleTab                matlab.ui.container.Tab
        TestGridLayout               matlab.ui.container.GridLayout
        TPanel3                      matlab.ui.container.Panel
        TP3GridLayout                matlab.ui.container.GridLayout
        MTOPlatformMToPLabel         matlab.ui.control.Label
        TOutputTextArea              matlab.ui.control.TextArea
        TPanel2                      matlab.ui.container.Panel
        TP2GridLayout                matlab.ui.container.GridLayout
        TP24GridLayout               matlab.ui.container.GridLayout
        TPauseButton                 matlab.ui.control.Button
        TStopButton                  matlab.ui.control.Button
        TStartButton                 matlab.ui.control.Button
        TP21GridLayout               matlab.ui.container.GridLayout
        TSampleNumberEditField       matlab.ui.control.NumericEditField
        SampleNumberEditFieldLabel   matlab.ui.control.Label
        TExportButton                matlab.ui.control.Button
        TShowTypeDropDown            matlab.ui.control.DropDown
        TUIAxes                      matlab.ui.control.UIAxes
        TPanel1                      matlab.ui.container.Panel
        TP1GridLayout                matlab.ui.container.GridLayout
        TYearDropDown                matlab.ui.control.DropDown
        TCompetitiveButton           matlab.ui.control.StateButton
        TStreamButton                matlab.ui.control.StateButton
        TConstrainedButton           matlab.ui.control.StateButton
        TDrawObjCheckBox             matlab.ui.control.CheckBox
        TDrawDecCheckBox             matlab.ui.control.CheckBox
        ObjectiveLabel               matlab.ui.control.Label
        TObjectiveTypeDropDown       matlab.ui.control.DropDown
        TaskLabel                    matlab.ui.control.Label
        TTaskTypeDropDown            matlab.ui.control.DropDown
        ProblemDropDownLabel         matlab.ui.control.Label
        TProblemDropDown             matlab.ui.control.DropDown
        TProblemTree                 matlab.ui.container.Tree
        TAlgorithmTree               matlab.ui.container.Tree
        TAlgorithmDropDown           matlab.ui.control.DropDown
        AlgorithmDropDownLabel       matlab.ui.control.Label
        ExperimentModuleTab          matlab.ui.container.Tab
        ExperimentsGridLayout        matlab.ui.container.GridLayout
        EPanel3                      matlab.ui.container.Panel
        EP3GridLayout                matlab.ui.container.GridLayout
        EP3TGridLayout               matlab.ui.container.GridLayout
        EP3T2GridLayout              matlab.ui.container.GridLayout
        ESaveTableButton             matlab.ui.control.Button
        DrawingSelectTableAreaPanel  matlab.ui.container.Panel
        GridLayout6_3                matlab.ui.container.GridLayout
        ESplitCheckBox               matlab.ui.control.CheckBox
        EParetoButton                matlab.ui.control.Button
        EConvergeButton              matlab.ui.control.Button
        EConvergeTypeDropDown        matlab.ui.control.DropDown
        HighlightPanel               matlab.ui.container.Panel
        GridLayout6_5                matlab.ui.container.GridLayout
        EHighlightTypeDropDown       matlab.ui.control.DropDown
        StatisticalTestPanel         matlab.ui.container.Panel
        GridLayout6_4                matlab.ui.container.GridLayout
        ETestTypeDropDown            matlab.ui.control.DropDown
        EAlgorithmDropDown           matlab.ui.control.DropDown
        MetricandShowTypePanel       matlab.ui.container.Panel
        GridLayout6_2                matlab.ui.container.GridLayout
        EDataTypeDropDown            matlab.ui.control.DropDown
        EDataFormatEditField         matlab.ui.control.EditField
        EShowTypeDropDown            matlab.ui.control.DropDown
        EUITable                     matlab.ui.control.Table
        EPanel2                      matlab.ui.container.Panel
        EP2GridLayout                matlab.ui.container.GridLayout
        GridLayout                   matlab.ui.container.GridLayout
        ELoadDataButton              matlab.ui.control.Button
        ESaveDataButton              matlab.ui.control.Button
        GridLayout4                  matlab.ui.container.GridLayout
        EProblemsDelButton           matlab.ui.control.Button
        ESelectedProblemsLabel       matlab.ui.control.Label
        GridLayout3                  matlab.ui.container.GridLayout
        EAlgorithmsDelButton         matlab.ui.control.Button
        ESelectedAlgorithmsLabel     matlab.ui.control.Label
        GridLayout2                  matlab.ui.container.GridLayout
        EStopButton                  matlab.ui.control.Button
        EPauseButton                 matlab.ui.control.Button
        EStartButton                 matlab.ui.control.Button
        EProblemsTree                matlab.ui.container.Tree
        EAlgorithmsTree              matlab.ui.container.Tree
        EPanel1                      matlab.ui.container.Panel
        EP1GridLayout                matlab.ui.container.GridLayout
        EYearDropDown                matlab.ui.control.DropDown
        EStreamButton                matlab.ui.control.StateButton
        ECompetitiveButton           matlab.ui.control.StateButton
        EConstrainedButton           matlab.ui.control.StateButton
        ESaveDecCheckBox             matlab.ui.control.CheckBox
        EParallelCheckBox            matlab.ui.control.CheckBox
        GridLayout5                  matlab.ui.container.GridLayout
        ERngSeedCheckBox             matlab.ui.control.CheckBox
        ERngSeedEditField            matlab.ui.control.NumericEditField
        EResultsNumEditFieldLabel    matlab.ui.control.Label
        ERepsEditFieldLabel          matlab.ui.control.Label
        EResultsNumEditField         matlab.ui.control.NumericEditField
        ERepsEditField               matlab.ui.control.NumericEditField
        EObjectiveTypeDropDown       matlab.ui.control.DropDown
        EObjectiveTypeDropDownLabel  matlab.ui.control.Label
        ETaskTypeDropDown            matlab.ui.control.DropDown
        ETaskTypeDropDownLabel       matlab.ui.control.Label
        EProblemListLabel            matlab.ui.control.Label
        EProblemsListBox             matlab.ui.control.ListBox
        EAlgorithmListLabel          matlab.ui.control.Label
        EAlgorithmsListBox           matlab.ui.control.ListBox
        EAlgorithmsAddButton         matlab.ui.control.Button
        EProblemsAddButton           matlab.ui.control.Button
        DataProcessModuleTab         matlab.ui.container.Tab
        DataProcessGridLayout        matlab.ui.container.GridLayout
        DPanel2                      matlab.ui.container.Panel
        DP2GridLayout                matlab.ui.container.GridLayout
        DDataTree                    matlab.ui.container.Tree
        DPanel1                      matlab.ui.container.Panel
        DP1GridLayout                matlab.ui.container.GridLayout
        GridLayout6                  matlab.ui.container.GridLayout
        DDataLengthButton            matlab.ui.control.Button
        DDataLengthEditField         matlab.ui.control.NumericEditField
        DDataLengthLabel             matlab.ui.control.Label
        DP1Panel5                    matlab.ui.container.Panel
        DP1P5GridLayout              matlab.ui.container.GridLayout
        DPreisionEditField           matlab.ui.control.NumericEditField
        DPreisionButton              matlab.ui.control.Button
        DDPreisionButtonDataLabel    matlab.ui.control.Label
        DLoadDataorSelectandDeleteSaveDataLabel_5  matlab.ui.control.Label
        DP1Panel4                    matlab.ui.container.Panel
        DP1P4GridLayout              matlab.ui.container.GridLayout
        DDownButton                  matlab.ui.control.Button
        DUpButton                    matlab.ui.control.Button
        DUpandDownDataLabel          matlab.ui.control.Label
        DP1Panel3                    matlab.ui.container.Panel
        DP1P3GridLayout              matlab.ui.container.GridLayout
        DProblemsMergeButton         matlab.ui.control.Button
        DAlgorithmsMergeButton       matlab.ui.control.Button
        DRepsMergeButton             matlab.ui.control.Button
        DSelectandMergeDataLabel     matlab.ui.control.Label
        DP1Panel2                    matlab.ui.container.Panel
        DP1P2GridLayout              matlab.ui.container.GridLayout
        DProblemsSplitButton         matlab.ui.control.Button
        DAlgorithmsSplitButton       matlab.ui.control.Button
        DRepsSplitButton             matlab.ui.control.Button
        DSelectandSplitDataLabel     matlab.ui.control.Label
        DP1Panel1                    matlab.ui.container.Panel
        DP1P1GridLayout              matlab.ui.container.GridLayout
        DLoadDataorSelectandDeleteSaveDataLabel_4  matlab.ui.control.Label
        DLoadDataorSelectandDeleteSaveDataLabel_3  matlab.ui.control.Label
        DSaveDataButton              matlab.ui.control.Button
        DDeleteDataButton            matlab.ui.control.Button
        DLoadDataButton              matlab.ui.control.Button
        DDataProcessModuleLabel      matlab.ui.control.Label
        DDataContextMenu             matlab.ui.container.ContextMenu
        DDataSelectAllMenu           matlab.ui.container.Menu
        SelectedAlgoContextMenu      matlab.ui.container.ContextMenu
        SelectedAlgoSelectAllMenu    matlab.ui.container.Menu
        SelectedProbContextMenu      matlab.ui.container.ContextMenu
        SelectedProbSelectAllMenu    matlab.ui.container.Menu
        EditPublicParaMenu           matlab.ui.container.Menu
        AlgorithmsContextMenu        matlab.ui.container.ContextMenu
        AlgorithmsSelectAllMenu      matlab.ui.container.Menu
        AlgorithmRefreshMenu         matlab.ui.container.Menu
        ProblemsContextMenu          matlab.ui.container.ContextMenu
        ProblemsSelectAllMenu        matlab.ui.container.Menu
        ProblemRefreshMenu           matlab.ui.container.Menu
    end

    properties (Access = public)
        AlgoLoad % cell of algorithms loaded from folder
        ProbLoad % cell of problems loaded from folder
        MetricLoad % cell of metrics loaded from folder

        % Plot appearance is configured in GUI/PlotFunctions/PlotStyle.m.

        % Test Module
        TData % data
        TStopFlag

        % Experiment Module
        EData % data
        EStopFlag % stop button clicked flag

        ETableSelected % selected table cell index
        EMetricMin = true % default metric min
        EResultConvergeData % results converge corresponding to metric
        EResultParetoData % results pareto corresponding to metric
        EResultTableData % results data corresponding to metric
        EHighlightMatrix

        ETableData % table data for calculate
        ETableView % table data view
        ETableTest % table data view test
        ETableReps % table reps

    end

    methods (Access = public)
        function algo_years = readAlgoProb(app, label_str, excluded)
            if nargin < 3, excluded = {}; end
            [algorithms, algo_years] = app.readList('../Algorithms', label_str, excluded);
            app.AlgoLoad = sort_nat(algorithms);
            app.ProbLoad = sort_nat(app.readList('../Problems', label_str, excluded));
        end

        function readMetric(app, label_str)
            % load the metrics

            app.MetricLoad = app.readList('../Metrics', label_str);
            app.MetricLoad = sort_nat(app.MetricLoad);
        end

        function [read_list, year_map] = readList(app, folder_name, label_str, excluded)
            if nargin < 4, excluded = {}; end
            read_list = {};
            year_map = containers.Map('KeyType', 'char', 'ValueType', 'char');
            root = fullfile(fileparts(mfilename('fullpath')), folder_name);
            folders = split(genpath(root), pathsep);
            for i = 1:numel(folders)
                if isempty(folders{i}), continue; end
                files = dir(fullfile(folders{i}, '*.m'));
                for j = 1:numel(files)
                    fid = fopen(fullfile(files(j).folder, files(j).name), 'r');
                    if fid < 0, continue; end
                    cleanup = onCleanup(@() fclose(fid));
                    fgetl(fid); header = fgetl(fid); clear cleanup;
                    if MatchCatalogLabels(header, label_str, excluded)
                        name = files(j).name(1:end-2);
                        read_list{end+1} = name;
                        if nargout > 1
                            token = regexp(header, '<Year:\s*((?:19|20)\d{2})>', 'tokens', 'once');
                            if isempty(token), year_map(name) = '';
                            else, year_map(name) = token{1}; end
                        end
                    end
                end
            end
            read_list = unique(read_list, 'stable');
        end

        function labels = getDataLabels(app, MTOData)
            m = [MTOData.Problems.M];
            if any(m >= 2)
                objective_label = 'Multi-objective';
            else
                objective_label = 'Single-objective';
            end

            t = [MTOData.Problems.T];
            if any(t >= 2)
                task_label = 'Multi-task';
            else
                task_label = 'Single-task';
            end

            labels = {task_label, objective_label};
        end

        function TloadAlgoProb(app)
            % load the algorithms and problems in Test module

            % Labels filter available choices; explicit selections update the parameter trees.
            oldAlgo = app.TAlgorithmDropDown.Value;
            oldProb = app.TProblemDropDown.Value;
            if ~isempty(app.TAlgorithmTree.Children)
                oldAlgo = class(app.TAlgorithmTree.Children(1).NodeData);
            end
            if ~isempty(app.TProblemTree.Children)
                oldProb = class(app.TProblemTree.Children(1).NodeData);
            end
            [required, excluded] = CatalogFilter(app.TTaskTypeDropDown.Value, ...
                app.TObjectiveTypeDropDown.Value, app.TConstrainedButton.Value, ...
                app.TCompetitiveButton.Value, app.TStreamButton.Value);
            algo_years = app.readAlgoProb(required, excluded);
            years = cellfun(@(name) algo_years(name), app.AlgoLoad, 'UniformOutput', false);
            known = years(~cellfun(@isempty, years));
            sorted_years = sort(unique(str2double(known)), 'descend');
            year_items = [{'All Year'}, arrayfun(@num2str, sorted_years, 'UniformOutput', false)];
            if any(cellfun(@isempty, years)), year_items{end+1} = 'Unknown Year'; end
            old_year = app.TYearDropDown.Value;
            app.TYearDropDown.Items = year_items;
            if ismember(old_year, year_items)
                app.TYearDropDown.Value = old_year;
            else
                app.TYearDropDown.Value = 'All Year';
            end
            selected_year = app.TYearDropDown.Value;
            if strcmp(selected_year, 'All Year')
                algorithms = app.AlgoLoad;
            elseif strcmp(selected_year, 'Unknown Year')
                algorithms = app.AlgoLoad(cellfun(@isempty, years));
            else
                algorithms = app.AlgoLoad(strcmp(years, selected_year));
            end
            problems = app.ProbLoad;
            % Filter the lists strictly; loaded objects remain in their parameter trees.
            app.TAlgorithmDropDown.Items = {};
            app.TProblemDropDown.Items = {};
            app.TAlgorithmDropDown.Items = strrep(algorithms, '_', '-');
            app.TAlgorithmDropDown.ItemsData = algorithms;
            app.TProblemDropDown.Items = strrep(problems, '_', '-');
            app.TProblemDropDown.ItemsData = problems;
            if ismember(oldAlgo, algorithms), app.TAlgorithmDropDown.Value = oldAlgo; end
            if ismember(oldProb, problems), app.TProblemDropDown.Value = oldProb; end
        end

        function EloadAlgoProb(app)
            % load the algorithms and problems in Experiment module

            [required, excluded] = CatalogFilter(app.ETaskTypeDropDown.Value, ...
                app.EObjectiveTypeDropDown.Value, app.EConstrainedButton.Value, ...
                app.ECompetitiveButton.Value, app.EStreamButton.Value);
            algo_years = app.readAlgoProb(required, excluded);
            years = cellfun(@(name) algo_years(name), app.AlgoLoad, 'UniformOutput', false);
            known = years(~cellfun(@isempty, years));
            sorted_years = sort(unique(str2double(known)), 'descend');
            year_items = [{'All Year'}, arrayfun(@num2str, sorted_years, 'UniformOutput', false)];
            if any(cellfun(@isempty, years)), year_items{end+1} = 'Unknown Year'; end
            old_year = app.EYearDropDown.Value;
            app.EYearDropDown.Items = year_items;
            if ismember(old_year, year_items)
                app.EYearDropDown.Value = old_year;
            else
                app.EYearDropDown.Value = 'All Year';
            end
            selected_year = app.EYearDropDown.Value;
            if strcmp(selected_year, 'All Year')
                algorithms = app.AlgoLoad;
            elseif strcmp(selected_year, 'Unknown Year')
                algorithms = app.AlgoLoad(cellfun(@isempty, years));
            else
                algorithms = app.AlgoLoad(strcmp(years, selected_year));
            end
            app.EAlgorithmsListBox.Items(:) = [];
            app.EProblemsListBox.Items(:) = [];
            app.EAlgorithmsListBox.Items = strrep(algorithms, '_', '-');
            app.EAlgorithmsListBox.ItemsData = algorithms;
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
            app.TPauseButton.Enable = ~value;
            app.TStopButton.Enable = ~value;
            app.TTaskTypeDropDown.Enable = value;
            app.TObjectiveTypeDropDown.Enable = value;
            app.TConstrainedButton.Enable = value;
            app.TCompetitiveButton.Enable = value;
            app.TStreamButton.Enable = value;
            app.TAlgorithmDropDown.Enable = value;
            app.TAlgorithmTree.Enable = value;
            app.TProblemDropDown.Enable = value;
            app.TProblemTree.Enable = value;
            app.TDrawDecCheckBox.Enable = value;
            app.TDrawObjCheckBox.Enable = value;
        end

        function EstartEnable(app, value)
            % change controler enable when start button pused and end
            % in Experiment module

            app.EStartButton.Enable = value;
            app.ERepsEditField.Enable = value;
            app.ERepsEditFieldLabel.Enable = value;
            app.EResultsNumEditField.Enable = value;
            app.EResultsNumEditFieldLabel.Enable = value;
            app.ESaveDecCheckBox.Enable = value;
            app.EParallelCheckBox.Enable = value;
            app.ERngSeedCheckBox.Enable = value;
            app.ERngSeedEditField.Enable = value;
            app.ETaskTypeDropDown.Enable = value;
            app.ETaskTypeDropDownLabel.Enable = value;
            app.EObjectiveTypeDropDown.Enable = value;
            app.EObjectiveTypeDropDownLabel.Enable = value;
            app.ECompetitiveButton.Enable = value;
            app.EConstrainedButton.Enable = value;
            app.EStreamButton.Enable = value;
            app.EAlgorithmsAddButton.Enable = value;
            app.EAlgorithmListLabel.Enable = value;
            app.EProblemsAddButton.Enable = value;
            app.EProblemListLabel.Enable = value;
            app.EAlgorithmsListBox.Enable = value;
            app.EProblemsListBox.Enable = value;
            app.EAlgorithmsDelButton.Enable = value;
            app.ESelectedAlgorithmsLabel.Enable = value;
            app.EProblemsDelButton.Enable = value;
            app.ESelectedProblemsLabel.Enable = value;
            app.EAlgorithmsTree.Enable = value;
            app.EProblemsTree.Enable = value;
            app.ELoadDataButton.Enable = value;
            app.ESaveDataButton.Enable = value;
            app.EPauseButton.Enable = ~value;
            app.EStopButton.Enable = ~value;
        end

        function report = showError(app, exception, title)
            % Keep stack traces and nested causes visible and copyable in the Command Window.
            report = getReport(exception, 'extended', 'hyperlinks', 'off');
            if ~isempty(exception.identifier)
                report = sprintf('Identifier: %s\n\n%s', exception.identifier, report);
            end
            fprintf(2, '\n%s\n%s\n', title, report);
            uialert(app.MToPv111UIFigure, report, title, 'Icon', 'error', 'Interpreter', 'none');
        end

        % Restore controls after completion, errors, or user cancellation.
        function finishRun(app, module)
            if ~isvalid(app) || ~isgraphics(app.MToPv111UIFigure), return; end
            if strcmp(module, 'Test')
                app.TPauseButton.Text = 'Pause';
                app.TStopFlag = false;
                app.TstartEnable(true);
                nodes = app.TAlgorithmTree.Children;
            else
                app.EPauseButton.Text = 'Pause';
                app.EStopFlag = false;
                app.EstartEnable(true);
                nodes = app.EAlgorithmsTree.Children;
            end
            for i = 1:numel(nodes)
                % Detach run callbacks before algorithms are reused outside this GUI session.
                nodes(i).NodeData.Check_Status_Fn = @emptyFn;
            end
        end

        function TcheckPauseStopStatus(app)
            if app.TStopFlag
                error('User Stop');
            end

            if strcmp(app.TPauseButton.Text, 'Resume')
                waitfor(app.TPauseButton,'Text', 'Pause');
            end
            if app.TStopFlag
                error('User Stop');
            end
        end

        function EcheckPauseStopStatus(app)
            % This function can be called at any time to check that status of the pause and stop buttons.
            % If paused, it will wait until un-paused.
            % If stopped, it will throw an error to break execution. The error will not be thrown.

            if app.EStopFlag
                error('User Stop');
            end

            if strcmp(app.EPauseButton.Text, 'Resume')
                waitfor(app.EPauseButton,'Text', 'Pause');
            end
            if app.EStopFlag
                error('User Stop');
            end
        end

        function data = EcreateExperimentData(app)
            % Capture experiment metadata once, before running any algorithm.
            data.Reps = app.ERepsEditField.Value;
            data.Problems = [];
            fields = {'Name', 'T', 'M', 'D', 'N', 'Fnc', 'Lb', 'Ub', 'maxFE'};
            nodes = app.EProblemsTree.Children;
            for prob = 1:numel(nodes)
                object = nodes(prob).NodeData;
                for i = 1:numel(fields)
                    data.Problems(prob).(fields{i}) = object.(fields{i});
                end
                if max(object.M) > 1
                    data.Problems(prob).Optimum = object.getOptimum();
                end
            end
            data.Algorithms = [];
            nodes = app.EAlgorithmsTree.Children;
            for algo = 1:numel(nodes)
                object = nodes(algo).NodeData;
                data.Algorithms(algo).Name = object.Name;
                data.Algorithms(algo).Para = object.getParameter();
            end
            data.Results = [];
            data.RunTimes = [];
        end

        function [results, runTimes] = ErunRepetitions(app, prob, algo, seeds)
            % Run one algorithm/problem pair and retain repetition order in the results.
            algorithm = app.EAlgorithmsTree.Children(algo).NodeData;
            problem = app.EProblemsTree.Children(prob).NodeData;
            algorithm.Result_Num = app.EResultsNumEditField.Value;
            algorithm.Save_Dec = app.ESaveDecCheckBox.Value;
            algorithm.Check_Status_Fn = @emptyFn;
            reps = numel(seeds);
            results = cell(1, reps);
            runTimes = zeros(1, reps);

            if app.EParallelCheckBox.Value
                futures = parallel.FevalFuture.empty;
                try
                    for rep = 1:reps
                        futures(rep) = parfeval(@parRun, 1, algorithm, problem, seeds(rep));
                    end
                    completed = 0;
                    while completed < reps
                        drawnow('limitrate');
                        app.EcheckPauseStopStatus();
                        [rep, result] = fetchNext(futures, 0.01);
                        if isempty(rep), continue; end
                        results{rep} = ConvertExperimentResult(result, max(problem.M) > 1);
                        runTimes(rep) = seconds(futures(rep).FinishDateTime - futures(rep).StartDateTime);
                        completed = completed + 1;
                        app.ETableReps(prob, algo) = completed;
                        app.EupdateTableReps();
                    end
                catch ME
                    % Also cancel jobs if submission or result conversion fails.
                    cancel(futures);
                    rethrow(ME);
                end
            else
                for rep = 1:reps
                    app.EcheckPauseStopStatus();
                    startTime = tic;
                    if seeds(rep) ~= -1
                        rng(seeds(rep));
                    end
                    problem.setTasks();
                    algorithm.reset();
                    algorithm.Check_Status_Fn = @app.EcheckPauseStopStatus;
                    algorithm.run(problem);
                    algorithm.Check_Status_Fn = @emptyFn;
                    result = algorithm.getResult(problem);
                    results{rep} = ConvertExperimentResult(result, max(problem.M) > 1);
                    runTimes(rep) = toc(startTime);
                    app.ETableReps(prob, algo) = rep;
                    app.EupdateTableReps();
                end
            end
            results = [results{:}];
        end

        function TupdateAlgorithm(app)
            name = app.TAlgorithmDropDown.Value;
            if isempty(name), return; end
            nodes = app.TAlgorithmTree.Children;
            if ~isempty(nodes) && strcmp(class(nodes(1).NodeData), name)
                return;
            end
            % Construct and read parameters before replacing the currently loaded object.
            object = feval(name, strrep(name, '_', '-'));
            parameters = object.getParameter();
            delete(nodes);
            node = uitreenode(app.TAlgorithmTree, 'Text', object.Name, 'NodeData', object);
            RefreshParameterTree(node, parameters);
            expand(node);
        end

        function TupdateProblem(app)
            name = app.TProblemDropDown.Value;
            if isempty(name), return; end
            nodes = app.TProblemTree.Children;
            if ~isempty(nodes) && strcmp(class(nodes(1).NodeData), name)
                return;
            end
            % Construct and read parameters before replacing the currently loaded object.
            object = feval(name, strrep(name, '_', '-'));
            parameters = object.getParameter();
            delete(nodes);
            node = uitreenode(app.TProblemTree, 'Text', object.Name, 'NodeData', object);
            RefreshParameterTree(node, parameters);
            expand(node);
        end

        function TupdateUIAxes(app)
            PlotTest(app);
        end

        function [vars, objectives, feasible] = TpreviewSlice(app, prob, task, coordinates)
            [vars, objectives, feasible] = PreviewTaskSlice(prob, task, coordinates);
        end

        function values = TpreviewObjective(app, objectives, feasible, unified)
            values = PreviewObjectiveValues(objectives, feasible, unified);
        end

        function TupdateTasksFigure(app)
            PlotTestTasks1D(app);
        end

        function TupdateTasksFigure2D(app)
            PlotTestTasks2D(app);
        end

        function TupdateFeasibleRegion(app)
            PlotTestFeasibleRegion(app);
        end

        function TupdateConvergence(app)
            PlotTestConvergence(app);
        end

        function TupdateParetoFront(app)
            PlotTestParetoFront(app);
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

            % Table styles persist when Data is replaced, so clear them explicitly.
            app.EUITable.removeStyle();
            app.EHighlightMatrix = [];
            app.EUITable.Data = {};
            app.EUITable.RowName = row_name;
            app.EUITable.ColumnName = column_name;
            app.ETableData = {};
            app.ETableView = {};
            app.ETableTest = {};
            drawnow;
        end

        function EreloadTableData(app)
            % Reload table data only after results have been loaded or produced.
            if isempty(app.EData), return; end
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
                        result = feval(app.EDataTypeDropDown.Value, app.EData, app.EParallelCheckBox.Value);
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
            UpdateExperimentStatistics(app);
        end

        function EupdateTableHighlight(app)
            % update table highlight

            % highlight best value
            app.EUITable.removeStyle();
            app.EHighlightMatrix = zeros(size(app.EUITable.DisplayData));
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
                    app.EHighlightMatrix(row_idx, temp_idx) = 1;
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
            if size(app.EUITable.Data, 1) == size(app.ETableData, 1) + 2
                % Friedman test
                temp_data = app.EUITable.Data(end-1,:);
                temp_data = cell2mat(cellfun(@str2double, temp_data, 'UniformOutput', false));
                best_data = min(temp_data);
                temp_idx = find(temp_data == best_data)';
                temp_x = repmat(size(app.ETableData, 1) + 1, length(temp_idx), 1);
                best_matrix = [best_matrix; [temp_x, temp_idx]];
                app.EHighlightMatrix(size(app.ETableData, 1) + 1, temp_idx) = 1;
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

        function nodes = DselectedData(app, minimum)
            % Use tree order and ignore metadata children in mixed selections.
            nodes = app.DDataTree.Children;
            nodes = nodes(ismember(nodes, app.DDataTree.SelectedNodes));
            if numel(nodes) < minimum
                uialert(app.MToPv111UIFigure, ...
                    sprintf('Select at least %d data node(s).', minimum), ...
                    'Data selection', 'Icon', 'warning');
                nodes = nodes([]);
            end
        end

        function DprocessData(app, operation, argument)
            nodes = app.DselectedData(1 + strcmp(operation, 'merge'));
            if isempty(nodes), return; end
            labels = {'Problems', 'Algorithms', 'Reps'};
            if strcmp(operation, 'merge')
                try
                    inputs = arrayfun(@(node) node.NodeData, nodes, 'UniformOutput', false);
                    data = ProcessMTOData(inputs, operation, argument);
                    app.DputDataNode(['data (Merge ', labels{argument}, ')'], data);
                catch ME
                    app.showError(ME, 'Data merge failed');
                end
                return;
            end
            for i = 1:numel(nodes)
                try
                    output = ProcessMTOData(nodes(i).NodeData, operation, argument);
                    if strcmp(operation, 'split')
                        if numel(output) == 1
                            uialert(app.MToPv111UIFigure, ...
                                ['Only one ', lower(labels{argument}), ' entry in ', nodes(i).Text, '.'], ...
                                'Data split', 'Icon', 'warning');
                            continue;
                        end
                        for j = 1:numel(output)
                            switch argument
                                case 1, suffix = ['Problem: ', output{j}.Problems.Name];
                                case 2, suffix = ['Algorithm: ', output{j}.Algorithms.Name];
                                case 3, suffix = ['Rep: ', num2str(j)];
                            end
                            app.DputDataNode([nodes(i).Text, ' (Split ', suffix, ')'], output{j});
                        end
                    else
                        if strcmp(operation, 'reduce'), suffix = 'Reduced';
                        else, suffix = 'Precision'; end
                        app.DputDataNode([nodes(i).Text, ' (', suffix, ')'], output);
                    end
                catch ME
                    app.showError(ME, ['Data processing failed: ', nodes(i).Text]);
                end
            end
        end

        function DmoveData(app, direction)
            nodes = app.DselectedData(1);
            if direction > 0, nodes = flipud(nodes); end
            for i = 1:numel(nodes)
                siblings = app.DDataTree.Children;
                index = find(siblings == nodes(i)) + direction;
                if index < 1 || index > numel(siblings) || ismember(siblings(index), nodes)
                    continue;
                end
                if direction < 0, location = 'before'; else, location = 'after'; end
                move(nodes(i), siblings(index), location);
            end
            app.DDataTree.SelectedNodes = nodes;
        end

        function DputDataNode(app, name, data)
            node = uitreenode(app.DDataTree, 'Text', name, 'NodeData', data);
            text = ['Reps: ', num2str(data.Reps)];
            uitreenode(node, 'Text', text, 'NodeData', text);
            fields = {'Algorithms', 'Problems'};
            for i = 1:numel(fields)
                text = [fields{i}, ':'];
                group = uitreenode(node, 'Text', text, 'NodeData', text);
                items = data.(fields{i});
                for j = 1:numel(items)
                    uitreenode(group, 'Text', items(j).Name, 'NodeData', items(j).Name);
                end
            end
            drawnow;
        end

        function DsaveData(app, MTOData)
            [file, folder] = uiputfile('MTOData.mat');
            if isequal(file, 0), return; end
            save(fullfile(folder, file), 'MTOData');
        end

    end


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            addpath(genpath(fileparts(fileparts(mfilename('fullpath')))));
            app.TSampleNumberEditField.Limits = [1, Inf];
            app.TSampleNumberEditField.RoundFractionalValues = 'on';
            % Item clicks also load the first filtered choice when Value has not changed.
            app.TAlgorithmDropDown.ClickedFcn = @(~, event) app.TAlgorithmDropDownValueChanged(event);
            app.TProblemDropDown.ClickedFcn = @(~, event) app.TProblemDropDownValueChanged(event);
            % App startup function

            app.TloadAlgoProb();
            app.TupdateAlgorithm();
            app.TupdateProblem();
            % app.TupdateUIAxes();
            app.EloadAlgoProb();
            app.MTOPlatformTabGroup.SelectedTab = app.ExperimentModuleTab;
            app.EloadMetric('Nothing');
        end

        % Value changed function: TTaskTypeDropDown
        function TTaskTypeDropDownValueChanged(app, event)
            app.TloadAlgoProb();
        end

        % Value changed function: TObjectiveTypeDropDown
        function TObjectiveTypeDropDownValueChanged(app, event)
            app.TloadAlgoProb();
        end

        % Value changed function: TAlgorithmDropDown
        function TAlgorithmDropDownValueChanged(app, event)
            if isa(event, 'matlab.ui.eventdata.ClickedData')
                index = event.InteractionInformation.Item;
                if isempty(index), return; end
                app.TAlgorithmDropDown.Value = app.TAlgorithmDropDown.ItemsData{index};
            end
            nodes = app.TAlgorithmTree.Children;
            if isempty(app.TAlgorithmDropDown.Value) || ...
                    (~isempty(nodes) && strcmp(class(nodes(1).NodeData), app.TAlgorithmDropDown.Value))
                return;
            end
            try
                app.TupdateAlgorithm();
                app.TData = [];
                app.TupdateUIAxes();
            catch ME
                app.showError(ME, 'Algorithm selection failed');
            end
        end

        % Drop down opening function: TAlgorithmDropDown
        function TAlgorithmDropDownOpening(app, event)
            % Opening the list does not change the selection or its parameters.
        end

        % Node text changed function: TAlgorithmTree
        function TAlgorithmTreeNodeTextChanged(app, event)
            try
                if EditParameterTree(event.Node)
                    app.TData = [];
                    app.TupdateUIAxes();
                end
            catch ME
                app.TData = [];
                app.showError(ME, 'Parameter edit failed');
            end
        end

        % Value changed function: TProblemDropDown
        function TProblemDropDownValueChanged(app, event)
            if isa(event, 'matlab.ui.eventdata.ClickedData')
                index = event.InteractionInformation.Item;
                if isempty(index), return; end
                app.TProblemDropDown.Value = app.TProblemDropDown.ItemsData{index};
            end
            nodes = app.TProblemTree.Children;
            if isempty(app.TProblemDropDown.Value) || ...
                    (~isempty(nodes) && strcmp(class(nodes(1).NodeData), app.TProblemDropDown.Value))
                return;
            end
            try
                app.TupdateProblem();
                app.TData = [];
                app.TupdateUIAxes();
            catch ME
                app.showError(ME, 'Problem selection failed');
            end
        end

        % Drop down opening function: TProblemDropDown
        function TProblemDropDownOpening(app, event)
            % Opening the list does not change the selection or its parameters.
        end

        % Node text changed function: TProblemTree
        function TProblemTreeNodeTextChanged(app, event)
            try
                if EditParameterTree(event.Node)
                    app.TData = [];
                    app.TupdateUIAxes();
                end
            catch ME
                app.TData = [];
                app.showError(ME, 'Parameter edit failed');
            end
        end

        % Value changed function: TShowTypeDropDown
        function TShowTypeDropDownValueChanged(app, event)
            app.TupdateUIAxes();
        end

        % Value changed function: TSampleNumberEditField
        function TSampleNumberEditFieldValueChanged(app, event)
            app.TupdateUIAxes();
        end

        % Button pushed function: TStartButton
        function TStartButtonPushed(app, event)
            % start this test

            if isempty(app.TAlgorithmTree.Children) || isempty(app.TProblemTree.Children)
                uialert(app.MToPv111UIFigure, 'Please select an algorithm and a problem.', ...
                    'Cannot start', 'Icon', 'warning');
                return;
            end

            % off the start button
            app.TstartEnable(false);
            % Restore controls even if preparation or execution returns early or fails.
            cleanup = onCleanup(@() app.finishRun('Test')); %#ok<NASGU>
            app.TStopFlag = false;
            drawnow;

            try
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
                app.TAlgorithmTree.Children(1).NodeData.Check_Status_Fn = @app.TcheckPauseStopStatus;
                app.TAlgorithmTree.Children(1).NodeData.Draw_Dec = app.TDrawDecCheckBox.Value;
                app.TAlgorithmTree.Children(1).NodeData.Draw_Obj = app.TDrawObjCheckBox.Value;
                app.TAlgorithmTree.Children(1).NodeData.drawInit(app.TProblemTree.Children(1).NodeData);
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
            catch ME
                if strcmp(ME.message, 'User Stop')
                    return;
                else
                    app.TData = [];
                    report = app.showError(ME, 'Test run failed');
                    app.Toutput(cellstr(splitlines(string(report))));
                    scroll(app.TOutputTextArea, 'bottom');
                    return;
                end
            end

            % Completed results remain available if plotting or metric calculation fails.
            try
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
                scroll(app.TOutputTextArea,"bottom");

            catch ME
                report = app.showError(ME, 'Test postprocessing failed');
                app.Toutput(cellstr(splitlines(string(report))));
                scroll(app.TOutputTextArea, 'bottom');
            end
        end

        % Button pushed function: TPauseButton
        function TPauseButtonPushed(app, event)
            % pause or resume

            if strcmp(app.TPauseButton.Text, 'Pause')
                app.TStopButton.Enable = 'on';
                app.TPauseButton.Text = 'Resume';
            else
                app.TStopButton.Enable = 'on';
                app.TPauseButton.Text = 'Pause';
            end
        end

        % Button pushed function: TStopButton
        function TStopButtonPushed(app, event)
            app.TStopFlag = true;
                app.TPauseButton.Text = 'Pause';
            app.TData = [];
            app.TStopButton.Enable = 'off';
        end

        % Button pushed function: TExportButton
        function TExportButtonPushed(app, event)
            ExportTestPlot(app);
        end

        % Value changed function: ETaskTypeDropDown
        function ETaskTypeDropDownValueChanged(app, event)
            app.EloadAlgoProb();
        end

        % Value changed function: EObjectiveTypeDropDown
        function EObjectiveTypeDropDownValueChanged(app, event)
            app.EloadAlgoProb();
        end

        % Menu selected function: AlgorithmsSelectAllMenu
        function EAlgorithmsSelectAllMenuSelected(app, event)
            % select all algorithms

            if ~isempty(app.EAlgorithmsListBox.Items)
                app.EAlgorithmsListBox.Value = app.EAlgorithmsListBox.ItemsData;
            end
        end

        % Button pushed function: EAlgorithmsAddButton
        function EAlgorithmsAddButtonPushed(app, event)
            % add selected algorithms to selected algorithms tree

            algo_selected = app.EAlgorithmsListBox.Value;
            if isempty(algo_selected), return; end
            for i= 1:length(algo_selected)
                algo_name = algo_selected{i};
                algo_dispname = strrep(algo_name, '_', '-');
                if exist(algo_name, 'class')
                    clear(algo_name);
                end
                rehash;
                algo_obj = feval(algo_name, algo_dispname);

                algo_node = uitreenode(app.EAlgorithmsTree);
                algo_node.Text = algo_obj.Name;
                algo_node.NodeData = algo_obj;

                RefreshParameterTree(algo_node);
            end

            % collapse other node and expand this node
            all_node = algo_node.Parent.Children;
            for i = 1:length(all_node)
                collapse(all_node(i));
            end
            expand(algo_node);
        end

        % Menu selected function: ProblemsSelectAllMenu
        function EProblemsSelectAllMenuSelected(app, event)
            % select all problems

            if ~isempty(app.EProblemsListBox.Items)
                app.EProblemsListBox.Value = app.EProblemsListBox.ItemsData;
            end
        end

        % Button pushed function: EProblemsAddButton
        function EProblemsAddButtonPushed(app, event)
            % add selected problems to selected problems tree

            prob_selected = app.EProblemsListBox.Value;
            if isempty(prob_selected), return; end
            for i= 1:length(prob_selected)
                prob_name = prob_selected{i};
                prob_dispname = strrep(prob_name, '_', '-');
                if exist(prob_name, 'class')
                    clear(prob_name);
                end
                rehash;
                prob_obj = feval(prob_name, prob_dispname);

                prob_node = uitreenode(app.EProblemsTree);
                prob_node.Text = prob_obj.Name;
                prob_node.NodeData = prob_obj;

                RefreshParameterTree(prob_node);
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
            if isempty(app.EAlgorithmsTree.Children) || isempty(app.EProblemsTree.Children)
                uialert(app.MToPv111UIFigure, ...
                    'Please select at least one algorithm and one problem.', ...
                    'Experiment', 'Icon', 'warning');
                return;
            end

            app.EstartEnable(false);
            cleanup = onCleanup(@() app.finishRun('Experiment')); %#ok<NASGU>
            try
                app.EStopFlag = false;
                MTOData = app.EcreateExperimentData();
                problems = MTOData.Problems;
                algorithms = MTOData.Algorithms;
                prob_num = numel(problems);
                algo_num = numel(algorithms);

                app.EData = [];
                app.EloadMetric('Nothing');
                app.EDataTypeDropDown.Value = 'Reps';
                app.ETableReps = zeros(prob_num, algo_num);
                app.EresetTable({problems.Name}, {algorithms.Name});
                app.EupdateTableReps();
                app.EresetTableAlgorithmDropDown({algorithms.Name});

                % Each repetition uses the same seed across all algorithms and problems.
                seeds = -ones(1, MTOData.Reps);
                if app.ERngSeedCheckBox.Value
                    seeds = app.ERngSeedEditField.Value + (0:MTOData.Reps-1);
                end

                startTime = tic;
                Results = struct([]);
                for prob = 1:prob_num
                    for algo = 1:algo_num
                        app.EcheckPauseStopStatus();
                        [results, runTimes] = app.ErunRepetitions(prob, algo, seeds);
                        if isempty(Results)
                            Results = reshape(results, 1, 1, []);
                        else
                            Results(prob, algo, :) = reshape(results, 1, 1, []);
                        end
                        MTOData.RunTimes(prob, algo, :) = runTimes;
                        app.EcheckPauseStopStatus();

                        % Save only complete rectangles: the first row or a full problem row.
                        if prob == 1 || algo == algo_num
                            MTOData.Results = MakeGenEqual(Results);
                            MTOData.Problems = problems(1:prob);
                            MTOData.Algorithms = algorithms(1:algo);
                            save('MTOData_Temp', 'MTOData');
                            app.EData = MTOData;
                        end
                    end
                end

                app.EloadMetric(app.getDataLabels(MTOData));
                msg = ['All Use Time: ', char(duration([0, 0, toc(startTime)]))];
                uiconfirm(app.MToPv111UIFigure, msg, 'success', 'Icon', 'success');
                app.EreloadTableData();
            catch ME
                if ~strcmp(ME.message, 'User Stop')
                    app.showError(ME, 'Experiment run failed');
                end
            end
        end

        % Button pushed function: EPauseButton
        function EPauseButtonPushed(app, event)
            % pause or resume this experiment

            if strcmp(app.EPauseButton.Text, 'Pause')
                msg = 'Are you sure to pause the experiment?';
                selection = uiconfirm(app.MToPv111UIFigure, msg, 'Confirm Pause', ...
                                     'Options', {'Confirm', 'Cancel'}, ...
                                     'DefaultOption', 'Cancel', ...
                                     'Icon', 'warning'); % 'warning' might be more appropriate than 'success'
                if strcmp(selection, 'Confirm')
                    app.EStopButton.Enable = 'on';
                    app.EPauseButton.Text = 'Resume';
                end
            else
                app.EStopButton.Enable = 'on';
                app.EPauseButton.Text = 'Pause';
            end
        end

        % Button pushed function: EStopButton
        function EStopButtonPushed(app, event)
            % stop this experiment

            msg = 'Are you sure to stop the experiment?';
            selection = uiconfirm(app.MToPv111UIFigure, msg, 'Confirm Stop', ...
                                 'Options', {'Confirm', 'Cancel'}, ...
                                 'DefaultOption', 'Cancel', ...
                                 'Icon', 'warning'); % 'warning' might be more appropriate than 'success'
            
            if strcmp(selection, 'Confirm')
                app.EStopButton.Enable = 'off';
                app.EStopFlag = true;
                app.EPauseButton.Text = 'Pause';
            end
        end

        % Button pushed function: EAlgorithmsDelButton
        function EAlgorithmsDelButtonPushed(app, event)
            % delete selected algorithms from algorithms tree

            algo_selected = app.EAlgorithmsTree.SelectedNodes;
            if isempty(algo_selected)
                msg = 'Select Algorithm node in tree first';
                uiconfirm(app.MToPv111UIFigure, msg, 'error', 'Icon','warning');
            end

            for i = 1:length(algo_selected)
                if isa(algo_selected(i).Parent, 'matlab.ui.container.Tree')
                    algo_selected(i).delete;
                end
            end
        end

        % Node text changed function: EAlgorithmsTree
        function EAlgorithmsTreeNodeTextChanged(app, event)
            try
                EditParameterTree(event.Node);
            catch ME
                app.showError(ME, 'Parameter edit failed');
            end
        end

        % Menu selected function: SelectedAlgoSelectAllMenu
        function ESelectedAlgoSelectAllMenuSelected(app, event)
            % select all selected algorithms

            if ~isempty(app.EAlgorithmsTree.Children)
                app.EAlgorithmsTree.SelectedNodes = app.EAlgorithmsTree.Children;
            end
        end

        % Menu selected function: SelectedProbSelectAllMenu
        function ESelectedProbSelectAllMenuSelected(app, event)
            % select all selected problems

            if ~isempty(app.EProblemsTree.Children)
                app.EProblemsTree.SelectedNodes = app.EProblemsTree.Children;
            end
        end

        % Menu selected function: EditPublicParaMenu
        function EEditPublicParaMenuSelected(app, event)
            % Get selected problem nodes
            selected_nodes = app.EProblemsTree.SelectedNodes;
            if isempty(selected_nodes)
                uialert(app.MToPv111UIFigure, ...
                    'No nodes selected. Please select at least one problem node.', ...
                    'Warning', 'Icon', 'warning');
                return;
            end
        
            % Filter top-level problem nodes (exclude parameter subnodes)
            prob_nodes = [];
            for i = 1:length(selected_nodes)
                if isa(selected_nodes(i).Parent, 'matlab.ui.container.Tree')
                    prob_nodes = [prob_nodes, selected_nodes(i)];
                end
            end
        
            if isempty(prob_nodes)
                uialert(app.MToPv111UIFigure, ...
                    'No top-level problem nodes selected. Please select proper problem nodes.', ...
                    'Warning', 'Icon', 'warning');
                return;
            end
        
            problems = arrayfun(@(node) node.NodeData, prob_nodes, 'UniformOutput', false);
            info = GetPublicParameterInfo(problems);
            screen_size = get(0, 'ScreenSize');
            dlg_width = 245;
            dlg_height = 175;
            dlg = uifigure('Name', sprintf('Batch Edit %d Problem(s)', length(prob_nodes)), ...
                           'Position', [(screen_size(3)-dlg_width)/2, ...
                                        (screen_size(4)-dlg_height)/2, ...
                                         dlg_width, dlg_height], ...
                           'Color', [1 1 1]);
            dlg.WindowStyle = 'modal';
            dlg.Resize = 'on';
            layout = uigridlayout(dlg, [1, 1]);
            layout.Padding = [0, 0, 0, 0];
            paraUI = SetPublicPara(layout, 'CurrentValues', info.Values, 'EditableFields', info.Editable);
            paraUI.Layout.Row = 1;
            paraUI.Layout.Column = 1;
        
            addlistener(paraUI, 'ParametersApplied', @(src,evt)applyBatchEdit(paraUI.PublicParameters));
        
            function applyBatchEdit(params)
                % Only explicitly changed, shared parameters are applied.
                changed = find(info.Editable & isfinite(params));
                if isempty(changed), close(dlg); return; end
                try
                    for n = 1:length(prob_nodes)
                        current_params = prob_nodes(n).NodeData.getParameter();
                        for p = changed
                            current_params{info.Indices(n, p)} = num2str(params(p), 16);
                        end
                        prob_nodes(n).NodeData.setParameter(current_params(2:2:end));
                        % Display the values accepted by each problem's setter.
                        RefreshParameterTree(prob_nodes(n));
                        expand(prob_nodes(n));
                    end
                    close(dlg);
                catch ME
                    report = getReport(ME, 'extended', 'hyperlinks', 'off');
                    fprintf(2, '\nBatch edit failed\n%s\n', report);
                    uialert(dlg, report, 'Batch edit failed', 'Icon', 'error', 'Interpreter', 'none');
                end
            end
        end

        % Button pushed function: EProblemsDelButton
        function EProblemsDelButtonPushed(app, event)
            % delete selected problems from problems tree

            prob_selected = app.EProblemsTree.SelectedNodes;
            if isempty(prob_selected)
                msg = 'Select Problem node in tree first';
                uiconfirm(app.MToPv111UIFigure, msg, 'error', 'Icon','warning');
            end

            for i = 1:length(prob_selected)
                if isa(prob_selected(i).Parent, 'matlab.ui.container.Tree')
                    prob_selected(i).delete;
                end
            end
        end

        % Node text changed function: EProblemsTree
        function EProblemsTreeNodeTextChanged(app, event)
            try
                EditParameterTree(event.Node);
            catch ME
                app.showError(ME, 'Parameter edit failed');
            end
        end

        % Button pushed function: ESaveDataButton
        function ESaveDataButtonPushed(app, event)
            % save data to folder

            % check data
            if isempty(app.EData)
                msg = 'Please run experiment first';
                uiconfirm(app.MToPv111UIFigure, msg, 'error', 'Icon','warning');
                return;
            end

            % check selected file name
            app.MToPv111UIFigure.Visible = 'off';
            [file_name, dir_name] = uiputfile('MTOData.mat');
            app.MToPv111UIFigure.Visible = 'on';
            figure(app.MToPv111UIFigure);
            drawnow;
            
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
            [file_name, pathname] = uigetfile('*.mat', 'Select Data', './');
            if isequal(file_name, 0), return; end
            try
                loaded = load(fullfile(pathname, file_name), 'MTOData');
                if ~isfield(loaded, 'MTOData')
                    error('MToP:MissingData', 'The file does not contain MTOData.');
                end
                ValidateMTOData(loaded.MTOData);
                labels = app.getDataLabels(loaded.MTOData);
                names = {loaded.MTOData.Algorithms.Name};
                app.EData = loaded.MTOData;
                app.EloadMetric(labels);
                app.ETableReps = app.EData.Reps * ones(numel(app.EData.Problems), numel(app.EData.Algorithms));
                app.EresetTableAlgorithmDropDown(names);
                app.EreloadTableData();
            catch ME
                app.showError(ME, 'Data load failed');
            end
        end

        % Button pushed function: ESaveTableButton
        function ESaveTableButtonPushed(app, event)
            msg = 'Select Export Type';
            selection = uiconfirm(app.MToPv111UIFigure, msg, 'Export', ...
                                 'Options', {'Current Table (tex, xlsx, csv)', 'IOHanalyzer Data (csv)', 'Best Dec/PopDecs (mat)', 'Cancel'}, ...
                                 'DefaultOption', 'Cancel', 'Icon', 'question');

            if contains(selection, 'Current Table')
                % save table
    
                % check selected file name
                filter = {'*.tex'; '*.xlsx';'*.csv';};
                app.MToPv111UIFigure.Visible = 'off';
                [file_name, dir_name] = uiputfile(filter);
                app.MToPv111UIFigure.Visible = 'on';
                figure(app.MToPv111UIFigure);
                drawnow;
                
                if file_name == 0
                    return;
                end
                if contains(file_name, 'tex')
                    hl = zeros(size(app.EUITable.Data));
                    if ~strcmp(app.EHighlightTypeDropDown.Value, 'None')
                        hl = app.EHighlightMatrix;
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
            elseif contains(selection, 'IOHanalyzer')
                % save current metric convergence

                 % check selected file name
                filter = {'*.csv';};
                app.MToPv111UIFigure.Visible = 'off';
                [file_name, dir_name] = uiputfile(filter);
                app.MToPv111UIFigure.Visible = 'on';
                figure(app.MToPv111UIFigure);
                drawnow;
                
                if file_name == 0
                    return;
                end
                if ~isfield(app.EData, 'Metrics') || isempty(app.EData.Metrics)
                    msg = 'No metric data in current results!';
                    uiconfirm(app.MToPv111UIFigure, msg, 'warning', 'Icon', 'warning');
                    return;
                end
                metric_idx = find(ismember({app.EData.Metrics.Name}, app.EDataTypeDropDown.Value));
                table_out = IOHconvert(app.EData.Metrics(metric_idx).Result, app.EData.Problems);
                writetable(table_out, [dir_name, file_name]);
            elseif contains(selection, 'Best Decision Variable')
                % save best dec of algorithms on problems

                if ~isfield(app.EData.Results(1), 'Dec')
                    msg = 'No decision variable data in current results!';
                    uiconfirm(app.MToPv111UIFigure, msg, 'warning', 'Icon', 'warning');
                    return;
                end
                if contains(app.EDataTypeDropDown.Value, 'Reps') || ...
                        contains(app.EDataTypeDropDown.Value, 'Time')
                    msg = 'Please select metric data';
                    uiconfirm(app.MToPv111UIFigure, msg, 'warning', 'Icon', 'warning');
                    return;
                end
                % check selected file name
                filter = {'*.mat'; };
                app.MToPv111UIFigure.Visible = 'off';
                [file_name, dir_name] = uiputfile(filter);
                app.MToPv111UIFigure.Visible = 'on';
                figure(app.MToPv111UIFigure);
                drawnow;

                if file_name == 0
                    return;
                end

                % get best dec
                prob_num = length(app.EData.Problems);
                Decs = {};

                table_data = app.EResultTableData;
                m = size(table_data, 1);
                idx = zeros(m, 2);
                for i = 1:m
                    slice = reshape(table_data(i,:,:), size(table_data,2), size(table_data,3));
                    [~, linearIdx] = min(slice(:));
                    [row, col] = ind2sub(size(slice), linearIdx);
                    idx(i, :) = [row, col];
                end

                if m == prob_num
                    % each problem contains tasks
                    for p = 1:prob_num
                        for t = 1:app.EData.Problems(p).T
                            if max(app.EData.Problems(p).M) > 1
                                Decs{p, t} = squeeze(app.EData.Results(p, idx(p,1), idx(p,2)).Dec(t,end,:,1:app.EData.Problems(p).D(t)));
                            else
                                Decs{p, t} = squeeze(app.EData.Results(p, idx(p,1), idx(p,2)).Dec(t,end,1:app.EData.Problems(p).D(t)))';
                            end
                        end
                    end
                else
                    % each task
                    task_count = 0;
                    for p = 1:prob_num
                        for t = 1:app.EData.Problems(p).T
                            task_count = task_count + 1;
                            if max(app.EData.Problems(p).M) > 1
                                Decs{p, t} = squeeze(app.EData.Results(p, idx(task_count,1), idx(task_count,2)).Dec(t,end,:,1:app.EData.Problems(p).D(t)));
                            else
                                Decs{p, t} = squeeze(app.EData.Results(p, idx(task_count,1), idx(task_count,2)).Dec(t,end,1:app.EData.Problems(p).D(t)))';
                            end
                        end
                    end
                end
                save([dir_name, file_name], 'Decs');
            end
        end

        % Cell selection callback: EUITable
        function EUITableCellSelection(app, event)
            app.ETableSelected = event.Indices;
            app.ETableSelected(app.ETableSelected(:,1) > size(app.ETableView,1),:) = [];
        end

        % Button pushed function: EConvergeButton
        function EConvergeButtonPushed(app, event)
            PlotExperimentConvergence(app);
        end

        % Button pushed function: EParetoButton
        function EParetoButtonPushed(app, event)
            PlotExperimentParetoFront(app);
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
            [files, folder] = uigetfile('*.mat', 'Select MTOData files', './', 'MultiSelect', 'on');
            if isequal(files, 0), return; end
            if ischar(files), files = {files}; end
            for i = 1:numel(files)
                try
                    loaded = load(fullfile(folder, files{i}), 'MTOData');
                    if ~isfield(loaded, 'MTOData')
                        error('MToP:MissingData', '%s does not contain MTOData.', files{i});
                    end
                    ValidateMTOData(loaded.MTOData);
                    [~, name] = fileparts(files{i});
                    app.DputDataNode(name, loaded.MTOData);
                catch ME
                    app.showError(ME, ['Data load failed: ', files{i}]);
                end
            end
        end

        % Button pushed function: DDeleteDataButton
        function DDeleteDataButtonPushed(app, event)
            delete(app.DselectedData(1));
        end

        % Button pushed function: DSaveDataButton
        function DSaveDataButtonPushed(app, event)
            nodes = app.DselectedData(1);
            for i = 1:numel(nodes)
                try
                    app.DsaveData(nodes(i).NodeData);
                catch ME
                    app.showError(ME, ['Data save failed: ', nodes(i).Text]);
                end
            end
        end

        % Button pushed function: DRepsSplitButton
        function DRepsSplitButtonPushed(app, event)
            app.DprocessData('split', 3);
        end

        % Button pushed function: DAlgorithmsSplitButton
        function DAlgorithmsSplitButtonPushed(app, event)
            app.DprocessData('split', 2);
        end

        % Button pushed function: DProblemsSplitButton
        function DProblemsSplitButtonPushed(app, event)
            app.DprocessData('split', 1);
        end

        % Button pushed function: DRepsMergeButton
        function DRepsMergeButtonPushed(app, event)
            app.DprocessData('merge', 3);
        end

        % Button pushed function: DAlgorithmsMergeButton
        function DAlgorithmsMergeButtonPushed(app, event)
            app.DprocessData('merge', 2);
        end

        % Button pushed function: DProblemsMergeButton
        function DProblemsMergeButtonPushed(app, event)
            app.DprocessData('merge', 1);
        end

        % Button pushed function: DPreisionButton
        function DPreisionButtonPushed(app, event)
            app.DprocessData('precision', app.DPreisionEditField.Value);
        end

        % Button pushed function: DDataLengthButton
        function DDataLengthButtonPushed(app, event)
            app.DprocessData('reduce', app.DDataLengthEditField.Value);
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
            app.DmoveData(-1);
        end

        % Button pushed function: DDownButton
        function DDownButtonPushed(app, event)
            app.DmoveData(1);
        end

        % Button down function: TestModuleTab
        function TestModuleTabButtonDown(app, event)
            app.TupdateUIAxes();
        end

        % Value changed function: EConstrainedButton
        function EConstrainedButtonValueChanged(app, event)
            app.EloadAlgoProb();
        end

        % Value changed function: ECompetitiveButton
        function ECompetitiveButtonValueChanged(app, event)
            app.EloadAlgoProb();
        end

        % Value changed function: EStreamButton
        function EStreamButtonValueChanged(app, event)
            app.EloadAlgoProb();
        end

        % Menu selected function: AlgorithmRefreshMenu, ProblemRefreshMenu
        function RefreshMenuSelected(app, event)
            rehash('path');
            app.EloadAlgoProb();
        end

        % Value changed function: TConstrainedButton
        function TConstrainedButtonValueChanged(app, event)
            app.TloadAlgoProb();
        end

        % Value changed function: TCompetitiveButton
        function TCompetitiveButtonValueChanged(app, event)
            app.TloadAlgoProb();
        end

        % Value changed function: TStreamButton
        function TStreamButtonValueChanged(app, event)
            app.TloadAlgoProb();
        end

        % Value changed function: EYearDropDown
        function EYearDropDownValueChanged(app, event)
            app.EloadAlgoProb();
            
        end

        % Value changed function: TYearDropDown
        function TYearDropDownValueChanged(app, event)
            app.TloadAlgoProb();
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create MToPv111UIFigure and hide until all components are created
            app.MToPv111UIFigure = uifigure('Visible', 'off');
            app.MToPv111UIFigure.Color = [1 1 1];
            app.MToPv111UIFigure.Position = [100 100 1045 744];
            app.MToPv111UIFigure.Name = 'MToP v1.11';

            % Create MTOPlatformGridLayout
            app.MTOPlatformGridLayout = uigridlayout(app.MToPv111UIFigure);
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
            app.TestModuleTab.ButtonDownFcn = createCallbackFcn(app, @TestModuleTabButtonDown, true);

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
            app.TP1GridLayout.RowHeight = {'fit', 'fit', 'fit', 'fit', 'fit', 'fit', '1x', 'fit', '1x'};
            app.TP1GridLayout.ColumnSpacing = 5;
            app.TP1GridLayout.RowSpacing = 7;
            app.TP1GridLayout.Padding = [0 0 0 0];
            app.TP1GridLayout.BackgroundColor = [1 1 1];

            % Create AlgorithmDropDownLabel
            app.AlgorithmDropDownLabel = uilabel(app.TP1GridLayout);
            app.AlgorithmDropDownLabel.FontWeight = 'bold';
            app.AlgorithmDropDownLabel.Layout.Row = 6;
            app.AlgorithmDropDownLabel.Layout.Column = 1;
            app.AlgorithmDropDownLabel.Text = 'Algorithm';

            % Create TAlgorithmDropDown
            app.TAlgorithmDropDown = uidropdown(app.TP1GridLayout);
            app.TAlgorithmDropDown.Items = {};
            app.TAlgorithmDropDown.DropDownOpeningFcn = createCallbackFcn(app, @TAlgorithmDropDownOpening, true);
            app.TAlgorithmDropDown.ValueChangedFcn = createCallbackFcn(app, @TAlgorithmDropDownValueChanged, true);
            app.TAlgorithmDropDown.Tooltip = {'Select algorithm'};
            app.TAlgorithmDropDown.FontSize = 10;
            app.TAlgorithmDropDown.FontWeight = 'bold';
            app.TAlgorithmDropDown.BackgroundColor = [1 1 1];
            app.TAlgorithmDropDown.Layout.Row = 6;
            app.TAlgorithmDropDown.Layout.Column = 2;
            app.TAlgorithmDropDown.Value = {};

            % Create TAlgorithmTree
            app.TAlgorithmTree = uitree(app.TP1GridLayout);
            app.TAlgorithmTree.Multiselect = 'on';
            app.TAlgorithmTree.NodeTextChangedFcn = createCallbackFcn(app, @TAlgorithmTreeNodeTextChanged, true);
            app.TAlgorithmTree.Editable = 'on';
            app.TAlgorithmTree.Tooltip = {'Click triangle to expand the algorithm, double-click to change the algorithm name or parameter value'};
            app.TAlgorithmTree.Layout.Row = 7;
            app.TAlgorithmTree.Layout.Column = [1 2];

            % Create TProblemTree
            app.TProblemTree = uitree(app.TP1GridLayout);
            app.TProblemTree.Multiselect = 'on';
            app.TProblemTree.NodeTextChangedFcn = createCallbackFcn(app, @TProblemTreeNodeTextChanged, true);
            app.TProblemTree.Editable = 'on';
            app.TProblemTree.Tooltip = {'Click triangle to expand the problem, double-click to change the problem name or parameter value'};
            app.TProblemTree.Layout.Row = 9;
            app.TProblemTree.Layout.Column = [1 2];

            % Create TProblemDropDown
            app.TProblemDropDown = uidropdown(app.TP1GridLayout);
            app.TProblemDropDown.Items = {};
            app.TProblemDropDown.DropDownOpeningFcn = createCallbackFcn(app, @TProblemDropDownOpening, true);
            app.TProblemDropDown.ValueChangedFcn = createCallbackFcn(app, @TProblemDropDownValueChanged, true);
            app.TProblemDropDown.Tooltip = {'Select problem'};
            app.TProblemDropDown.FontSize = 10;
            app.TProblemDropDown.FontWeight = 'bold';
            app.TProblemDropDown.BackgroundColor = [1 1 1];
            app.TProblemDropDown.Layout.Row = 8;
            app.TProblemDropDown.Layout.Column = 2;
            app.TProblemDropDown.Value = {};

            % Create ProblemDropDownLabel
            app.ProblemDropDownLabel = uilabel(app.TP1GridLayout);
            app.ProblemDropDownLabel.FontWeight = 'bold';
            app.ProblemDropDownLabel.Layout.Row = 8;
            app.ProblemDropDownLabel.Layout.Column = 1;
            app.ProblemDropDownLabel.Text = 'Problem';

            % Create TTaskTypeDropDown
            app.TTaskTypeDropDown = uidropdown(app.TP1GridLayout);
            app.TTaskTypeDropDown.Items = {'Multi', 'Many', 'Single'};
            app.TTaskTypeDropDown.ItemsData = {'Multi-task', 'Many-task', 'Single-task'};
            app.TTaskTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @TTaskTypeDropDownValueChanged, true);
            app.TTaskTypeDropDown.FontSize = 10;
            app.TTaskTypeDropDown.FontWeight = 'bold';
            app.TTaskTypeDropDown.BackgroundColor = [1 1 1];
            app.TTaskTypeDropDown.Layout.Row = 2;
            app.TTaskTypeDropDown.Layout.Column = 2;
            app.TTaskTypeDropDown.Value = 'Multi-task';

            % Create TaskLabel
            app.TaskLabel = uilabel(app.TP1GridLayout);
            app.TaskLabel.FontWeight = 'bold';
            app.TaskLabel.Tooltip = {''};
            app.TaskLabel.Layout.Row = 2;
            app.TaskLabel.Layout.Column = 1;
            app.TaskLabel.Text = 'Task';

            % Create TObjectiveTypeDropDown
            app.TObjectiveTypeDropDown = uidropdown(app.TP1GridLayout);
            app.TObjectiveTypeDropDown.Items = {'Single', 'Multi'};
            app.TObjectiveTypeDropDown.ItemsData = {'Single-objective', 'Multi-objective'};
            app.TObjectiveTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @TObjectiveTypeDropDownValueChanged, true);
            app.TObjectiveTypeDropDown.FontSize = 10;
            app.TObjectiveTypeDropDown.FontWeight = 'bold';
            app.TObjectiveTypeDropDown.BackgroundColor = [1 1 1];
            app.TObjectiveTypeDropDown.Layout.Row = 3;
            app.TObjectiveTypeDropDown.Layout.Column = 2;
            app.TObjectiveTypeDropDown.Value = 'Single-objective';

            % Create ObjectiveLabel
            app.ObjectiveLabel = uilabel(app.TP1GridLayout);
            app.ObjectiveLabel.FontWeight = 'bold';
            app.ObjectiveLabel.Tooltip = {''};
            app.ObjectiveLabel.Layout.Row = 3;
            app.ObjectiveLabel.Layout.Column = 1;
            app.ObjectiveLabel.Text = 'Objective';

            % Create TDrawDecCheckBox
            app.TDrawDecCheckBox = uicheckbox(app.TP1GridLayout);
            app.TDrawDecCheckBox.Tooltip = {'Parallel flag'; '(independent repetitions in parallel)'};
            app.TDrawDecCheckBox.Text = 'Draw Dec';
            app.TDrawDecCheckBox.FontWeight = 'bold';
            app.TDrawDecCheckBox.Layout.Row = 1;
            app.TDrawDecCheckBox.Layout.Column = 1;
            app.TDrawDecCheckBox.Value = true;

            % Create TDrawObjCheckBox
            app.TDrawObjCheckBox = uicheckbox(app.TP1GridLayout);
            app.TDrawObjCheckBox.Tooltip = {'Parallel flag'; '(independent repetitions in parallel)'};
            app.TDrawObjCheckBox.Text = 'Draw Obj';
            app.TDrawObjCheckBox.FontWeight = 'bold';
            app.TDrawObjCheckBox.Layout.Row = 1;
            app.TDrawObjCheckBox.Layout.Column = 2;
            app.TDrawObjCheckBox.Value = true;

            % Create TConstrainedButton
            app.TConstrainedButton = uibutton(app.TP1GridLayout, 'state');
            app.TConstrainedButton.ValueChangedFcn = createCallbackFcn(app, @TConstrainedButtonValueChanged, true);
            app.TConstrainedButton.Text = 'Constrained';
            app.TConstrainedButton.BackgroundColor = [1 1 1];
            app.TConstrainedButton.FontSize = 10;
            app.TConstrainedButton.FontWeight = 'bold';
            app.TConstrainedButton.Layout.Row = 4;
            app.TConstrainedButton.Layout.Column = 1;

            % Create TStreamButton
            app.TStreamButton = uibutton(app.TP1GridLayout, 'state');
            app.TStreamButton.ValueChangedFcn = createCallbackFcn(app, @TStreamButtonValueChanged, true);
            app.TStreamButton.Text = 'Stream';
            app.TStreamButton.BackgroundColor = [1 1 1];
            app.TStreamButton.FontSize = 10;
            app.TStreamButton.FontWeight = 'bold';
            app.TStreamButton.Layout.Row = 5;
            app.TStreamButton.Layout.Column = 1;

            % Create TCompetitiveButton
            app.TCompetitiveButton = uibutton(app.TP1GridLayout, 'state');
            app.TCompetitiveButton.ValueChangedFcn = createCallbackFcn(app, @TCompetitiveButtonValueChanged, true);
            app.TCompetitiveButton.Text = 'Competitive';
            app.TCompetitiveButton.BackgroundColor = [1 1 1];
            app.TCompetitiveButton.FontSize = 10;
            app.TCompetitiveButton.FontWeight = 'bold';
            app.TCompetitiveButton.Layout.Row = 4;
            app.TCompetitiveButton.Layout.Column = 2;

            % Create TYearDropDown
            app.TYearDropDown = uidropdown(app.TP1GridLayout);
            app.TYearDropDown.Items = {'All Year'};
            app.TYearDropDown.ValueChangedFcn = createCallbackFcn(app, @TYearDropDownValueChanged, true);
            app.TYearDropDown.FontSize = 10;
            app.TYearDropDown.FontWeight = 'bold';
            app.TYearDropDown.BackgroundColor = [1 1 1];
            app.TYearDropDown.Layout.Row = 5;
            app.TYearDropDown.Layout.Column = 2;
            app.TYearDropDown.Value = 'All Year';

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

            % Create TUIAxes
            app.TUIAxes = uiaxes(app.TP2GridLayout);
            app.TUIAxes.PlotBoxAspectRatio = [1.14506769825919 1 1];
            app.TUIAxes.Layout.Row = 2;
            app.TUIAxes.Layout.Column = 1;

            % Create TP21GridLayout
            app.TP21GridLayout = uigridlayout(app.TP2GridLayout);
            app.TP21GridLayout.ColumnWidth = {'1x', 'fit', 'fit', 'fit', 'fit'};
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
            app.TShowTypeDropDown.Tooltip = {'Figure Type'};
            app.TShowTypeDropDown.FontSize = 10;
            app.TShowTypeDropDown.FontWeight = 'bold';
            app.TShowTypeDropDown.BackgroundColor = [1 1 1];
            app.TShowTypeDropDown.Layout.Row = 1;
            app.TShowTypeDropDown.Layout.Column = 5;
            app.TShowTypeDropDown.Value = 'Tasks Figure (1D Unified)';

            % Create TExportButton
            app.TExportButton = uibutton(app.TP21GridLayout, 'push');
            app.TExportButton.ButtonPushedFcn = createCallbackFcn(app, @TExportButtonPushed, true);
            app.TExportButton.BusyAction = 'cancel';
            app.TExportButton.BackgroundColor = [1 1 1];
            app.TExportButton.FontSize = 10;
            app.TExportButton.FontWeight = 'bold';
            app.TExportButton.Tooltip = {''};
            app.TExportButton.Layout.Row = 1;
            app.TExportButton.Layout.Column = 4;
            app.TExportButton.Text = 'Export Figure';

            % Create SampleNumberEditFieldLabel
            app.SampleNumberEditFieldLabel = uilabel(app.TP21GridLayout);
            app.SampleNumberEditFieldLabel.HorizontalAlignment = 'right';
            app.SampleNumberEditFieldLabel.FontWeight = 'bold';
            app.SampleNumberEditFieldLabel.Layout.Row = 1;
            app.SampleNumberEditFieldLabel.Layout.Column = 2;
            app.SampleNumberEditFieldLabel.Text = 'Sample Number';

            % Create TSampleNumberEditField
            app.TSampleNumberEditField = uieditfield(app.TP21GridLayout, 'numeric');
            app.TSampleNumberEditField.ValueChangedFcn = createCallbackFcn(app, @TSampleNumberEditFieldValueChanged, true);
            app.TSampleNumberEditField.FontWeight = 'bold';
            app.TSampleNumberEditField.Layout.Row = 1;
            app.TSampleNumberEditField.Layout.Column = 3;
            app.TSampleNumberEditField.Value = 100;

            % Create TP24GridLayout
            app.TP24GridLayout = uigridlayout(app.TP2GridLayout);
            app.TP24GridLayout.ColumnWidth = {'1x', 70, 70, 70, '1x'};
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

            % Create TStopButton
            app.TStopButton = uibutton(app.TP24GridLayout, 'push');
            app.TStopButton.ButtonPushedFcn = createCallbackFcn(app, @TStopButtonPushed, true);
            app.TStopButton.BusyAction = 'cancel';
            app.TStopButton.BackgroundColor = [1 0.7294 0.7294];
            app.TStopButton.FontWeight = 'bold';
            app.TStopButton.Enable = 'off';
            app.TStopButton.Tooltip = {''};
            app.TStopButton.Layout.Row = 1;
            app.TStopButton.Layout.Column = 4;
            app.TStopButton.Text = {'Stop'; ''};

            % Create TPauseButton
            app.TPauseButton = uibutton(app.TP24GridLayout, 'push');
            app.TPauseButton.ButtonPushedFcn = createCallbackFcn(app, @TPauseButtonPushed, true);
            app.TPauseButton.BusyAction = 'cancel';
            app.TPauseButton.BackgroundColor = [1 1 0.7608];
            app.TPauseButton.FontWeight = 'bold';
            app.TPauseButton.Enable = 'off';
            app.TPauseButton.Tooltip = {''};
            app.TPauseButton.Layout.Row = 1;
            app.TPauseButton.Layout.Column = 3;
            app.TPauseButton.Text = 'Pause';

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

            % Create MTOPlatformMToPLabel
            app.MTOPlatformMToPLabel = uilabel(app.TP3GridLayout);
            app.MTOPlatformMToPLabel.HorizontalAlignment = 'center';
            app.MTOPlatformMToPLabel.FontWeight = 'bold';
            app.MTOPlatformMToPLabel.Layout.Row = 2;
            app.MTOPlatformMToPLabel.Layout.Column = 1;
            app.MTOPlatformMToPLabel.Text = 'MTO-Platform (MToP) by Yanchi Li';

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
            app.EP1GridLayout.ColumnWidth = {'2x', '1x', '1x'};
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
            app.EProblemsAddButton.Tooltip = {'Add Selected Problems'};
            app.EProblemsAddButton.Layout.Row = 9;
            app.EProblemsAddButton.Layout.Column = 3;
            app.EProblemsAddButton.Text = 'Add';

            % Create EAlgorithmsAddButton
            app.EAlgorithmsAddButton = uibutton(app.EP1GridLayout, 'push');
            app.EAlgorithmsAddButton.ButtonPushedFcn = createCallbackFcn(app, @EAlgorithmsAddButtonPushed, true);
            app.EAlgorithmsAddButton.VerticalAlignment = 'top';
            app.EAlgorithmsAddButton.BackgroundColor = [1 1 1];
            app.EAlgorithmsAddButton.FontWeight = 'bold';
            app.EAlgorithmsAddButton.Tooltip = {'Add Selected Algorithms'};
            app.EAlgorithmsAddButton.Layout.Row = 7;
            app.EAlgorithmsAddButton.Layout.Column = 3;
            app.EAlgorithmsAddButton.Text = 'Add';

            % Create EAlgorithmsListBox
            app.EAlgorithmsListBox = uilistbox(app.EP1GridLayout);
            app.EAlgorithmsListBox.Items = {};
            app.EAlgorithmsListBox.Multiselect = 'on';
            app.EAlgorithmsListBox.Tooltip = {'Hold <Control> to select multiple, Hold <Shift> to select a range'};
            app.EAlgorithmsListBox.Layout.Row = 8;
            app.EAlgorithmsListBox.Layout.Column = [1 3];
            app.EAlgorithmsListBox.Value = {};

            % Create EAlgorithmListLabel
            app.EAlgorithmListLabel = uilabel(app.EP1GridLayout);
            app.EAlgorithmListLabel.FontWeight = 'bold';
            app.EAlgorithmListLabel.Layout.Row = 7;
            app.EAlgorithmListLabel.Layout.Column = [1 2];
            app.EAlgorithmListLabel.Text = 'Algorithm List';

            % Create EProblemsListBox
            app.EProblemsListBox = uilistbox(app.EP1GridLayout);
            app.EProblemsListBox.Items = {};
            app.EProblemsListBox.Multiselect = 'on';
            app.EProblemsListBox.Tooltip = {'Hold Control to select multiple, Hold Shift to select a range'};
            app.EProblemsListBox.Layout.Row = 10;
            app.EProblemsListBox.Layout.Column = [1 3];
            app.EProblemsListBox.Value = {};

            % Create EProblemListLabel
            app.EProblemListLabel = uilabel(app.EP1GridLayout);
            app.EProblemListLabel.FontWeight = 'bold';
            app.EProblemListLabel.Layout.Row = 9;
            app.EProblemListLabel.Layout.Column = [1 2];
            app.EProblemListLabel.Text = 'Problem List';

            % Create ETaskTypeDropDownLabel
            app.ETaskTypeDropDownLabel = uilabel(app.EP1GridLayout);
            app.ETaskTypeDropDownLabel.FontWeight = 'bold';
            app.ETaskTypeDropDownLabel.Tooltip = {''};
            app.ETaskTypeDropDownLabel.Layout.Row = 3;
            app.ETaskTypeDropDownLabel.Layout.Column = 1;
            app.ETaskTypeDropDownLabel.Text = 'Task';

            % Create ETaskTypeDropDown
            app.ETaskTypeDropDown = uidropdown(app.EP1GridLayout);
            app.ETaskTypeDropDown.Items = {'Multi', 'Many', 'Single'};
            app.ETaskTypeDropDown.ItemsData = {'Multi-task', 'Many-task', 'Single-task'};
            app.ETaskTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @ETaskTypeDropDownValueChanged, true);
            app.ETaskTypeDropDown.FontSize = 10;
            app.ETaskTypeDropDown.FontWeight = 'bold';
            app.ETaskTypeDropDown.BackgroundColor = [1 1 1];
            app.ETaskTypeDropDown.Layout.Row = 3;
            app.ETaskTypeDropDown.Layout.Column = [2 3];
            app.ETaskTypeDropDown.Value = 'Multi-task';

            % Create EObjectiveTypeDropDownLabel
            app.EObjectiveTypeDropDownLabel = uilabel(app.EP1GridLayout);
            app.EObjectiveTypeDropDownLabel.FontWeight = 'bold';
            app.EObjectiveTypeDropDownLabel.Tooltip = {''};
            app.EObjectiveTypeDropDownLabel.Layout.Row = 4;
            app.EObjectiveTypeDropDownLabel.Layout.Column = 1;
            app.EObjectiveTypeDropDownLabel.Text = 'Objective';

            % Create EObjectiveTypeDropDown
            app.EObjectiveTypeDropDown = uidropdown(app.EP1GridLayout);
            app.EObjectiveTypeDropDown.Items = {'Single', 'Multi', 'Many'};
            app.EObjectiveTypeDropDown.ItemsData = {'Single-objective', 'Multi-objective', 'Many-objective'};
            app.EObjectiveTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @EObjectiveTypeDropDownValueChanged, true);
            app.EObjectiveTypeDropDown.FontSize = 10;
            app.EObjectiveTypeDropDown.FontWeight = 'bold';
            app.EObjectiveTypeDropDown.BackgroundColor = [1 1 1];
            app.EObjectiveTypeDropDown.Layout.Row = 4;
            app.EObjectiveTypeDropDown.Layout.Column = [2 3];
            app.EObjectiveTypeDropDown.Value = 'Single-objective';

            % Create GridLayout5
            app.GridLayout5 = uigridlayout(app.EP1GridLayout);
            app.GridLayout5.ColumnWidth = {'2x', '1.2x'};
            app.GridLayout5.RowHeight = {'1x', '1x', '1x'};
            app.GridLayout5.ColumnSpacing = 5;
            app.GridLayout5.RowSpacing = 7;
            app.GridLayout5.Padding = [0 0 0 0];
            app.GridLayout5.Layout.Row = 2;
            app.GridLayout5.Layout.Column = [1 3];
            app.GridLayout5.BackgroundColor = [1 1 1];

            % Create ERepsEditField
            app.ERepsEditField = uieditfield(app.GridLayout5, 'numeric');
            app.ERepsEditField.Limits = [1 Inf];
            app.ERepsEditField.RoundFractionalValues = 'on';
            app.ERepsEditField.ValueDisplayFormat = '%d';
            app.ERepsEditField.HorizontalAlignment = 'center';
            app.ERepsEditField.FontWeight = 'bold';
            app.ERepsEditField.Tooltip = {'Number of Independent Repetitions'};
            app.ERepsEditField.Layout.Row = 2;
            app.ERepsEditField.Layout.Column = 2;
            app.ERepsEditField.Value = 1;

            % Create EResultsNumEditField
            app.EResultsNumEditField = uieditfield(app.GridLayout5, 'numeric');
            app.EResultsNumEditField.Limits = [1 Inf];
            app.EResultsNumEditField.RoundFractionalValues = 'on';
            app.EResultsNumEditField.ValueDisplayFormat = '%d';
            app.EResultsNumEditField.HorizontalAlignment = 'center';
            app.EResultsNumEditField.FontWeight = 'bold';
            app.EResultsNumEditField.Tooltip = {'Convergence Data Length.'; 'Set to 1 to save only the last generation.'; '(Does not affect termination conditions)'};
            app.EResultsNumEditField.Layout.Row = 3;
            app.EResultsNumEditField.Layout.Column = 2;
            app.EResultsNumEditField.Value = 50;

            % Create ERepsEditFieldLabel
            app.ERepsEditFieldLabel = uilabel(app.GridLayout5);
            app.ERepsEditFieldLabel.FontWeight = 'bold';
            app.ERepsEditFieldLabel.Tooltip = {'Number of Independent Repetitions'};
            app.ERepsEditFieldLabel.Layout.Row = 2;
            app.ERepsEditFieldLabel.Layout.Column = 1;
            app.ERepsEditFieldLabel.Text = 'Repetitions';

            % Create EResultsNumEditFieldLabel
            app.EResultsNumEditFieldLabel = uilabel(app.GridLayout5);
            app.EResultsNumEditFieldLabel.FontWeight = 'bold';
            app.EResultsNumEditFieldLabel.Tooltip = {'Convergence Data Length.'; 'Set to 1 to save only the last generation.'; '(Does not affect termination conditions)'};
            app.EResultsNumEditFieldLabel.Layout.Row = 3;
            app.EResultsNumEditFieldLabel.Layout.Column = 1;
            app.EResultsNumEditFieldLabel.Text = 'Data Length';

            % Create ERngSeedEditField
            app.ERngSeedEditField = uieditfield(app.GridLayout5, 'numeric');
            app.ERngSeedEditField.Limits = [1 Inf];
            app.ERngSeedEditField.RoundFractionalValues = 'on';
            app.ERngSeedEditField.ValueDisplayFormat = '%d';
            app.ERngSeedEditField.HorizontalAlignment = 'center';
            app.ERngSeedEditField.FontWeight = 'bold';
            app.ERngSeedEditField.Tooltip = {'Seed for random number generation'; '(For the r-th independent repetition, use rng(seed + r - 1))'};
            app.ERngSeedEditField.Layout.Row = 1;
            app.ERngSeedEditField.Layout.Column = 2;
            app.ERngSeedEditField.Value = 2333;

            % Create ERngSeedCheckBox
            app.ERngSeedCheckBox = uicheckbox(app.GridLayout5);
            app.ERngSeedCheckBox.Tooltip = {'Enable random seed control flag'; '(When checked, each r-th repetition uses rng(seed + r - 1))'};
            app.ERngSeedCheckBox.Text = 'Rand Seed';
            app.ERngSeedCheckBox.FontWeight = 'bold';
            app.ERngSeedCheckBox.Layout.Row = 1;
            app.ERngSeedCheckBox.Layout.Column = 1;
            app.ERngSeedCheckBox.Value = true;

            % Create EParallelCheckBox
            app.EParallelCheckBox = uicheckbox(app.EP1GridLayout);
            app.EParallelCheckBox.Tooltip = {'Parallel flag'; '(independent repetitions in parallel)'};
            app.EParallelCheckBox.Text = 'Parallel';
            app.EParallelCheckBox.FontWeight = 'bold';
            app.EParallelCheckBox.Layout.Row = 1;
            app.EParallelCheckBox.Layout.Column = 1;

            % Create ESaveDecCheckBox
            app.ESaveDecCheckBox = uicheckbox(app.EP1GridLayout);
            app.ESaveDecCheckBox.Tooltip = {'Save decision variables flag'};
            app.ESaveDecCheckBox.Text = 'SaveDec';
            app.ESaveDecCheckBox.FontWeight = 'bold';
            app.ESaveDecCheckBox.Layout.Row = 1;
            app.ESaveDecCheckBox.Layout.Column = [2 3];

            % Create EConstrainedButton
            app.EConstrainedButton = uibutton(app.EP1GridLayout, 'state');
            app.EConstrainedButton.ValueChangedFcn = createCallbackFcn(app, @EConstrainedButtonValueChanged, true);
            app.EConstrainedButton.Text = 'Constrained';
            app.EConstrainedButton.BackgroundColor = [1 1 1];
            app.EConstrainedButton.FontSize = 10;
            app.EConstrainedButton.FontWeight = 'bold';
            app.EConstrainedButton.Layout.Row = 5;
            app.EConstrainedButton.Layout.Column = 1;

            % Create ECompetitiveButton
            app.ECompetitiveButton = uibutton(app.EP1GridLayout, 'state');
            app.ECompetitiveButton.ValueChangedFcn = createCallbackFcn(app, @ECompetitiveButtonValueChanged, true);
            app.ECompetitiveButton.Text = 'Competitive';
            app.ECompetitiveButton.BackgroundColor = [1 1 1];
            app.ECompetitiveButton.FontSize = 10;
            app.ECompetitiveButton.FontWeight = 'bold';
            app.ECompetitiveButton.Layout.Row = 5;
            app.ECompetitiveButton.Layout.Column = [2 3];

            % Create EStreamButton
            app.EStreamButton = uibutton(app.EP1GridLayout, 'state');
            app.EStreamButton.ValueChangedFcn = createCallbackFcn(app, @EStreamButtonValueChanged, true);
            app.EStreamButton.Text = 'Stream';
            app.EStreamButton.BackgroundColor = [1 1 1];
            app.EStreamButton.FontSize = 10;
            app.EStreamButton.FontWeight = 'bold';
            app.EStreamButton.Layout.Row = 6;
            app.EStreamButton.Layout.Column = 1;

            % Create EYearDropDown
            app.EYearDropDown = uidropdown(app.EP1GridLayout);
            app.EYearDropDown.Items = {'All Year'};
            app.EYearDropDown.ValueChangedFcn = createCallbackFcn(app, @EYearDropDownValueChanged, true);
            app.EYearDropDown.FontSize = 10;
            app.EYearDropDown.FontWeight = 'bold';
            app.EYearDropDown.BackgroundColor = [1 1 1];
            app.EYearDropDown.Layout.Row = 6;
            app.EYearDropDown.Layout.Column = [2 3];
            app.EYearDropDown.Value = 'All Year';

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
            app.EAlgorithmsTree.Tooltip = {'Click triangle to expand the algorithm, double-click to change the algorithm name or parameter value'};
            app.EAlgorithmsTree.Layout.Row = 4;
            app.EAlgorithmsTree.Layout.Column = 1;

            % Create EProblemsTree
            app.EProblemsTree = uitree(app.EP2GridLayout);
            app.EProblemsTree.Multiselect = 'on';
            app.EProblemsTree.NodeTextChangedFcn = createCallbackFcn(app, @EProblemsTreeNodeTextChanged, true);
            app.EProblemsTree.Editable = 'on';
            app.EProblemsTree.Tooltip = {'Click triangle to expand the problem, double-click to change the problem name or parameter value'};
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
            app.ESelectedAlgorithmsLabel.Text = 'Added Algorithm Tree';

            % Create EAlgorithmsDelButton
            app.EAlgorithmsDelButton = uibutton(app.GridLayout3, 'push');
            app.EAlgorithmsDelButton.ButtonPushedFcn = createCallbackFcn(app, @EAlgorithmsDelButtonPushed, true);
            app.EAlgorithmsDelButton.BackgroundColor = [1 1 1];
            app.EAlgorithmsDelButton.FontWeight = 'bold';
            app.EAlgorithmsDelButton.Tooltip = {'Delete Selected Algorithms'};
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
            app.ESelectedProblemsLabel.Text = 'Added Problem Tree';

            % Create EProblemsDelButton
            app.EProblemsDelButton = uibutton(app.GridLayout4, 'push');
            app.EProblemsDelButton.ButtonPushedFcn = createCallbackFcn(app, @EProblemsDelButtonPushed, true);
            app.EProblemsDelButton.BackgroundColor = [1 1 1];
            app.EProblemsDelButton.FontWeight = 'bold';
            app.EProblemsDelButton.Tooltip = {'Delete Selected Problems'};
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
            app.ESaveDataButton.Tooltip = {'Save Finished Data to MAT File'};
            app.ESaveDataButton.Layout.Row = 1;
            app.ESaveDataButton.Layout.Column = 2;
            app.ESaveDataButton.Text = 'Save Data';

            % Create ELoadDataButton
            app.ELoadDataButton = uibutton(app.GridLayout, 'push');
            app.ELoadDataButton.ButtonPushedFcn = createCallbackFcn(app, @ELoadDataButtonPushed, true);
            app.ELoadDataButton.BackgroundColor = [1 1 1];
            app.ELoadDataButton.FontWeight = 'bold';
            app.ELoadDataButton.Tooltip = {'Load Saved MAT Data from File'};
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
            app.EP3TGridLayout.RowSpacing = 5;
            app.EP3TGridLayout.Padding = [0 0 0 0];
            app.EP3TGridLayout.Layout.Row = 1;
            app.EP3TGridLayout.Layout.Column = 1;
            app.EP3TGridLayout.BackgroundColor = [1 1 1];

            % Create EUITable
            app.EUITable = uitable(app.EP3TGridLayout);
            app.EUITable.ColumnName = '';
            app.EUITable.RowName = {};
            app.EUITable.CellSelectionCallback = createCallbackFcn(app, @EUITableCellSelection, true);
            app.EUITable.Layout.Row = 2;
            app.EUITable.Layout.Column = 1;

            % Create EP3T2GridLayout
            app.EP3T2GridLayout = uigridlayout(app.EP3TGridLayout);
            app.EP3T2GridLayout.ColumnWidth = {'fit', '3x', '2x', '1x', '3.7x'};
            app.EP3T2GridLayout.RowHeight = {48};
            app.EP3T2GridLayout.ColumnSpacing = 5;
            app.EP3T2GridLayout.RowSpacing = 0;
            app.EP3T2GridLayout.Padding = [0 0 0 0];
            app.EP3T2GridLayout.Layout.Row = 1;
            app.EP3T2GridLayout.Layout.Column = 1;
            app.EP3T2GridLayout.BackgroundColor = [1 1 1];

            % Create MetricandShowTypePanel
            app.MetricandShowTypePanel = uipanel(app.EP3T2GridLayout);
            app.MetricandShowTypePanel.BorderType = 'none';
            app.MetricandShowTypePanel.Title = 'Metric and Show Type';
            app.MetricandShowTypePanel.BackgroundColor = [1 1 1];
            app.MetricandShowTypePanel.Layout.Row = 1;
            app.MetricandShowTypePanel.Layout.Column = 2;
            app.MetricandShowTypePanel.FontWeight = 'bold';

            % Create GridLayout6_2
            app.GridLayout6_2 = uigridlayout(app.MetricandShowTypePanel);
            app.GridLayout6_2.ColumnWidth = {'1x', '1x', '1x'};
            app.GridLayout6_2.RowHeight = {'1x'};
            app.GridLayout6_2.ColumnSpacing = 5;
            app.GridLayout6_2.RowSpacing = 0;
            app.GridLayout6_2.Padding = [0 0 0 5];
            app.GridLayout6_2.BackgroundColor = [1 1 1];

            % Create EShowTypeDropDown
            app.EShowTypeDropDown = uidropdown(app.GridLayout6_2);
            app.EShowTypeDropDown.Items = {'Mean', 'Mean&Std', 'Std', 'Median', 'Best', 'Worst'};
            app.EShowTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @EShowTypeDropDownValueChanged, true);
            app.EShowTypeDropDown.Tooltip = {'Result Type'};
            app.EShowTypeDropDown.FontSize = 10;
            app.EShowTypeDropDown.FontWeight = 'bold';
            app.EShowTypeDropDown.BackgroundColor = [1 1 1];
            app.EShowTypeDropDown.Layout.Row = 1;
            app.EShowTypeDropDown.Layout.Column = 3;
            app.EShowTypeDropDown.Value = 'Mean';

            % Create EDataFormatEditField
            app.EDataFormatEditField = uieditfield(app.GridLayout6_2, 'text');
            app.EDataFormatEditField.ValueChangedFcn = createCallbackFcn(app, @EDataFormatEditFieldValueChanged, true);
            app.EDataFormatEditField.HorizontalAlignment = 'center';
            app.EDataFormatEditField.FontSize = 10;
            app.EDataFormatEditField.FontWeight = 'bold';
            app.EDataFormatEditField.Tooltip = {'Data Format Str'};
            app.EDataFormatEditField.Layout.Row = 1;
            app.EDataFormatEditField.Layout.Column = 2;
            app.EDataFormatEditField.Value = '%d';

            % Create EDataTypeDropDown
            app.EDataTypeDropDown = uidropdown(app.GridLayout6_2);
            app.EDataTypeDropDown.Items = {'Reps'};
            app.EDataTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @EDataTypeDropDownValueChanged, true);
            app.EDataTypeDropDown.Tooltip = {'Performance Metric'};
            app.EDataTypeDropDown.FontSize = 10;
            app.EDataTypeDropDown.FontWeight = 'bold';
            app.EDataTypeDropDown.BackgroundColor = [1 1 1];
            app.EDataTypeDropDown.Layout.Row = 1;
            app.EDataTypeDropDown.Layout.Column = 1;
            app.EDataTypeDropDown.Value = 'Reps';

            % Create StatisticalTestPanel
            app.StatisticalTestPanel = uipanel(app.EP3T2GridLayout);
            app.StatisticalTestPanel.BorderType = 'none';
            app.StatisticalTestPanel.Title = 'Statistical Test';
            app.StatisticalTestPanel.BackgroundColor = [1 1 1];
            app.StatisticalTestPanel.Layout.Row = 1;
            app.StatisticalTestPanel.Layout.Column = 3;
            app.StatisticalTestPanel.FontWeight = 'bold';

            % Create GridLayout6_4
            app.GridLayout6_4 = uigridlayout(app.StatisticalTestPanel);
            app.GridLayout6_4.RowHeight = {'1x'};
            app.GridLayout6_4.ColumnSpacing = 5;
            app.GridLayout6_4.RowSpacing = 0;
            app.GridLayout6_4.Padding = [0 0 0 5];
            app.GridLayout6_4.BackgroundColor = [1 1 1];

            % Create EAlgorithmDropDown
            app.EAlgorithmDropDown = uidropdown(app.GridLayout6_4);
            app.EAlgorithmDropDown.Items = {'Algorithm'};
            app.EAlgorithmDropDown.ValueChangedFcn = createCallbackFcn(app, @EAlgorithmDropDownValueChanged, true);
            app.EAlgorithmDropDown.Tooltip = {'Main Algorithm in Statistical Analysis'};
            app.EAlgorithmDropDown.FontSize = 10;
            app.EAlgorithmDropDown.FontWeight = 'bold';
            app.EAlgorithmDropDown.BackgroundColor = [1 1 1];
            app.EAlgorithmDropDown.Layout.Row = 1;
            app.EAlgorithmDropDown.Layout.Column = 2;
            app.EAlgorithmDropDown.Value = 'Algorithm';

            % Create ETestTypeDropDown
            app.ETestTypeDropDown = uidropdown(app.GridLayout6_4);
            app.ETestTypeDropDown.Items = {'None', 'Wilcoxon Rank-sum', 'Wilcoxon Signed-rank', 'Friedman (mean)', 'Friedman (all reps)'};
            app.ETestTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @ETestTypeDropDownValueChanged, true);
            app.ETestTypeDropDown.Tooltip = {'Statistical Analysis'};
            app.ETestTypeDropDown.FontSize = 10;
            app.ETestTypeDropDown.FontWeight = 'bold';
            app.ETestTypeDropDown.BackgroundColor = [1 1 1];
            app.ETestTypeDropDown.Layout.Row = 1;
            app.ETestTypeDropDown.Layout.Column = 1;
            app.ETestTypeDropDown.Value = 'None';

            % Create HighlightPanel
            app.HighlightPanel = uipanel(app.EP3T2GridLayout);
            app.HighlightPanel.BorderType = 'none';
            app.HighlightPanel.Title = 'Highlight';
            app.HighlightPanel.BackgroundColor = [1 1 1];
            app.HighlightPanel.Layout.Row = 1;
            app.HighlightPanel.Layout.Column = 4;
            app.HighlightPanel.FontWeight = 'bold';

            % Create GridLayout6_5
            app.GridLayout6_5 = uigridlayout(app.HighlightPanel);
            app.GridLayout6_5.ColumnWidth = {'1x'};
            app.GridLayout6_5.RowHeight = {'1x'};
            app.GridLayout6_5.ColumnSpacing = 5;
            app.GridLayout6_5.RowSpacing = 0;
            app.GridLayout6_5.Padding = [0 0 0 5];
            app.GridLayout6_5.BackgroundColor = [1 1 1];

            % Create EHighlightTypeDropDown
            app.EHighlightTypeDropDown = uidropdown(app.GridLayout6_5);
            app.EHighlightTypeDropDown.Items = {'None', 'Best', 'Best&Worst'};
            app.EHighlightTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @EHighlightTypeDropDownValueChanged, true);
            app.EHighlightTypeDropDown.Tooltip = {'Highlight Type'};
            app.EHighlightTypeDropDown.FontSize = 10;
            app.EHighlightTypeDropDown.FontWeight = 'bold';
            app.EHighlightTypeDropDown.BackgroundColor = [1 1 1];
            app.EHighlightTypeDropDown.Layout.Row = 1;
            app.EHighlightTypeDropDown.Layout.Column = 1;
            app.EHighlightTypeDropDown.Value = 'Best&Worst';

            % Create DrawingSelectTableAreaPanel
            app.DrawingSelectTableAreaPanel = uipanel(app.EP3T2GridLayout);
            app.DrawingSelectTableAreaPanel.BorderType = 'none';
            app.DrawingSelectTableAreaPanel.Title = 'Drawing (Select Table Area)';
            app.DrawingSelectTableAreaPanel.BackgroundColor = [1 1 1];
            app.DrawingSelectTableAreaPanel.Layout.Row = 1;
            app.DrawingSelectTableAreaPanel.Layout.Column = 5;
            app.DrawingSelectTableAreaPanel.FontWeight = 'bold';

            % Create GridLayout6_3
            app.GridLayout6_3 = uigridlayout(app.DrawingSelectTableAreaPanel);
            app.GridLayout6_3.ColumnWidth = {'1x', '1x', '1x', '0.7x'};
            app.GridLayout6_3.RowHeight = {'1x'};
            app.GridLayout6_3.ColumnSpacing = 5;
            app.GridLayout6_3.RowSpacing = 0;
            app.GridLayout6_3.Padding = [0 0 0 5];
            app.GridLayout6_3.BackgroundColor = [1 1 1];

            % Create EConvergeTypeDropDown
            app.EConvergeTypeDropDown = uidropdown(app.GridLayout6_3);
            app.EConvergeTypeDropDown.Items = {'Log', 'Log Type2', 'Log Range', 'Normal', 'Norm Range'};
            app.EConvergeTypeDropDown.Tooltip = {'Y-axis Show Type of Convergence Plot'};
            app.EConvergeTypeDropDown.FontSize = 10;
            app.EConvergeTypeDropDown.FontWeight = 'bold';
            app.EConvergeTypeDropDown.BackgroundColor = [1 1 1];
            app.EConvergeTypeDropDown.Layout.Row = 1;
            app.EConvergeTypeDropDown.Layout.Column = 1;
            app.EConvergeTypeDropDown.Value = 'Log';

            % Create EConvergeButton
            app.EConvergeButton = uibutton(app.GridLayout6_3, 'push');
            app.EConvergeButton.ButtonPushedFcn = createCallbackFcn(app, @EConvergeButtonPushed, true);
            app.EConvergeButton.BackgroundColor = [1 1 1];
            app.EConvergeButton.FontSize = 10;
            app.EConvergeButton.FontWeight = 'bold';
            app.EConvergeButton.Tooltip = {'Select data area in Table to draw Metric Convergence plot'};
            app.EConvergeButton.Layout.Row = 1;
            app.EConvergeButton.Layout.Column = 2;
            app.EConvergeButton.Text = 'Converge';

            % Create EParetoButton
            app.EParetoButton = uibutton(app.GridLayout6_3, 'push');
            app.EParetoButton.ButtonPushedFcn = createCallbackFcn(app, @EParetoButtonPushed, true);
            app.EParetoButton.BackgroundColor = [1 1 1];
            app.EParetoButton.FontSize = 10;
            app.EParetoButton.FontWeight = 'bold';
            app.EParetoButton.Tooltip = {'Select data area in Table to draw Median Population Pareto Front'};
            app.EParetoButton.Layout.Row = 1;
            app.EParetoButton.Layout.Column = 3;
            app.EParetoButton.Text = 'Pareto';

            % Create ESplitCheckBox
            app.ESplitCheckBox = uicheckbox(app.GridLayout6_3);
            app.ESplitCheckBox.Text = 'Split';
            app.ESplitCheckBox.FontSize = 10;
            app.ESplitCheckBox.FontWeight = 'bold';
            app.ESplitCheckBox.Layout.Row = 1;
            app.ESplitCheckBox.Layout.Column = 4;

            % Create ESaveTableButton
            app.ESaveTableButton = uibutton(app.EP3T2GridLayout, 'push');
            app.ESaveTableButton.ButtonPushedFcn = createCallbackFcn(app, @ESaveTableButtonPushed, true);
            app.ESaveTableButton.BackgroundColor = [1 1 1];
            app.ESaveTableButton.FontWeight = 'bold';
            app.ESaveTableButton.Tooltip = {'Export Current Table or Convergence Data to File'};
            app.ESaveTableButton.Layout.Row = 1;
            app.ESaveTableButton.Layout.Column = 1;
            app.ESaveTableButton.Text = 'Export';

            % Create DataProcessModuleTab
            app.DataProcessModuleTab = uitab(app.MTOPlatformTabGroup);
            app.DataProcessModuleTab.Title = 'Data Process Module';
            app.DataProcessModuleTab.BackgroundColor = [1 1 1];

            % Create DataProcessGridLayout
            app.DataProcessGridLayout = uigridlayout(app.DataProcessModuleTab);
            app.DataProcessGridLayout.RowHeight = {'2x'};
            app.DataProcessGridLayout.BackgroundColor = [1 1 1];

            % Create DPanel1
            app.DPanel1 = uipanel(app.DataProcessGridLayout);
            app.DPanel1.BorderColor = [0.651 0.651 0.651];
            app.DPanel1.HighlightColor = [0.651 0.651 0.651];
            app.DPanel1.BackgroundColor = [1 1 1];
            app.DPanel1.Layout.Row = 1;
            app.DPanel1.Layout.Column = 1;

            % Create DP1GridLayout
            app.DP1GridLayout = uigridlayout(app.DPanel1);
            app.DP1GridLayout.ColumnWidth = {'1x'};
            app.DP1GridLayout.RowHeight = {'fit', 'fit', '1x', 'fit', '1x', 'fit', '1x', 'fit', '1x', 'fit', '1x', 'fit', '1x', 'fit', '2x'};
            app.DP1GridLayout.BackgroundColor = [1 1 1];

            % Create DDataProcessModuleLabel
            app.DDataProcessModuleLabel = uilabel(app.DP1GridLayout);
            app.DDataProcessModuleLabel.HorizontalAlignment = 'center';
            app.DDataProcessModuleLabel.VerticalAlignment = 'bottom';
            app.DDataProcessModuleLabel.FontSize = 18;
            app.DDataProcessModuleLabel.FontWeight = 'bold';
            app.DDataProcessModuleLabel.Layout.Row = 1;
            app.DDataProcessModuleLabel.Layout.Column = 1;
            app.DDataProcessModuleLabel.Text = 'Experiment Data Process ';

            % Create DP1Panel1
            app.DP1Panel1 = uipanel(app.DP1GridLayout);
            app.DP1Panel1.BorderType = 'none';
            app.DP1Panel1.BackgroundColor = [1 1 1];
            app.DP1Panel1.Layout.Row = 4;
            app.DP1Panel1.Layout.Column = 1;

            % Create DP1P1GridLayout
            app.DP1P1GridLayout = uigridlayout(app.DP1Panel1);
            app.DP1P1GridLayout.ColumnWidth = {'1x', '1x', '1x'};
            app.DP1P1GridLayout.RowHeight = {'fit', 'fit'};
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
            app.DP1Panel2.Layout.Row = 6;
            app.DP1Panel2.Layout.Column = 1;

            % Create DP1P2GridLayout
            app.DP1P2GridLayout = uigridlayout(app.DP1Panel2);
            app.DP1P2GridLayout.ColumnWidth = {'1x', '1x', '1x'};
            app.DP1P2GridLayout.RowHeight = {'fit', 'fit'};
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
            app.DP1Panel3.Layout.Row = 8;
            app.DP1Panel3.Layout.Column = 1;

            % Create DP1P3GridLayout
            app.DP1P3GridLayout = uigridlayout(app.DP1Panel3);
            app.DP1P3GridLayout.ColumnWidth = {'1x', '1x', '1x'};
            app.DP1P3GridLayout.RowHeight = {'fit', 'fit'};
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
            app.DP1Panel4.Layout.Row = 14;
            app.DP1Panel4.Layout.Column = 1;

            % Create DP1P4GridLayout
            app.DP1P4GridLayout = uigridlayout(app.DP1Panel4);
            app.DP1P4GridLayout.ColumnWidth = {'1x', '2x', '2x', '1x'};
            app.DP1P4GridLayout.RowHeight = {'fit', 'fit'};
            app.DP1P4GridLayout.Padding = [0 0 0 0];
            app.DP1P4GridLayout.BackgroundColor = [1 1 1];

            % Create DUpandDownDataLabel
            app.DUpandDownDataLabel = uilabel(app.DP1P4GridLayout);
            app.DUpandDownDataLabel.HorizontalAlignment = 'center';
            app.DUpandDownDataLabel.VerticalAlignment = 'bottom';
            app.DUpandDownDataLabel.Layout.Row = 1;
            app.DUpandDownDataLabel.Layout.Column = [1 4];
            app.DUpandDownDataLabel.Text = 'Select data node, click Up or Down button';

            % Create DUpButton
            app.DUpButton = uibutton(app.DP1P4GridLayout, 'push');
            app.DUpButton.ButtonPushedFcn = createCallbackFcn(app, @DUpButtonPushed, true);
            app.DUpButton.BackgroundColor = [1 1 1];
            app.DUpButton.FontWeight = 'bold';
            app.DUpButton.Layout.Row = 2;
            app.DUpButton.Layout.Column = 2;
            app.DUpButton.Text = 'UP';

            % Create DDownButton
            app.DDownButton = uibutton(app.DP1P4GridLayout, 'push');
            app.DDownButton.ButtonPushedFcn = createCallbackFcn(app, @DDownButtonPushed, true);
            app.DDownButton.BackgroundColor = [1 1 1];
            app.DDownButton.FontWeight = 'bold';
            app.DDownButton.Layout.Row = 2;
            app.DDownButton.Layout.Column = 3;
            app.DDownButton.Text = 'Down';

            % Create DLoadDataorSelectandDeleteSaveDataLabel_5
            app.DLoadDataorSelectandDeleteSaveDataLabel_5 = uilabel(app.DP1GridLayout);
            app.DLoadDataorSelectandDeleteSaveDataLabel_5.HorizontalAlignment = 'center';
            app.DLoadDataorSelectandDeleteSaveDataLabel_5.WordWrap = 'on';
            app.DLoadDataorSelectandDeleteSaveDataLabel_5.FontSize = 14;
            app.DLoadDataorSelectandDeleteSaveDataLabel_5.Layout.Row = 2;
            app.DLoadDataorSelectandDeleteSaveDataLabel_5.Layout.Column = 1;
            app.DLoadDataorSelectandDeleteSaveDataLabel_5.Text = {'Load saved data of Experiment Module first.'; 'Select Data Root-Node to merge or split.'; 'Hold Control to select multiple data.'};

            % Create DP1Panel5
            app.DP1Panel5 = uipanel(app.DP1GridLayout);
            app.DP1Panel5.BorderColor = [0.6902 0.6902 0.6902];
            app.DP1Panel5.HighlightColor = [0.6902 0.6902 0.6902];
            app.DP1Panel5.BorderType = 'none';
            app.DP1Panel5.Layout.Row = 10;
            app.DP1Panel5.Layout.Column = 1;

            % Create DP1P5GridLayout
            app.DP1P5GridLayout = uigridlayout(app.DP1Panel5);
            app.DP1P5GridLayout.ColumnWidth = {'1x', '2x', '2x', '1x'};
            app.DP1P5GridLayout.RowHeight = {'fit', 'fit'};
            app.DP1P5GridLayout.Padding = [0 0 0 0];
            app.DP1P5GridLayout.BackgroundColor = [1 1 1];

            % Create DDPreisionButtonDataLabel
            app.DDPreisionButtonDataLabel = uilabel(app.DP1P5GridLayout);
            app.DDPreisionButtonDataLabel.HorizontalAlignment = 'center';
            app.DDPreisionButtonDataLabel.VerticalAlignment = 'bottom';
            app.DDPreisionButtonDataLabel.Layout.Row = 1;
            app.DDPreisionButtonDataLabel.Layout.Column = [1 4];
            app.DDPreisionButtonDataLabel.Text = 'Select data node, set precision, click adjust';

            % Create DPreisionButton
            app.DPreisionButton = uibutton(app.DP1P5GridLayout, 'push');
            app.DPreisionButton.ButtonPushedFcn = createCallbackFcn(app, @DPreisionButtonPushed, true);
            app.DPreisionButton.BackgroundColor = [1 1 1];
            app.DPreisionButton.FontWeight = 'bold';
            app.DPreisionButton.Layout.Row = 2;
            app.DPreisionButton.Layout.Column = 3;
            app.DPreisionButton.Text = 'Precision Adjust';

            % Create DPreisionEditField
            app.DPreisionEditField = uieditfield(app.DP1P5GridLayout, 'numeric');
            app.DPreisionEditField.RoundFractionalValues = 'on';
            app.DPreisionEditField.ValueDisplayFormat = '%d';
            app.DPreisionEditField.HorizontalAlignment = 'center';
            app.DPreisionEditField.FontWeight = 'bold';
            app.DPreisionEditField.Tooltip = {''};
            app.DPreisionEditField.Layout.Row = 2;
            app.DPreisionEditField.Layout.Column = 2;
            app.DPreisionEditField.Value = -4;

            % Create GridLayout6
            app.GridLayout6 = uigridlayout(app.DP1GridLayout);
            app.GridLayout6.ColumnWidth = {'1x', '2x', '2x', '1x'};
            app.GridLayout6.RowHeight = {'fit', 'fit'};
            app.GridLayout6.Layout.Row = 12;
            app.GridLayout6.Layout.Column = 1;
            app.GridLayout6.BackgroundColor = [1 1 1];

            % Create DDataLengthLabel
            app.DDataLengthLabel = uilabel(app.GridLayout6);
            app.DDataLengthLabel.HorizontalAlignment = 'center';
            app.DDataLengthLabel.VerticalAlignment = 'bottom';
            app.DDataLengthLabel.Layout.Row = 1;
            app.DDataLengthLabel.Layout.Column = [1 4];
            app.DDataLengthLabel.Text = 'Select data node, reduce Data Length, click adjust';

            % Create DDataLengthEditField
            app.DDataLengthEditField = uieditfield(app.GridLayout6, 'numeric');
            app.DDataLengthEditField.Limits = [1 Inf];
            app.DDataLengthEditField.RoundFractionalValues = 'on';
            app.DDataLengthEditField.ValueDisplayFormat = '%d';
            app.DDataLengthEditField.HorizontalAlignment = 'center';
            app.DDataLengthEditField.FontWeight = 'bold';
            app.DDataLengthEditField.Tooltip = {''};
            app.DDataLengthEditField.Layout.Row = 2;
            app.DDataLengthEditField.Layout.Column = 2;
            app.DDataLengthEditField.Value = 30;

            % Create DDataLengthButton
            app.DDataLengthButton = uibutton(app.GridLayout6, 'push');
            app.DDataLengthButton.ButtonPushedFcn = createCallbackFcn(app, @DDataLengthButtonPushed, true);
            app.DDataLengthButton.BackgroundColor = [1 1 1];
            app.DDataLengthButton.FontWeight = 'bold';
            app.DDataLengthButton.Layout.Row = 2;
            app.DDataLengthButton.Layout.Column = 3;
            app.DDataLengthButton.Text = 'DataLen Reduce';

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
            app.DDataTree.Tooltip = {'Select Root-Node to perform.'; 'Click the triangle to display metadata.'};
            app.DDataTree.Layout.Row = 1;
            app.DDataTree.Layout.Column = 1;

            % Create DDataContextMenu
            app.DDataContextMenu = uicontextmenu(app.MToPv111UIFigure);
            app.DDataContextMenu.ContextMenuOpeningFcn = createCallbackFcn(app, @DDataContextMenuOpening, true);

            % Create DDataSelectAllMenu
            app.DDataSelectAllMenu = uimenu(app.DDataContextMenu);
            app.DDataSelectAllMenu.Accelerator = 'a';
            app.DDataSelectAllMenu.Text = 'Select All';
            
            % Assign app.DDataContextMenu
            app.DDataTree.ContextMenu = app.DDataContextMenu;

            % Create SelectedAlgoContextMenu
            app.SelectedAlgoContextMenu = uicontextmenu(app.MToPv111UIFigure);

            % Create SelectedAlgoSelectAllMenu
            app.SelectedAlgoSelectAllMenu = uimenu(app.SelectedAlgoContextMenu);
            app.SelectedAlgoSelectAllMenu.MenuSelectedFcn = createCallbackFcn(app, @ESelectedAlgoSelectAllMenuSelected, true);
            app.SelectedAlgoSelectAllMenu.Accelerator = 'a';
            app.SelectedAlgoSelectAllMenu.Text = 'Select All';
            
            % Assign app.SelectedAlgoContextMenu
            app.EAlgorithmsTree.ContextMenu = app.SelectedAlgoContextMenu;

            % Create SelectedProbContextMenu
            app.SelectedProbContextMenu = uicontextmenu(app.MToPv111UIFigure);

            % Create SelectedProbSelectAllMenu
            app.SelectedProbSelectAllMenu = uimenu(app.SelectedProbContextMenu);
            app.SelectedProbSelectAllMenu.MenuSelectedFcn = createCallbackFcn(app, @ESelectedProbSelectAllMenuSelected, true);
            app.SelectedProbSelectAllMenu.Accelerator = 'a';
            app.SelectedProbSelectAllMenu.Text = 'Select All';

            % Create EditPublicParaMenu
            app.EditPublicParaMenu = uimenu(app.SelectedProbContextMenu);
            app.EditPublicParaMenu.MenuSelectedFcn = createCallbackFcn(app, @EEditPublicParaMenuSelected, true);
            app.EditPublicParaMenu.Accelerator = 'e';
            app.EditPublicParaMenu.Text = 'Edit Public Para';
            
            % Assign app.SelectedProbContextMenu
            app.EProblemsTree.ContextMenu = app.SelectedProbContextMenu;

            % Create AlgorithmsContextMenu
            app.AlgorithmsContextMenu = uicontextmenu(app.MToPv111UIFigure);

            % Create AlgorithmsSelectAllMenu
            app.AlgorithmsSelectAllMenu = uimenu(app.AlgorithmsContextMenu);
            app.AlgorithmsSelectAllMenu.MenuSelectedFcn = createCallbackFcn(app, @EAlgorithmsSelectAllMenuSelected, true);
            app.AlgorithmsSelectAllMenu.Accelerator = 'a';
            app.AlgorithmsSelectAllMenu.Text = 'Select All';

            % Create AlgorithmRefreshMenu
            app.AlgorithmRefreshMenu = uimenu(app.AlgorithmsContextMenu);
            app.AlgorithmRefreshMenu.MenuSelectedFcn = createCallbackFcn(app, @RefreshMenuSelected, true);
            app.AlgorithmRefreshMenu.Accelerator = 'r';
            app.AlgorithmRefreshMenu.Text = 'Refresh';
            
            % Assign app.AlgorithmsContextMenu
            app.EAlgorithmsListBox.ContextMenu = app.AlgorithmsContextMenu;

            % Create ProblemsContextMenu
            app.ProblemsContextMenu = uicontextmenu(app.MToPv111UIFigure);

            % Create ProblemsSelectAllMenu
            app.ProblemsSelectAllMenu = uimenu(app.ProblemsContextMenu);
            app.ProblemsSelectAllMenu.MenuSelectedFcn = createCallbackFcn(app, @EProblemsSelectAllMenuSelected, true);
            app.ProblemsSelectAllMenu.Accelerator = 'a';
            app.ProblemsSelectAllMenu.Text = 'Select All';

            % Create ProblemRefreshMenu
            app.ProblemRefreshMenu = uimenu(app.ProblemsContextMenu);
            app.ProblemRefreshMenu.MenuSelectedFcn = createCallbackFcn(app, @RefreshMenuSelected, true);
            app.ProblemRefreshMenu.Accelerator = 'r';
            app.ProblemRefreshMenu.Text = 'Refresh';
            
            % Assign app.ProblemsContextMenu
            app.EProblemsListBox.ContextMenu = app.ProblemsContextMenu;

            % Show the figure after all components are created
            app.MToPv111UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = MTO_GUI

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.MToPv111UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.MToPv111UIFigure)
        end
    end
end