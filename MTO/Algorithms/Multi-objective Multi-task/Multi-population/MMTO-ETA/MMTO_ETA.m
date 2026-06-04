classdef MMTO_ETA < Algorithm
% <Multi-task> <Multi-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Zhang2026MMTO-ETA
%   title   = {Ensemble of Transfer Techniques via Adaptive Resource Allocation for Multiobjective Multitask Optimization},
%   author  = {Zhang, Tingyu and Huang, Kuihua and Wu, Xinyi and Li, Yanchi and Liu, Jianfeng and Li, Shuijia and Gong, Wenyin},
%   journal = {IEEE Transactions on Artificial Intelligence},
%   year    = {2026},
%   pages   = {1-13},
%   doi     = {10.1109/TAI.2026.3689513},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, ACM Trans. Evol. Learn. Optim., 2026"
%--------------------------------------------------------------------------

properties (SetAccess = private)
    K = 5
    Tau = 0.2
    Alpha = 0.3
    Fim = 0.3
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'K', num2str(Algo.K), ...
                'Tau', num2str(Algo.Tau), ...
                'Alpha', num2str(Algo.Alpha) ...
                'Fim', num2str(Algo.Fim)};
    end

    function setParameter(Algo, Parameter)
        i = 1;
        Algo.K = str2double(Parameter{i}); i = i + 1;
        Algo.Tau = str2double(Parameter{i}); i = i + 1;
        Algo.Alpha = str2double(Parameter{i}); i = i + 1;
        Algo.Fim = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialize
        population = Initialization(Algo, Prob, Individual_ETA);
        for t = 1:Prob.T
            [population{t}, Fitness{t}] = Selection_SPEA2(population{t}, Prob.N);
            for i = 1:Prob.N
                population{t}(i).F = Algo.Fim + rand();
                population{t}(i).CR = rand();
            end
            rwd{t} = zeros();
            rwd_history{t} = []; % Initialize rwd history for each task
            pro_history{t} = []; % Initialize pro history for each task
        end

        while Algo.notTerminated(Prob, population)
            for t = 1:Prob.T
                [~, rank{t}] = sort(Fitness{t});
                [~, rank{t}] = sort(rank{t});
                [Model{t}, partition] = Algo.LPCA(population{t}, Prob.M(t), Algo.K);
                for i = 1:Prob.N
                    population{t}(i).CId = partition(i);
                    population{t}(i).S = [];
                end
                % Calculate the selection probability
                if Algo.FE <= 0.02 * Prob.maxFE
                    % Stage 1: Evolution stage
                    pro{t} = 1/3 * ones(1, 3);
                else
                    % Stage 2: Competition stage
                    if sum(rwd{t}) ~= 0
                        pro{t} = Algo.Alpha .* pro{t} + (1 - Algo.Alpha) * rwd{t} ./ sum(rwd{t});
                        pro{t} = pro{t} ./ sum(pro{t});
                    else
                        pro{t} = 1/3 * ones(1, 3);
                    end
                end
            end

            for t = 1:Prob.T
                % Generation
                offspring = Algo.Generation(population, Prob, Model, t, rank{t}, pro{t});
                offspring = Algo.Evaluation(offspring, Prob, t);
                population{t} = [population{t}, offspring];
                [population{t}, Fitness{t}, Next] = Selection_SPEA2(population{t}, Prob.N);
                allStrategies = [offspring.S];

                % Count the total number of individuals for each strategy
                strategyCounts = histcounts(allStrategies, 1:4);
                % Get the indices of surviving individuals
                survivedIndices = Next(Prob.N + 1:end); % Survival status of the offspring part

                % Get the strategy numbers of surviving individuals
                survivedStrategies = allStrategies(survivedIndices);
                % Count the number of each strategy among the surviving individuals
                survivedCounts = histcounts(survivedStrategies, 1:4);
                rwd{t} = rwd{t} + survivedCounts ./ strategyCounts;
                rwd_history{t} = [rwd_history{t}; rwd{t}];
                pro_history{t} = [pro_history{t}; pro{t}];
            end
        end
    end

    function offspring = Generation(Algo, population, Prob, Model, t, R, pro)
        for i = 1:length(population{t})
            offspring(i) = population{t}(i);
            % Parameter disturbance
            offspring(i).F = normrnd(population{t}(i).F, 0.1);
            offspring(i).F = min(max(offspring(i).F, Algo.Fim), 1 + Algo.Fim);
            offspring(i).CR = normrnd(population{t}(i).CR, 0.1);
            offspring(i).CR = min(max(offspring(i).CR, 0), 1);

            % Parameter mutation
            if rand() < Algo.Tau
                offspring(i).F = Algo.Fim + rand();
            end
            if rand() < Algo.Tau
                offspring(i).CR = rand();
            end

            strategy = RouletteSelection(pro, 1);

            % Individual selection
            Np = length(population{t});
            x1 = randi(Np);
            while rand() > (Np - R(x1)) / Np || x1 == i
                x1 = randi(Np);
            end
            x2 = randi(Np);
            while rand() > (Np - R(x2)) / Np || x2 == i || x2 == x1
                x2 = randi(Np);
            end
            x3 = randi(Np);
            while x3 == i || x3 == x1 || x3 == x2
                x3 = randi(Np);
            end

            x1Dec = population{t}(x1).Dec;
            x2Dec = population{t}(x2).Dec;
            x3Dec = population{t}(x3).Dec;
            xiDec = population{t}(i).Dec;

            Id = population{t}(i).CId;

            k = randi(Prob.T);
            while k == t, k = randi(Prob.T); end
            kId = randi(Algo.K);
            SP = population{k}([population{k}.CId] == kId);
            Ns = length(SP);
            while isempty(Model{k}(kId).eValue) || Ns < 2
                kId = randi(Algo.K);
                SP = population{k}([population{k}.CId] == kId);
                Ns = length(SP);
            end
            if strategy == 1 && ~isempty(Model{t}(Id).eValue)
                U1 = Model{t}(Id).eVector(:, 1:Prob.M(t) - 1);
                U2 = Model{k}(kId).eVector(:, 1:Prob.M(t) - 1);
                vec = (SP(randi(Ns)).Dec - Model{k}(kId).mean) * U2 * U1' + Model{t}(Id).mean;
                X = GA_Mutation(vec, 20);
                switch randi(4)
                    case 1
                        x1Dec = X;
                    case 2
                        x2Dec = X;
                    case 3
                        xiDec = X;
                    case 4
                        x3Dec = X;
                end
                offspring(i).Dec = xiDec + offspring(i).F * (x1Dec - xiDec) + offspring(i).F * (x2Dec - x3Dec);
                offspring(i).S = 1;
            elseif strategy == 2
                vec = Model{k}(kId).mean;
                X = vec;
                switch randi(4)
                    case 1
                        x1Dec = X;
                    case 2
                        x2Dec = X;
                    case 3
                        xiDec = X;
                    case 4
                        x3Dec = X;
                end
                offspring(i).Dec = xiDec + offspring(i).F * (x1Dec - xiDec) + offspring(i).F * (x2Dec - x3Dec);
                offspring(i).S = 2;
            else
                offspring(i).Dec = x1Dec + offspring(i).F * (x2Dec - x3Dec);
                offspring(i).S = 3;
            end
            offspring(i).Dec = DE_Crossover(offspring(i).Dec, xiDec, offspring(i).CR);
            offspring(i).Dec = min(max(offspring(i).Dec, 0), 1);
            offspring(i).Dec = real(offspring(i).Dec);
        end
    end

    function [Model, partition] = LPCA(Algo, P, M, K)
        PopDec = P.Decs;
        [N, D] = size(PopDec);
        Model = struct('mean', num2cell(PopDec(1:K, :), 2), ... % The mean of the model
            'eMean', num2cell(PopDec(1:K, :), 2), ...
            'PI', eye(D), ... % The matrix PI
            'eVector', [], ... % The eigenvectors
            'eValue', [], ... % The eigenvalues
            'a', [], ... % The lower bound of the projections
            'b', []); % The upper bound of the projections
        %% Modeling
        for iter = 1:100
            distance = zeros(N, K);
            for k = 1:K
                distance(:, k) = sum((PopDec - repmat(Model(k).mean, N, 1)) * Model(k).PI .* (PopDec - repmat(Model(k).mean, N, 1)), 2);
            end
            [~, partition] = min(distance, [], 2);
            updated = false(1, K);

            for k = 1:K
                oldMean = Model(k).mean;
                current = partition == k;
                if sum(current) < 2
                    if ~any(current)
                        current = randi(N);
                    end
                    Model(k).mean = PopDec(current, :);
                    Model(k).PI = eye(D);
                    Model(k).eVector = [];
                    Model(k).eValue = [];
                else
                    Model(k).mean = mean(PopDec(current, :), 1);
                    [eVector, eValue] = eig(cov(PopDec(current, :) - repmat(Model(k).mean, sum(current), 1)));
                    [eValue, rr] = sort(diag(eValue), 'descend');
                    Model(k).eValue = real(eValue);
                    Model(k).eVector = real(eVector(:, rr));
                    Model(k).PI = Model(k).eVector(:, M:end) * Model(k).eVector(:, M:end)';
                end
                updated(k) = ~any(current) || sqrt(sum((oldMean - Model(k).mean).^2)) > 1e-5;
            end

            % Break if no change is made
            if ~any(updated)
                break;
            end
        end
    end
end
end
