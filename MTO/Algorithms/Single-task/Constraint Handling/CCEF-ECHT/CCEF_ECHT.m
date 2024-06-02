classdef CCEF_ECHT < Algorithm
% <Single-task> <Single-objective> <Constrained>

%------------------------------- Reference --------------------------------
% @Article{Li2023CCEF-ECHT,
%   title    = {A Competitive and Cooperative Evolutionary Framework for Ensemble of Constraint Handling Techniques},
%   author   = {Li, Yanchi and Gong, Wenyin and Hu, Zhenzhen and Li, Shuijia},
%   journal  = {IEEE Transactions on Systems, Man, and Cybernetics: Systems},
%   year     = {2023},
%   doi      = {10.1109/TSMC.2023.3343778},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties (SetAccess = private)
    PR0 = 0.1
    Alpha = 0.5
    Beta = 0.1
    Pmin = 0.1
    RH = 10

    % CHT parameters
    EC_Top = 0.2
    EC_Cp = 5
    EC_P = 0.8
    DE_Beta = 6
    DE_Alpha = 0.75
    DE_Gama = 30
    DE_P = 0.85
    CO_LP = 0.05
    CHNum = 4
    FP_ch = 1
    EC_ch = 2
    DE_ch = 3
    CO_ch = 4

    % DE parameters
    P = 0.2
    STNum = 2
end

methods
    function parameter = getParameter(Algo)
        parameter = {'PR0: Knowledge Absorption Probability', num2str(Algo.PR0), ...
                'Alpha: Proportion of Global and Population', num2str(Algo.Alpha), ...
                'Beta: Competing Start Stage', num2str(Algo.Beta), ...
                'Pmin: Mininum Selection Probability', num2str(Algo.Pmin), ...
                'RH: Record History', num2str(Algo.RH), ...
                'P: Top p-best', num2str(Algo.P)};
    end

    function Algo = setParameter(Algo, parameter_cell)
        count = 1;
        Algo.PR0 = str2double(parameter_cell{count}); count = count + 1;
        Algo.Alpha = str2double(parameter_cell{count}); count = count + 1;
        Algo.Beta = str2double(parameter_cell{count}); count = count + 1;
        Algo.Pmin = str2double(parameter_cell{count}); count = count + 1;
        Algo.RH = str2double(parameter_cell{count}); count = count + 1;
        Algo.P = str2double(parameter_cell{count}); count = count + 1;
    end

    function run(Algo, Prob)
        % Initialization
        population_temp = Initialization(Algo, Prob, Individual_DE44);
        for ch = 1:Algo.CHNum
            population(:, ch) = population_temp;
        end
        n0 = 2;
        delta = 1 / (5 * Algo.STNum);
        for t = 1:Prob.T
            STRecord{t} = zeros(1, Algo.STNum) + n0;
            for ch = 1:Algo.CHNum
                archive{t, ch} = Individual_DE44.empty();
            end

            % Initialize parameters of EC
            n = ceil(Algo.EC_Top * length(population{t, Algo.EC_ch}));
            cv_temp = [population{t, Algo.EC_ch}.CV];
            [~, idx] = sort(cv_temp);
            Ep0{t} = cv_temp(idx(n));
            EC_X{t} = 0;
            % Initialize parameters of DeMO
            VAR0{t} = min(10^(Prob.D(t) / 2), max([population{t, Algo.DE_ch}.CV]));
            DE_Cp{t} = (-log(VAR0{t}) - Algo.DE_Beta) / log(1 - Algo.DE_P);
            pmax{t} = 1;
            DE_X{t} = 0;
            % Initialize parameters of COR
            CO_Flag{t} = false;
            CO_archive{t} = population{t, Algo.CO_ch};
            CO_X{t} = 0;
            CO_Idx{t} = 0;
            Div_Delta{t} = 0;
            p = reshape([population{t, Algo.CO_ch}.Dec], length(population{t, Algo.CO_ch}(1).Dec), length(population{t, Algo.CO_ch}))';
            Div_Init{t} = sum(std(p)) / size(p, 2);
            Div_Idx{t} = Div_Init{t};
            betterRecord1{t} = [];
            betterRecord2{t} = [];

            % Initialize parameters of CCEF
            HR{t} = 0 * ones(Algo.CHNum, Algo.RH); % History Record
            HRIdx{t} = ones(1, Algo.CHNum);
            CHPro{t}(1, :) = 1 / Algo.CHNum * ones(1, Algo.CHNum);
        end

        while Algo.notTerminated(Prob, population(:, 1))
            for t = 1:Prob.T
                % Select a task to evolve
                if Algo.FE <= Algo.Beta * Prob.maxFE % Stage 1: Development
                    CHPro{t}(Algo.Gen, :) = 1 / Algo.CHNum * ones(1, Algo.CHNum);
                else % Stage 2: Competition
                    if sum(HR{t}, 'all') ~= 0
                        CHPro{t}(Algo.Gen, :) = Algo.Pmin / Algo.CHNum + (1 - Algo.Pmin) * sum(HR{t}, 2) ./ max(sum(HR{t}, 'all'));
                        CHPro{t}(Algo.Gen, :) = CHPro{t}(Algo.Gen, :) ./ sum(CHPro{t}(Algo.Gen, :));
                    else
                        CHPro{t}(Algo.Gen, :) = 1 / Algo.CHNum * ones(1, Algo.CHNum);
                    end
                end
                ch_k = RouletteSelection(CHPro{t}(Algo.Gen, :));

                % Update parameters of EC
                if Algo.FE < Algo.EC_P * Prob.maxFE
                    Ep = Ep0{t} * (1 - EC_X{t})^Algo.EC_Cp;
                else
                    Ep = 0;
                end
                EC_X{t} = EC_X{t} + Prob.N / (Prob.maxFE / Prob.T);
                % Update parameters of DeMO
                if DE_X{t} < Algo.DE_P
                    VAR = VAR0{t} * (1 - DE_X{t})^DE_Cp{t};
                else
                    VAR = 0;
                end
                DE_X{t} = DE_X{t} + Prob.N / (Prob.maxFE / Prob.T);
                if length(find([population{t, Algo.DE_ch}.CV] == 0)) > 0.85 * length(population{t, Algo.DE_ch})
                    VAR = 0;
                end
                population{t, Algo.DE_ch} = population{t, Algo.DE_ch}(randperm(length(population{t, Algo.DE_ch})));
                if isempty(find([population{t, Algo.DE_ch}.CV] < VAR))
                    pmax{t} = 1e-18;
                end
                pr = max(1e-18, pmax{t} / (1 + exp(Algo.DE_Gama * (Algo.FE / Prob.maxFE - Algo.DE_Alpha))));
                DE_weights = 0:pr / length(population{t, Algo.DE_ch}):pr - pr / length(population{t, Algo.DE_ch});
                DE_weights(randperm(length(DE_weights))) = DE_weights;
                % Update parameters of COR
                if Algo.FE < Algo.CO_LP * Prob.maxFE
                    CO_stage = 1;
                else
                    CO_stage = 2;
                    CO_X{t} = CO_X{t} + Prob.N / (Prob.maxFE / Prob.T);
                    if ~CO_Flag{t}
                        recordLength = length(betterRecord1{t});
                        betterLength1 = sum(betterRecord1{t} ~= 0);
                        betterLength2 = sum(betterRecord2{t} ~= 0);
                        betterLength = min(betterLength1, betterLength2);
                        CO_Idx{t} = betterLength / recordLength;
                        Div_Delta{t} = Div_Init{t} - Div_Idx{t};
                        CO_Flag{t} = true;
                    end
                end
                CO_weights = WeightGenerator(length(population{t, Algo.CO_ch}), [population{t, Algo.CO_ch}.CV], [population{t, Algo.CO_ch}.Obj], CO_X{t}, CO_Idx{t}, Div_Delta{t}, CO_stage);

                % Parent Reconstruction
                parent = population{t, ch_k};
                HelpCH = 1:Algo.CHNum; HelpCH(HelpCH == ch_k) = [];
                for i = 1:length(parent)
                    if rand() < Algo.PR0
                        ch_help = HelpCH(randi(length(HelpCH)));
                        if (parent(i).CV > population{t, ch_help}(i).CV || ...
                                (parent(i).CV == population{t, ch_help}(i).CV && ...
                                parent(i).Obj > population{t, ch_help}(i).Obj))
                            parent(i) = population{t, ch_help}(i);
                        end
                    end
                end

                if min(STRecord{t} / sum(STRecord{t})) < delta
                    STRecord{t} = zeros(1, Algo.STNum) + n0;
                end
                % Offspring Generation
                union = [parent, archive{t, ch_k}];
                offspring = Algo.Generation(parent, union, STRecord{t}, ch_k, Ep, DE_weights, CO_weights);
                [offspring, reward_global] = Algo.Evaluation(offspring, Prob, t);

                % Calculate pop reward
                [~, reward_pop] = Selection_Tournament(population{t, ch_k}, offspring);

                % Calculate strategy reward
                [~, replace_fp] = Selection_Tournament(parent, offspring);
                is_used = hist([offspring(replace_fp).ST], 1:Algo.STNum);
                STRecord{t} = STRecord{t} + is_used;

                % Offspring Diffusion
                for ch = 1:Algo.CHNum
                    % Selection
                    Obj = [[population{t, ch}.Obj], [offspring.Obj]];
                    CV = [[population{t, ch}.CV], [offspring.CV]];
                    normal_Obj = (Obj - min(Obj)) ./ (std(Obj) + eps(0));
                    normal_CV = (CV - min(CV)) ./ (std(CV) + eps(0));
                    replace = false(1, length(population{t, ch}));
                    for i = 1:length(population{t, ch})
                        switch ch
                            case Algo.FP_ch % FP
                                obj_pair = [Obj(i), Obj(i + end / 2)];
                                cv_pair = [CV(i), CV(i + end / 2)];
                                flag = sort_FP(obj_pair, cv_pair);
                            case Algo.EC_ch % EC
                                obj_pair = [Obj(i), Obj(i + end / 2)];
                                cv_pair = [CV(i), CV(i + end / 2)];
                                flag = sort_EC(obj_pair, cv_pair, Ep);
                            case Algo.DE_ch % DeMO
                                obj_pair = [normal_Obj(i), normal_Obj(i + end / 2)];
                                cv_pair = [normal_CV(i), normal_CV(i + end / 2)];
                                fit = DE_weights(i) .* obj_pair + (1 - DE_weights(i)) .* cv_pair;
                                [~, flag] = sort(fit);
                            case Algo.CO_ch % COR
                                obj_pair = [normal_Obj(i), normal_Obj(i + end / 2)];
                                cv_pair = [normal_CV(i), normal_CV(i + end / 2)];
                                fit = CO_weights(i) .* obj_pair + (1 - CO_weights(i)) .* cv_pair;
                                [~, flag] = sort(fit);
                        end
                        replace(i) = (flag(1) ~= 1);
                    end

                    % Update operator DE archive
                    archive{t, ch} = [archive{t, ch}, population{t, ch}(replace)];
                    if length(archive{t, ch}) > Prob.N
                        archive{t, ch} = archive{t, ch}(randperm(length(archive{t, ch}), Prob.N));
                    end
                    population{t, ch}(replace) = offspring(replace);

                    % Calculate parameters of COR
                    if ch == Algo.CO_ch && Algo.FE < Algo.CO_LP * Prob.maxFE
                        % archive select
                        CO_archive{t} = Selection_Tournament(CO_archive{t}, offspring);
                        [con_obj_betterNum, obj_con_betterNum] = InterCompare([CO_archive{t}.Obj], [CO_archive{t}.CV], [population{t, Algo.CO_ch}.Obj], [population{t, Algo.CO_ch}.CV]);
                        p = reshape([population{t, Algo.CO_ch}.Dec], length(population{t, Algo.CO_ch}(1).Dec), length(population{t, Algo.CO_ch}))';
                        Div_Idx{t} = sum(std(p)) / size(p, 2);
                        betterRecord1{t} = [betterRecord1{t}, con_obj_betterNum];
                        betterRecord2{t} = [betterRecord2{t}, obj_con_betterNum];
                    end
                end

                Rb = reward_global;
                Rp = reward_pop;
                HR{t}(ch_k, HRIdx{t}(ch_k)) = Algo.Alpha * Rb + (1 - Algo.Alpha) * mean(Rp);
                HRIdx{t}(ch_k) = mod(HRIdx{t}(ch_k), Algo.RH) + 1;
            end
        end
    end

    function offspring = Generation(Algo, population, union, STRecord, ch_k, Ep, DE_wei, CO_wei)
        F_pool = [0.6, 0.8, 1.0];
        CR_pool = [0.1, 0.2, 1.0];
        N = length(population);
        [~, rank_fp] = sortrows([[population.CV]', [population.Obj]'], [1, 2]);

        Obj = [population.Obj]; CV = [population.CV];
        normal_Obj = (Obj - min(Obj)) ./ (std(Obj) + eps(0));
        normal_CV = (CV - min(CV)) ./ (std(CV) + eps(0));

        if ch_k == Algo.FP_ch || ch_k == Algo.EC_ch
            if ch_k == Algo.FP_ch
                Ep = 0;
            end
            % get top 100p% individuals
            rank = sort_EC([population.Obj], [population.CV], Ep);
            pop_pbest = rank(1:max(round(Algo.P * length(population)), 1));
        end

        roulette = STRecord / sum(STRecord);
        for i = 1:length(population)
            offspring(i) = population(i);
            F = F_pool(randi(length(F_pool)));
            CR = CR_pool(randi(length(CR_pool)));

            % Heuristic
            roulette_temp = roulette;
            if rank_fp(i) < N * 1/2
                roulette_temp(1) = roulette_temp(1) * 0.9;
                roulette_temp(2) = roulette_temp(2) * 0.1;
            else
                roulette_temp(1) = roulette_temp(1) * 0.1;
                roulette_temp(2) = roulette_temp(2) * 0.9;
            end
            roulette_temp = roulette_temp / sum(roulette_temp);

            offspring(i).ST = RouletteSelection(roulette_temp);
            switch offspring(i).ST
                case 1
                    % current-to-rand
                    x1 = randi(length(population));
                    while x1 == i
                        x1 = randi(length(population));
                    end
                    x2 = randi(length(population));
                    while x2 == i || x2 == x1
                        x2 = randi(length(population));
                    end
                    x3 = randi(length(population));
                    while x3 == i || x3 == x1 || x3 == x2
                        x3 = randi(length(population));
                    end

                    offspring(i).Dec = population(i).Dec + ...
                        rand() * (population(x1).Dec - population(i).Dec) + ...
                        F * (population(x2).Dec - population(x3).Dec);
                case 2
                    % rand-to-pbest
                    if ch_k == Algo.DE_ch
                        fit = DE_wei(i) * normal_Obj + (1 - DE_wei(i)) * normal_CV;
                        [~, rank] = sort(fit);
                        pop_pbest = rank(1:max(round(Algo.P * length(population)), 1));
                    elseif ch_k == Algo.CO_ch
                        fit = CO_wei(i) * normal_Obj + (1 - CO_wei(i)) * normal_CV;
                        [~, rank] = sort(fit);
                        pop_pbest = rank(1:max(round(Algo.P * length(population)), 1));
                    end

                    pbest = pop_pbest(randi(length(pop_pbest)));
                    x1 = randi(length(population));
                    while x1 == i || x1 == pbest
                        x1 = randi(length(population));
                    end
                    x2 = randi(length(population));
                    while x2 == i || x2 == x1 || x2 == pbest
                        x2 = randi(length(population));
                    end
                    x3 = randi(length(union));
                    while x3 == i || x3 == x1 || x3 == x2 || x3 == pbest
                        x3 = randi(length(union));
                    end

                    offspring(i).Dec = population(x1).Dec + ...
                        F * (population(pbest).Dec - population(x1).Dec) + ...
                        F * (population(x2).Dec - union(x3).Dec);
                    offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, CR);
            end

            % CEC20-RWCO
            % offspring(i).Dec(offspring(i).Dec > 1) = 1;
            % offspring(i).Dec(offspring(i).Dec < 0) = 0;

            % CEC06-CSO CEC10-CSO CEC17-CSO
            vio_low = find(offspring(i).Dec < 0);
            if rand() < 0.5
                offspring(i).Dec(vio_low) = 2 * 0 - offspring(i).Dec(vio_low);
                vio_temp = offspring(i).Dec(vio_low) > 1;
                offspring(i).Dec(vio_low(vio_temp)) = 1;
            else
                if rand() < 0.5
                    offspring(i).Dec(vio_low) = 0;
                else
                    offspring(i).Dec(vio_low) = 1;
                end
            end
            vio_up = find(offspring(i).Dec > 1);
            if rand() < 0.5
                offspring(i).Dec(vio_up) = 2 * 1 - offspring(i).Dec(vio_up);
                vio_temp = offspring(i).Dec(vio_up) < 0;
                offspring(i).Dec(vio_up(vio_temp)) = 1;
            else
                if rand() < 0.5
                    offspring(i).Dec(vio_up) = 0;
                else
                    offspring(i).Dec(vio_up) = 1;
                end
            end
        end
    end
end
end
