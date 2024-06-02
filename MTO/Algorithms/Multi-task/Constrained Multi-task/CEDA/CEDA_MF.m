classdef CEDA_MF < Algorithm
% <Multi-task> <Single-objective> <Constrained>

%------------------------------- Reference --------------------------------
% @Article{Zhang2024CEDA,
%   author     = {Tingyu Zhang and Dongcheng Li and Yanchi Li and Wenyin Gong},
%   journal    = {Swarm and Evolutionary Computation},
%   title      = {Constrained Multitasking Optimization Via Co-Evolution and Domain Adaptation},
%   year       = {2024},
%   issn       = {2210-6502},
%   pages      = {101570},
%   volume     = {87},
%   doi        = {https://doi.org/10.1016/j.swevo.2024.101570},
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
    Swap = 0.5
    EC_Top = 0.2
    EC_Tc = 0.8
    EC_Cp = 5
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'RMP: Random Mating Probability', num2str(Algo.RMP), ...
                'MuC: Simulated Binary Crossover', num2str(Algo.MuC), ...
                'MuM: Polynomial Mutation', num2str(Algo.MuM), ...
                'Swap: Variable Swap Probability', num2str(Algo.Swap), ...
                'EC_Top', num2str(Algo.EC_Top), ...
                'EC_Tc', num2str(Algo.EC_Tc), ...
                'EC_Cp', num2str(Algo.EC_Cp)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.RMP = str2double(Parameter{i}); i = i + 1;
        Algo.MuC = str2double(Parameter{i}); i = i + 1;
        Algo.MuM = str2double(Parameter{i}); i = i + 1;
        Algo.Swap = str2double(Parameter{i}); i = i + 1;
        Algo.EC_Top = str2double(Parameter{i}); i = i + 1;
        Algo.EC_Tc = str2double(Parameter{i}); i = i + 1;
        Algo.EC_Cp = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialize
        population1 = Initialization_MF(Algo, Prob, Individual_MF);
        population2 = Initialization_MF(Algo, Prob, Individual_MF);
        for t = 1:Prob.T
            n = ceil(Algo.EC_Top * length(population1));
            cv_temp = [];
            for i = 1:length(population1)
                cv_temp = [cv_temp, population1(i).MFCV(t)];
            end
            [~, idx] = sort(cv_temp);
            Ep0{t} = cv_temp(idx(n));
        end

        while Algo.notTerminated(Prob, population2)
            % calculate epsilon
            for t = 1:Prob.T
                if Algo.FE < Algo.EC_Tc * Prob.maxFE
                    Ep{t} = Ep0{t} * ((1 - Algo.FE / (Algo.EC_Tc * Prob.maxFE))^Algo.EC_Cp);
                else
                    Ep{t} = 0;
                end
            end

            for t = 1:Prob.T
                for i = 1:length(population1)
                    CV1(i, 1) = population1(i).MFCV(t);
                    CV1(CV1 < Ep{t}) = 0;
                    Obj1(i, 1) = population1(i).MFObj(t);
                end
                [~, rank1] = sortrows([CV1, Obj1], [1, 2]);
                for i = 1:length(population1)
                    population1(rank1(i)).MFRank(t) = i;
                end
            end

            for i = 1:length(population1)
                fit1(i) = min([population1(i).MFRank]);
            end
            for t = 1:Prob.T
                for i = 1:length(population2)
                    Obj2(i, 1) = population2(i).MFObj(t);
                    CV2(i, 1) = population2(i).MFCV(t);
                end
                [~, rank2] = sortrows([CV2, Obj2], [1, 2]);
                for i = 1:length(population2)
                    population2(rank2(i)).MFRank(t) = i;
                end
            end

            for i = 1:length(population2)
                fit2(i) = min([population2(i).MFRank]);
            end
            mating_pool1 = TournamentSelection(2, 2 * Prob.N, fit1);
            mating_pool2 = TournamentSelection(2, 2 * Prob.N, fit2);
            % Generation
            offspring1 = Algo.Generation1(population1(mating_pool1));
            offspring2 = Algo.Generation2(population2(mating_pool2));
            % Evaluation
            offspring_temp1 = Individual_MF.empty();
            offspring_temp2 = Individual_MF.empty();
            for t = 1:Prob.T
                offspring_t1 = offspring1([offspring1.MFFactor] == t);
                offspring_t1 = Algo.Evaluation(offspring_t1, Prob, t);
                offspring_t2 = offspring2([offspring2.MFFactor] == t);
                offspring_t2 = Algo.Evaluation(offspring_t2, Prob, t);
                for i = 1:length(offspring_t1)
                    offspring_t1(i).MFObj = inf(1, Prob.T);
                    offspring_t1(i).MFCV = inf(1, Prob.T);
                    offspring_t1(i).MFObj(t) = offspring_t1(i).Obj;
                    offspring_t1(i).MFCV(t) = offspring_t1(i).CV;
                end
                for i = 1:length(offspring_t2)
                    offspring_t2(i).MFObj = inf(1, Prob.T);
                    offspring_t2(i).MFCV = inf(1, Prob.T);
                    offspring_t2(i).MFObj(t) = offspring_t2(i).Obj;
                    offspring_t2(i).MFCV(t) = offspring_t2(i).CV;
                end
                offspring_temp1 = [offspring_temp1, offspring_t1];
                offspring_temp2 = [offspring_temp2, offspring_t2];
            end
            offspring1 = offspring_temp1;
            offspring2 = offspring_temp2;
            offspring = [offspring1, offspring2];
            % Selection
            population1 = Algo.Selection_MF_CEDA(population1, offspring, Prob, Ep);
            population2 = Selection_MF(population2, offspring, Prob);
        end
    end

    function offspring = Generation1(Algo, population)
        for i = 1:ceil(length(population) / 2)
            p1 = i;
            p2 = i + fix(length(population) / 2);
            offspring(i) = population(p1);

            if (population(p1).MFFactor == population(p2).MFFactor)
                % crossover
                offspring(i).Dec = GA_Crossover(population(p1).Dec, population(p2).Dec, Algo.MuC);
                % mutation
                offspring(i).Dec = GA_Mutation(offspring(i).Dec, Algo.MuM);
                % variable swap (uniform X)
                swap_indicator = (rand(1, length(population(p1).Dec)) >= Algo.Swap);
                temp = population(p2).Dec(swap_indicator);
                offspring(i).Dec(swap_indicator) = temp;
                % imitation
                p = [p1, p2];
                offspring(i).MFFactor = population(p(randi(2))).MFFactor;
            elseif rand() < Algo.RMP
                Ds = Individual_MF.empty();
                Dt = Individual_MF.empty();
                % DA
                pm1 = population(p1); pm2 = population(p2);
                MF1 = pm1.MFFactor;
                MF2 = pm2.MFFactor;
                Ds = population([population.MFFactor] == MF1);
                Dt = population([population.MFFactor] == MF2);
                pm1.Dec = CEDA_trans(Ds, Dt, pm1.Dec);
                % crossover
                offspring(i).Dec = GA_Crossover(pm1.Dec, population(p2).Dec, Algo.MuC);
                % mutation
                offspring(i).Dec = GA_Mutation(offspring(i).Dec, Algo.MuM);

                % imitation
                p = [p1, p2];
                offspring(i).MFFactor = population(p(randi(2))).MFFactor;

            else
                % Randomly pick another individual from the same task
                p = [p1, p2];
                find_idx = find([population.MFFactor] == population(p(1)).MFFactor);
                idx = find_idx(randi(length(find_idx)));
                while idx == p(1)
                    idx = find_idx(randi(length(find_idx)));
                end
                offspring_temp = population(idx);
                % crossover
                offspring(i).Dec = GA_Crossover(population(p(1)).Dec, population(idx).Dec, Algo.MuC);
                % mutation
                offspring(i).Dec = GA_Mutation(offspring(i).Dec, Algo.MuM);
                % variable swap (uniform X)
                swap_indicator = (rand(1, length(population(p(1)).Dec)) >= Algo.Swap);
                offspring(i).Dec(swap_indicator) = offspring_temp.Dec(swap_indicator);
                % imitate
                offspring(i).MFFactor = population(p(1)).MFFactor;

            end

            offspring(i).Dec(offspring(i).Dec > 1) = 1;
            offspring(i).Dec(offspring(i).Dec < 0) = 0;

        end
    end

    function offspring = Generation2(Algo, population)
        for i = 1:ceil(length(population) / 2)
            p1 = i;
            p2 = i + fix(length(population) / 2);
            offspring(i) = population(p1);

            if (population(p1).MFFactor == population(p2).MFFactor)
                % crossover
                offspring(i).Dec = GA_Crossover(population(p1).Dec, population(p2).Dec, Algo.MuC);
                % mutation
                offspring(i).Dec = GA_Mutation(offspring(i).Dec, Algo.MuM);
                % variable swap (uniform X)
                swap_indicator = (rand(1, length(population(p1).Dec)) >= Algo.Swap);
                temp = population(p2).Dec(swap_indicator);
                offspring(i).Dec(swap_indicator) = temp;
                % imitation
                p = [p1, p2];
                offspring(i).MFFactor = population(p(randi(2))).MFFactor;
            elseif rand() < 0
                Ds = Individual_MF.empty();
                Dt = Individual_MF.empty();
                % DA
                pm1 = population(p1); pm2 = population(p2);
                MF1 = pm1.MFFactor;
                MF2 = pm2.MFFactor;
                Ds = population([population.MFFactor] == MF1);
                Dt = population([population.MFFactor] == MF2);
                pm1.Dec = CEDA_trans(Ds, Dt, pm1.Dec);
                % crossover
                offspring(i).Dec = GA_Crossover(pm1.Dec, population(p2).Dec, Algo.MuC);
                % mutation
                offspring(i).Dec = GA_Mutation(offspring(i).Dec, Algo.MuM);

                % imitation
                p = [p1, p2];
                offspring(i).MFFactor = population(p(randi(2))).MFFactor;

            else
                % Randomly pick another individual from the same task
                p = [p1, p2];
                find_idx = find([population.MFFactor] == population(p(1)).MFFactor);
                idx = find_idx(randi(length(find_idx)));
                while idx == p(1)
                    idx = find_idx(randi(length(find_idx)));
                end
                offspring_temp = population(idx);
                % crossover
                offspring(i).Dec = GA_Crossover(population(p(1)).Dec, population(idx).Dec, Algo.MuC);
                % mutation
                offspring(i).Dec = GA_Mutation(offspring(i).Dec, Algo.MuM);
                % variable swap (uniform X)
                swap_indicator = (rand(1, length(population(p(1)).Dec)) >= Algo.Swap);
                offspring(i).Dec(swap_indicator) = offspring_temp.Dec(swap_indicator);
                % imitate
                offspring(i).MFFactor = population(p(1)).MFFactor;
            end

            offspring(i).Dec(offspring(i).Dec > 1) = 1;
            offspring(i).Dec(offspring(i).Dec < 0) = 0;

        end
    end

    function population = Selection_MF_CEDA(Algo, population, offspring, Prob, Ep)
        %% Elite selection based on scalar fitness
        % Input: population (old), offspring,
        % Output: population (new)

        population = [population, offspring];

        for t = 1:Prob.T
            for i = 1:length(population)
                Obj(i, 1) = population(i).MFObj(t);
                CV(i, 1) = population(i).MFCV(t); CV(CV < Ep{t}) = 0;
            end
            [~, rank] = sortrows([CV, Obj], [1, 2]);
            for i = 1:length(population)
                population(rank(i)).MFRank(t) = i;
            end
        end

        for i = 1:length(population)
            fit(i) = 1 / min([population(i).MFRank]);
        end

        [~, rank] = sort(fit, 'descend');
        population = population(rank(1:Prob.N * Prob.T));
    end
end
end
