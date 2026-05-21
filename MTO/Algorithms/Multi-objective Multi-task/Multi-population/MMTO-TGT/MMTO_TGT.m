classdef MMTO_TGT < Algorithm
% <Multi-task/Many-task> <Multi-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Zhang2026MMTO-TGT,
%   title    = {Topology-Guided Knowledge Transfer for Multiobjective Multitask Optimization},
%   author   = {Zhang, Tingyu and Wu, Xinyi and Gong, Wenyin and Li, Shuijia and Li, Yanchi and Qin, A. K.}
%   journal  = {IEEE Transactions on Evolutionary Computation},
%   year     = {2026},
%   doi      = {10.1109/TEVC.2026.3696355},
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
    Tau = 0.1
    H = 8
    KP = 0.15
    Alpha = 0.6
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'Tau', num2str(Algo.Tau), ...
                'H', num2str(Algo.H), ...
                'KP', num2str(Algo.KP), ...
                'Alpha', num2str(Algo.Alpha)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.Tau = str2double(Parameter{i}); i = i + 1;
        Algo.H = str2double(Parameter{i}); i = i + 1;
        Algo.KP = str2double(Parameter{i}); i = i + 1;
        Algo.Alpha = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialization
        population = Initialization(Algo, Prob, Individual_DE);
        for t = 1:Prob.T
            [population{t}, Fitness{t}] = Selection_SPEA2(population{t}, Prob.N);
            archive{t} = Individual_DE.empty();
            for i = 1:Prob.N
                population{t}(i).F = rand() + 0.2;
                population{t}(i).CR = rand();
            end
            RMP(t) = Algo.KP;
            imp_1{t} = 0;
            dec_1{t} = 0;
            N_1{t} = 0;
            imp_2{t} = 0;
            dec_2{t} = 0;
            N_2{t} = 0;
            contri_1{t} = 0;
            contri_2{t} = 0;
        end

        while Algo.notTerminated(Prob, population)
            % dbstop if all error
            for t = 1:Prob.T
                N = Prob.N;
                N2 = ceil(sqrt(N));
                k = randi(length(population)); % help task
                while (k == t), k = randi(length(population)); end
                if rand < RMP(t)
                    if Prob.M(t) == 2
                        msize = [N 1];
                    else
                        msize = [N2 N2];
                    end
                    P1 = population{t}(1:Prob.N / 2);
                    P2 = population{k}(1:Prob.N / 2);
                    sMap{t} = som_randinit([P1.Decs; P2.Decs], 'msize', msize);
                    sMap{t} = som_batchtrain(sMap{t}, [P1.Decs; P2.Decs], 'radius', [1, 0.8, 0.5, 0.3, 0.2, 0.1], 'trainlen', 6, 'neigh', 'gaussian');
                    NeighMat{t} = som_neighbors(sMap{t}, Algo.H);
                    Bestmu{t} = som_bmus(sMap{t}, [P1.Decs; P2.Decs]);
                    flag{t} = 1;
                else
                    flag{t} = -1;
                end
            end
            for t = 1:Prob.T
                if flag{t} == 1
                    offspring{t} = Algo.Transfer(Prob, population, t, sMap, NeighMat, Bestmu);
                else
                    offspring{t} = Algo.Generate(Prob, population, archive, Fitness, t);
                end
            end

            for t = 1:Prob.T
                if flag{t} == -1
                    offspring{t} = Algo.Evaluation(offspring{t}, Prob, t);
                    population{t} = [population{t}, offspring{t}];
                    temp_p = population{t};
                    [population{t}, Fitness{t}, Next, Fitall{t}] = Selection_SPEA2(population{t}, Prob.N);
                    archive{t} = [archive{t}, temp_p(~Next)];
                    if length(archive{t}) > round(2 * length(population{t}))
                        archive{t} = archive{t}(randperm(length(archive{t}), round(2 * length(population{t}))));
                    end
                    A = (Fitall{t} - min(Fitall{t})) ./ (max(Fitall{t}) - min(Fitall{t}));
                    % Calculate the contribution of hypervolume of each solution
                    PopObj = temp_p.Objs;
                    B = Algo.CalHV(PopObj, max(PopObj, [], 1) * 1.1, 1, 10000);
                    temp_A = max(A(1:Prob.N) - A(Prob.N + 1:end), 0);
                    B = B ./ (max(B) + eps);
                    imp_1{t} = imp_1{t} + sum(temp_A) + sum(B);
                    N_1{t} = N_1{t} + Prob.N;
                else
                    population{t} = [population{t}, offspring{t}];
                    temp_p = population{t};
                    [population{t}, Fitness{t}, Next, Fitall{t}] = Selection_SPEA2(population{t}, Prob.N);
                    A = (Fitall{t} - min(Fitall{t})) ./ (max(Fitall{t}) - min(Fitall{t}));
                    PopObj = temp_p.Objs;
                    B = Algo.CalHV(PopObj, max(PopObj, [], 1) * 1.1, 1, 10000);
                    temp_A = max(A(1:Prob.N) - A(Prob.N + 1:end), 0);
                    B = B ./ (max(B) + eps);
                    imp_2{t} = imp_2{t} + sum(temp_A) + sum(B);
                    N_2{t} = N_2{t} + Prob.N;
                end
                if N_2{t} > 0 && Algo.Gen > (Prob.maxFE / (Prob.T * Prob.N)) * 0.1
                    a = imp_1{t} / N_1{t};
                    b = imp_2{t} / N_2{t};
                    contri_1{t} = Algo.Alpha * contri_1{t} + (1 - Algo.Alpha) * (a / (a + b));
                    contri_2{t} = Algo.Alpha * contri_2{t} + (1 - Algo.Alpha) * (b / (a + b));
                    RMP(t) = RMP(t) + 0.1 * (contri_2{t} / (contri_1{t} + contri_2{t}) - 0.5);
                end
                RMP(t) = max(min(RMP(t), 0.5), 0.1);
            end
        end
    end
    function offspring = Generate(Algo, Prob, population, archive, fitness, t)
        [~, rank] = sort(fitness{t});
        [~, rank] = sort(rank);
        offspring = population{t};
        for i = 1:Prob.N
            % Parameter disturbance
            offspring(i).F = cauchyrnd(population{t}(i).F, 0.1);
            while (offspring(i).F <= 0.2)
                offspring(i).F = cauchyrnd(population{t}(i).F, 0.1);
            end
            offspring(i).F(offspring(i).F > 1.2) = 1.2;
            offspring(i).CR = normrnd(population{t}(i).CR, 0.1);
            offspring(i).CR(offspring(i).CR > 1) = 1;
            offspring(i).CR(offspring(i).CR < 0) = 0;
            % Parameter mutation
            if rand() < Algo.Tau
                offspring(i).F = rand() + 0.2;
            end
            if rand() < Algo.Tau
                offspring(i).CR = rand();
            end
            % Select individuals (rank-DE)
            Np = length(population{t});
            Na = length(archive{t});
            x1 = randi(Np);
            while rand() > (Np - rank(x1)) / Np || x1 == i
                x1 = randi(Np);
            end
            x2 = randi(Np);
            while rand() > (Np - rank(x2)) / Np || x2 == i || x2 == x1
                x2 = randi(Np);
            end
            x3 = randi(Np + Na);
            while x3 == i || x3 == x1 || x3 == x2
                x3 = randi(Np + Na);
            end
            xDeci = population{t}(i).Dec;
            xDec1 = population{t}(x1).Dec;
            xDec2 = population{t}(x2).Dec;
            if x3 <= Np
                xDec3 = population{t}(x3).Dec;
            else
                xDec3 = archive{t}(x3 - Np).Dec;
            end
            offspring(i).Dec = xDeci + offspring(i).F * (xDec1 - xDeci) + offspring(i).F * (xDec2 - xDec3);
            offspring(i).Dec = DE_Crossover(offspring(i).Dec, xDeci, offspring(i).CR);
            offspring(i).Dec = real(min(max(offspring(i).Dec, 0), 1));
        end
    end

    function offspring = Transfer(Algo, Prob, population, t, sMap, NeighMat, Bestmu)
        N = Prob.N;
        half = N / 2;
        offspring = population{t};

        %% 1) First, batch generate the first half of Dec (without evaluation)
        for i = 1:half
            Neuro = Bestmu{t}(i);
            Neigh = find(NeighMat{t}(Neuro, :) == 1);
            Dec = sMap{t}.codebook(Neigh, :);
            mu = mean(Dec);
            sigma = cov(Dec);
            offspring(i).Dec = mvnrnd(mu, sigma);
            offspring(i).Dec = GA_Mutation(offspring(i).Dec, 20);
            offspring(i).Dec = real(min(max(offspring(i).Dec, 0), 1));
        end
        offspring(1:half) = Algo.Evaluation(offspring(1:half), Prob, t);

        %% 3) Generate the second half (based on the evaluation results of the first half)
        for i = 1:half
            if all(offspring(i).Obj <= population{t}(i).Obj) && any(offspring(i).Obj < population{t}(i).Obj)
                offspring(i + half).Dec = offspring(i).Dec + rand .* (offspring(i).Dec - population{t}(i).Dec);
            elseif all(offspring(i).Obj >= population{t}(i).Obj) && any(offspring(i).Obj > population{t}(i).Obj)
                offspring(i + half).Dec = 2 .* population{t}(i).Dec - offspring(i).Dec;
            else
                Neuro = Bestmu{t}(i + half);
                Neigh = find(NeighMat{t}(Neuro, :) == 1);
                Dec = sMap{t}.codebook(Neigh, :);
                mu = mean(Dec);
                sigma = cov(Dec);
                offspring(i + half).Dec = mvnrnd(mu, sigma);
                offspring(i + half).Dec = GA_Mutation(offspring(i + half).Dec, 20);
            end
            offspring(i + half).Dec = real(min(max(offspring(i + half).Dec, 0), 1));
        end
        offspring(1 + half:N) = Algo.Evaluation(offspring(1 + half:N), Prob, t);
    end

    function F = CalHV(Algo, points, bounds, k, nSample)
        % Calculate the hypervolume-based fitness value of each solution

        [N, M] = size(points);
        if M > 2
            % Use the estimated method for three or more objectives
            alpha = zeros(1, N);
            for i = 1:k
                alpha(i) = prod((k - [1:i - 1]) ./ (N - [1:i - 1])) ./ i;
            end
            Fmin = min(points, [], 1);
            S = unifrnd(repmat(Fmin, nSample, 1), repmat(bounds, nSample, 1));
            PdS = false(N, nSample);
            dS = zeros(1, nSample);
            for i = 1:N
                x = sum(repmat(points(i, :), nSample, 1) - S <= 0, 2) == M;
                PdS(i, x) = true;
                dS(x) = dS(x) + 1;
            end
            F = zeros(1, N);
            for i = 1:N
                F(i) = sum(alpha(dS(PdS(i, :))));
            end
            F = F .* prod(bounds - Fmin) / nSample;
        else
            % Use the accurate method for two objectives
            pvec = 1:size(points, 1);
            alpha = zeros(1, k);
            for i = 1:k
                j = 1:i - 1;
                alpha(i) = prod((k - j) ./ (N - j)) ./ i;
            end
            F = Algo.hypesub(N, points, M, bounds, pvec, alpha, k);
        end
    end

    function h = hypesub(Algo, l, A, M, bounds, pvec, alpha, k)
        % The recursive function for the accurate method

        h = zeros(1, l);
        [S, i] = sortrows(A, M);
        pvec = pvec(i);
        for i = 1:size(S, 1)
            if i < size(S, 1)
                extrusion = S(i + 1, M) - S(i, M);
            else
                extrusion = bounds(M) - S(i, M);
            end
            if M == 1
                if i > k
                    break;
                end
                if alpha >= 0
                    h(pvec(1:i)) = h(pvec(1:i)) + extrusion * alpha(i);
                end
            elseif extrusion > 0
                h = h + extrusion * Algo.hypesub(l, S(1:i, :), M - 1, bounds, pvec(1:i), alpha, k);
            end
        end
    end

end
end
