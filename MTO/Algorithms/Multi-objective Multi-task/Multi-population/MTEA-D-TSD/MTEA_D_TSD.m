classdef MTEA_D_TSD < Algorithm
% <Multi-task> <Multi-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @InProceedings{Li2024MTEA-D-TSD,
%   title     = {Transfer Search Directions Among Decomposed Subtasks for Evolutionary Multitasking in Multiobjective Optimization},
%   author    = {Li, Yanchi and Gong, Wenyin and Gu, Qiong},
%   booktitle = {Proceedings of the Genetic and Evolutionary Computation Conference},
%   year      = {2024},
%   address   = {New York, NY, USA},
%   pages     = {557–565},
%   publisher = {Association for Computing Machinery},
%   series    = {GECCO '24},
%   doi       = {10.1145/3638529.3653989},
%   isbn      = {9798400704949},
%   location  = {Melbourne, VIC, Australia},
%   numpages  = {9},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties (SetAccess = public)
    TR0 = 0.2
    CF = 0.4
    SNum = 10
    Delta = 0.9
    NR = 2
    F = 0.5
    CR = 0.9
    MuM = 15
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'TR0: Initial transfer rate', num2str(Algo.TR0), ...
                'CF: Cumulative factor', num2str(Algo.CF), ...
                'SNum: Sample number', num2str(Algo.SNum), ...
                'Delta: Probability of choosing parents locally', num2str(Algo.Delta), ...
                'NR: Maximum number of solutions replaced by each offspring', num2str(Algo.NR), ...
                'F:Mutation Factor', num2str(Algo.F), ...
                'CR: Crossover Rate', num2str(Algo.CR), ...
                'MuM: Polynomial Mutation', num2str(Algo.MuM)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.TR0 = str2double(Parameter{i}); i = i + 1;
        Algo.CF = str2double(Parameter{i}); i = i + 1;
        Algo.SNum = str2double(Parameter{i}); i = i + 1;
        Algo.Delta = str2double(Parameter{i}); i = i + 1;
        Algo.NR = str2double(Parameter{i}); i = i + 1;
        Algo.F = str2double(Parameter{i}); i = i + 1;
        Algo.CR = str2double(Parameter{i}); i = i + 1;
        Algo.MuM = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialize
        maxD = max(Prob.D);
        for t = 1:Prob.T
            % Generate the weight vectors
            [W{t}, N(t)] = UniformPoint(Prob.N, Prob.M(t));
            DT(t) = ceil(N(t) / 10);

            % Detect the neighbours of each solution
            B{t} = pdist2(W{t}, W{t});
            [~, B{t}] = sort(B{t}, 2);
            B{t} = B{t}(:, 1:DT(t));

            population{t} = Initialization_One(Algo, Prob, t, Individual_TSD, N(t));
            for i = 1:N(t)
                population{t}(i).SD = zeros(1, maxD);
                population{t}(i).TR = Algo.TR0;
            end
            Z{t} = min(population{t}.Objs, [], 1);
            if N(t) < Prob.N % Fill population
                population{t}(N(t) + 1:Prob.N) = population{t}(1:Prob.N - N(t));
            end
        end
        trans_flag = false;
        History_Matrix = zeros(sum(N));

        while Algo.notTerminated(Prob, population)
            if ~trans_flag && Algo.FE > 0.1 * Prob.maxFE && Algo.TR0 > 0
                % Start knowledge transfer
                for t = 1:Prob.T
                    for i = 1:N(t)
                        for j = 1:DT(t)
                            % Initialize search direction neighbors
                            [k, jj] = Algo.SourceSelect(population{t}(i).SD, population, Prob.T, N);
                            SD_B{t, i}(j, :) = [k, jj]; % search-direction-neiborhood (task, index)
                            RD_B{t, i}(j) = 1; % success record of search-direction-neiborhood
                        end
                    end
                end
                trans_flag = true;
            end

            old_pop = population;
            for t = randperm(Prob.T)
                for i = randperm(N(t))
                    PL = B{t}(i, randperm(end));
                    PG = randperm(N(t));
                    if rand() < Algo.Delta
                        P = PL;
                    else
                        P = PG;
                    end

                    flag = false;
                    if trans_flag && rand() < population{t}(i).TR
                        flag = true;
                        % select a search-direction-neighbor
                        idx = randi(DT(t));
                        selected = SD_B{t, i}(idx, :);
                        k = selected(1); j = selected(2);
                        % search-direction transfer
                        sd = population{k}(j).SD ./ norm(population{k}(j).SD) .* norm(population{t}(i).SD);
                        offspring = Algo.Transfer(population{t}(i), sd);
                    else
                        if rand() < 0.5
                            offspring = Algo.Generation(population{t}([i, P(1:2)]));
                        else
                            offspring = Algo.Generation([population{t}([i, P(1)]), old_pop{t}(P(2))]);
                        end
                    end

                    offspring = Algo.Evaluation(offspring, Prob, t);
                    Z{t} = min(Z{t}, offspring.Obj);
                    % Tchebycheff approach
                    g_old = max(abs(population{t}(P).Objs - repmat(Z{t}, length(P), 1)) .* W{t}(P, :), [], 2);
                    g_new = max(repmat(abs(offspring.Obj - Z{t}), length(P), 1) .* W{t}(P, :), [], 2);

                    CVO = offspring.CV;
                    CVP = population{t}(P).CVs;
                    replace = P(find(g_old >= g_new & CVP == CVO | CVP > CVO, Algo.NR));
                    population{t}(replace) = offspring;

                    if flag && ~isempty(replace) % Successful transfer
                        % Increase transfer rate of the target subtask
                        population{t}(i).TR = min(0.5, population{t}(i).TR * 1.1);
                        % Record the success of the transferred source subtask
                        RD_B{t, i}(idx) = RD_B{t, i}(idx) + 1;
                        % Record the success history matrix
                        History_Matrix(sum(N(1:t - 1)) + i, sum(N(1:k - 1)) + j) = ...
                            History_Matrix(sum(N(1:t - 1)) + i, sum(N(1:k - 1)) + j) + 1;
                    elseif flag && isempty(replace) % Failed transfer
                        % Decrease transfer rate of the target subtask
                        population{t}(i).TR = population{t}(i).TR * 0.9 + Algo.TR0 / 2 * 0.1;
                        % Record the fail of the transferred source subtask
                        RD_B{t, i}(idx) = RD_B{t, i}(idx) - 1;
                        % Re-initialize this search-direction-neighbor
                        if RD_B{t, i}(idx) <= 0
                            [k, jj] = Algo.SourceSelect(population{t}(i).SD, population, Prob.T, N);
                            SD_B{t, i}(idx, :) = [k, jj];
                            RD_B{t, i}(idx) = 1;
                        end
                    end
                end
                if N(t) < Prob.N % Fill population
                    population{t}(N(t) + 1:Prob.N) = population{t}(1:Prob.N - N(t));
                end
            end

            for t = 1:Prob.T
                % Update success search direction
                for i = 1:N(t)
                    variation = population{t}(i).Dec - old_pop{t}(i).Dec;
                    if ~all(variation == 0)
                        population{t}(i).SD = Algo.CF * population{t}(i).SD + ...
                            (1 - Algo.CF) * (variation);
                    end
                end
            end
        end
    end

    function [k, jj] = SourceSelect(Algo, self_sd, population, T, N)
        % Source search-direction-neighbor selection based on cosine similarity
        index = [];
        for i = 1:Algo.SNum
            index(i, 1) = randi(T);
            index(i, 2) = randi(N(index(i, 1)));
            search_dir = population{index(i, 1)}(index(i, 2)).SD;
            cosine_sim(i) = dot(self_sd, search_dir) / (norm(self_sd) * norm(search_dir));
        end
        cosine_sim(cosine_sim == 1) = -1;
        [~, idx] = max(cosine_sim);
        k = index(idx, 1);
        jj = index(idx, 2);
    end

    function offspring = Transfer(Algo, population, search_dir)
        offspring = population(1);
        offspring.Dec = population(1).Dec + 2 * rand() * search_dir;
        offspring.Dec = min(max(offspring.Dec, 0), 1);
    end

    function offspring = Generation(Algo, population)
        offspring = population(1);
        offspring.Dec = population(1).Dec + Algo.F * (population(2).Dec - population(3).Dec);
        offspring.Dec = DE_Crossover(offspring.Dec, population(1).Dec, Algo.CR);
        offspring.Dec = GA_Mutation(offspring.Dec, Algo.MuM);
        offspring.Dec = min(max(offspring.Dec, 0), 1);
    end
end
end
