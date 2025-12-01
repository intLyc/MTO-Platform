classdef MFEA_DV < Algorithm
% <Multi-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Yin2019MFEA-DV,
%   title      = {Multifactorial Evolutionary Algorithm Enhanced with Cross-task Search Direction},
%   author     = {Yin,Jian and Zhu, Anmin and Zhu, Zexuan and Yu, Yanan and Ma, Xiaoling},
%   journal    = {IEEE Congress on Evolutionary Computation },
%   year       = {2019},
%   pages      = {2244-2251},
%   doi        = {10.1109/CEC.2019.8789959},
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
    P = 0.1
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'RMP: Random Mating Probability', num2str(Algo.RMP), ...
                'MuC: Simulated Binary Crossover', num2str(Algo.MuC), ...
                'MuM: Polynomial Mutation', num2str(Algo.MuM), ...
                'P: 100p% top as pbest', num2str(Algo.P)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.RMP = str2double(Parameter{i}); i = i + 1;
        Algo.MuC = str2double(Parameter{i}); i = i + 1;
        Algo.MuM = str2double(Parameter{i}); i = i + 1;
        Algo.P = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialize
        population = Initialization_MF(Algo, Prob, Individual_MF);

        while Algo.notTerminated(Prob, population)
            % Generation
            offspring = Algo.Generation(population, Prob.N, Prob.T);
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
        end
    end

    function offspring = Generation(Algo, population, N, T)
        % knowledge transfer stategy
        pbest_pop = Individual_MF.empty();
        for t = 1:T
            for i = 1:N
                Obj(i) = population(i).MFObj(t);
                CV(i) = population(i).MFCV(t);
            end
            [~, rank] = sortrows([CV', Obj'], [1, 2]);
            for i = 1:N
                population(rank(i)).MFRank(t) = i;
            end
            pbest_idx{t} = rank(1:round(Algo.P * length(population)));
        end
        group = cell([1, T]);
        for i = 1:length(population)
            group{population(i).MFFactor} = [group{population(i).MFFactor}, i];
        end
        for i = 1:Algo.P * length(population)
            offspring_tt = Individual_MF();
            offspring_tt.MFObj = inf(1, T);
            offspring_tt.MFCV = inf(1, T);
            for t = 1:length(group)
                pbest = pbest_idx{t}(i);
                other = [];
                for w = 1:length(group)
                    if population(pbest).MFFactor ~= w
                        other = [other, group{w}];
                    end
                end

                other = other(randperm(length(other)));
                x2 = other(randi(length(other)));
                c_pbest = pbest_idx{population(x2).MFFactor}(i);
                offspring_tt.Dec = population(pbest).Dec + population(x2).Dec - population(c_pbest).Dec;
                offspring_tt.MFFactor = population(i).MFFactor;
                pbest_pop = [pbest_pop, offspring_tt];
            end
        end
        population = [population, pbest_pop];
        population = population(randperm(length(population)));

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
