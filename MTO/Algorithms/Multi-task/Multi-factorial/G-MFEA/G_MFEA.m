classdef G_MFEA < Algorithm
% <Multi-task> <Single-objective> <None>

%------------------------------- Reference --------------------------------
% @Article{Ding2019G-MFEA,
%   title    = {Generalized Multitasking for Evolutionary Optimization of Expensive Problems},
%   author   = {Ding, Jinliang and Yang, Cuie and Jin, Yaochu and Chai, Tianyou},
%   journal  = {IEEE Transactions on Evolutionary Computation},
%   year     = {2019},
%   number   = {1},
%   pages    = {44-58},
%   volume   = {23},
%   doi      = {10.1109/TEVC.2017.2785351},
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
    RMP = 0.3
    MuC = 2
    MuM = 5
    Phi = 0.1
    Theta = 0.02
    Top = 0.4
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'RMP: Random Mating Probability', num2str(Algo.RMP), ...
                'MuC: Simulated Binary Crossover', num2str(Algo.MuC), ...
                'MuM: Polynomial Mutation', num2str(Algo.MuM), ...
                'Phi', num2str(Algo.Phi), ...
                'Theta', num2str(Algo.Theta), ...
                'Top', num2str(Algo.Top)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.RMP = str2double(Parameter{i}); i = i + 1;
        Algo.MuC = str2double(Parameter{i}); i = i + 1;
        Algo.MuM = str2double(Parameter{i}); i = i + 1;
        Algo.Phi = str2double(Parameter{i}); i = i + 1;
        Algo.Theta = str2double(Parameter{i}); i = i + 1;
        Algo.Top = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialize
        population = Initialization_MF(Algo, Prob, Individual_MF);
        MidNum = 0.5 * ones(1, max(Prob.D));
        Alpha = 0;
        transfer = {};
        Inorder = {};
        for t = 1:Prob.T
            meanT{t} = zeros(1, max(Prob.D));
            population_t = population([population.MFFactor] == t);
            pop_Dec{t} = population_t.Decs;
            pop_Rank{t} = [population_t.MFRank];
        end
        for t = 1:Prob.T - 1
            for k = (t + 1):Prob.T
                Inorder{t, k} = randperm(max(Prob.D));
                if Prob.D(t) > Prob.D(k)
                    p1 = t; p2 = k;
                else
                    p1 = k; p2 = t;
                end
                index = randi(size(pop_Dec{p1}, 1), [size(pop_Dec{p2}, 1), 1]);
                intpop = pop_Dec{p1}(index, :);
                intpop(:, Inorder{t, k}(1:Prob.D(p2))) = pop_Dec{p2}(:, 1:Prob.D(p2));
                idx = 1;
                for i = find([population.MFFactor] == p2)
                    population(i).Dec = intpop(idx, :);
                    idx = idx + 1;
                end
                transfer{t, k} = Alpha * meanT{p1};
                transfer{k, t} = Alpha * meanT{p2};
            end
        end

        while Algo.notTerminated(Prob)
            % Generation
            offspring = Algo.Generation(population, transfer);
            % Evaluation
            offspring_temp = Individual_MF.empty();
            for t = 1:Prob.T
                offspring_t = offspring([offspring.MFFactor] == t);
                offspring_t = Algo.Evaluation(offspring_t, Prob, t);
                for i = 1:length(offspring_t)
                    offspring_t(i).MFObj = inf(1, Prob.T);
                    offspring_t(i).MFCV = inf(1, Prob.T);
                    offspring_t(i).MFObj(t) = offspring_t(i).Obj;
                    offspring_t(i).MFCV(t) = offspring_t(i).CV;
                end
                offspring_temp = [offspring_temp, offspring_t];
            end
            offspring = offspring_temp;
            % Selection
            population = Selection_MF(population, offspring, Prob);

            % Transfer
            pop_Dec = {}; pop_Rank = {};
            for t = 1:Prob.T
                population_t = population([population.MFFactor] == t);
                pop_Dec{t} = population_t.Decs;
                pop_Rank{t} = [population_t.MFRank];
            end

            if Algo.Gen >= Algo.Phi * (Prob.maxFE / (Prob.N * Prob.T)) && ...
                    mod(Algo.Gen, round(Algo.Theta * (Prob.maxFE / (Prob.N * Prob.T)))) == 0
                Alpha = (Algo.FE / Prob.maxFE)^2;
                for t = 1:Prob.T
                    [~, y] = sort(pop_Rank{t});
                    meanT{t} = mean(pop_Dec{t}(y(1:round(Algo.Top * Prob.N)), :));
                end
            end

            for t = 1:Prob.T - 1
                for k = (t + 1):Prob.T
                    Inorder{t, k} = randperm(max(Prob.D));
                    if Prob.D(t) > Prob.D(k)
                        % p2.dim <= p1.dim
                        p1 = t; p2 = k;
                    else
                        p1 = k; p2 = t;
                    end
                    index = randi(size(pop_Dec{p1}, 1), [size(pop_Dec{p2}, 1), 1]);
                    intpop = pop_Dec{p1}(index, :);
                    intpop(:, Inorder{t, k}(1:Prob.D(p2))) = pop_Dec{p2}(:, 1:Prob.D(p2));
                    idx = 1;
                    for i = find([population.MFFactor] == p2)
                        population(i).Dec = intpop(idx, :);
                        population(i) = Algo.Evaluation(population(i), Prob, p2);
                        idx = idx + 1;
                    end
                    intmean = meanT{p1};
                    intmean(Inorder{t, k}(1:Prob.D(p2))) = meanT{p2}(1:Prob.D(p2));
                    transfer{p1, p2} = Alpha * (MidNum - meanT{p1});
                    transfer{p2, p1} = Alpha * (MidNum - intmean);
                end
            end
        end
    end

    function offspring = Generation(Algo, population, transfer)
        indorder = randperm(length(population));
        count = 1;
        for i = 1:ceil(length(population) / 2)
            p1 = indorder(i);
            p2 = indorder(i + fix(length(population) / 2));
            offspring(count) = population(p1);
            offspring(count + 1) = population(p2);

            if (population(p1).MFFactor == population(p2).MFFactor)
                % crossover
                [offspring(count).Dec, offspring(count + 1).Dec] = GA_Crossover(population(p1).Dec, population(p2).Dec, Algo.MuC);
                % imitation
                p = [p1, p2];
                offspring(count).MFFactor = population(p(randi(2))).MFFactor;
                offspring(count + 1).MFFactor = population(p(randi(2))).MFFactor;
            elseif rand() < Algo.RMP
                TDec1 = population(p1).Dec + transfer{population(p1).MFFactor, population(p2).MFFactor};
                TDec2 = population(p2).Dec + transfer{population(p2).MFFactor, population(p1).MFFactor};
                % crossover
                [offspring(count).Dec, offspring(count + 1).Dec] = GA_Crossover(TDec1, TDec2, Algo.MuC);
                offspring(count).Dec = offspring(count).Dec - transfer{population(p1).MFFactor, population(p2).MFFactor};
                offspring(count + 1).Dec = offspring(count + 1).Dec - transfer{population(p2).MFFactor, population(p1).MFFactor};
                % imitation
                p = [p1, p2];
                offspring(count).MFFactor = population(p(randi(2))).MFFactor;
                offspring(count + 1).MFFactor = population(p(randi(2))).MFFactor;
            else
                % mutation
                offspring(count).Dec = GA_Mutation(population(p1).Dec, Algo.MuM);
                offspring(count + 1).Dec = GA_Mutation(population(p2).Dec, Algo.MuM);
                % imitation
                offspring(count).MFFactor = population(p1).MFFactor;
                offspring(count + 1).MFFactor = population(p2).MFFactor;
            end
            for x = count:count + 1
                offspring(x).Dec(offspring(x).Dec > 1) = 1;
                offspring(x).Dec(offspring(x).Dec < 0) = 0;
            end
            count = count + 2;
        end
    end
end
end
