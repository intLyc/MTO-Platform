classdef AR_MOEA < Algorithm
% <Single-task> <Multi-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Tian2018AR-MOEA,
%   title    = {An Indicator-Based Multiobjective Evolutionary Algorithm With Reference Point Adaptation for Better Versatility},
%   author   = {Tian, Ye and Cheng, Ran and Zhang, Xingyi and Cheng, Fan and Jin, Yaochu},
%   journal  = {IEEE Transactions on Evolutionary Computation},
%   year     = {2018},
%   number   = {4},
%   pages    = {609-622},
%   volume   = {22},
%   doi      = {10.1109/TEVC.2017.2749619},
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
        for t = 1:Prob.T
            % Generate the sampling points and random population
            population{t} = Initialization_One(Algo, Prob, t, Individual, Prob.N);
            W{t} = UniformPoint(Prob.N, Prob.M(t));
            [archive{t}, ref_point{t}, range{t}] = Algo.UpdateRefPoint(population{t}(population{t}.CVs <= 0).Objs, W{t}, []);
        end

        while Algo.notTerminated(Prob, population)
            for t = 1:Prob.T
                mating_pool = Algo.MatingSelection(population{t}, ref_point{t}, range{t});
                offspring = Algo.Generation(population{t}(mating_pool));
                offspring = Algo.Evaluation(offspring, Prob, t);

                [archive{t}, ref_point{t}, range{t}] = Algo.UpdateRefPoint([archive{t}; offspring(offspring.CVs <= 0).Objs], W{t}, range{t});

                [population{t}, range{t}] = Algo.EnvironmentalSelection([population{t}, offspring], ref_point{t}, range{t}, Prob.N);
            end
        end
    end

    function [Archive, RefPoint, Range] = UpdateRefPoint(Algo, Archive, W, Range)
        % Reference point adaption

        %------------------------------- Copyright --------------------------------
        % Copyright (c) 2024 BIMK Group. You are free to use the PlatEMO for
        % research purposes. All publications which use this platform or any code
        % in the platform should acknowledge the use of "PlatEMO" and reference "Ye
        % Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
        % for evolutionary multi-objective optimization [educational forum], IEEE
        % Computational Intelligence Magazine, 2017, 12(4): 73-87".
        %--------------------------------------------------------------------------

        %% Delete duplicated and dominated solutions
        Archive = unique(Archive(NDSort(Archive, 1) == 1, :), 'rows');
        NA = size(Archive, 1);
        NW = size(W, 1);

        %% Update the ideal point
        if ~isempty(Range)
            Range(1, :) = min([Range(1, :); Archive], [], 1);
        elseif ~isempty(Archive)
            Range = [min(Archive, [], 1); max(Archive, [], 1)];
        end

        %% Update archive and reference points
        if size(Archive, 1) <= 1
            RefPoint = W;
        else
            %% Find contributing solutions and valid weight vectors
            tArchive = Archive - repmat(Range(1, :), NA, 1);
            W = W .* repmat(Range(2, :) - Range(1, :), NW, 1);
            Distance = Algo.CalDistance(tArchive, W);
            [~, nearestP] = min(Distance, [], 1);
            ContributingS = unique(nearestP);
            [~, nearestW] = min(Distance, [], 2);
            ValidW = unique(nearestW(ContributingS));

            %% Update archive
            Choose = ismember(1:NA, ContributingS);
            Cosine = 1 - pdist2(tArchive, tArchive, 'cosine');
            Cosine(logical(eye(size(Cosine, 1)))) = 0;
            while sum(Choose) < min(3 * NW, size(tArchive, 1))
                unSelected = find(~Choose);
                [~, x] = min(max(Cosine(~Choose, Choose), [], 2));
                Choose(unSelected(x)) = true;
            end
            Archive = Archive(Choose, :);
            tArchive = tArchive(Choose, :);

            %% Update reference points
            RefPoint = [W(ValidW, :); tArchive];
            Choose = [true(1, length(ValidW)), false(1, size(tArchive, 1))];
            Cosine = 1 - pdist2(RefPoint, RefPoint, 'cosine');
            Cosine(logical(eye(size(Cosine, 1)))) = 0;
            while sum(Choose) < min(NW, size(RefPoint, 1))
                Selected = find(~Choose);
                [~, x] = min(max(Cosine(~Choose, Choose), [], 2));
                Choose(Selected(x)) = true;
            end
            RefPoint = RefPoint(Choose, :);
        end
    end

    function Distance = CalDistance(Algo, PopObj, RefPoint)
        % Calculate the distance between each solution to each adjusted reference
        % point

        %------------------------------- Copyright --------------------------------
        % Copyright (c) 2024 BIMK Group. You are free to use the PlatEMO for
        % research purposes. All publications which use this platform or any code
        % in the platform should acknowledge the use of "PlatEMO" and reference "Ye
        % Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
        % for evolutionary multi-objective optimization [educational forum], IEEE
        % Computational Intelligence Magazine, 2017, 12(4): 73-87".
        %--------------------------------------------------------------------------

        N = size(PopObj, 1);
        NR = size(RefPoint, 1);
        PopObj = max(PopObj, 1e-6);
        RefPoint = max(RefPoint, 1e-6);

        %% Adjust the location of each reference point
        Cosine = 1 - pdist2(PopObj, RefPoint, 'cosine');
        NormR = sqrt(sum(RefPoint.^2, 2));
        NormP = sqrt(sum(PopObj.^2, 2));
        d1 = repmat(NormP, 1, NR) .* Cosine;
        d2 = repmat(NormP, 1, NR) .* sqrt(1 - Cosine.^2);
        [~, nearest] = min(d2, [], 1);
        RefPoint = RefPoint .* repmat(d1(N .* (0:NR - 1) + nearest)' ./ NormR, 1, size(RefPoint, 2));

        %% Calculate the distance between each solution to each point
        Distance = pdist2(PopObj, RefPoint);
    end

    function MatingPool = MatingSelection(Algo, Population, RefPoint, Range)
        % The mating selection of AR-MOEA

        %------------------------------- Copyright --------------------------------
        % Copyright (c) 2024 BIMK Group. You are free to use the PlatEMO for
        % research purposes. All publications which use this platform or any code
        % in the platform should acknowledge the use of "PlatEMO" and reference "Ye
        % Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
        % for evolutionary multi-objective optimization [educational forum], IEEE
        % Computational Intelligence Magazine, 2017, 12(4): 73-87".
        %--------------------------------------------------------------------------

        %% Calculate the degree of violation of each solution
        CV = Population.CVs;

        %% Calculate the fitness of each feasible solution based on IGD-NS
        if sum(CV == 0) > 1
            % Calculate the distance between each solution and point
            N = sum(CV == 0);
            Distance = Algo.CalDistance(Population(CV == 0).Objs - repmat(Range(1, :), N, 1), RefPoint);
            Convergence = min(Distance, [], 2);
            [dis, rank] = sort(Distance, 1);
            % Calculate the fitness of noncontributing solutions
            Noncontributing = true(1, N);
            Noncontributing(rank(1, :)) = false;
            METRIC = sum(dis(1, :)) + sum(Convergence(Noncontributing));
            fitness = inf(1, N);
            fitness(Noncontributing) = METRIC - Convergence(Noncontributing);
            % Calculate the fitness of contributing solutions
            for p = find(~Noncontributing)
                temp = rank(1, :) == p;
                noncontributing = false(1, N);
                noncontributing(rank(2, temp)) = true;
                noncontributing = noncontributing & Noncontributing;
                fitness(p) = METRIC - sum(dis(1, temp)) + sum(dis(2, temp)) - sum(Convergence(noncontributing));
            end
        else
            fitness = zeros(1, sum(CV == 0));
        end

        %% Combine the fitness of feasible solutions with the fitness of infeasible solutions
        Fitness = -inf(1, length(Population));
        Fitness(CV == 0) = fitness;

        %% Binary tournament selection
        MatingPool = TournamentSelection(2, length(Population), CV, -Fitness);
    end

    function [Population, Range] = EnvironmentalSelection(Algo, Population, RefPoint, Range, N)
        % The environmental selection of AR-MOEA

        %------------------------------- Copyright --------------------------------
        % Copyright (c) 2024 BIMK Group. You are free to use the PlatEMO for
        % research purposes. All publications which use this platform or any code
        % in the platform should acknowledge the use of "PlatEMO" and reference "Ye
        % Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
        % for evolutionary multi-objective optimization [educational forum], IEEE
        % Computational Intelligence Magazine, 2017, 12(4): 73-87".
        %--------------------------------------------------------------------------

        CV = Population.CVs;
        if sum(CV == 0) > N
            %% Selection among feasible solutions
            Population = Population(CV == 0);
            % Non-dominated sorting
            [FrontNo, MaxFNo] = NDSort(Population.Objs, N);
            Next = FrontNo < MaxFNo;
            % Select the solutions in the last front
            Last = find(FrontNo == MaxFNo);
            Choose = Algo.LastSelection(Population(Last).Objs, RefPoint, Range, N - sum(Next));
            Next(Last(Choose)) = true;
            Population = Population(Next);
            % Update the range for normalization
            Range(2, :) = max(Population.Objs, [], 1);
            Range(2, Range(2, :) - Range(1, :) < 1e-6) = 1;
        else
            %% Selection including infeasible solutions
            [~, rank] = sort(CV);
            Population = Population(rank(1:N));
        end
    end

    function Remain = LastSelection(Algo, PopObj, RefPoint, Range, K)
        % Select part of the solutions in the last front

        N = size(PopObj, 1);
        NR = size(RefPoint, 1);

        %% Calculate the distance between each solution and point
        Distance = Algo.CalDistance(PopObj - repmat(Range(1, :), N, 1), RefPoint);
        Convergence = min(Distance, [], 2);

        %% Delete the solution which has the smallest metric contribution one by one
        [dis, rank] = sort(Distance, 1);
        Remain = true(1, N);
        while sum(Remain) > K
            % Calculate the fitness of noncontributing solutions
            Noncontributing = Remain;
            Noncontributing(rank(1, :)) = false;
            METRIC = sum(dis(1, :)) + sum(Convergence(Noncontributing));
            Metric = inf(1, N);
            Metric(Noncontributing) = METRIC - Convergence(Noncontributing);
            % Calculate the fitness of contributing solutions
            for p = find(Remain & ~Noncontributing)
                temp = rank(1, :) == p;
                noncontributing = false(1, N);
                noncontributing(rank(2, temp)) = true;
                noncontributing = noncontributing & Noncontributing;
                Metric(p) = METRIC - sum(dis(1, temp)) + sum(dis(2, temp)) - sum(Convergence(noncontributing));
            end
            % Delete the worst solution and update the variables
            [~, del] = min(Metric);
            temp = rank ~= del;
            dis = reshape(dis(temp), sum(Remain) - 1, NR);
            rank = reshape(rank(temp), sum(Remain) - 1, NR);
            Remain(del) = false;
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
end
end
