function PlotTest(app)
% Dispatch the selected Test plot and reset its axes.
% Edit this file to customize the plot; app provides the current GUI data and controls.

% update UI Axes in Test module

cla(app.TUIAxes, 'reset');
type = app.TShowTypeDropDown.Value;
switch type
    case 'Tasks Figure (1D Unified)' % Tasks Figure (1D unified)
        PlotTestTasks1D(app);
    case 'Tasks Figure (2D Unified)' % Tasks Figure (2D unified)
        PlotTestTasks2D(app);
    case 'Tasks Figure (2D Real)' % Tasks Figure (2D unified)
        PlotTestTasks2D(app);
    case 'Tasks Figure (1D Real)' % Tasks Figure (1D real)
        PlotTestTasks1D(app);
    case 'Feasible Region (2D)' % Feasible Region (2D)
        PlotTestFeasibleRegion(app);
    case 'Convergence'
        PlotTestConvergence(app);
    case 'Pareto Front'
        PlotTestParetoFront(app);
end
PlotStyle(app.TUIAxes, 'Test');
end
