classdef VMCH_LSHADE44 < Algorithm
    % <ST-SO> <Constrained>

    %------------------------------- Reference --------------------------------
    % @Article{Wu2022VMCH,
    %   author   = {Wu, Guohua and Wen, Xupeng and Wang, Ling and Pedrycz, Witold and Suganthan, Ponnuthurai Nagaratnam},
    %   journal  = {IEEE Transactions on Evolutionary Computation},
    %   title    = {A Voting-Mechanism-Based Ensemble Framework for Constraint Handling Techniques},
    %   year     = {2022},
    %   number   = {4},
    %   pages    = {646-660},
    %   volume   = {26},
    %   doi      = {10.1109/TEVC.2021.3110130},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        P = 0.2
        H = 10

        EC_Top = 0.2
        EC_Alpha = 0.8
        EC_Cp = 2
        EC_Tc = 0.8
        EC_Tcc = 5
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'P: 100p% top as pbest', num2str(obj.P), ...
                        'H: success memory size', num2str(obj.H), ...
                        'EC_Top', num2str(obj.EC_Top), ...
                        'EC_Alpha', num2str(obj.EC_Alpha), ...
                        'EC_Cp', num2str(obj.EC_Cp), ...
                        'EC_Tc', num2str(obj.EC_Tc), ...
                        'EC_Tcc', num2str(obj.EC_Tcc)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.P = str2double(Parameter{i}); i = i + 1;
            obj.H = str2double(Parameter{i}); i = i + 1;
            obj.EC_Top = str2double(Parameter{i}); i = i + 1;
            obj.EC_Alpha = str2double(Parameter{i}); i = i + 1;
            obj.EC_Cp = str2double(Parameter{i}); i = i + 1;
            obj.EC_Tc = str2double(Parameter{i}); i = i + 1;
            obj.EC_Tcc = str2double(Parameter{i}); i = i + 1;
        end

        function run(obj, Prob)
            % Initialization
            population = Initialization(obj, Prob, Individual_DE44);
            Nmin = 4;
            % initialize Parameter
            CHnum = 5;
            STnum = 4;
            n0 = 2;
            delta = 1 / (5 * STnum);
            for t = 1:Prob.T
                % initialize Parameter
                n = ceil(obj.EC_Top * length(population{t}));
                cv_temp = [population{t}.CV];
                [~, idx] = sort(cv_temp);
                Ep{t} = cv_temp(idx(n));
                weight{t} = 1 / CHnum * ones(1, CHnum);
                correctCount{t} = zeros(1, CHnum);

                STRecord{t} = zeros(1, STnum) + n0;
                for k = 1:STnum
                    Hidx{t, k} = 1;
                    MF{t, k} = 0.5 .* ones(obj.H, 1);
                    MCR{t, k} = 0.5 .* ones(obj.H, 1);
                end
                archive{t} = Individual_DE44.empty();
            end

            while obj.notTerminated(Prob)
                N = round((Nmin - Prob.N) / Prob.maxFE * obj.FE + Prob.N);
                for t = 1:Prob.T
                    % Update Epsilon
                    fea_percent = sum([population{t}.CV] <= 0) / length(population{t});
                    if fea_percent < 1
                        Ep{t} = max([population{t}.CV]);
                    end
                    if obj.FE / (Prob.maxFE / Prob.T) < obj.EC_Tc
                        if fea_percent < obj.EC_Alpha
                            Ep{t} = Ep{t} * (1 - obj.FE / ((Prob.maxFE / Prob.T) * obj.EC_Tc))^obj.EC_Cp;
                        else
                            Ep{t} = 1.1 * max([population{t}.CV]);
                        end
                    else
                        Ep{t} = 0;
                    end
                    if obj.Gen <= obj.EC_Tcc
                        Ep_t = Ep{t} * ((1 - obj.Gen / obj.EC_Tcc)^obj.EC_Cp);
                    else
                        Ep_t = 0;
                    end

                    % Calculate individual F and CR and ST
                    roulette = STRecord{t} / sum(STRecord{t});
                    for i = 1:length(population{t})
                        % Stragety Roulette Selection
                        r = rand();
                        for k = 1:STnum
                            if r <= sum(roulette(1:k))
                                st = k;
                                break;
                            end
                        end
                        if min(roulette) < delta
                            STRecord{t} = zeros(1, STnum) + n0;
                            roulette = STRecord{t} / sum(STRecord{t});
                        end
                        population{t}(i).ST = st;

                        idx = randi(obj.H);
                        uF = MF{t, st}(idx);
                        population{t}(i).F = uF + 0.1 * tan(pi * (rand() - 0.5));
                        while (population{t}(i).F <= 0)
                            population{t}(i).F = uF + 0.1 * tan(pi * (rand() - 0.5));
                        end
                        population{t}(i).F(population{t}(i).F > 1) = 1;

                        uCR = MCR{t, st}(idx);
                        population{t}(i).CR = normrnd(uCR, 0.1);
                        population{t}(i).CR(population{t}(i).CR > 1) = 1;
                        population{t}(i).CR(population{t}(i).CR < 0) = 0;
                    end

                    % Generation
                    union = [population{t}, archive{t}];
                    offspring = obj.Generation(population{t}, union);
                    % Evaluation
                    offspring = obj.Evaluation(offspring, Prob, t);

                    % Selection with Vote-Mechanism
                    replace = false(1, length(population{t}));
                    for i = 1:length(population{t})
                        Q_p = 0; Q_o = 0;
                        obj_pair = [population{t}(i).Obj, offspring(i).Obj];
                        cv_pair = [population{t}(i).CV, offspring(i).CV];

                        % Feasible Priority
                        temp = sort_FP(obj_pair, cv_pair);
                        flag(1) = temp(1) ~= 1;
                        if flag(1)
                            Q_o = Q_o + 1 * weight{t}(1);
                        else
                            Q_p = Q_p + 1 * weight{t}(1);
                        end

                        % Self-adaptive Penalty 1
                        obj_temp = [[population{t}.Obj], offspring(i).Obj];
                        cv_temp = [[population{t}.CV], offspring(i).CV];
                        f = cal_SP(obj_temp, cv_temp, 1);
                        if f(i) > f(end)
                            flag(2) = true;
                            Q_o = Q_o + 1 * weight{t}(2);
                        else
                            flag(2) = false;
                            Q_p = Q_p + 1 * weight{t}(2);
                        end

                        % Self-adaptive Penalty 2
                        obj_temp = [[population{t}.Obj], offspring(i).Obj];
                        cv_temp = [[population{t}.CV], offspring(i).CV];
                        f = cal_SP(obj_temp, cv_temp, 2);
                        if f(i) > f(end)
                            flag(3) = true;
                            Q_o = Q_o + 1 * weight{t}(3);
                        else
                            flag(3) = false;
                            Q_p = Q_p + 1 * weight{t}(3);
                        end

                        % Epsilon Constraint 1
                        temp = sort_EC(obj_pair, cv_pair, Ep_t);
                        flag(4) = temp(1) ~= 1;
                        if flag(4)
                            Q_o = Q_o + 1 * weight{t}(4);
                        else
                            Q_p = Q_p + 1 * weight{t}(4);
                        end

                        % Epsilon Constraint 2
                        temp = sort_EC(obj_pair, cv_pair, Ep{t});
                        flag(5) = temp(1) ~= 1;
                        if flag(5)
                            Q_o = Q_o + 1 * weight{t}(5);
                        else
                            Q_p = Q_p + 1 * weight{t}(5);
                        end

                        if (Q_p <= Q_o)
                            replace(i) = true;
                            for ch = 1:CHnum
                                if flag(ch) == true
                                    correctCount{t}(ch) = correctCount{t}(ch) + 1;
                                end
                            end
                        else
                            for ch = 1:CHnum
                                if flag(ch) == false
                                    correctCount{t}(ch) = correctCount{t}(ch) + 1;
                                end
                            end
                        end
                    end

                    %Contributions
                    sumVote = sum(correctCount{t}, 2);
                    weight{t} = correctCount{t} / sumVote;
                    weight{t}(weight{t} < 0.01) = 0.01;

                    % Calculate SF SCR
                    is_used = hist([population{t}(replace).ST], 1:STnum);
                    STRecord{t} = STRecord{t} + is_used;
                    for k = 1:STnum
                        k_idx = [population{t}.ST] == k;
                        SF = [population{t}(replace & k_idx).F];
                        SCR = [population{t}(replace & k_idx).CR];
                        dif = [population{t}(replace & k_idx).CV] - [offspring(replace & k_idx).CV];
                        dif_obj = [population{t}(replace & k_idx).Obj] - [offspring(replace & k_idx).Obj];
                        dif_obj(dif_obj < 0) = 0;
                        dif(dif <= 0) = dif_obj(dif <= 0);
                        dif = dif ./ sum(dif);
                        % update MF MCR
                        if ~isempty(SF)
                            MF{t, k}(Hidx{t, k}) = sum(dif .* (SF.^2)) / sum(dif .* SF);
                            MCR{t, k}(Hidx{t, k}) = sum(dif .* SCR);
                        else
                            MF{t, k}(Hidx{t, k}) = MF{t, k}(mod(Hidx{t, k} + obj.H - 2, obj.H) + 1);
                            MCR{t, k}(Hidx{t, k}) = MCR{t, k}(mod(Hidx{t, k} + obj.H - 2, obj.H) + 1);
                        end
                        Hidx{t, k} = mod(Hidx{t, k}, obj.H) + 1;
                    end

                    archive{t} = [archive{t}, population{t}(replace)];
                    if length(archive{t}) > N
                        archive{t} = archive{t}(randperm(length(archive{t}), N));
                    end

                    population{t}(replace) = offspring(replace);

                    % Linear Population Size Reduction
                    if length(population{t}) > N
                        [~, rank] = sortrows([[population{t}.CV]', [population{t}.Obj]'], [1, 2]);
                        population{t} = population{t}(rank(1:N));
                    end
                end
            end
        end

        function offspring = Generation(obj, population, union)
            % get top 100p% individuals
            [~, rank] = sortrows([[population.CV]', [population.Obj]'], [1, 2]);
            pop_pbest = rank(1:max(round(obj.P * length(population)), 1));

            for i = 1:length(population)
                offspring(i) = population(i);

                switch population(i).ST
                    case 1 % pbest + bin
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
                    case 2 % pbest + exp
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
                        offspring(i).Dec = DE_Crossover_Exp(offspring(i).Dec, population(i).Dec, population(i).CR);
                    case 3 % randrl + bin
                        A = randperm(length(population), 4);
                        A(A == i) = []; idx = A(1:3);
                        [~, rank_temp] = sortrows([[population(idx).CV]', [population(idx).Obj]'], [1, 2]);
                        x1 = idx(rank_temp(1));
                        if rand < 0.5
                            x2 = idx(rank_temp(2)); x3 = idx(rank_temp(3));
                        else
                            x3 = idx(rank_temp(3)); x2 = idx(rank_temp(2));
                        end
                        offspring(i).Dec = population(x1).Dec + population(i).F * (population(x2).Dec - population(x3).Dec);
                        offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, population(i).CR);

                    case 4 % randrl + exp
                        A = randperm(length(population), 4);
                        A(A == i) = []; idx = A(1:3);
                        [~, rank_temp] = sortrows([[population(idx).CV]', [population(idx).Obj]'], [1, 2]);
                        x1 = idx(rank_temp(1));
                        if rand < 0.5
                            x2 = idx(rank_temp(2)); x3 = idx(rank_temp(3));
                        else
                            x3 = idx(rank_temp(3)); x2 = idx(rank_temp(2));
                        end
                        offspring(i).Dec = population(x1).Dec + population(i).F * (population(x2).Dec - population(x3).Dec);
                        offspring(i).Dec = DE_Crossover_Exp(offspring(i).Dec, population(i).Dec, population(i).CR);
                end

                offspring(i).Dec(offspring(i).Dec > 1) = 1;
                offspring(i).Dec(offspring(i).Dec < 0) = 0;

                % vio_low = find(offspring(i).Dec < 0);
                % offspring(i).Dec(vio_low) = (population(i).Dec(vio_low) + 0) / 2;
                % vio_up = find(offspring(i).Dec > 1);
                % offspring(i).Dec(vio_up) = (population(i).Dec(vio_up) + 1) / 2;
            end
        end
    end
end
