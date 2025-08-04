classdef SSLT_GA < Algorithm
% <Multi-task/Many-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Yuan2025Scenario,
%   author   = {Zhuoming Yuan and Guangming Dai and Lei Peng and Maocai Wang and Zhiming Song and Xiaoyu Chen},
%   journal  = {Knowledge-Based Systems},
%   title    = {Scenario-based self-learning transfer framework for multi-task optimization problems},
%   year     = {2025},
%   issn     = {0950-7051},
%   pages    = {113824},
%   volume   = {325},
%   doi      = {https://doi.org/10.1016/j.knosys.2025.113824},
% }
%---------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties (SetAccess = private)
    Gamma = 0.9;
    Threshold = 150;
    Epsilon = 0.8;
    Gap = 50;
    MuC = 2;
    MuM = 5;

end

methods

    function Parameter = getParameter(Algo)
        Parameter = {'Gamma: Discount Rate', num2str(Algo.Gamma), ...
                'Threshold: Threshold to Build DQN', num2str(Algo.Threshold), ...
                'Epsilon: Epsilon-Greedy', num2str(Algo.Epsilon), ...
                'Gap: DQN Update Gap', num2str(Algo.Gap), ...
                'MuC: Simulated Binary Crossover', num2str(Algo.MuC), ...
                'MuM: Polynomial Mutation', num2str(Algo.MuM)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.Gamma = str2double(Parameter{i}); i = i + 1;
        Algo.Threshold = str2double(Parameter{i}); i = i + 1;
        Algo.Epsilon = str2double(Parameter{i}); i = i + 1;
        Algo.Gap = str2double(Parameter{i}); i = i + 1;
        Algo.MuC = str2double(Parameter{i}); i = i + 1;
        Algo.MuM = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)

        % Initialization.
        population = Initialization(Algo, Prob, Individual_DE);

        for t = 1:Prob.T
            % initialize Parameter
            Data_task{t} = [];
            model_built_task(t) = 0;
            count_task(t) = 0;
            indicator{t} = [];
            state_record{t} = [];
            Params_task{t} = [];
            net_task{t} = [];
        end

        population_old = population;

        action_record1 = [];
        action_record2 = [];

        while Algo.notTerminated(Prob)

            for t = 1:Prob.T

                % random select a source task
                idx = 1:Prob.T; idx(t) = [];
                s = idx(randi(end));

                % old state
                conv_target = (min(population_old{t}.Objs) - min(population{t}.Objs)) / min(population_old{t}.Objs);
                conv_source = (min(population_old{s}.Objs) - min(population{s}.Objs)) / min(population_old{s}.Objs);

                wsd = Algo.Ws(population{s}, population{t});
                ls_target_type = Algo.Dispersion(population{t}, population_old{t});
                ls_source_type = Algo.Dispersion(population{s}, population_old{s});
                pha = Algo.FE / Prob.maxFE;
                state_record{t} = [state_record{t}; conv_source, conv_target, wsd, ls_target_type, ls_source_type, pha];
                if Algo.Gen <= Algo.Threshold % 50 125  200 275  400
                    % random select at the first 150 generations
                    action = randi(4);
                else
                    if ~model_built_task(t)
                        % build model here
                        tr_x = Data_task{t}(:, 1:7);
                        [tr_xx, ps] = mapminmax(tr_x'); tr_xx = tr_xx';
                        tr_y = Data_task{t}(:, 8:14);
                        [tr_yy, qs] = mapminmax(tr_y'); tr_yy = tr_yy';
                        Params_task{t}.ps = ps; Params_task{t}.qs = qs;
                        [net_task{t}, Params_task{t}] = trainmodel(tr_xx, tr_yy, Params_task{t});
                        model_built_task(t) = 1;
                        action = randi(4);
                    else
                        % use the model to choose action
                        if rand > Algo.Epsilon
                            action = randi(4);
                        else
                            test_x1 = [conv_source, conv_target, wsd, ls_target_type, ls_source_type, pha, 1];
                            test_x2 = [conv_source, conv_target, wsd, ls_target_type, ls_source_type, pha, 2];
                            test_x3 = [conv_source, conv_target, wsd, ls_target_type, ls_source_type, pha, 3];
                            test_x4 = [conv_source, conv_target, wsd, ls_target_type, ls_source_type, pha, 4];
                            ps = Params_task{t}.ps; qs = Params_task{t}.qs;
                            x1 = mapminmax('apply', test_x1', ps); x1 = x1';
                            x2 = mapminmax('apply', test_x2', ps); x2 = x2';
                            x3 = mapminmax('apply', test_x3', ps); x3 = x3';
                            x4 = mapminmax('apply', test_x4', ps); x4 = x4';
                            succ1 = testNet(x1, net_task{t}, Params_task{t});
                            succ1 = mapminmax('reverse', succ1', qs); succ1 = succ1';
                            succ2 = testNet(x2, net_task{t}, Params_task{t});
                            succ2 = mapminmax('reverse', succ2', qs); succ2 = succ2';
                            succ3 = testNet(x3, net_task{t}, Params_task{t});
                            succ3 = mapminmax('reverse', succ3', qs); succ3 = succ3';
                            succ4 = testNet(x4, net_task{t}, Params_task{t});
                            succ4 = mapminmax('reverse', succ4', qs); succ4 = succ4';
                            succ = [succ1; succ2; succ3; succ4];
                            [~, action] = max(succ(:, 1));
                        end
                    end
                end
                indicator{t} = [indicator{t}, action];
                current_at = action; %action

                if current_at == 1 % no KT

                    % Generate offspring
                    offspring = Algo.Generation(population{t});
                    % Evaluation
                    offspring = Algo.Evaluation(offspring, Prob, t);
                    % Selection
                    new_population = Selection_Elit(population{t}, offspring);

                elseif current_at == 2 % shape KT

                    smooth_pop2 = Algo.Smooth(population{s});
                    smooth_pop1 = Algo.Smooth(population{t});
                    % Center of the target_population
                    center_target_population = sum(smooth_pop1.Decs, 1) ./ length(smooth_pop1);
                    % Center of the source_population
                    center_source_population = sum(smooth_pop2.Decs, 1) ./ length(smooth_pop2);

                    % Move distance
                    for si = 1:length(smooth_pop2)
                        smooth_pop2(si).Dec = smooth_pop2(si).Dec + (center_target_population - center_source_population);
                    end

                    % Evaluation
                    smooth_pop2 = Algo.Evaluation(smooth_pop2, Prob, t);

                    new_population = Selection_Elit(population{t}, smooth_pop2);

                elseif current_at == 3 % Bi-KT

                    % Generation hybrid offspring
                    offspring = Algo.Generation_Bi(population{t}, population{s});
                    % Evaluation
                    offspring = Algo.Evaluation(offspring, Prob, t);
                    % Selection
                    new_population = Selection_Elit(population{t}, offspring);

                elseif current_at == 4 % Domin KT

                    % Generation hybrid offspring
                    offspring = Algo.Generation_Domain(population{t}, population{s}, Prob);

                    offspring = Algo.Evaluation(offspring, Prob, t);

                    % Selection
                    [new_population, ~] = Selection_Elit(population{t}, offspring);

                else
                    disp('Exceed the boundary of action space!');
                end

                population_old{t} = population{t};
                population{t} = new_population;
                fold = min(population_old{t}.Objs);
                f = min(population{t}.Objs);
                fold_mean = mean(population_old{t}.Objs);
                f_mean = mean(population{t}.Objs);

                % Update State

                conv_new_target = (min(population_old{t}.Objs) - min(population{t}.Objs)) / min(population_old{t}.Objs);
                conv_new_source = (min(population_old{s}.Objs) - min(population{s}.Objs)) / min(population_old{s}.Objs);

                wsd_new = Algo.Ws(population{s}, population{t});
                ls_target_type_new = Algo.Dispersion(population{t}, population_old{t});
                ls_source_type_new = Algo.Dispersion(population{s}, population_old{s});
                pha_new = Algo.FE / Prob.maxFE;

                imp_rate = (fold - f) / fold;
                pop_rate = (fold_mean - f_mean) / fold_mean;
                move_dis = Algo.Convergence(population_old{t}, population{t});

                max_val = max([imp_rate pop_rate move_dis]);
                min_val = min([imp_rate pop_rate move_dis]);

                imp_rate = (imp_rate - min_val) / (max_val - min_val);
                pop_rate = (pop_rate - min_val) / (max_val - min_val);
                move_dis = (move_dis - min_val) / (max_val - min_val);

                Reward = (imp_rate + pop_rate + move_dis) * pha_new;

                % Update experience replay
                current_record = [conv_source conv_target wsd ls_target_type ls_source_type pha current_at ...
                        Reward conv_new_source conv_new_target wsd_new ls_target_type_new ls_source_type_new pha_new];

                Data_task{t} = [Data_task{t}; current_record];
                if size(Data_task{t}, 1) > 500
                    Data_task{t}(1, :) = [];
                end

                %% Update Q-net
                if model_built_task(t)
                    count_task(t) = count_task(t) + 1;
                    if count_task(t) > Algo.Gap
                        qs = Params_task{t}.qs;
                        tr_x = Data_task{t}(:, 1:7);
                        [tr_xx, ps] = mapminmax(tr_x'); tr_xx = tr_xx';
                        succ1 = testNet(tr_xx, net_task{t}, Params_task{t});
                        succ1 = mapminmax('reverse', succ1', qs); succ1 = succ1';
                        succ = succ1(:, 1);
                        tr_yy = Data_task{t}(:, 8) + Algo.Gamma * max(succ);
                        [tr_yy, qs] = mapminmax(tr_yy'); tr_yy = tr_yy';
                        Params_task{t}.ps = ps; Params_task{t}.qs = qs;
                        net_task{t} = updatemodel(tr_xx, tr_yy, Params_task{t}, net_task{t});
                        count_task(t) = 0;
                    end
                end
            end
        end
    end

    function div = Diversity(Algo, population)
        [~, ind_best] = min(population.Objs);
        population_best_dec = population(ind_best).Dec;
        population_dec_matrix = population.Decs;
        div = sum(sum((population_dec_matrix - population_best_dec).^3, 2), 1) / length(population);
    end

    function conv = Convergence(Algo, population_old, population_current)
        center_old_pop = mean(population_old.Decs, 1);
        center_current_pop = mean(population_current.Decs, 1);
        conv = sqrt(sum((center_old_pop - center_current_pop).^2, 2));
    end

    function ls_type = Dispersion(Algo, population, population_old)
        [~, rank] = sortrows(population.Objs);
        M = round(0.1 * length(population));
        M_pop = population(rank(1:max(M, 1))).Decs;
        up = 0;
        for i = 1:M - 1
            temp = M_pop(i + 1:end);
            up = up + sum((temp - M_pop(i)).^2, 2);
        end

        dm = up / (M * (M - 1));

        [~, rank] = sortrows(population_old.Objs);
        M = round(0.1 * length(population_old));
        M_pop_old = population_old(rank(1:max(M, 1))).Decs;
        up_old = 0;
        for i = 1:M - 1
            temp = M_pop_old(i + 1:end);
            up_old = up_old + sum((temp - M_pop_old(i)).^2, 2);
        end

        dm_old = up_old / (M * (M - 1));

        if dm - dm_old < 0
            ls_type = 1;
        elseif dm - dm_old == 0
            ls_type = 2;
        else
            ls_type = 3;
        end
    end

    function wsd = Ws(Algo, target_population, domain_population)
        u_samples = target_population.Decs;
        v_samples = domain_population.Decs;
        u_samples_sorted = sort(u_samples(:));
        v_samples_sorted = sort(v_samples(:));
        all_samples = unique([u_samples_sorted; v_samples_sorted], 'sorted');

        u_cdf = find_interval(u_samples_sorted, all_samples(1:end - 1)) ...
            / numel(u_samples);
        v_cdf = find_interval(v_samples_sorted, all_samples(1:end - 1)) ...
            / numel(v_samples);

        wsd = sum(abs(u_cdf - v_cdf) .* diff(all_samples));
    end

    function offspring = Generation(Algo, population)
        indorder = randperm(length(population));
        count = 1;
        for i = 1:ceil(length(population) / 2)
            p1 = indorder(i);
            p2 = indorder(i + fix(length(population) / 2));
            offspring(count) = population(p1);
            offspring(count + 1) = population(p2);

            [offspring(count).Dec, offspring(count + 1).Dec] = GA_Crossover(population(p1).Dec, population(p2).Dec, Algo.MuC);

            offspring(count).Dec = GA_Mutation(offspring(count).Dec, Algo.MuM);
            offspring(count + 1).Dec = GA_Mutation(offspring(count + 1).Dec, Algo.MuM);

            for x = count:count + 1
                offspring(x).Dec(offspring(x).Dec > 1) = 1;
                offspring(x).Dec(offspring(x).Dec < 0) = 0;
            end
            count = count + 2;
        end
    end

    function offspring = Generation_Domain(Algo, population, source_population, Prob)
        count = 1;
        [~, best_source_ind] = min(source_population.Objs);
        best_source_individual = source_population(best_source_ind);
        [~, best_target_ind] = min(population.Objs);
        best_target_individual = population(best_target_ind);
        mean_target_source = (best_source_individual.Dec - best_target_individual.Dec);
        num = max(1, round((Algo.FE / Prob.maxFE) * 10));

        ind_rnd = randperm(100);
        population = population(ind_rnd(1:num));
        indorder = randperm(length(population));

        for i = 1:ceil(length(population) / 2)
            p1 = indorder(i);
            p2 = indorder(i + fix(length(population) / 2));

            offspring(count) = population(i); offspring(count + 1) = population(i);
            [offspring(count).Dec, offspring(count + 1).Dec] = GA_Crossover_Domain(population(p1).Dec, population(p2).Dec, mean_target_source, Algo.MuC);
            for x = count:count + 1
                offspring(x).Dec(offspring(x).Dec > 1) = 1;
                offspring(x).Dec(offspring(x).Dec < 0) = 0;
            end
            count = count + 2;
        end
    end

    function offspring = Generation_Bi(Algo, population, source_population)
        merge_population = [population, source_population];
        ind_rand = randperm(length(merge_population));
        merge_population = merge_population(ind_rand);
        indorder = randperm(length(merge_population));
        count = 1;

        for i = 1:ceil(length(merge_population) / 3)
            p1 = indorder(i);
            p2 = indorder(i + fix(length(merge_population) / 3));
            p3 = indorder(i + 2 * fix(length(merge_population) / 3));

            offspring(count) = merge_population(p1);
            offspring(count + 1) = merge_population(p2);
            offspring(count + 2) = merge_population(p3);

            [offspring(count).Dec, offspring(count + 1).Dec, offspring(count + 2).Dec] = ...
                GA_Crossover_Bi(merge_population(p1).Dec, merge_population(p2).Dec, merge_population(p3).Dec, Algo.MuC);

            offspring(count).Dec = GA_Mutation(offspring(count).Dec, Algo.MuM);
            offspring(count + 1).Dec = GA_Mutation(offspring(count + 1).Dec, Algo.MuM);
            offspring(count + 2).Dec = GA_Mutation(offspring(count + 2).Dec, Algo.MuM);
            for x = count:count + 2
                offspring(x).Dec(offspring(x).Dec > 1) = 1;
                offspring(x).Dec(offspring(x).Dec < 0) = 0;
            end
            count = count + 3;
        end
    end

    function smooth_pop = Smooth(Algo, population)
        smooth_pop = population;
        delete_pop_id = [];
        for i = 1:3:length(population) - 1
            [~, ind] = sort([population(i).Obj population(i + 1).Obj population(i + 2).Obj]);
            delete_pop_id = [delete_pop_id, ind(2) + i - 1, ind(3) + i - 1];
        end
        smooth_pop(delete_pop_id) = [];
    end
end
end

function idx = find_interval(bounds, vals)
m = 0;
bounds = [bounds(:); inf];
idx = zeros(numel(vals), 1);

for i = 1:numel(vals)
    while bounds(m + 1) <= vals(i)
        m = m + 1;
    end
    idx(i) = m;
end
end

function [OffDec1, OffDec2, OffDec3] = GA_Crossover_Domain(ParDec1, ParDec2, ParDec3, mu)
D = size(ParDec1, 2);
u = rand(1, D);
beta = zeros(1, D);
beta(u <= 0.5) = (2 * u(u <= 0.5)).^(1 / (mu + 1));
beta(u > 0.5) = (2 * (1 - u(u > 0.5))).^(-1 / (mu + 1));
beta = beta .* (-1).^randi([0, 1], 1, D);
beta(rand(1, D) < 0.5) = 1;

OffDec1 = 0.5 * ((1 + beta) .* ParDec1 + (1 - beta) .* (ParDec2 / 2 + ParDec3 / 2));
OffDec2 = 0.5 * ((1 + beta) .* ParDec2 + (1 - beta) .* (ParDec1 / 2 + ParDec3 / 2));
OffDec3 = 0.5 * ((1 + beta) .* ParDec3 + (1 - beta) .* (ParDec2 / 2 + ParDec1 / 2));
end

function [OffDec1, OffDec2, OffDec3] = GA_Crossover_Bi(ParDec1, ParDec2, ParDec3, mu)
D = size(ParDec1, 2);
u = rand(1, D);
beta = zeros(1, D);
beta(u <= 0.5) = (2 * u(u <= 0.5)).^(1 / (mu + 1));
beta(u > 0.5) = (2 * (1 - u(u > 0.5))).^(-1 / (mu + 1));
beta = beta .* (-1).^randi([0, 1], 1, D);
beta(rand(1, D) < 0.5) = 1;

OffDec1 = 0.5 * ((1 + beta) .* ParDec1 + (1 - beta) .* (ParDec2 / 2 + ParDec3 / 2));
OffDec2 = 0.5 * ((1 + beta) .* ParDec2 + (1 - beta) .* (ParDec1 / 2 + ParDec3 / 2));
OffDec3 = 0.5 * ((1 + beta) .* ParDec3 + (1 - beta) .* (ParDec1 / 2 + ParDec2 / 2));
end
