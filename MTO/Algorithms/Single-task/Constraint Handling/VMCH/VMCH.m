classdef VMCH < Algorithm
% <Single-task> <Single-objective> <Constrained>

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
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties (SetAccess = private)
    P = 0.2
    H = 10
    R = 18
    A = 2.1

    EC_Top = 0.2
    EC_Alpha = 0.8
    EC_Cp = 2
    EC_Tc = 0.8
    EC_Tc2 = 0.2
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'P: 100p% top as pbest', num2str(Algo.P), ...
                'H: success memory size', num2str(Algo.H), ...
                'R: multiplier of init pop size', num2str(Algo.R), ...
                'A: archive size', num2str(Algo.A), ...
                'EC_Top', num2str(Algo.EC_Top), ...
                'EC_Alpha', num2str(Algo.EC_Alpha), ...
                'EC_Cp', num2str(Algo.EC_Cp), ...
                'EC_Tc', num2str(Algo.EC_Tc), ...
                'EC_Tc2', num2str(Algo.EC_Tc2)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.P = str2double(Parameter{i}); i = i + 1;
        Algo.H = str2double(Parameter{i}); i = i + 1;
        Algo.EC_Top = str2double(Parameter{i}); i = i + 1;
        Algo.EC_Alpha = str2double(Parameter{i}); i = i + 1;
        Algo.EC_Cp = str2double(Parameter{i}); i = i + 1;
        Algo.EC_Tc = str2double(Parameter{i}); i = i + 1;
        Algo.EC_Tc2 = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialization
        Nmin = 4;
        CHnum = 5;
        STnum = 4;
        n0 = 2;
        delta = 1 / (5 * STnum);
        for t = 1:Prob.T
            Ninit(t) = round(Algo.R .* Prob.D(t));
            population{t} = Initialization_One(Algo, Prob, t, Individual_DE44, Ninit(t));

            n = ceil(Algo.EC_Top * length(population{t}));
            cv_temp = [population{t}.CV];
            [~, idx] = sort(cv_temp);
            Ep{t} = cv_temp(idx(n));
            weight{t} = 1 / CHnum * ones(1, CHnum);
            correctCount{t} = zeros(1, CHnum);

            STRecord{t} = zeros(1, STnum) + n0;
            for k = 1:STnum
                Hidx{t, k} = 1;
                MF{t, k} = 0.5 .* ones(Algo.H, 1);
                MCR{t, k} = 0.5 .* ones(Algo.H, 1);
            end
            archive{t} = Individual_DE44.empty();
        end

        while Algo.notTerminated(Prob)
            for t = 1:Prob.T
                N = round((Nmin - Ninit(t)) / Prob.maxFE * Algo.FE + Ninit(t));
                % Update Epsilon
                fea_percent = sum([population{t}.CV] <= 0) / length(population{t});
                if fea_percent < 1
                    Ep{t} = max([population{t}.CV]);
                end
                if Algo.FE / Prob.maxFE < Algo.EC_Tc
                    if fea_percent < Algo.EC_Alpha
                        Ep{t} = Ep{t} * (1 - Algo.FE / (Prob.maxFE * Algo.EC_Tc))^Algo.EC_Cp;
                    else
                        Ep{t} = 1.1 * max([population{t}.CV]);
                    end
                else
                    Ep{t} = 0;
                end
                if Algo.FE / Prob.maxFE <= Algo.EC_Tc2
                    Ep_t = Ep{t} * ((1 - Algo.FE / (Prob.maxFE * Algo.EC_Tc2))^Algo.EC_Cp);
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

                    idx = randi(Algo.H);
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
                offspring = Algo.Generation(population{t}, union);
                % Evaluation
                offspring = Algo.Evaluation(offspring, Prob, t);

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
                    dif = population{t}(replace & k_idx).CVs' - offspring(replace & k_idx).CVs';
                    dif_obj = population{t}(replace & k_idx).Objs' - offspring(replace & k_idx).Objs';
                    dif_obj(dif_obj < 0) = 0;
                    dif(dif <= 0) = dif_obj(dif <= 0);
                    dif = dif ./ sum(dif);
                    % update MF MCR
                    if ~isempty(SF)
                        MF{t, k}(Hidx{t, k}) = sum(dif .* (SF.^2)) / sum(dif .* SF);
                        MCR{t, k}(Hidx{t, k}) = sum(dif .* SCR);
                    else
                        MF{t, k}(Hidx{t, k}) = MF{t, k}(mod(Hidx{t, k} + Algo.H - 2, Algo.H) + 1);
                        MCR{t, k}(Hidx{t, k}) = MCR{t, k}(mod(Hidx{t, k} + Algo.H - 2, Algo.H) + 1);
                    end
                    Hidx{t, k} = mod(Hidx{t, k}, Algo.H) + 1;
                end

                archive{t} = [archive{t}, population{t}(replace)];
                if length(archive{t}) > round(Algo.A * N)
                    archive{t} = archive{t}(randperm(length(archive{t}), round(Algo.A * N)));
                end

                population{t}(replace) = offspring(replace);

                % Linear Population Size Reduction
                if length(population{t}) > N
                    [~, rank] = sortrows([population{t}.CVs, population{t}.Objs], [1, 2]);
                    population{t} = population{t}(rank(1:N));
                end
            end
        end
    end

    function offspring = Generation(Algo, population, union)
        % get top 100p% individuals
        [~, rank] = sortrows([population.CVs, population.Objs], [1, 2]);
        pop_pbest = rank(1:max(round(Algo.P * length(population)), 1));

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
                    [~, rank_temp] = sortrows([population(idx).CVs, population(idx).Objs], [1, 2]);
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
                    [~, rank_temp] = sortrows([population(idx).CVs, population(idx).Objs], [1, 2]);
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
