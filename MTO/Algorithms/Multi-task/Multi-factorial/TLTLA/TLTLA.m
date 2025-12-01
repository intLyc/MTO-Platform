classdef TLTLA < Algorithm
% <Multi-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Ma2020TLTLA,
%   author    = {Ma, Xiaoliang and Chen, Qunjian and Yu, Yanan and Sun, Yiwen and Ma, Lijia and Zhu, Zexuan},
%   journal   = {Frontiers in neuroscience},
%   title     = {A Two-level Transfer Learning Algorithm for Evolutionary Multitasking},
%   year      = {2020},
%   pages     = {1408},
%   volume    = {13},
%   publisher = {Frontiers},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------
properties (SetAccess = public)
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
        population = Initialization_MF(Algo, Prob, Individual_MF);

        while Algo.notTerminated(Prob, population)
            %% Upper-level: Inter-task Knowledge Transfer
            % Generation
            offspring = Algo.Generation(population);
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

            %% Lower-level: Intra-task Knowledge Transfer
            parent = randi(length(population));
            t = population(parent).MFFactor;
            dimen = mod(Algo.Gen - 2, max(Prob.D)) + 1; % start with 1 Dim
            child_Dec = zeros(size(population(parent)));
            pool = population([population.MFFactor] == t);
            for d = 1:max(Prob.D)
                x = randperm(length(pool), min(3, length(pool)));
                if length(pool) < 3
                    child_Dec(d) = pool(x(1)).Dec(dimen);
                    continue;
                end
                if rand > 0.5
                    child_Dec(d) = pool(x(1)).Dec(dimen) + 0.5 * rand * (pool(x(2)).Dec(dimen) - pool(x(3)).Dec(dimen));
                else
                    child_Dec(d) = pool(x(1)).Dec(dimen) + 0.5 * rand * (pool(x(3)).Dec(dimen) - pool(x(2)).Dec(dimen));
                end
            end
            child_Dec(child_Dec > 1) = 1;
            child_Dec(child_Dec < 0) = 0;

            if rand() > 0.5
                tmp_population = population(parent);
                for d = 1:max(Prob.D)
                    tmp_population.Dec(d) = child_Dec(d);
                    tmp_population = Algo.Evaluation(tmp_population, Prob, t);
                    TMP = [tmp_population, population(parent)];
                    [~, ~, idx] = min_FP(TMP.Objs, TMP.CVs);
                    if idx == 1
                        population(parent) = tmp_population;
                        break;
                    end
                end
            else
                for d = 1:max(Prob.D)
                    tmp_population = population(parent);
                    tmp_population.Dec(d) = child_Dec(d);
                    tmp_population = Algo.Evaluation(tmp_population, Prob, t);
                    TMP = [tmp_population, population(parent)];
                    [~, ~, idx] = min_FP([TMP.Obj], [TMP.CV]);
                    if idx == 1
                        population(parent) = tmp_population;
                        break;
                    end
                end
            end
        end
    end

    function offspring = Generation(Algo, population)
        indorder = randperm(length(population));
        count = 1;
        for i = 1:ceil(length(population) / 2)
            p1 = indorder(i);
            p2 = indorder(i + fix(length(population) / 2));
            offspring(count) = population(p1);
            offspring(count + 1) = population(p2);

            if (population(p1).MFFactor == population(p2).MFFactor) || rand() < Algo.RMP
                % crossover
                [offspring(count).Dec, offspring(count + 1).Dec] = GA_Crossover(population(p1).Dec, population(p2).Dec, Algo.MuC);
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
