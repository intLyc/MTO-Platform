classdef MFEA_GHS < Algorithm
    % <MT-SO> <None/Constrained>

    %------------------------------- Reference --------------------------------
    % @Article{Liang2019MFEA-GHS,
    %   title    = {A Hybrid of Genetic Transform and Hyper-rectangle Search Strategies for Evolutionary Multi-tasking},
    %   author   = {Zhengping Liang and Jian Zhang and Liang Feng and Zexuan Zhu},
    %   journal  = {Expert Systems with Applications},
    %   year     = {2019},
    %   volume   = {138},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        RMP = 0.3
        MuC = 2
        MuM = 5
    end

    methods
        function Parameter = getParameter(Algo)
            Parameter = {'RMP: Random Mating Probability', num2str(Algo.RMP), ...
                        'MuC: Simulated Binary Crossover', num2str(Algo.MuC), ...
                        'MuM: Polynomial Mutation', num2str(Algo.MuM)};
        end

        function Algo = setParameter(Algo, Parameter)
            i = 1;
            Algo.RMP = str2double(Parameter{i}); i = i + 1;
            Algo.MuC = str2double(Parameter{i}); i = i + 1;
            Algo.MuM = str2double(Parameter{i}); i = i + 1;
        end

        function run(Algo, Prob)
            % Initialize
            population = Initialization_MF_One(Algo, Prob, Individual_MF);
            [max_T, min_T] = Algo.cal_max_min(population, Prob.T);
            for t = 1:Prob.T
                M{t} = ones(1, max(Prob.D));
            end

            while Algo.notTerminated(Prob)
                % Generation
                offspring = Algo.Generation(population, max_T, min_T, M);
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
                % Update Parameter
                [max_T, min_T] = Algo.cal_max_min(population, Prob.T);
                M = Algo.domain_ad(population, Prob.T);
            end
        end

        function offspring = Generation(Algo, population, max_T, min_T, M)
            indorder = randperm(length(population));
            count = 1;
            for i = 1:ceil(length(population) / 2)
                k = 0.5 + 1 * rand();
                p1 = indorder(i);
                p2 = indorder(i + fix(length(population) / 2));
                offspring(count) = population(p1);
                offspring(count + 1) = population(p2);

                if (population(p1).MFFactor == population(p2).MFFactor)
                    t = population(p1).MFFactor;
                    % crossover
                    [offspring(count).Dec, offspring(count + 1).Dec] = GA_Crossover(population(p1).Dec, population(p2).Dec, Algo.MuC);
                    if rand() > mod(Algo.Gen, 2) % OBL
                        offspring(count + 1).Dec = 1 - offspring(count).Dec;
                    else
                        offspring(count + 1).Dec = k * (max_T{t} + min_T{t}) - offspring(count).Dec;
                    end
                    % imitation
                    p = [p1, p2];
                    offspring(count).MFFactor = population(p(randi(2))).MFFactor;
                    offspring(count + 1).MFFactor = population(p(randi(2))).MFFactor;
                elseif rand() < Algo.RMP
                    % crossover
                    p = [p1, p2]; r1 = randi(2); r2 = mod(r1, 2) + 1;
                    t1 = population(p(r1)).MFFactor; t2 = population(p(r2)).MFFactor;
                    if rand() < 0.5
                        tmp = population(p(r1));
                        tmp.Dec = population(p(r1)).Dec .* M{t1};
                        tmp.Dec(tmp.Dec > 1) = 1; tmp.Dec(tmp.Dec < 0) = 0;
                        offspring(count).Dec = GA_Crossover(tmp.Dec, population(p(r2)).Dec, Algo.MuC);
                        if rand() > mod(Algo.Gen, 2) % OBL
                            offspring(count + 1).Dec = 1 - offspring(count).Dec;
                        else
                            offspring(count + 1).Dec = k * (max_T{t2} + min_T{t2}) - offspring(count).Dec;
                        end
                    else
                        tmp = population(p(r2));
                        tmp.Dec = population(p(r2)).Dec .* M{t2};
                        tmp.Dec(tmp.Dec > 1) = 1; tmp.Dec(tmp.Dec < 0) = 0;
                        offspring(count).Dec = GA_Crossover(population(p(r1)).Dec, tmp.Dec, Algo.MuC);
                        if rand() > mod(Algo.Gen, 2) % OBL
                            offspring(count + 1).Dec = 1 - offspring(count).Dec;
                        else
                            offspring(count + 1).Dec = k * (max_T{t1} + min_T{t1}) - offspring(count).Dec;
                        end
                    end
                    % imitation
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

        function [max_T, min_T] = cal_max_min(Algo, population, Tnum)
            max_T = {};
            min_T = {};
            for t = 1:Tnum
                Dec_t = [];
                population_t = population([population.MFFactor] == t);
                for i = 1:length(population_t)
                    Dec_t = [Dec_t; population_t(i).Dec];
                end
                max_T{t} = max(Dec_t);
                min_T{t} = min(Dec_t);
            end
        end

        function [M] = domain_ad(Algo, population, Tnum)
            M = {};
            for t = 1:Tnum
                population_t = population([population.MFFactor] == t);
                T = [];
                N = unidrnd(Tnum);
                for i = 1:N
                    T = [T; population_t(i).Dec];
                end
                mean_T = mean(T);
                M{t} = (mean_T + 1e-10) ./ (mean_T + 1e-10);
            end
        end
    end
end
