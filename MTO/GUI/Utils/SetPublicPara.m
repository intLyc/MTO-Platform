classdef SetPublicPara < matlab.ui.componentcontainer.ComponentContainer
    properties (Access = private, Transient, NonCopyable)
        GridLayout matlab.ui.container.GridLayout
        Fields matlab.ui.control.EditField
        ApplyButton matlab.ui.control.Button
        DisplayedValues = []
        DisplayedEditable = []
    end

    events (HasCallbackProperty, NotifyAccess = private)
        ParametersApplied
    end

    properties
        CurrentValues = nan(1, 4)
        EditableFields = false(1, 4)
        PublicParameters = nan(1, 4) % NaN leaves the corresponding parameter unchanged.
    end

    methods (Access = private)
        function apply(comp)
            values = nan(1, 4);
            names = {'N', 'maxFE', 'Task Num', 'Dim'};
            minimum = [1, 0, 1, 1];
            for p = 1:4
                text = strtrim(comp.Fields(p).Value);
                if ~comp.EditableFields(p) || isempty(text), continue; end
                value = str2double(text);
                if ~isfinite(value) || value < minimum(p) || value ~= fix(value)
                    uialert(ancestor(comp, 'figure'), ...
                        sprintf('%s must be an integer greater than or equal to %d.', names{p}, minimum(p)), ...
                        'Invalid parameter', 'Icon', 'error');
                    return;
                end
                if value ~= comp.CurrentValues(p), values(p) = value; end
            end
            comp.PublicParameters = values;
            notify(comp, 'ParametersApplied');
        end
    end

    methods (Access = protected)
        function update(comp)
            % Resizing must not replace unsaved edits with the initial values.
            if isequaln(comp.CurrentValues, comp.DisplayedValues) && ...
                    isequal(comp.EditableFields, comp.DisplayedEditable)
                return;
            end
            comp.DisplayedValues = comp.CurrentValues;
            comp.DisplayedEditable = comp.EditableFields;
            for p = 1:4
                if isfinite(comp.CurrentValues(p))
                    comp.Fields(p).Value = num2str(comp.CurrentValues(p), 16);
                else
                    comp.Fields(p).Value = '';
                end
                comp.Fields(p).Placeholder = 'Mixed (unchanged)';
                if comp.EditableFields(p)
                    comp.Fields(p).Enable = 'on';
                    comp.Fields(p).Tooltip = 'Enter a value to apply to all selected problems; leave blank to keep existing values.';
                else
                    comp.Fields(p).Enable = 'off';
                    comp.Fields(p).Tooltip = 'This parameter is fixed or is not editable in every selected problem.';
                end
            end
            comp.ApplyButton.Enable = any(comp.EditableFields);
        end

        function setup(comp)
            comp.GridLayout = uigridlayout(comp, [5, 2]);
            comp.GridLayout.ColumnWidth = {'fit', '1x'};
            comp.GridLayout.RowHeight = {'1x', '1x', '1x', '1x', '1x'};
            comp.GridLayout.RowSpacing = 5;
            comp.GridLayout.Padding = [8, 8, 8, 8];
            comp.GridLayout.BackgroundColor = [1, 1, 1];
            names = {'N', 'maxFE', 'Task Num', 'Dim'};
            for p = 1:4
                label = uilabel(comp.GridLayout, 'Text', names{p}, ...
                    'HorizontalAlignment', 'right', 'FontWeight', 'bold');
                label.Layout.Row = p; label.Layout.Column = 1;
                comp.Fields(p) = uieditfield(comp.GridLayout, 'text', 'Tag', names{p});
                comp.Fields(p).Layout.Row = p; comp.Fields(p).Layout.Column = 2;
            end
            buttons = uigridlayout(comp.GridLayout, [1, 2]);
            buttons.Layout.Row = 5; buttons.Layout.Column = [1, 2];
            buttons.Padding = [0, 0, 0, 0];
            buttons.BackgroundColor = [1, 1, 1];
            comp.ApplyButton = uibutton(buttons, 'Text', 'Apply', ...
                'BackgroundColor', [0.7882, 1, 0.7882], ...
                'ButtonPushedFcn', @(~, ~) comp.apply());
            uibutton(buttons, 'Text', 'Cancel', ...
                'ButtonPushedFcn', @(~, ~) close(ancestor(comp, 'figure')));
        end
    end
end
