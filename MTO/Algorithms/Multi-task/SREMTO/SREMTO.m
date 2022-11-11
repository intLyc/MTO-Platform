classdef SREMTO < Algorithm
    % <Multi-task> <Single-objective> <None/Constrained>

    %------------------------------- Reference --------------------------------
    % @Article{Zheng2020SREMTO,
    %   title      = {Self-Regulated Evolutionary Multitask Optimization},
    %   author     = {Zheng, Xiaolong and Qin, A. K. and Gong, Maoguo and Zhou, Deyun},
    %   journal    = {IEEE Transactions on Evolutionary Computation},
    %   year       = {2020},
    %   number     = {1},
    %   pages      = {16-28},
    %   volume     = {24},
    %   doi        = {10.1109/TEVC.2019.2904696},
    %   file       = {:Zheng2020SREMTO - Self Regulated Evolutionary Multitask Optimization.pdf:PDF},
    %   groups     = {MT, SO, Algorithm},
    %   readstatus = {read},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        TH = 0.3
        MuC = 2
        MuM = 5
    end

    methods
        function Parameter = getParameter(Algo)
            Parameter = {'TH: two line segments point', num2str(Algo.TH), ...
                        'MuC: Simulated Binary Crossover', num2str(Algo.MuC), ...
                        'MuM: Polynomial Mutation', num2str(Algo.MuM)};
        end

        function Algo = setParameter(Algo, Parameter)
            i = 1;
            Algo.TH = str2double(Parameter{i}); i = i + 1;
            Algo.MuC = str2double(Parameter{i}); i = i + 1;
            Algo.MuM = str2double(Parameter{i}); i = i + 1;
        end

        function run(Algo, Prob)
            % Initialize
            population = Initialization_MF(Algo, Prob, Individual_SRE);
            a1 = (Algo.TH - 1) / (Prob.N - 1);
            b1 = (Prob.N - Algo.TH) / (Prob.N - 1);
            a2 = (- Algo.TH) / (Prob.N * (Prob.T - 1));
            b2 = ((Prob.N * Prob.T) * Algo.TH) ./ (Prob.N * (Prob.T - 1));

            for t = 1:Prob.T
                for i = 1:length(population)
                    % Get ability vector
                    if population(i).MFRank(t) <= Prob.N
                        population(i).Ability(t) = a1 * population(i).MFRank(t) + b1;
                    else
                        population(i).Ability(t) = a2 * population(i).MFRank(t) + b2;
                    end
                end
            end

            while Algo.notTerminated(Prob)
                int_population = population;
                for t = 1:Prob.T
                    parent = Individual_SRE.empty();
                    for i = 1:length(population)
                        if population(i).MFRank(t) <= Prob.N
                            parent = [parent, population(i)];
                        end
                    end

                    offspring = Algo.Generation(parent);
                    for i = 1:length(offspring)
                        for k = 1:Prob.T
                            if k == t || rand() < offspring(i).Ability(k)
                                offspring(i) = Algo.Evaluation(offspring(i), Prob, k);
                                offspring(i).MFObj(k) = offspring(i).Obj;
                                offspring(i).MFCV(k) = offspring(i).CV;
                            else
                                offspring(i).MFObj(k) = inf;
                                offspring(i).MFCV(k) = inf;
                            end
                        end
                    end
                    int_population = [int_population, offspring];
                end

                % Selection
                for t = 1:Prob.T
                    Obj = []; CV = [];
                    for i = 1:length(int_population)
                        Obj(i) = int_population(i).MFObj(t);
                        CV(i) = int_population(i).MFCV(t);
                    end
                    [~, rank] = sortrows([CV', Obj'], [1, 2]);
                    for i = 1:length(int_population)
                        int_population(rank(i)).MFRank(t) = i;
                    end
                end
                % Select next generation population
                next_idx = [];
                for t = 1:Prob.T
                    for i = 1:length(int_population)
                        if int_population(i).MFRank(t) <= Prob.N
                            next_idx = [next_idx, i];
                        end
                    end
                end
                population = int_population(unique(next_idx));
                % Get ability vector
                for t = 1:Prob.T
                    for i = 1:length(population)
                        if population(i).MFRank(t) <= Prob.N
                            population(i).Ability(t) = a1 * population(i).MFRank(t) + b1;
                        else
                            population(i).Ability(t) = a2 * population(i).MFRank(t) + b2;
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
                % crossover
                [offspring(count).Dec, offspring(count + 1).Dec] = GA_Crossover(population(p1).Dec, population(p2).Dec, Algo.MuC);
                % mutation
                offspring(count).Dec = GA_Mutation(population(p1).Dec, Algo.MuM);
                offspring(count + 1).Dec = GA_Mutation(population(p2).Dec, Algo.MuM);
                % imitation
                offspring(count).Ability = population(p1).Ability;
                offspring(count + 1).Ability = population(p2).Ability;
                for x = count:count + 1
                    offspring(x).Dec(offspring(x).Dec > 1) = 1;
                    offspring(x).Dec(offspring(x).Dec < 0) = 0;
                end
                count = count + 2;
            end
        end
    end
end
