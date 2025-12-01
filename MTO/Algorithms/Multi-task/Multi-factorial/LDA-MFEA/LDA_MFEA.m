classdef LDA_MFEA < Algorithm
% <Multi-task> <Single-objective> <None>

%------------------------------- Reference --------------------------------
% @inproceedings{Bali2017LDA-MFEA,
%   title     = {Linearized Domain Adaptation in Evolutionary Multitasking},
%   author    = {Bali, Kavitesh Kumar and Gupta, Abhishek and Feng, Liang and Ong, Yew Soon and Tan Puay Siew},
%   booktitle = {2017 IEEE Congress on Evolutionary Computation (CEC)},
%   year      = {2017},
%   pages     = {1295-1302},
%   doi       = {10.1109/CEC.2017.7969454},
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
    K = 5
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'RMP: Random Mating Probability', num2str(Algo.RMP), ...
                'MuC: Simulated Binary Crossover', num2str(Algo.MuC), ...
                'MuM: Polynomial Mutation', num2str(Algo.MuM), ...
                'K: Cluster Number', num2str(Algo.K)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.RMP = str2double(Parameter{i}); i = i + 1;
        Algo.MuC = str2double(Parameter{i}); i = i + 1;
        Algo.MuM = str2double(Parameter{i}); i = i + 1;
        Algo.K = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialize
        population = Initialization_MF(Algo, Prob, Individual_MF);
        for t = 1:Prob.T
            P{t} = []; M{t} = [];
        end

        while Algo.notTerminated(Prob, population)
            % Extract Task specific Data Sets
            for t = 1:Prob.T
                subpops(t).data = []; f(t).cost = [];
            end
            for i = 1:length(population)
                subpops(population(i).MFFactor).data = [subpops(population(i).MFFactor).data; population(i).Dec];
                f(population(i).MFFactor).cost = [f(population(i).MFFactor).cost; population(i).MFObj(population(i).MFFactor)];
            end

            for t = 1:Prob.T
                if Algo.Gen > 2
                    % Clustering to reduce data size
                    [~, P{t}] = kmeans(P{t}, Algo.K);
                end
                % Accumulate all historical points of t and sort according to objective
                temp = [P{t}; [subpops(t).data, f(t).cost]];
                temp = sortrows(temp, max(Prob.D) + 1);
                P{t} = temp;
                M{t} = temp(:, 1:end - 1); % extract chromosomes except the last column(Obj), store into matrix
            end

            % Generation
            offspring = Algo.Generation(population, M, Prob.D);
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

    function offspring = Generation(Algo, population, M, Dim)
        indorder = randperm(length(population));
        count = 1;
        for i = 1:ceil(length(population) / 2)
            p1 = indorder(i);
            p2 = indorder(i + fix(length(population) / 2));
            offspring(count) = population(p1);
            offspring(count + 1) = population(p2);
            temp_offspring = offspring(count);

            if (population(p1).MFFactor == population(p2).MFFactor) || rand() < Algo.RMP
                % crossover
                [offspring(count).Dec, offspring(count + 1).Dec] = GA_Crossover(population(p1).Dec, population(p2).Dec, Algo.MuC);
                % imitation
                p = [p1, p2];
                offspring(count).MFFactor = population(p(randi(2))).MFFactor;
                offspring(count + 1).MFFactor = population(p(randi(2))).MFFactor;
            else % LDA
                t1 = population(p1).MFFactor; t2 = population(p2).MFFactor;

                diff = abs(size(M{t1}, 1) - size(M{t2}, 1));
                % same number of rows for both task populations.
                % for matrix mapping
                if size(M{t1}, 1) < size(M{t2}, 1)
                    M{t2} = M{t2}(1:end - diff, :);
                else
                    M{t1} = M{t1}(1:end - diff, :);
                end

                % find Linear Least square mapping between two tasks.
                if (Dim(t1) > Dim(t2)) % swap t1, t2, make t1.Dim < t2.Dim
                    tt = t1; t1 = t2; t2 = tt;
                    pp = p1; p1 = p2; p2 = pp;
                end

                % map t1 to t2 (low to high dim)
                [m1, m2] = Algo.mapping(M{t1}, M{t2});
                temp_offspring.Dec = population(p1).Dec * m1;
                % crossover
                [offspring(count).Dec, offspring(count + 1).Dec] = GA_Crossover(temp_offspring.Dec, population(p2).Dec, Algo.MuC);
                % mutation
                offspring(count).Dec = GA_Mutation(population(p1).Dec, Algo.MuM);
                offspring(count + 1).Dec = GA_Mutation(population(p2).Dec, Algo.MuM);
                % imitation
                p = [p1, p2];
                rand_p = p(randi(2));
                offspring(count).MFFactor = population(rand_p).MFFactor;
                if offspring(count).MFFactor == t1
                    offspring(count).Dec = offspring(count).Dec * m2;
                end
                rand_p = p(randi(2));
                offspring(count + 1).MFFactor = population(rand_p).MFFactor;
                if offspring(count + 1).MFFactor == t1
                    offspring(count + 1).Dec = offspring(count + 1).Dec * m2;
                end
            end
            for x = count:count + 1
                offspring(x).Dec(offspring(x).Dec > 1) = 1;
                offspring(x).Dec(offspring(x).Dec < 0) = 0;
            end
            count = count + 2;
        end
    end

    function [m1, m2] = mapping(Algo, a, b)
        m1 = (inv(transpose(a) * a)) * (transpose(a) * b);
        m2 = transpose(m1) * (inv(m1 * transpose(m1)));
    end
end
end
