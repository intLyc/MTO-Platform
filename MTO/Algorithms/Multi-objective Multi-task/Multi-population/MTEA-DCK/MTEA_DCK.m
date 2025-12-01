classdef MTEA_DCK < Algorithm
% <Multi-task/Many-task> <Multi-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Li2025MTEA-DCK,
%   title      = {Multiobjective Multitask Optimization via Diversity- and Convergence-Oriented Knowledge Transfer},
%   author     = {Li, Yanchi and Li, Dongcheng and Gong, Wenyin and Gu, Qiong},
%   journal    = {IEEE Transactions on Systems, Man, and Cybernetics: Systems},
%   year       = {2025},
%   number     = {3},
%   pages      = {2367-2379},
%   volume     = {55},
%   doi        = {10.1109/TSMC.2024.3520526},
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
    Tau = 0.1
    TRC0 = 0.3
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'Tau', num2str(Algo.Tau), ...
                'TRC0', num2str(Algo.TRC0)};
    end

    function Algo = setParameter(Algo, Parameter)
        Algo.Tau = str2double(Parameter{1});
        Algo.TRC0 = str2double(Parameter{2});
    end

    function run(Algo, Prob)
        % Initialization
        population = Initialization(Algo, Prob, Individual_DCK);
        for t = 1:Prob.T
            [population{t}, Fitness{t}] = Selection_SPEA2(population{t}, Prob.N);
            for i = 1:Prob.N
                population{t}(i).V = zeros(size(population{t}(i).Dec));
                population{t}(i).F = rand();
                population{t}(i).CR = rand();
                population{t}(i).TRD = rand(); % Transfer rate of Diversified KT
            end
        end

        while Algo.notTerminated(Prob, population)
            for t = 1:Prob.T
                % Determine the losers and winners
                rnd_idx = randperm(Prob.N);
                loser{t} = rnd_idx(1:end / 2);
                winner{t} = rnd_idx(end / 2 + 1:end);
                replace = Fitness{t}(winner{t}) > Fitness{t}(loser{t}); % ATRDeady Sorted
                temp = loser{t}(replace);
                loser{t}(replace) = winner{t}(replace);
                winner{t}(replace) = temp;
                % Winner regions for DKT
                UniUpperB{t} = max(population{t}(winner{t}).Decs);
                UniLowerB{t} = min(population{t}(winner{t}).Decs);
            end

            for t = 1:Prob.T
                % DE Generation with Diversity Oriented Knowledge Transfer
                offspring_DE = Algo.Generation_DE(population, winner, loser, t, UniUpperB, UniLowerB);
                offspring_DE = Algo.Evaluation(offspring_DE, Prob, t);

                % CSO Generation with Convergence Oriented Knowledge Transfer
                offspring_CSO = Algo.Generation_CSO(population, winner, loser, t, Algo.FE / Prob.maxFE);
                offspring_CSO = Algo.Evaluation(offspring_CSO, Prob, t);

                % Selection
                population{t} = [population{t}, offspring_DE, offspring_CSO];
                [population{t}, Fitness{t}] = Selection_SPEA2(population{t}, Prob.N);
            end
        end
    end

    function [offspring, flag] = Generation_DE(Algo, population, winner, loser, t, uni_up, uni_low)
        union = [winner{t}, loser{t}];
        task_pool = 1:length(population);
        task_pool(task_pool == t) = [];

        flag = zeros(1, length(loser{t}));
        for i = 1:length(winner{t})
            offspring(i) = population{t}(winner{t}(i));

            % Parameter disturbance
            offspring(i).F = cauchyrnd(population{t}(winner{t}(i)).F, 0.1);
            while (offspring(i).F <= 0)
                offspring(i).F = cauchyrnd(population{t}(winner{t}(i)).F, 0.1);
            end
            offspring(i).F = min(1, offspring(i).F);
            offspring(i).CR = normrnd(population{t}(winner{t}(i)).CR, 0.1);
            offspring(i).CR = max(0, min(1, offspring(i).CR));
            offspring(i).TRD = normrnd(population{t}(winner{t}(i)).TRD, 0.1);
            offspring(i).TRD = max(0, min(1, offspring(i).TRD));

            % Parameter mutation
            if rand() < Algo.Tau
                offspring(i).F = rand();
            end
            if rand() < Algo.Tau
                offspring(i).CR = rand();
            end
            if rand() < Algo.Tau
                offspring(i).TRD = rand();
            end

            x1 = randi(length(winner{t}));
            while x1 == i
                x1 = randi(length(winner{t}));
            end
            x2 = randi(length(winner{t}));
            while x2 == i || x2 == x1
                x2 = randi(length(winner{t}));
            end
            x3 = randi(length(union));
            while x3 == i || x3 == x1 || x3 == x2
                x3 = randi(length(union));
            end

            % Mutation
            if rand() < offspring(i).TRD % Diversified Knowledge transfer
                flag(i) = 3;
                % Select source task
                k = task_pool(randi(length(task_pool)));
                % Diversified knowledge
                diverDec = population{k}(winner{k}(x1)).Dec;
                diverV = population{k}(winner{k}(x1)).V;
                % Particle reversal
                if rand() < 0.5
                    diverDec = (uni_low{k} + uni_up{k}) - diverDec;
                    diverV = -diverV;
                end
                % Region mapping
                diverDec = (diverDec - uni_low{k}) ./ (uni_up{k} - uni_low{k}) ...
                    .* (uni_up{t} - uni_low{t}) + uni_low{t};
                diverDec = GA_Mutation(diverDec, 20);
                diverV = diverV ./ (uni_up{k} - uni_low{k}) .* (uni_up{t} - uni_low{t});

                offspring(i).Dec = diverDec + ...
                    offspring(i).F * (population{t}(winner{t}(x1)).Dec - diverDec) + ...
                    offspring(i).F * (population{t}(winner{t}(x2)).Dec - population{t}(union(x3)).Dec);
                offspring(i).V = diverV + ...
                    offspring(i).F * (population{t}(winner{t}(x1)).V - diverV) + ...
                    offspring(i).F * (population{t}(winner{t}(x2)).V - population{t}(union(x3)).V);
            else
                flag(i) = 4;
                offspring(i).Dec = population{t}(winner{t}(i)).Dec + ...
                    offspring(i).F * (population{t}(winner{t}(x1)).Dec - population{t}(winner{t}(i)).Dec) + ...
                    offspring(i).F * (population{t}(winner{t}(x2)).Dec - population{t}(union(x3)).Dec);
                offspring(i).V = population{t}(winner{t}(i)).V + ...
                    offspring(i).F * (population{t}(winner{t}(x1)).V - population{t}(winner{t}(i)).V) + ...
                    offspring(i).F * (population{t}(winner{t}(x2)).V - population{t}(union(x3)).V);
            end

            % Crossover
            temp = DE_Crossover([offspring(i).Dec; offspring(i).V], ...
                [population{t}(winner{t}(i)).Dec; population{t}(winner{t}(i)).V], offspring(i).CR);
            offspring(i).Dec = temp(1, :);
            offspring(i).V = temp(2, :);

            % Boundary check
            rnd_lower = 0 + rand(size(population{t}(winner{t}(i)).Dec)) .* (population{t}(winner{t}(i)).Dec - 0);
            vio_low = find(offspring(i).Dec < 0);
            offspring(i).Dec(vio_low) = rnd_lower(vio_low);
            rnd_upper = population{t}(winner{t}(i)).Dec + rand(size(population{t}(winner{t}(i)).Dec)) .* (1 - population{t}(winner{t}(i)).Dec);
            vio_up = find(offspring(i).Dec > 1);
            offspring(i).Dec(vio_up) = rnd_upper(vio_up);
            offspring(i).Dec = real(max(0, min(1, offspring(i).Dec)));
        end
    end

    function [offspring, flag] = Generation_CSO(Algo, population, winner, loser, t, factor)
        task_pool = 1:length(population);
        task_pool(task_pool == t) = [];
        TRC = Algo.TRC0 * ((1 - factor)^2); % Transfer rate of convergent KT

        flag = zeros(1, length(loser{t}));
        for i = 1:length(loser{t})
            offspring(i) = population{t}(loser{t}(i));

            % Parameter learning
            offspring(i).F = population{t}(winner{t}(i)).F;
            offspring(i).CR = population{t}(winner{t}(i)).CR;
            offspring(i).TRD = population{t}(winner{t}(i)).TRD;

            % Velocity update
            if rand() < TRC % Convergent Knowledge transfer
                flag(i) = 1;
                % Select source task
                k = task_pool(randi(length(task_pool)));
                % Convergent knowledge
                converDec = population{k}(winner{k}(randi(length(winner{k})))).Dec;
                % Fragment swap
                rand_idx = rand(size(converDec)) < rand();
                converDec(rand_idx) = population{t}(winner{t}(i)).Dec(rand_idx);
                offspring(i).V = rand() .* population{t}(loser{t}(i)).V + ...
                    rand() .* (converDec - population{t}(loser{t}(i)).Dec);
            else
                flag(i) = 2;
                offspring(i).V = rand() .* population{t}(loser{t}(i)).V + ...
                    rand() .* (population{t}(winner{t}(i)).Dec - population{t}(loser{t}(i)).Dec);
            end
            % Position update
            offspring(i).Dec = population{t}(loser{t}(i)).Dec + offspring(i).V;

            % Boundary check
            rnd_lower = 0 + rand(size(population{t}(loser{t}(i)).Dec)) .* (population{t}(loser{t}(i)).Dec - 0);
            vio_low = find(offspring(i).Dec < 0);
            offspring(i).Dec(vio_low) = rnd_lower(vio_low);
            rnd_upper = population{t}(loser{t}(i)).Dec + rand(size(population{t}(loser{t}(i)).Dec)) .* (1 - population{t}(loser{t}(i)).Dec);
            vio_up = find(offspring(i).Dec > 1);
            offspring(i).Dec(vio_up) = rnd_upper(vio_up);
            offspring(i).Dec = real(max(0, min(1, offspring(i).Dec)));
        end
    end
end
end
