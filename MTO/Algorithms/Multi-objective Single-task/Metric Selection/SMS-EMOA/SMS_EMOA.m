classdef SMS_EMOA < Algorithm
% <Single-task> <Multi-objective> <None>

%------------------------------- Reference --------------------------------
% @Article{Beume2007SMS-EMOA,
%   title    = {SMS-EMOA: Multiobjective Selection Based on Dominated Hypervolume},
%   author   = {Nicola Beume and Boris Naujoks and Michael Emmerich},
%   journal  = {European Journal of Operational Research},
%   year     = {2007},
%   issn     = {0377-2217},
%   number   = {3},
%   pages    = {1653-1669},
%   volume   = {181},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

% The code implementation is referenced from PlatEMO(https://github.com/BIMK/PlatEMO).
%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

properties (SetAccess = public)
    MuC = 20
    MuM = 15
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'MuC: Simulated Binary Crossover', num2str(Algo.MuC), ...
                'MuM: Polynomial Mutation', num2str(Algo.MuM)};
    end

    function setParameter(Algo, Parameter)
        i = 1;
        Algo.MuC = str2double(Parameter{i}); i = i + 1;
        Algo.MuM = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        population = Initialization(Algo, Prob, Individual);
        for t = 1:Prob.T
            FrontNo{t} = NDSort(population{t}.Objs, inf);
        end

        while Algo.notTerminated(Prob, population)
            for t = 1:Prob.T
                for i = 1:Prob.N
                    offspring = Algo.Generation(population{t}(randperm(end, 2)));
                    offspring = Algo.Evaluation(offspring, Prob, t);
                    [population{t}, FrontNo{t}] = Algo.Reduce([population{t}, offspring], FrontNo{t});
                end
            end
        end
    end

    function offspring = Generation(Algo, population)
        for i = 1:ceil(length(population) / 2)
            p1 = i; p2 = i + fix(length(population) / 2);
            offspring(i) = population(p1);
            offspring(i).Dec = GA_Crossover(population(p1).Dec, population(p2).Dec, Algo.MuC);
            offspring(i).Dec = GA_Mutation(offspring(i).Dec, Algo.MuM);
            offspring(i).Dec(offspring(i).Dec > 1) = 1;
            offspring(i).Dec(offspring(i).Dec < 0) = 0;
        end
    end

    function [population, FrontNo] = Reduce(Algo, population, FrontNo)
        % Delete one solution from the population

        % Identify the solutions in the last front
        FrontNo = Algo.UpdateFront(population.Objs, FrontNo);
        LastFront = find(FrontNo == max(FrontNo));
        PopObj = population(LastFront).Objs;
        [N, M] = size(PopObj);

        % Calculate the contribution of hypervolume of each solution
        deltaS = inf(1, N);
        if M == 2
            [~, rank] = sortrows(PopObj);
            for i = 2:N - 1
                deltaS(rank(i)) = (PopObj(rank(i + 1), 1) - PopObj(rank(i), 1)) .* (PopObj(rank(i - 1), 2) - PopObj(rank(i), 2));
            end
        elseif N > 1
            deltaS = Algo.CalHV(PopObj, max(PopObj, [], 1) * 1.1, 1, 10000);
        end

        % Delete the worst solution from the last front
        [~, worst] = min(deltaS);
        FrontNo = Algo.UpdateFront(population.Objs, FrontNo, LastFront(worst));
        population(LastFront(worst)) = [];
    end

    function FrontNo = UpdateFront(Algo, PopObj, FrontNo, x)
        % Update the front No. of each solution when a solution is added or deleted

        [N, M] = size(PopObj);
        if nargin < 4
            % Add a new solution (has been stored in the last of PopObj)
            FrontNo = [FrontNo, 0];
            Move = false(1, N);
            Move(N) = true;
            CurrentF = 1;
            % Locate the front No. of the new solution
            while true
                Dominated = false;
                for i = 1:N - 1
                    if FrontNo(i) == CurrentF
                        m = 1;
                        while m <= M && PopObj(i, m) <= PopObj(end, m)
                            m = m + 1;
                        end
                        Dominated = m > M;
                        if Dominated
                            break;
                        end
                    end
                end
                if ~Dominated
                    break;
                else
                    CurrentF = CurrentF + 1;
                end
            end
            % Move down the dominated solutions front by front
            while any(Move)
                NextMove = false(1, N);
                for i = 1:N
                    if FrontNo(i) == CurrentF
                        Dominated = false;
                        for j = 1:N
                            if Move(j)
                                m = 1;
                                while m <= M && PopObj(j, m) <= PopObj(i, m)
                                    m = m + 1;
                                end
                                Dominated = m > M;
                                if Dominated
                                    break;
                                end
                            end
                        end
                        NextMove(i) = Dominated;
                    end
                end
                FrontNo(Move) = CurrentF;
                CurrentF = CurrentF + 1;
                Move = NextMove;
            end
        else
            % Delete the x-th solution
            Move = false(1, N);
            Move(x) = true;
            CurrentF = FrontNo(x) + 1;
            while any(Move)
                NextMove = false(1, N);
                for i = 1:N
                    if FrontNo(i) == CurrentF
                        Dominated = false;
                        for j = 1:N
                            if Move(j)
                                m = 1;
                                while m <= M && PopObj(j, m) <= PopObj(i, m)
                                    m = m + 1;
                                end
                                Dominated = m > M;
                                if Dominated
                                    break;
                                end
                            end
                        end
                        NextMove(i) = Dominated;
                    end
                end
                for i = 1:N
                    if NextMove(i)
                        Dominated = false;
                        for j = 1:N
                            if FrontNo(j) == CurrentF - 1 && ~Move(j)
                                m = 1;
                                while m <= M && PopObj(j, m) <= PopObj(i, m)
                                    m = m + 1;
                                end
                                Dominated = m > M;
                                if Dominated
                                    break;
                                end
                            end
                        end
                        NextMove(i) = ~Dominated;
                    end
                end
                FrontNo(Move) = CurrentF - 2;
                CurrentF = CurrentF + 1;
                Move = NextMove;
            end
            FrontNo(x) = [];
        end
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
                h = h + extrusion * hypesub(l, S(1:i, :), M - 1, bounds, pvec(1:i), alpha, k);
            end
        end
    end
end
end
