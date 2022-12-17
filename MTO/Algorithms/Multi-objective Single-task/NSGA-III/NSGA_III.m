classdef NSGA_III < Algorithm
% <Single-task> <Multi-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Deb2014NSGA3,
%   author  = {Deb, Kalyanmoy and Jain, Himanshu},
%   journal = {IEEE Transactions on Evolutionary Computation},
%   title   = {An Evolutionary Many-Objective Optimization Algorithm Using Reference-Point-Based Nondominated Sorting Approach, Part I: Solving Problems With Box Constraints},
%   year    = {2014},
%   number  = {4},
%   pages   = {577-601},
%   volume  = {18},
%   doi     = {10.1109/TEVC.2013.2281535},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
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

properties (SetAccess = private)
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
        % Initialize
        for t = 1:Prob.T
            [Z{t}, N{t}] = UniformPoint(Prob.N, Prob.M(t));
            population{t} = Initialization_One(Algo, Prob, t, Individual, N{t});
            Zmin{t} = min(population{t}(population{t}.CVs <= 0).Objs, [], 1);
        end

        while Algo.notTerminated(Prob, population)
            for t = 1:Prob.T
                % Generation
                mating_pool = TournamentSelection(2, N{t}, population{t}.CVs);
                offspring = Algo.Generation(population{t}(mating_pool));
                % Evaluation
                offspring = Algo.Evaluation(offspring, Prob, t);
                % Selection
                Zmin{t} = min([Zmin{t}; offspring(offspring.CVs <= 0).Objs], [], 1);
                population{t} = Algo.EnvironmentalSelection([population{t}, offspring], N{t}, Z{t}, Zmin{t});
            end
        end
    end

    function offspring = Generation(Algo, population)
        count = 1;
        for i = 1:ceil(length(population) / 2)
            p1 = i; p2 = i + fix(length(population) / 2);
            offspring(count) = population(p1);
            offspring(count + 1) = population(p2);

            [offspring(count).Dec, offspring(count + 1).Dec] = GA_Crossover(population(p1).Dec, population(p2).Dec, Algo.MuC);

            offspring(count).Dec = GA_Mutation(offspring(count).Dec, Algo.MuM);
            offspring(count + 1).Dec = GA_Mutation(offspring(count + 1).Dec, Algo.MuM);

            for x = count:count + 1
                offspring(x).Dec(offspring(x).Dec > 1) = 1;
                offspring(x).Dec(offspring(x).Dec < 0) = 0;
            end
            count = count + 2;
        end
    end

    function population = EnvironmentalSelection(Algo, population, N, Z, Zmin)
        if isempty(Zmin)
            Zmin = ones(1, size(Z, 2));
        end

        %% Non-dominated sorting
        [FrontNo, MaxFNo] = NDSort(population.Objs, population.CVs, N);
        Next = FrontNo < MaxFNo;

        %% Select the solutions in the last front
        Last = find(FrontNo == MaxFNo);
        Choose = Algo.LastSelection(population(Next).Objs, population(Last).Objs, N - sum(Next), Z, Zmin);
        Next(Last(Choose)) = true;
        % population for next generation
        population = population(Next);
    end

    function Choose = LastSelection(Algo, PopObj1, PopObj2, K, Z, Zmin)
        % Select part of the solutions in the last front

        PopObj = [PopObj1; PopObj2] - repmat(Zmin, size(PopObj1, 1) + size(PopObj2, 1), 1);
        [N, M] = size(PopObj);
        N1 = size(PopObj1, 1);
        N2 = size(PopObj2, 1);
        NZ = size(Z, 1);

        %% Normalization
        % Detect the extreme points
        Extreme = zeros(1, M);
        w = zeros(M) +1e-6 + eye(M);
        for i = 1:M
            [~, Extreme(i)] = min(max(PopObj ./ repmat(w(i, :), N, 1), [], 2));
        end
        % Calculate the intercepts of the hyperplane constructed by the extreme
        % points and the axes
        Hyperplane = PopObj(Extreme, :) \ ones(M, 1);
        a = 1 ./ Hyperplane;
        if any(isnan(a))
            a = max(PopObj, [], 1)';
        end
        % Normalization
        PopObj = PopObj ./ repmat(a', N, 1);

        %% Associate each solution with one reference point
        % Calculate the distance of each solution to each reference vector
        Cosine = 1 - pdist2(PopObj, Z, 'cosine');
        Distance = repmat(sqrt(sum(PopObj.^2, 2)), 1, NZ) .* sqrt(1 - Cosine.^2);
        % Associate each solution with its nearest reference point
        [d, pi] = min(Distance', [], 1);

        %% Calculate the number of associated solutions except for the last front of each reference point
        rho = hist(pi(1:N1), 1:NZ);

        %% Environmental selection
        Choose = false(1, N2);
        Zchoose = true(1, NZ);
        % Select K solutions one by one
        while sum(Choose) < K
            % Select the least crowded reference point
            Temp = find(Zchoose);
            Jmin = find(rho(Temp) == min(rho(Temp)));
            j = Temp(Jmin(randi(length(Jmin))));
            I = find(Choose == 0 & pi(N1 + 1:end) == j);
            % Then select one solution associated with this reference point
            if ~isempty(I)
                if rho(j) == 0
                    [~, s] = min(d(N1 + I));
                else
                    s = randi(length(I));
                end
                Choose(I(s)) = true;
                rho(j) = rho(j) + 1;
            else
                Zchoose(j) = false;
            end
        end
    end
end
end
