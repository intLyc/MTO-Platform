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

ga = GA();
mfea = MFEA();
mfea.Draw_Dec = true; % enable decision variable plotting

p = CEC17_MTSO1_CI_HS();
p.maxFE = 40000;

MTOData = mto( ...
    {ga, mfea}, ...
    {p}, ...
    'Save_Dec', true ...
);

mfea.dpd.close(); % close decision variable plot

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
    drawnow;
end

clear;
%% ==========================================================
%  Example 2: Multi-objective optimization and evaluate IGD
%% ==========================================================
disp('=== Example 2: Multi-objective optimization with IGD metric ===');

nsga2 = NSGA_II();
mo_mfea = MO_MFEA();
mo_mfea.Draw_Obj = true; % enable objective plotting
mo_mfea.Draw_Dec = true; % enable decision variable plotting

p = CEC17_MTMO1_CI_HS();
p.maxFE = 40000;

MTOData = mto( ...
    {nsga2, mo_mfea}, ...
    {p}, ...
    'Save_Dec', true ...
);

mo_mfea.dpo.close(); % close objective plot
mo_mfea.dpd.close(); % close decision variable plot

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
    drawnow;
end

% plot Pareto front
figure;
for i = 1:size(result2.ParetoData.Obj, 1)
    nexttile;
    for j = 1:size(result2.ParetoData.Obj, 2)
        % draw population
        scatter( ...
            result2.ParetoData.Obj{i, j, 1}(:, 1), ...
            result2.ParetoData.Obj{i, j, 1}(:, 2), ...
            10, 'filled' ...
        );
        hold on;
    end
    % draw real Pareto front
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
    drawnow;
end

clear;
%% ==========================================================
%  Example 3: Modify algorithm and problem parameters before run
%% ==========================================================
disp('=== Example 3: Modify algorithm and problem parameters before run ===');

% Create algorithm with default parameters
% Method 1: modify parameters via getParameter/setParameter
mfea1 = MFEA();
mfea1_para = mfea1.getParameter();
disp('Default MFEA parameters:');
disp(reshape(mfea1_para, 2, [])');
mfea1_para_values = mfea1_para(2:2:end);
mfea1_para_values{1} = '0.3'; % Modify RMP
mfea1.setParameter(mfea1_para_values);
mfea1.Name = 'MFEA-RMP0.3';

% Method 2: modify parameters directly via properties
mfea2 = MFEA();
mfea2.RMP = 0.5; % Modify RMP
mfea2.Name = 'MFEA-RMP0.5';

mfea3 = MFEA();
mfea3.RMP = 0.7; % Modify RMP
mfea3.Name = 'MFEA-RMP0.7';

% Create problem with default parameters
ci_hs1 = CEC17_MTSO1_CI_HS();
ci_hs1_para = ci_hs1.getParameter();
disp('Default CEC17-MTSO1-CI-HS parameters:');
disp(reshape(ci_hs1_para, 2, [])');
ci_hs1_para_values = ci_hs1_para(2:2:end);
ci_hs1_para_values{1} = '50'; % Modify N=50
ci_hs1.setParameter(ci_hs1_para_values);
ci_hs1.Name = 'CEC17-MTSO1-N50';

ci_hs2 = CEC17_MTSO1_CI_HS();
ci_hs2.N = 100; % Modify N=100 directly
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
    drawnow;
end

clear;
%% ==========================================================
%  Example 4: Full experiment with parallel evaluation
%% ==========================================================
disp('=== Example 4: Full experiment with parallel evaluation ===');

alg1 = NSGA_II();
alg2 = MO_MFEA();
alg3 = MTDE_MKTA();
p1 = CEC17_MTMO1_CI_HS();
p1.N = 100;
p2 = CEC17_MTMO8_NI_MS();
p2.N = 120;

MTOData = mto( ...
    {alg1, alg2, alg3}, ...
    {p1, p2}, ...
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

% plot convergence curves
figure;
mean_converge = squeeze(mean(result4.ConvergeData.Y, 3));
mean_evaluations = squeeze(mean(result4.ConvergeData.X, 3));
for i = 1:size(mean_converge, 1)
    nexttile;
    for j = 1:size(mean_converge, 2)
        plot(squeeze(mean_evaluations(i, j, :)), ...
            squeeze(mean_converge(i, j, :)), ...
            'LineWidth', 1.5 ...
        );
        hold on;
    end
    title(result4.RowName{i});
    legend(result4.ColumnName);
    xlabel('Evaluations');
    ylabel('IGD value');
    yscale('log');
    grid on;
    drawnow;
end

% plot Pareto front
figure;
for i = 1:size(result4.ParetoData.Obj, 1)
    nexttile;
    for j = 1:size(result4.ParetoData.Obj, 2)
        % draw population
        if size(result4.ParetoData.Obj{i, j, 1}, 2) == 2
            scatter( ...
                result4.ParetoData.Obj{i, j, 1}(:, 1), ...
                result4.ParetoData.Obj{i, j, 1}(:, 2), ...
                10, 'filled' ...
            );
        elseif size(result4.ParetoData.Obj{i, j, 1}, 2) == 3
            scatter3( ...
                result4.ParetoData.Obj{i, j, 1}(:, 1), ...
                result4.ParetoData.Obj{i, j, 1}(:, 2), ...
                result4.ParetoData.Obj{i, j, 1}(:, 3), ...
                10, 'filled' ...
            );
        end
        hold on;
    end

    % draw real Pareto front
    if size(result4.ParetoData.Optimum{i}, 2) == 2
        scatter( ...
            result4.ParetoData.Optimum{i}(:, 1), ...
            result4.ParetoData.Optimum{i}(:, 2), ...
            1.5, 'k', 'filled' ...
        );
        xlabel('Objective 1');
        ylabel('Objective 2');
    elseif size(result4.ParetoData.Optimum{i}, 2) == 3
        scatter3( ...
            result4.ParetoData.Optimum{i}(:, 1), ...
            result4.ParetoData.Optimum{i}(:, 2), ...
            result4.ParetoData.Optimum{i}(:, 3), ...
            1.5, 'k', 'filled' ...
        );
        view([135 30]);
        xlabel('Objective 1');
        ylabel('Objective 2');
        zlabel('Objective 3');
    end
    hold on;
    title(result4.RowName{i});
    legend([result4.ColumnName, {'Pareto Front'}]);
    grid on;
    drawnow;
end

disp('=== All experiments completed successfully. ===');
