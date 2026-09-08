% GUI plot customization
% Edit these functions to change plots without editing or rebuilding MToP.mlapp.
% Plot functions accept app and read its public data, axes, and display controls.
%
% Shared style
%   PlotStyle                   - Markers, line widths, fonts, colors, and opacity.
%
% Test module
%   PlotTest                    - Plot dispatch and axes reset.
%   PlotTestTasks1D              - One-variable task slices.
%   PlotTestTasks2D              - Two-variable task slices.
%   PlotTestFeasibleRegion       - Feasible slices.
%   PlotTestConvergence          - Obj/IGD convergence from app.TData.
%   PlotTestParetoFront          - Pareto fronts and final populations.
%   ExportTestPlot              - Standalone copy of the Test axes.
%
% Experiment module
%   PlotExperimentConvergence   - Selected metric curves and confidence ranges.
%   PlotExperimentParetoFront   - Selected 2D/3D fronts or parallel coordinates.
%
% Preview helpers
%   PreviewTaskSlice            - Full-dimensional slice evaluation.
%   PreviewObjectiveValues      - Objective selection and normalization.
