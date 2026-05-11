classdef EMT_MSKT < Algorithm
% <Multi-task> <Multi-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Zhang2026EMT-MSKT,
%   title    = {Multiobjective Multitask Optimization With Manifold Structure-Driven Knowledge Transfer},
%   author   = {Zhang, Tingyu and Wu, Xinyi and Li, Yanchi and Li, Shuijia and Gong, Wenyin},
%   journal  = {IEEE Transactions on Systems, Man, and Cybernetics: Systems},
%   year     = {2026},
%   number   = {4},
%   pages    = {2426-2438},
%   volume   = {56},
%   doi      = {10.1109/TSMC.2025.3649528},
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
    KTP = 0.5
    Tau = 0.2
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'K', num2str(Algo.K), ...
                'KTP', num2str(Algo.KTP), ...
                'Tau', num2str(Algo.Tau)};
    end

    function setParameter(Algo, Parameter)
        i = 1;
        Algo.K = str2double(Parameter{i}); i = i + 1;
        Algo.KTP = str2double(Parameter{i}); i = i + 1;
        Algo.Tau = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialize
        population = Initialization(Algo, Prob, Individual_MSKT);
        Model = cell(1, Prob.T); partition = cell(1, Prob.T); ktp = cell(1, Prob.T);
        Fitness = cell(1, Prob.T); rank = cell(1, Prob.T); ElitPop = cell(1, Prob.T);
        Sim = cell(Prob.T, Prob.T); Select = cell(Prob.T, Prob.T);
        for t = 1:Prob.T
            [population{t}, Fitness{t}] = Selection_SPEA2(population{t}, Prob.N);
            for i = 1:Prob.N
                population{t}(i).F = 0.2 + rand();
                population{t}(i).CR = rand();
            end
            ktp{t} = Algo.KTP;
        end

        while Algo.notTerminated(Prob, population)
            for t = 1:Prob.T
                [~, rank{t}] = sort(Fitness{t});
                [~, rank{t}] = sort(rank{t});
                M = Prob.M(t);
                [Model{t}, partition{t}] = Algo.LPCA(population{t}, M, Algo.K, rank{t});
                for i = 1:Prob.N
                    population{t}(i).CId = partition{t}(i);
                end
                ElitPop{t} = population{t}(rank{t} <= 50);
            end

            for t = 1:Prob.T
                for i = 1:Algo.K
                    for k = 1:Prob.T
                        if k == t
                            continue
                        end
                        for j = 1:Algo.K
                            if isempty(Model{t}(i).eVector) || isempty(Model{k}(j).eVector)
                                Sim{t, k}(i, j) = 1e1;
                            else
                                Sim{t, k}(i, j) = Algo.calculate_distances(Model{t}(i).eVector(:, 1:Prob.M(t) - 1), Model{k}(j).eVector(:, 1:Prob.M(k) - 1));
                            end
                        end
                    end
                end
            end

            for t = 1:Prob.T
                for i = 1:Algo.K
                    for k = 1:Prob.T
                        if k == t
                            continue
                        end
                        a = max(Sim{t, k}(i, :), eps);
                        a = (a - min(a)) ./ (max(a) - min(a) + eps);
                        probabilities = exp(-a) / sum(exp(-a));
                        Select{t, k}(i, :) = cumsum(probabilities);
                    end
                end
            end

            for t = 1:Prob.T
                % Generation
                offspring = Algo.Generation(population, Prob, Model, t, partition, ktp, rank{t}, Select);
                k = randi(Prob.T);
                while k == t, k = randi(Prob.T); end
                d1 = mean(ElitPop{t}.Decs, 1); d2 = mean(population{t}.Decs, 1);
                d3 = mean(ElitPop{k}.Decs, 1); d4 = mean(population{k}.Decs, 1);
                ds = d3 - d4;
                source_mean = population{k}.Decs - repmat(d4, Prob.N, 1);
                target_mean = population{t}.Decs - repmat(d2, Prob.N, 1);
                [Qs, ~, lamda_s] = pca(source_mean);
                [Qt, ~, lamda_t] = pca(target_mean);
                alpha = lamda_t(1) / lamda_s(1);
                sd = alpha * ds * Qs * Qt';
                vec = sd + d2;
                vec = real(vec);
                vec = max(0, min(1, vec));
                offspring(randi(Prob.N)).Dec = vec;
                offspring = Algo.Evaluation(offspring, Prob, t);
                population{t} = [population{t}, offspring];
                % Selection
                [population{t}, Fitness{t}] = Selection_SPEA2(population{t}, Prob.N);
            end
        end
    end

    function offspring = Generation(Algo, population, Prob, Model, t, partition, KTP, R, Select)
        for i = 1:length(population{t})
            offspring(i) = population{t}(i);
            % Parameter disturbance
            offspring(i).F = normrnd(population{t}(i).F, 0.1);
            offspring(i).F = min(max(offspring(i).F, 0.2), 1.2);
            offspring(i).CR = normrnd(population{t}(i).CR, 0.1);
            offspring(i).CR = min(max(offspring(i).CR, 0), 1);

            % Parameter mutation
            if rand() < Algo.Tau
                offspring(i).F = 0.2 + rand();
            end
            if rand() < Algo.Tau
                offspring(i).CR = rand();
            end

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

            Id = partition{t}(i);
            k = randi(Prob.T);
            while k == t, k = randi(Prob.T); end
            kId = find(rand() <= Select{t, k}(Id, :), 1);
            while isempty(kId) || isempty(Model{k}(kId).eMean) || isempty(Model{k}(kId).eValue)
                kId = find(rand() <= Select{t, k}(Id, :), 1);
            end
            current1 = partition{t} == Id;
            current2 = partition{k} == kId;
            if rand() < KTP{t} && ~isempty(Model{t}(Id).eMean) && ~isempty(Model{t}(Id).eValue)
                Xs = Algo.Trans(Prob, Model, t, k, Id, kId);
                pp1 = population{t}(current1);
                if length(pp1) < 2
                    pp1 = population{t};
                end
                pp1 = pp1(randperm(length(pp1), 2));
                Xp = GA_Mutation(rand() * (pp1(1).Dec - pp1(2).Dec), 20);
                X = Xs + Xp;
                pp = [population{t}(current1), population{k}(current2)];
                pp = pp(randperm(length(pp), 2));
                x2Dec = pp(1).Dec;
                x3Dec = pp(2).Dec;
                offspring(i).Dec = xiDec + offspring(i).F * (x2Dec - x3Dec) + ...
                    offspring(i).F * (X - xiDec);
            else
                offspring(i).Dec = x1Dec + offspring(i).F * (x2Dec - x3Dec);
            end
            offspring(i).Dec = DE_Crossover(offspring(i).Dec, xiDec, offspring(i).CR);
            offspring(i).Dec = min(max(offspring(i).Dec, 0), 1);
            idx = find(isnan(offspring(i).Dec));
            offspring(i).Dec(idx) = rand(1, length(idx));
            offspring(i).Dec = real(offspring(i).Dec);
        end
    end

    function [Model, partition] = LPCA(Algo, P, M, K, R)
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
        for iter = 1:50
            % Calculte the distance between each solution and its projection in
            % affine principal subspace of each cluster
            distance = zeros(N, K);
            for k = 1:K
                distance(:, k) = sum((PopDec - repmat(Model(k).mean, N, 1)) * Model(k).PI .* (PopDec - repmat(Model(k).mean, N, 1)), 2);
            end
            % CIdition
            [~, partition] = min(distance, [], 2);
            % Update the model of each cluster
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

        for k = 1:K
            kk = partition == k;
            if sum(kk) < 1
                Model(k).eMean = [];
            else
                cc = find(kk);
                cc_rank = R(kk);
                Ecc = cc_rank < 50;
                Ecc = cc(Ecc);
                if length(Ecc) >= 1
                    Model(k).eMean = mean(PopDec(Ecc, :), 1);
                else
                    Model(k).eMean = [];
                end
            end
        end
    end

    function trans = Trans(Algo, Prob, Model, t, k, i, j)
        Mt = Prob.M(t);
        d1 = Model{t}(i).eMean; d2 = Model{t}(i).mean;
        d3 = Model{k}(j).eMean; d4 = Model{k}(j).mean;
        ds = d3 - d4;
        sd = ds .* Model{t}(i).eValue(1) ./ Model{k}(j).eValue(1);
        trans = d2 + sd * Model{k}(j).eVector(:, 1:Mt - 1) * Model{t}(i).eVector(:, 1:Mt - 1)';
    end

    function distances = calculate_distances(Algo, A, B)
        [~, nA] = size(A);
        [~, nB] = size(B);
        if nA == 1 && nB == 2
            A_expanded = repmat(A, 1, 2);
            diff = A_expanded - B;
            distances = sum(sqrt(sum(diff.^2)));
        elseif nA == 2 && nB == 1
            B_expanded = repmat(B, 1, 2);
            diff = B_expanded - A;
            distances = sum(sqrt(sum(diff.^2)));
        elseif nA == 2 && nB == 2
            diff = A - B;
            distances = sum(sqrt(sum(diff.^2)));
        else
            distances = sqrt(sum((A - B).^2));
        end
    end
end
end
