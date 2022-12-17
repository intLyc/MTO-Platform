classdef LSHADE44 < Algorithm
% <Single-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @InProceedings{Polakova2017LSHADE44,
%   title     = {L-shade with Competing Strategies Applied to Constrained Optimization},
%   author    = {Poláková, Radka},
%   booktitle = {2017 IEEE Congress on Evolutionary Computation (CEC)},
%   year      = {2017},
%   pages     = {1683-1689},
%   doi       = {10.1109/CEC.2017.7969504},
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
    R = 18
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'P: 100p% top as pbest', num2str(Algo.P), ...
                'H: success memory size', num2str(Algo.H), ...
                'R: multiplier of init pop size', num2str(Algo.R)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.P = str2double(Parameter{i}); i = i + 1;
        Algo.H = str2double(Parameter{i}); i = i + 1;
        Algo.R = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialization
        population = Initialization(Algo, Prob, Individual_DE44);
        Nmin = 4;
        % initialize Parameter
        STNum = 4;
        n0 = 2;
        delta = 1 / (5 * STNum);
        for t = 1:Prob.T
            Ninit(t) = round(Algo.R .* Prob.D(t));
            STRecord{t} = zeros(1, STNum) + n0;
            for k = 1:STNum
                Hidx{t, k} = 1;
                MF{t, k} = 0.5 .* ones(Algo.H, 1);
                MCR{t, k} = 0.5 .* ones(Algo.H, 1);
            end
            archive{t} = Individual_DE44.empty();
        end

        while Algo.notTerminated(Prob)
            for t = 1:Prob.T
                N = round((Nmin - Ninit(t)) / Prob.maxFE * Algo.FE + Ninit(t));
                % Calculate individual F and CR and ST
                roulette = STRecord{t} / sum(STRecord{t});
                for i = 1:length(population{t})
                    % Stragety Roulette Selection
                    r = rand();
                    for k = 1:STNum
                        if r <= sum(roulette(1:k))
                            st = k;
                            break;
                        end
                    end
                    if min(roulette) < delta
                        STRecord{t} = zeros(1, STNum) + n0;
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
                % Selection
                [~, replace] = Selection_Tournament(population{t}, offspring);

                % Calculate SF SCR
                is_used = hist([population{t}(replace).ST], 1:STNum);
                STRecord{t} = STRecord{t} + is_used;
                for k = 1:STNum
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
                if length(archive{t}) > N
                    archive{t} = archive{t}(randperm(length(archive{t}), N));
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
