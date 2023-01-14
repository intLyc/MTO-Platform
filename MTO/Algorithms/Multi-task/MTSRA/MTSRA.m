classdef MTSRA < Algorithm
% <Multi-task> <Single-objective> <Competitive>

%------------------------------- Reference --------------------------------
% @Article{Li2023MTSRA,
%   title      = {Evolutionary Competitive Multitasking Optimization Via Improved Adaptive Differential Evolution},
%   author     = {Yanchi Li and Wenyin Gong and Shuijia Li},
%   journal    = {Expert Systems with Applications},
%   year       = {2023},
%   issn       = {0957-4174},
%   pages      = {119550},
%   doi        = {https://doi.org/10.1016/j.eswa.2023.119550},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
%--------------------------------------------------------------------------

properties (SetAccess = private)
    P = 0.1
    H = 100
    RH = 100
    Alpha = 0.5
    Beta = 0.2
    Pmin = 0.1
    RMP0 = 0.3
end

methods
    function parameter = getParameter(Algo)
        parameter = {'P: 100p% top as pbest', num2str(Algo.P), ...
                'H: Success memory size', num2str(Algo.H), ...
                'RH: Record success memory size', num2str(Algo.RH), ...
                'Alpha: Ratio of global and population', num2str(Algo.Alpha), ...
                'Beta: Learning phase', num2str(Algo.Beta), ...
                'Pmin: Minimum selection probability', num2str(Algo.Pmin), ...
                'RMP0: Init random mating probability', num2str(Algo.RMP0)};
    end

    function Algo = setParameter(Algo, parameter_cell)
        count = 1;
        Algo.P = str2double(parameter_cell{count}); count = count + 1;
        Algo.H = str2double(parameter_cell{count}); count = count + 1;
        Algo.RH = str2double(parameter_cell{count}); count = count + 1;
        Algo.Alpha = str2double(parameter_cell{count}); count = count + 1;
        Algo.Beta = str2double(parameter_cell{count}); count = count + 1;
        Algo.Pmin = str2double(parameter_cell{count}); count = count + 1;
        Algo.RMP0 = str2double(parameter_cell{count}); count = count + 1;
    end

    function run(Algo, Prob)
        % Initialization
        population = Initialization(Algo, Prob, Individual_DE);
        RMP = Algo.RMP0 * ones(Prob.T, Prob.T);
        delta_rmp = Prob.N / Prob.maxFE;
        delta_rmp = delta_rmp * (Prob.T * 2 - Prob.T);
        for t = 1:Prob.T
            MF{t} = 0.5 .* ones(1, Algo.H);
            MCR{t} = 0.5 * ones(1, Algo.H);
            archive{t} = Individual_DE.empty();
            Hidx(t) = 1;
            HR_idx(t) = 1;
        end
        HR = 0 * ones(Prob.T, Algo.RH); % HR is used to store the historical rewards
        pro(1, :) = 1 / Prob.T * ones(1, Prob.T);

        while Algo.notTerminated(Prob)
            % Select the k-th task to optimize
            if Algo.FE <= Algo.Beta * Prob.maxFE
                % Stage 1: Evolution
                pro(Algo.Gen, :) = 1 / Prob.T * ones(1, Prob.T);
            else
                % Stage 2: Competition
                if sum(HR, 'all') ~= 0
                    pro(Algo.Gen, :) = Algo.Pmin / Prob.T + (1 - Algo.Pmin) * sum(HR, 2) ./ max(sum(HR, 'all'));
                    pro(Algo.Gen, :) = pro(Algo.Gen, :) ./ sum(pro(Algo.Gen, :));
                else
                    pro(Algo.Gen, :) = 1 / Prob.T * ones(1, Prob.T);
                end
            end

            % Determine the a task based on the selection probability using roulette wheel method
            r = rand;
            for t = 1:Prob.T
                if r <= sum(pro(Algo.Gen, 1:t))
                    k = t;
                    break;
                end
            end

            % randomly select communicate task
            task_list = 1:Prob.T; task_list(k) = [];
            c = task_list(randi(length(task_list)));

            union = [population{k}, archive{k}];
            c_union = [population{c}, archive{c}];

            % calculate individual F and CR
            for i = 1:length(population{k})
                idx = randi(Algo.H);
                uF = MF{k}(idx);
                population{k}(i).F = uF + 0.1 * tan(pi * (rand - 0.5));
                while (population{k}(i).F <= 0)
                    population{k}(i).F = uF + 0.1 * tan(pi * (rand - 0.5));
                end
                population{k}(i).F(population{k}(i).F > 1) = 1;

                uCR = MCR{k}(idx);
                population{k}(i).CR = normrnd(uCR, 0.1);
                population{k}(i).CR(population{k}(i).CR > 1) = 1;
                population{k}(i).CR(population{k}(i).CR < 0) = 0;
            end

            [offspring, flag] = Algo.Generation(population{k}, union, population{c}, c_union, RMP(k, c));
            offspring = Algo.Evaluation(offspring, Prob, k);

            replace = [population{k}.Obj] > [offspring.Obj];

            % calculate SF SCR
            SF = [population{k}(replace).F];
            SCR = [population{k}(replace).CR];
            dif = abs([population{k}(replace).Obj] - [offspring(replace).Obj]);
            dif = dif ./ sum(dif);

            % update MF MCR
            if ~isempty(SF)
                MF{k}(Hidx(k)) = sum(dif .* (SF.^2)) / sum(dif .* SF);
                MCR{k}(Hidx(k)) = sum(dif .* SCR);
            else
                MF{k}(Hidx(k)) = MF{k}(mod(Hidx(k) + Algo.H - 2, Algo.H) + 1);
                MCR{k}(Hidx(k)) = MCR{k}(mod(Hidx(k) + Algo.H - 2, Algo.H) + 1);
            end
            Hidx(k) = mod(Hidx(k), Algo.H) + 1;

            Obj_old = [population{k}.Obj];
            population{k}(replace) = offspring(replace);
            Obj_new = [population{k}.Obj];

            % update archive
            archive{k} = [archive{k}, population{k}(replace)];
            % Linear Population Size Reduction
            for t = 1:Prob.T
                if length(archive{t}) > Prob.N
                    archive{t} = archive{t}(randperm(length(archive{t}), Prob.N));
                end
                if length(population{t}) > Prob.N
                    [~, rank] = sort([population{t}.Obj]);
                    population{t} = population{t}(rank(1:Prob.N));
                end
            end

            % calculate the reward
            R_p = max((Obj_old - Obj_new) ./ (Obj_old), 0);
            best_g = [Algo.Best{:}];
            R_b = max((min([best_g.Obj]) - min(Obj_new)) / min([best_g.Obj]), 0);
            % The main task
            HR(k, HR_idx(k)) = Algo.Alpha * R_b + (1 - Algo.Alpha) * (sum(R_p) / length(R_p));
            % The communicate task
            index = find(flag == 1);
            if ~isempty(index)
                [~, minid] = min(Obj_new);
                HR(c, HR_idx(c)) = Algo.Alpha * (flag(minid) == 1) * R_b + (1 - Algo.Alpha) * (sum(R_p(index)) / length(index));
            else
                HR(c, HR_idx(c)) = 0;
            end

            % adaptive RMP
            if HR(c, HR_idx(c)) >= HR(k, HR_idx(k))
                RMP(k, c) = min(RMP(k, c) + delta_rmp, 1);
            elseif HR(c, HR_idx(c)) < HR(k, HR_idx(k))
                RMP(k, c) = max(RMP(k, c) - delta_rmp, 0);
            end
            HR_idx(k) = mod(HR_idx(k), Algo.RH) + 1;
            HR_idx(c) = mod(HR_idx(c), Algo.RH) + 1;
        end
    end

    function [offspring, flag] = Generation(Algo, population, union, c_pop, c_union, RMP)
        % get top 100p% individuals
        [~, rank] = sort([population.Obj]);
        pop_pbest = rank(1:max(round(Algo.P * length(population)), 1));
        [~, rank] = sort([c_pop.Obj]);
        c_pop_pbest = rank(1:max(round(Algo.P * length(c_pop)), 1));

        flag = zeros(1, length(population));
        for i = 1:length(population)
            offspring(i) = population(i);

            if rand() < RMP
                c_pbest = c_pop_pbest(randi(length(c_pop_pbest)));
                x1 = randi(length(c_pop));
                while x1 == c_pbest
                    x1 = randi(length(c_pop));
                end
                x2 = randi(length(c_union));
                while x2 == x1 || x2 == c_pbest
                    x2 = randi(length(c_union));
                end

                offspring(i).Dec = population(i).Dec + ...
                    population(i).F * (c_pop(c_pbest).Dec - population(i).Dec) + ...
                    population(i).F * (c_pop(x1).Dec - c_union(x2).Dec);
                offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, population(i).CR);
                flag(i) = 1;
            else
                pbest = pop_pbest(randi(length(pop_pbest)));
                x1 = randi(length(population));
                while x1 == i || x1 == pbest
                    x1 = randi(length(population));
                end
                x2 = randi(length(union));
                while x2 == i || x2 == x1 || x2 == pbest
                    x2 = randi(length(union));
                end

                offspring(i).Dec = population(i).Dec + ...
                    population(i).F * (population(pbest).Dec - population(i).Dec) + ...
                    population(i).F * (population(x1).Dec - union(x2).Dec);
                offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, population(i).CR);
            end

            % offspring(i).Dec(offspring(i).Dec > 1) = 1;
            % offspring(i).Dec(offspring(i).Dec < 0) = 0;

            vio_low = find(offspring(i).Dec < 0);
            offspring(i).Dec(vio_low) = (population(i).Dec(vio_low) + 0) / 2;
            vio_up = find(offspring(i).Dec > 1);
            offspring(i).Dec(vio_up) = (population(i).Dec(vio_up) + 1) / 2;
        end
    end
end
end
