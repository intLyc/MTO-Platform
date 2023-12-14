classdef CEDE_DRL < Algorithm
% <Single-task> <Single-objective> <Constrained>

%------------------------------- Reference --------------------------------
% @Article{Hu2023CEDE-DRL,
%   title   = {Deep reinforcement learning assisted co-evolutionary differential evolution for constrained optimization},
%   author  = {Zhenzhen Hu and Wenyin Gong and Witold Pedrycz and Yanchi Li},
%   journal = {Swarm and Evolutionary Computation},
%   year    = {2023},
%   issn    = {2210-6502},
%   pages   = {101387},
%   volume  = {83},
%   doi     = {https://doi.org/10.1016/j.swevo.2023.101387},
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
    Alpha = 0.5
    Pmin = 0.1
    RH = 10
    EC_Top = 0.2
    EC_Cp = 5
    EC_P = 0.8
    DE_Beta = 6
    DE_Alpha = 0.75
    DE_Gama = 30
    DE_P = 0.85
    CO_LP = 0.05
    FP_ch = 1
    EC_ch = 2
    DE_ch = 3
    CO_ch = 4
    P = 0.2
end

methods
    function parameter = getParameter(obj)
        parameter = {'Alpha', num2str(obj.Alpha), ...
                'Pmin', num2str(obj.Pmin), ...
                'RH: Record History', num2str(obj.RH), ...
                'EC_Top', num2str(obj.EC_Top), ...
                'EC_Cp', num2str(obj.EC_Cp), ...
                'EC_P', num2str(obj.EC_P), ...
                'DE_Beta', num2str(obj.DE_Beta), ...
                'DE_Gama', num2str(obj.DE_Gama), ...
                'DE_P', num2str(obj.DE_P), ...
                'CO_LP', num2str(obj.CO_LP)};
    end

    function obj = setParameter(obj, parameter_cell)
        count = 1;
        obj.Alpha = str2double(parameter_cell{count}); count = count + 1;
        obj.Pmin = str2double(parameter_cell{count}); count = count + 1;
        obj.RH = str2double(parameter_cell{count}); count = count + 1;
        obj.EC_Top = str2double(parameter_cell{count}); count = count + 1;
        obj.EC_Cp = str2double(parameter_cell{count}); count = count + 1;
        obj.EC_P = str2double(parameter_cell{count}); count = count + 1;
        obj.DE_Gama = str2double(parameter_cell{count}); count = count + 1;
        obj.DE_P = str2double(parameter_cell{count}); count = count + 1;
        obj.CO_LP = str2double(parameter_cell{count}); count = count + 1;
    end

    function run(obj, Prob)
        CHNum = 4;
        % Initialization
        population_temp = Initialization(obj, Prob, Individual_DE44);
        for ch = 1:CHNum
            population(:, ch) = population_temp;
        end
        STNum = 3;
        n0 = 3;
        delta = 1 / (5 * STNum);
        for t = 1:Prob.T
            STRecord{t} = zeros(1, STNum) + n0;
            for ch = 1:CHNum
                archive{t, ch} = Individual_DE44.empty();
            end

            % initialize parameters of Epsilon Constraint
            n = ceil(obj.EC_Top * length(population{t, obj.EC_ch}));
            cv_temp = [population{t, obj.EC_ch}.CV];
            [~, idx] = sort(cv_temp);
            Ep0{t} = cv_temp(idx(n));
            EC_X{t} = 0;
            % initialize parameters of DeCO
            VAR0{t} = min(10^(Prob.D(t) / 2), max([population{t, obj.DE_ch}.CV]));
            DE_Cp{t} = (-log(VAR0{t}) - obj.DE_Beta) / log(1 - obj.DE_P);
            pmax{t} = 1;
            DE_X{t} = 0;
            % initialize parameters of COR
            CO_Flag{t} = false;
            CO_archive{t} = population{t, obj.CO_ch};
            CO_X{t} = 0;
            CO_Idx{t} = 0;
            Div_Delta{t} = 0;
            p = reshape([population{t, obj.CO_ch}.Dec], length(population{t, obj.CO_ch}(1).Dec), length(population{t, obj.CO_ch}))';
            Div_Init{t} = sum(std(p)) / size(p, 2);
            Div_Idx{t} = Div_Init{t};
            betterRecord1{t} = [];
            betterRecord2{t} = [];

            % initialize parameters of ECMT
            HR{t} = 0 * ones(CHNum, obj.RH); % History Record
            HRIdx{t} = ones(1, CHNum);
            CHPro{t}(1, :) = 1 / CHNum * ones(1, CHNum);
        end
        % initialize parameters of DQN
        Data = [];
        num_task = 4; %action number
        %learning = 0.4;
        model_built = 0;
        count = 0;
        greedy = 0.9;
        gama = 0.9;

        while obj.notTerminated(Prob)
            for t = 1:Prob.T

                if obj.Gen <= 2000
                    % random select at the first 2000 generations
                    action = randi(num_task);
                else
                    % choose an action based on the trained net

                    if ~model_built
                        % build model here
                        tr_x = Data(:, 1:4);
                        [tr_xx, ps] = mapminmax(tr_x'); tr_xx = tr_xx';
                        tr_y = Data(:, 5:8);
                        [tr_yy, qs] = mapminmax(tr_y'); tr_yy = tr_yy';
                        Params.ps = ps; Params.qs = qs;
                        [net, Params] = trainmodel(tr_xx, tr_yy, Params);
                        model_built = 1;
                        action = randi(num_task);
                    else
                        % use the model to choose action
                        if rand > greedy
                            action = randi(num_task);
                        else
                            test_x1 = [average_f, average_cv, d, 1];
                            test_x2 = [average_f, average_cv, d, 2];
                            test_x3 = [average_f, average_cv, d, 3];
                            test_x4 = [average_f, average_cv, d, 4];
                            ps = Params.ps; qs = Params.qs;
                            x1 = mapminmax('apply', test_x1', ps); x1 = x1';
                            x2 = mapminmax('apply', test_x2', ps); x2 = x2';
                            x3 = mapminmax('apply', test_x3', ps); x3 = x3';
                            x4 = mapminmax('apply', test_x4', ps); x4 = x4';
                            succ1 = testNet(x1, net, Params);
                            succ1 = mapminmax('reverse', succ1', qs); succ1 = succ1';
                            succ2 = testNet(x2, net, Params);
                            succ2 = mapminmax('reverse', succ2', qs); succ2 = succ2';
                            succ3 = testNet(x3, net, Params);
                            succ3 = mapminmax('reverse', succ3', qs); succ3 = succ3';
                            succ4 = testNet(x4, net, Params);
                            succ4 = mapminmax('reverse', succ4', qs); succ4 = succ4';
                            succ = [succ1; succ2; succ3; succ4];
                            [~, action] = max(succ(:, 1));

                        end
                    end
                end
                current_at = action; %action
                ch_k = current_at; % DQN choose strategy ch_k = DQN()

                % update parameters of Epsilon Constraint
                if obj.FE < obj.EC_P * Prob.maxFE
                    Ep = Ep0{t} * (1 - EC_X{t})^obj.EC_Cp;
                else
                    Ep = 0;
                end
                EC_X{t} = EC_X{t} + Prob.N / (Prob.maxFE / Prob.T);
                % update parameters of DeCO
                if DE_X{t} < obj.DE_P
                    VAR = VAR0{t} * (1 - DE_X{t})^DE_Cp{t};
                else
                    VAR = 0;
                end
                DE_X{t} = DE_X{t} + Prob.N / (Prob.maxFE / Prob.T);
                if length(find([population{t, obj.DE_ch}.CV] == 0)) > 0.85 * length(population{t, obj.DE_ch})
                    VAR = 0;
                end
                population{t, obj.DE_ch} = population{t, obj.DE_ch}(randperm(length(population{t, obj.DE_ch})));
                if isempty(find([population{t, obj.DE_ch}.CV] < VAR))
                    pmax{t} = 1e-18;
                end
                pr = max(1e-18, pmax{t} / (1 + exp(obj.DE_Gama * (obj.FE / Prob.maxFE - obj.DE_Alpha))));

                DE_weights = 0:pr / length(population{t, obj.DE_ch}):pr - pr / length(population{t, obj.DE_ch});
                DE_weights(randperm(length(DE_weights))) = DE_weights;

                % update parameters of COR
                if obj.FE < obj.CO_LP * Prob.maxFE
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
                CO_weights = WeightGenerator(length(population{t, obj.CO_ch}), [population{t, obj.CO_ch}.CV], [population{t, obj.CO_ch}.Obj], CO_X{t}, CO_Idx{t}, Div_Delta{t}, CO_stage);

                parent = population{t, ch_k};

                if min(STRecord{t} / sum(STRecord{t})) < delta %Selection of mutation strategies based on success rates
                    STRecord{t} = zeros(1, STNum) + n0;
                end
                % Offspring Generation
                union = [parent, archive{t, ch_k}];
                offspring = obj.Generation(parent, union, STRecord{t}, ch_k, Ep, DE_weights, CO_weights);
                [offspring, reward_global] = obj.Evaluation(offspring, Prob, t);

                % calculate Reward
                [~, reward_pop] = Selection_Tournament(population{t, ch_k}, offspring);
                bettersum = sum(reward_pop) / length(population{t});
                R = bettersum;

                % Distributability among populations
                Pop = population{t};
                for i = 1:length(Pop)
                    X(i, :) = (Prob.Ub{t} - Prob.Lb{t}) .* Pop(i).Dec(1:Prob.D(t)) + Prob.Lb{t};
                end
                d = obj.distance(X);

                %Distributability among populations
                Pop1 = offspring;
                for i = 1:length(Pop1)
                    X1(i, :) = (Prob.Ub{t} - Prob.Lb{t}) .* Pop1(i).Dec(1:Prob.D(t)) + Prob.Lb{t};
                end
                d1 = obj.distance(X1);
                %update State = (average fitness, average conV)
                average_f = sum([population{t, ch_k}.Obj]) / length(population{t, ch_k});
                average_cv = sum([population{t, ch_k}.CV]) / length(population{t, ch_k});
                average_f1 = sum([offspring.Obj]) / length(offspring);
                average_cv1 = sum([offspring.CV]) / length(offspring);
                current_record = [average_f average_cv current_at d R average_f1 average_cv1 d1]; % current_record = [s,current_at,reward ,s1];
                Data = [Data; current_record];
                if size(Data, 1) > 2000
                    Data(end, :) = [];
                end
                %   State_pop =   trial_State;

                % calculate strategy reward
                [~, replace_fp] = Selection_Tournament(parent, offspring);
                is_used = hist([offspring(replace_fp).ST], 1:STNum);
                STRecord{t} = STRecord{t} + is_used;

                % Population Replacement
                for ch = 1:CHNum
                    % Selection
                    Obj = [[population{t, ch}.Obj], [offspring.Obj]];
                    CV = [[population{t, ch}.CV], [offspring.CV]];
                    normal_Obj = (Obj - min(Obj)) ./ (std(Obj) + eps(0));
                    normal_CV = (CV - min(CV)) ./ (std(CV) + eps(0));
                    replace = false(1, length(population{t, ch}));
                    for i = 1:length(population{t, ch})
                        switch ch
                            case obj.FP_ch % Feasible Priority
                                obj_pair = [Obj(i), Obj(i + end / 2)];
                                cv_pair = [CV(i), CV(i + end / 2)];
                                flag = sort_FP(obj_pair, cv_pair);
                            case obj.EC_ch % Epsilon Constraint
                                obj_pair = [Obj(i), Obj(i + end / 2)];
                                cv_pair = [CV(i), CV(i + end / 2)];
                                flag = sort_EC(obj_pair, cv_pair, Ep);
                            case obj.DE_ch % DeCO
                                obj_pair = [normal_Obj(i), normal_Obj(i + end / 2)];
                                cv_pair = [normal_CV(i), normal_CV(i + end / 2)];
                                fit = DE_weights(i) .* obj_pair + (1 - DE_weights(i)) .* cv_pair;
                                [~, flag] = sort(fit);
                            case obj.CO_ch % COR
                                obj_pair = [normal_Obj(i), normal_Obj(i + end / 2)];
                                cv_pair = [normal_CV(i), normal_CV(i + end / 2)];
                                fit = CO_weights(i) .* obj_pair + (1 - CO_weights(i)) .* cv_pair;
                                [~, flag] = sort(fit);
                        end
                        replace(i) = (flag(1) ~= 1);
                    end
                    archive{t, ch} = [archive{t, ch}, population{t, ch}(replace)];
                    if length(archive{t, ch}) > Prob.N
                        archive{t, ch} = archive{t, ch}(randperm(length(archive{t, ch}), Prob.N));
                    end
                    population{t, ch}(replace) = offspring(replace);

                    % calculate parameters of COR
                    if ch == obj.CO_ch && obj.FE < obj.CO_LP * Prob.maxFE
                        % archive select
                        CO_archive{t} = Selection_Tournament(CO_archive{t}, offspring);
                        [con_obj_betterNum, obj_con_betterNum] = InterCompare([CO_archive{t}.Obj], [CO_archive{t}.CV], [population{t, obj.CO_ch}.Obj], [population{t, obj.CO_ch}.CV]);
                        p = reshape([population{t, obj.CO_ch}.Dec], length(population{t, obj.CO_ch}(1).Dec), length(population{t, obj.CO_ch}))';
                        Div_Idx{t} = sum(std(p)) / size(p, 2);
                        betterRecord1{t} = [betterRecord1{t}, con_obj_betterNum];
                        betterRecord2{t} = [betterRecord2{t}, obj_con_betterNum];
                    end
                end

                Rb = reward_global;
                Rp = reward_pop;
                HR{t}(ch_k, HRIdx{t}(ch_k)) = obj.Alpha * Rb + (1 - obj.Alpha) * mean(Rp);
                HRIdx{t}(ch_k) = mod(HRIdx{t}(ch_k), obj.RH) + 1;
                %      end

                %% update net model every 500 generations
                if model_built
                    count = count + 1;
                    if count > 500
                        % update model here
                        qs = Params.qs;
                        tr_x = Data(:, 1:4);
                        [tr_xx, ps] = mapminmax(tr_x'); tr_xx = tr_xx';
                        succ1 = testNet(tr_xx, net, Params);
                        succ1 = mapminmax('reverse', succ1', qs); succ1 = succ1';
                        succ = succ1(:, 1);
                        tr_yy = Data(:, 5) + gama * max(succ);
                        [tr_yy, qs] = mapminmax(tr_yy'); tr_yy = tr_yy';
                        Params.ps = ps; Params.qs = qs;
                        net = updatemodel(tr_xx, tr_yy, Params, net);
                        count = 0;
                        % train = train + 1
                    end
                end
            end
        end
    end

    function offspring = Generation(obj, population, union, STRecord, ch_k, Ep, DE_wei, CO_wei)
        F_pool = [0.6, 0.8, 1.0];
        CR_pool = [0.1, 0.2, 1.0];
        N = length(population);
        [~, rank_fp] = sortrows([[population.CV]', [population.Obj]'], [1, 2]);

        Obj = [population.Obj]; CV = [population.CV];
        normal_Obj = (Obj - min(Obj)) ./ (std(Obj) + eps(0));
        normal_CV = (CV - min(CV)) ./ (std(CV) + eps(0));

        if ch_k == obj.FP_ch || ch_k == obj.EC_ch
            if ch_k == obj.FP_ch
                Ep = 0;
            end
            % get top 100p% individuals
            rank = sort_EC([population.Obj], [population.CV], Ep);
            pop_pbest = rank(1:max(round(obj.P * length(population)), 1));
        end

        roulette = STRecord / sum(STRecord);
        for i = 1:length(population)
            offspring(i) = population(i);
            F = F_pool(randi(length(F_pool)));
            CR = CR_pool(randi(length(CR_pool)));

            roulette_temp = roulette;
            roulette_temp = roulette_temp / sum(roulette_temp);

            % Stragety Roulette Selection
            r = rand();
            for st = 1:length(roulette_temp)
                if r <= sum(roulette_temp(1:st))
                    st_k = st;
                    break;
                end
            end
            offspring(i).ST = st_k;
            switch st_k
                case 1 % current-to-pbest
                    if ch_k == obj.DE_ch
                        fit = DE_wei(i) * normal_Obj + (1 - DE_wei(i)) * normal_CV;
                        [~, rank] = sort(fit);
                        pop_pbest = rank(1:max(round(obj.P * length(population)), 1));
                    elseif ch_k == obj.CO_ch
                        fit = CO_wei(i) * normal_Obj + (1 - CO_wei(i)) * normal_CV;
                        [~, rank] = sort(fit);
                        pop_pbest = rank(1:max(round(obj.P * length(population)), 1));
                    end
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
                        F * (population(pbest).Dec - population(i).Dec) + ...
                        F * (population(x1).Dec - union(x2).Dec);
                    offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, CR);

                case 2 % randrl + bin
                    A = randperm(length(population), 4);
                    A(A == i) = []; idx = A(1:3);
                    [~, rank_temp] = sortrows([[population(idx).CV]', [population(idx).Obj]'], [1, 2]);
                    x1 = idx(rank_temp(1));
                    if rand < 0.5
                        x2 = idx(rank_temp(2)); x3 = idx(rank_temp(3));
                    else
                        x3 = idx(rank_temp(3)); x2 = idx(rank_temp(2));
                    end
                    offspring(i).Dec = population(x1).Dec + F * (population(x2).Dec - population(x3).Dec);
                    offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, CR);

                case 3
                    % rand-to-pbest
                    if ch_k == obj.DE_ch
                        fit = DE_wei(i) * normal_Obj + (1 - DE_wei(i)) * normal_CV;
                        [~, rank] = sort(fit);
                        pop_pbest = rank(1:max(round(obj.P * length(population)), 1));
                    elseif ch_k == obj.CO_ch
                        fit = CO_wei(i) * normal_Obj + (1 - CO_wei(i)) * normal_CV;
                        [~, rank] = sort(fit);
                        pop_pbest = rank(1:max(round(obj.P * length(population)), 1));
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

    %calcaulate the distance
    function [f] = distance(obj, ModelX)
        popsize = size(ModelX, 1);
        f = 0;
        for ii = 1:popsize
            Nap = ModelX(ii, :);
            D = 0;
            for i = 1:size(ModelX, 1)
                d = norm(Nap - ModelX(i, :));
                %D=[D;d];
                D = D + d;
            end
            %f=min(D);
            f = f + D;
        end
        f = f / (popsize * (popsize - 1));
    end

    function OffDec = DE_Crossover_Exp(OffDec, ParDec, CR)
        D = length(OffDec);
        L = 1 + fix(length(OffDec) * rand());
        replace = L;
        position = L;
        while rand() < CR && length(replace) < D
            position = position + 1;
            if position <= D
                replace(end + 1) = position;
            else
                replace(end + 1) = mod(position, D);
            end
        end
        Dec_temp = ParDec;
        Dec_temp(replace) = OffDec(replace);
        OffDec = Dec_temp;
    end

end
end
