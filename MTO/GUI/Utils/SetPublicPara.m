classdef SetPublicPara < matlab.ui.componentcontainer.ComponentContainer

    % Properties that correspond to underlying components
    properties (Access = private, Transient, NonCopyable)
        GridLayout             matlab.ui.container.GridLayout
        GridLayout2            matlab.ui.container.GridLayout
        cancelButton           matlab.ui.control.Button
        ApplyButton            matlab.ui.control.Button
        DimEditField           matlab.ui.control.NumericEditField
        DimEditFieldLabel      matlab.ui.control.Label
        TaskNumEditField       matlab.ui.control.NumericEditField
        TaskNumEditFieldLabel  matlab.ui.control.Label
        maxFEEditField         matlab.ui.control.NumericEditField
        maxFEEditFieldLabel    matlab.ui.control.Label
        NEditField             matlab.ui.control.NumericEditField
        NLabel                 matlab.ui.control.Label
    end

    % Events with associated public callbacks
    events (HasCallbackProperty, NotifyAccess = private)
        ParametersApplied
    end

    properties (Access = public)
        PublicParameters
    end
    
    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: ApplyButton
        function ApplyButtonPushed(comp, event)
            comp.PublicParameters(1) = comp.NEditField.Value;
            comp.PublicParameters(2) = comp.maxFEEditField.Value;
            comp.PublicParameters(3) = comp.TaskNumEditField.Value;
            comp.PublicParameters(4) = comp.DimEditField.Value;

            notify(comp, 'ParametersApplied');
        end

        % Button pushed function: cancelButton
        function cancelButtonPushed(comp, event)
            f = ancestor(comp, 'figure');
            if ~isempty(f) && isvalid(f)
                close(f);
            end
        end
    end

    methods (Access = protected)
        
        % Code that executes when the value of a public property is changed
        function update(comp)
            % Use this function to update the underlying components
            
        end

        % Create the underlying components
        function setup(comp)

            comp.Position = [1 1 152 145];

            % Create GridLayout
            comp.GridLayout = uigridlayout(comp);
            comp.GridLayout.ColumnWidth = {'fit', '1x'};
            comp.GridLayout.RowHeight = {'fit', 'fit', 'fit', 'fit', '1x'};
            comp.GridLayout.RowSpacing = 5;
            comp.GridLayout.Padding = [5 5 5 5];
            comp.GridLayout.BackgroundColor = [1 1 1];

            % Create NLabel
            comp.NLabel = uilabel(comp.GridLayout);
            comp.NLabel.HorizontalAlignment = 'right';
            comp.NLabel.FontWeight = 'bold';
            comp.NLabel.Layout.Row = 1;
            comp.NLabel.Layout.Column = 1;
            comp.NLabel.Text = 'N';

            % Create NEditField
            comp.NEditField = uieditfield(comp.GridLayout, 'numeric');
            comp.NEditField.Limits = [1 Inf];
            comp.NEditField.ValueDisplayFormat = '%d';
            comp.NEditField.Layout.Row = 1;
            comp.NEditField.Layout.Column = 2;
            comp.NEditField.Value = 100;

            % Create maxFEEditFieldLabel
            comp.maxFEEditFieldLabel = uilabel(comp.GridLayout);
            comp.maxFEEditFieldLabel.HorizontalAlignment = 'right';
            comp.maxFEEditFieldLabel.FontWeight = 'bold';
            comp.maxFEEditFieldLabel.Layout.Row = 2;
            comp.maxFEEditFieldLabel.Layout.Column = 1;
            comp.maxFEEditFieldLabel.Text = 'maxFE';

            % Create maxFEEditField
            comp.maxFEEditField = uieditfield(comp.GridLayout, 'numeric');
            comp.maxFEEditField.Limits = [0 Inf];
            comp.maxFEEditField.ValueDisplayFormat = '%d';
            comp.maxFEEditField.Layout.Row = 2;
            comp.maxFEEditField.Layout.Column = 2;
            comp.maxFEEditField.Value = 100000;

            % Create TaskNumEditFieldLabel
            comp.TaskNumEditFieldLabel = uilabel(comp.GridLayout);
            comp.TaskNumEditFieldLabel.HorizontalAlignment = 'right';
            comp.TaskNumEditFieldLabel.FontWeight = 'bold';
            comp.TaskNumEditFieldLabel.Layout.Row = 3;
            comp.TaskNumEditFieldLabel.Layout.Column = 1;
            comp.TaskNumEditFieldLabel.Text = 'Task Num';

            % Create TaskNumEditField
            comp.TaskNumEditField = uieditfield(comp.GridLayout, 'numeric');
            comp.TaskNumEditField.Limits = [1 Inf];
            comp.TaskNumEditField.ValueDisplayFormat = '%d';
            comp.TaskNumEditField.Layout.Row = 3;
            comp.TaskNumEditField.Layout.Column = 2;
            comp.TaskNumEditField.Value = 50;

            % Create DimEditFieldLabel
            comp.DimEditFieldLabel = uilabel(comp.GridLayout);
            comp.DimEditFieldLabel.HorizontalAlignment = 'right';
            comp.DimEditFieldLabel.FontWeight = 'bold';
            comp.DimEditFieldLabel.Layout.Row = 4;
            comp.DimEditFieldLabel.Layout.Column = 1;
            comp.DimEditFieldLabel.Text = 'Dim';

            % Create DimEditField
            comp.DimEditField = uieditfield(comp.GridLayout, 'numeric');
            comp.DimEditField.Limits = [1 Inf];
            comp.DimEditField.ValueDisplayFormat = '%d';
            comp.DimEditField.Layout.Row = 4;
            comp.DimEditField.Layout.Column = 2;
            comp.DimEditField.Value = 50;

            % Create GridLayout2
            comp.GridLayout2 = uigridlayout(comp.GridLayout);
            comp.GridLayout2.RowHeight = {'1x'};
            comp.GridLayout2.ColumnSpacing = 5;
            comp.GridLayout2.RowSpacing = 0;
            comp.GridLayout2.Padding = [0 0 0 0];
            comp.GridLayout2.Layout.Row = 5;
            comp.GridLayout2.Layout.Column = [1 2];
            comp.GridLayout2.BackgroundColor = [1 1 1];

            % Create ApplyButton
            comp.ApplyButton = uibutton(comp.GridLayout2, 'push');
            comp.ApplyButton.ButtonPushedFcn = matlab.apps.createCallbackFcn(comp, @ApplyButtonPushed, true);
            comp.ApplyButton.BackgroundColor = [0.7882 1 0.7882];
            comp.ApplyButton.Layout.Row = 1;
            comp.ApplyButton.Layout.Column = 1;
            comp.ApplyButton.Text = 'Apply';

            % Create cancelButton
            comp.cancelButton = uibutton(comp.GridLayout2, 'push');
            comp.cancelButton.ButtonPushedFcn = matlab.apps.createCallbackFcn(comp, @cancelButtonPushed, true);
            comp.cancelButton.BackgroundColor = [1 1 1];
            comp.cancelButton.Layout.Row = 1;
            comp.cancelButton.Layout.Column = 2;
            comp.cancelButton.Text = 'cancel';
        end
    end
end