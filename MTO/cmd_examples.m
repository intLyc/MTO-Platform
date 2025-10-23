%% MTO/cmd_examples.m
% Examples of using MToP in command-line mode

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

clc; clear; close all;
addpath(genpath(pwd));

%% ==========================================================
%  Example 1: Single-objective optimization and evaluate Obj
%% ==========================================================
disp('=== Example 1: Single-objective optimization with Obj metric ===');

MTOData = mto( ...
    {GA, MFEA}, ...
    {CEC17_MTSO1_CI_HS, CMT1}, ...
    'Reps', 2, ...
    'Save_Dec', true ...
);

% print results
result1 = Obj(MTOData);
disp('Objective final values:');
disp(mean(result1.TableData, 3));

% print size of decision variables
disp('Size of decision variables:');
% (1st problem, 1st algorithm, 1st repetition) - (1st task, last generation)
disp(size([squeeze(MTOData.Results(1, 1, 1).Dec(1, end, :))]'));

% plot convergence curves
figure;
mean_converge = squeeze(mean(result1.ConvergeData.Y, 3));
mean_evaluations = squeeze(mean(result1.ConvergeData.X, 3));
for i = 1:size(mean_converge, 1)
    nexttile;
    for j = 1:size(mean_converge, 2)
        plot(squeeze(mean_evaluations(i, j, :)), ...
            squeeze(mean_converge(i, j, :)), ...
            'LineWidth', 1.5 ...
        );
        hold on;
    end
    title(result1.RowName{i});
    legend(result1.ColumnName);
    xlabel('Evaluations');
    ylabel('Objective value');
    yscale('log');
    grid on;
end

clear;
%% ==========================================================
%  Example 2: Multi-objective optimization and evaluate IGD
%% ==========================================================
disp('=== Example 2: Multi-objective optimization with IGD metric ===');

MTOData = mto( ...
    {NSGA_II, MO_MFEA}, ...
    {CEC17_MTMO1_CI_HS, MTMO_Instance2}, ...
    'Reps', 2, ...
    'Save_Dec', true ...
);

% print results
result2 = IGD(MTOData, false);
disp('Final IGD values:');
disp(mean(result2.TableData, 3));

% print size of multi-objective decision variables (PopDec)
disp('Size of multi-objective decision variables (PopDec):');
% (1st problem, 1st algorithm, 1st repetition) - (1st task, last generation)
disp(size(squeeze(MTOData.Results(1, 1, 1).Dec(1, end, :, :))));

% plot convergence curves
figure;
mean_converge = squeeze(mean(result2.ConvergeData.Y, 3));
mean_evaluations = squeeze(mean(result2.ConvergeData.X, 3));
for i = 1:size(mean_converge, 1)
    nexttile;
    for j = 1:size(mean_converge, 2)
        plot(squeeze(mean_evaluations(i, j, :)), ...
            squeeze(mean_converge(i, j, :)), ...
            'LineWidth', 1.5 ...
        );
        hold on;
    end
    title(result2.RowName{i});
    legend(result2.ColumnName);
    xlabel('Evaluations');
    ylabel('IGD value');
    yscale('log');
    grid on;
end

% plot Pareto front
figure;
for i = 1:size(result2.ParetoData.Obj, 1)
    nexttile;
    for j = 1:size(result2.ParetoData.Obj, 2)
        scatter( ...
            result2.ParetoData.Obj{i, j, 1}(:, 1), ...
            result2.ParetoData.Obj{i, j, 1}(:, 2), ...
            10, 'filled' ...
        );
        hold on;
    end
    scatter( ...
        result2.ParetoData.Optimum{i}(:, 1), ...
        result2.ParetoData.Optimum{i}(:, 2), ...
        1.5, 'k', 'filled' ...
    ); hold on;
    title(result2.RowName{i});
    legend([result2.ColumnName, {'Pareto Front'}]);
    xlabel('Objective 1');
    ylabel('Objective 2');
    grid on;
end

clear;
%% ==========================================================
%  Example 3: Modify algorithm and problem parameters before run
%% ==========================================================
disp('=== Example 3: Modify algorithm and problem parameters before run ===');

% Create algorithm with default parameters
mfea1 = MFEA();
mfea1_para = mfea1.getParameter();
mfea1_para_values = mfea1_para(2:2:end);
mfea1_para_values{1} = '0.3'; % Modify RMP
mfea1.setParameter(mfea1_para_values);
mfea1.Name = 'MFEA-RMP0.3';

mfea2 = MFEA();
mfea2_para = mfea2.getParameter();
mfea2_para_values = mfea2_para(2:2:end);
mfea2_para_values{1} = '0.5'; % Modify RMP
mfea2.setParameter(mfea2_para_values);
mfea2.Name = 'MFEA-RMP0.5';

mfea3 = MFEA();
mfea3_para = mfea3.getParameter();
mfea3_para_values = mfea3_para(2:2:end);
mfea3_para_values{1} = '0.7'; % Modify RMP
mfea3.setParameter(mfea3_para_values);
mfea3.Name = 'MFEA-RMP0.7';

% Create problem with default parameters
ci_hs1 = CEC17_MTSO1_CI_HS();
ci_hs1_para = ci_hs1.getParameter();
ci_hs1_para_values = ci_hs1_para(2:2:end);
ci_hs1_para_values{1} = '50'; % Modify N=50
ci_hs1.setParameter(ci_hs1_para_values);
ci_hs1.Name = 'CEC17-MTSO1-N50';

ci_hs2 = CEC17_MTSO1_CI_HS();
ci_hs2_para = ci_hs2.getParameter();
ci_hs2_para_values = ci_hs2_para(2:2:end);
ci_hs2_para_values{1} = '100'; % Modify N=100
ci_hs2.setParameter(ci_hs2_para_values);
ci_hs2.Name = 'CEC17-MTSO1-N100';

MTOData = mto( ...
    {mfea1, mfea2, mfea3}, ...
    {ci_hs1, ci_hs2}, ...
    'Reps', 2 ...
);

result3 = Obj(MTOData);
disp('Objective final values with modified parameters:');
disp(mean(result3.TableData, 3));

figure;
mean_converge = squeeze(mean(result3.ConvergeData.Y, 3));
mean_evaluations = squeeze(mean(result3.ConvergeData.X, 3));
for i = 1:size(mean_converge, 1)
    nexttile;
    for j = 1:size(mean_converge, 2)
        plot(squeeze(mean_evaluations(i, j, :)), ...
            squeeze(mean_converge(i, j, :)), ...
            'LineWidth', 1.5 ...
        );
        hold on;
    end
    title(result3.RowName{i});
    legend(result3.ColumnName);
    xlabel('Evaluations');
    ylabel('Objective value');
    yscale('log');
    grid on;
end

clear;
%% ==========================================================
%  Example 4: Full experiment with parallel evaluation
%% ==========================================================
disp('=== Example 4: Full experiment with parallel evaluation ===');

MTOData = mto( ...
    {NSGA_II, MO_MFEA, MTDE_MKTA}, ...
    {CEC17_MTMO1_CI_HS, CEC17_MTMO2_CI_MS}, ...
    'Reps', 10, ...
    'Par_Flag', true, ...
    'Results_Num', 30, ...
    'Save_Dec', false, ...
    'Save_Name', 'MTODataSaved.mat', ...
    'Global_Seed', 2333 ...
);

result4 = IGD(MTOData, true);
disp('Final IGD values from full experiment:');
disp(mean(result4.TableData, 3));

disp('=== All experiments completed successfully. ===');
