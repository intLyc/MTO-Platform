classdef MFEA_AKT < Algorithm
% <Multi-task> <Single-objective> <None>

%------------------------------- Reference --------------------------------
% @Article{Zhou2021MFEA-AKT,
%   title      = {Toward Adaptive Knowledge Transfer in Multifactorial Evolutionary Computation},
%   author     = {Zhou, Lei and Feng, Liang and Tan, Kay Chen and Zhong, Jinghui and Zhu, Zexuan and Liu, Kai and Chen, Chao},
%   journal    = {IEEE Transactions on Cybernetics},
%   year       = {2021},
%   number     = {5},
%   pages      = {2563-2576},
%   volume     = {51},
%   doi        = {10.1109/TCYB.2020.2974100},
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
    Gap = 20
    MuC = 2
    MuM = 5
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'RMP: Random Mating Probability', num2str(Algo.RMP), ...
                'Gap', num2str(Algo.Gap), ...
                'MuC: Simulated Binary Crossover', num2str(Algo.MuC), ...
                'MuM: Polynomial Mutation', num2str(Algo.MuM)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.RMP = str2double(Parameter{i}); i = i + 1;
        Algo.Gap = str2double(Parameter{i}); i = i + 1;
        Algo.MuC = str2double(Parameter{i}); i = i + 1;
        Algo.MuM = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialize
        population = Initialization_MF(Algo, Prob, Individual_AKT);
        cfb_record = [];
        for i = 1:length(population)
            population(i).isTran = 0;
            population(i).CXFactor = randi(6);
            population(i).parNum = 0;
        end

        while Algo.notTerminated(Prob)
            % Generation
            offspring = Algo.Generation(population);
            % Evaluation
            offspring_temp = Individual_AKT.empty();
            for t = 1:Prob.T
                offspring_t = offspring([offspring.MFFactor] == t);
                offspring_t = Algo.Evaluation(offspring_t, Prob, t);
                for i = 1:length(offspring_t)
                    offspring_t(i).MFObj = inf(1, Prob.T);
                    offspring_t(i).MFObj(t) = offspring_t(i).Obj;
                end
                offspring_temp = [offspring_temp, offspring_t];
            end
            offspring = offspring_temp;

            % Calculate best CXFactor
            imp_num = zeros(1, 6);
            for i = 1:length(offspring)
                if offspring(i).parNum ~= 0
                    cfc = offspring(i).MFObj(offspring(i).MFFactor);
                    pfc = population(offspring(i).parNum).MFObj(population(offspring(i).parNum).MFFactor);
                    if (pfc - cfc) / pfc > imp_num(offspring(i).CXFactor)
                        imp_num(offspring(i).CXFactor) = (pfc - cfc) / pfc;
                    end
                end
            end
            prcfb_count = zeros(1, 6);
            if any(imp_num)
                [max_num, max_idx] = max(imp_num);
            else % have not better CXFactor
                if Algo.Gen <= Algo.Gap + 1 % former Algo.Gen
                    record_temp = cfb_record(2:Algo.Gen - 1);
                else
                    record_temp = cfb_record(Algo.Gen - Algo.Gap:Algo.Gen - 1);
                end
                unique_temp = unique(record_temp);
                hist_temp = hist(record_temp, unique_temp);
                hist_temp(hist_temp == 0) = [];
                prcfb_count(unique_temp) = prcfb_count(unique_temp) + hist_temp;
                [max_num, max_idx] = max(prcfb_count);
            end
            cfb_record(Algo.Gen) = max_idx;
            % Adaptive CXFactor
            for i = 1:length(offspring)
                if offspring(i).parNum ~= 0
                    cfc = offspring(i).MFObj(offspring(i).MFFactor);
                    pfc = population(offspring(i).parNum).MFObj(population(offspring(i).parNum).MFFactor);
                    if (pfc - cfc) / pfc < 0
                        offspring(i).CXFactor = max_idx;
                    end
                else
                    x = [max_idx, randi(6)];
                    offspring(i).CXFactor = x(randi(2));
                end
            end

            % Selection
            population = Selection_MF(population, offspring, Prob);
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
                p = [p1, p2];
                if (population(p1).MFFactor == population(p2).MFFactor)
                    % crossover
                    [offspring(count).Dec, offspring(count + 1).Dec] = GA_Crossover(population(p1).Dec, population(p2).Dec, Algo.MuC);
                    offspring(count).CXFactor = population(p1).CXFactor;
                    offspring(count + 1).CXFactor = population(p2).CXFactor;
                    offspring(count).isTran = 0;
                    offspring(count + 1).isTran = 0;
                else
                    alpha = population(p(randi(2))).CXFactor;
                    [offspring(count).Dec, offspring(count + 1).Dec] = Algo.hyberCX(population(p1).Dec, population(p2).Dec, alpha);
                    offspring(count).CXFactor = alpha;
                    offspring(count + 1).CXFactor = alpha;
                    offspring(count).isTran = 1;
                    offspring(count + 1).isTran = 1;
                end
                % imitation
                rand_p = p(randi(2));
                offspring(count).MFFactor = population(rand_p).MFFactor;
                if offspring(count).isTran == 1
                    offspring(count).parNum = rand_p;
                end
                rand_p = p(randi(2));
                offspring(count + 1).MFFactor = population(rand_p).MFFactor;
                if offspring(count + 1).isTran == 1
                    offspring(count + 1).parNum = rand_p;
                end
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

    function [OffDec1, OffDec2] = hyberCX(Algo, ParDec1, ParDec2, alpha)
        switch alpha
            case 1
                OffDec1 = Algo.TPCrossover(ParDec1, ParDec2);
                OffDec2 = Algo.TPCrossover(ParDec2, ParDec1);
            case 2
                OffDec1 = Algo.UFCrossover(ParDec1, ParDec2);
                OffDec2 = Algo.UFCrossover(ParDec2, ParDec1);
            case 3
                OffDec1 = Algo.ARICrossover(ParDec1, ParDec2);
                OffDec2 = Algo.ARICrossover(ParDec2, ParDec1);
            case 4
                OffDec1 = Algo.GEOCrossover(ParDec1, ParDec2);
                OffDec2 = Algo.GEOCrossover(ParDec2, ParDec1);
            case 5
                a = 0.3;
                OffDec1 = Algo.BLXACrossover(ParDec1, ParDec2, a);
                OffDec2 = Algo.BLXACrossover(ParDec2, ParDec1, a);
            case 6
                [OffDec1, OffDec2] = GA_Crossover(ParDec1, ParDec2, Algo.MuC);
        end
    end

    % Twopoint crossover
    function OffDec = TPCrossover(Algo, ParDec1, ParDec2)
        i = randi([1, length(ParDec1)], 1, 1);
        j = randi([1, length(ParDec1)], 1, 1);
        if i > j
            t = i; i = j; j = t;
        end
        t1 = ParDec1(1:i - 1);
        t2 = ParDec2(i:j);
        t3 = ParDec1(j + 1:end);
        OffDec = [t1 t2 t3];
    end

    % Uniform crossover
    function OffDec = UFCrossover(Algo, ParDec1, ParDec2)
        i = 1;
        while i <= length(ParDec1)
            u = randi([0, 1], 1, 1);
            if u == 0
                OffDec(i) = ParDec1(i);
            else
                OffDec(i) = ParDec2(i);
            end
            i = i + 1;
        end
    end

    % Arithmetical crossover
    function OffDec = ARICrossover(Algo, ParDec1, ParDec2)
        i = 1; len = length(ParDec1);
        r = 0.25;
        while i <= len
            OffDec(i) = r * ParDec1(i) + (1 - r) * ParDec2(i);
            i = i + 1;
        end
    end

    % Geometric crossover
    function OffDec = GEOCrossover(Algo, ParDec1, ParDec2)
        i = 1; len = length(ParDec1);
        r = 0.2;
        while i <= len
            OffDec(i) = ParDec1(i)^r * ParDec2(i)^(1 - r);
            i = i + 1;
        end
    end

    % BLX-a crossover
    function OffDec = BLXACrossover(Algo, ParDec1, ParDec2, a)
        i = 1; len = length(ParDec1);
        while i <= len
            if ParDec1(i) < ParDec2(i)
                Cmin = ParDec1(i);
                Cmax = ParDec2(i);
            else
                Cmin = ParDec2(i);
                Cmax = ParDec1(i);
            end
            I = Cmax - Cmin;
            OffDec(i) = (Cmin - I * a) + (I + 2 * I * a) * rand(1, 1);
            i = i + 1;
        end
    end
end
end
