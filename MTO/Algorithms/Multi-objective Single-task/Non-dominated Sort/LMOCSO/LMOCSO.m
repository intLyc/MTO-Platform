classdef LMOCSO < Algorithm
% <Single-task> <Multi-objective> <None/Constrained>

%------------------------------- Reference --------------------------------

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

methods
    function run(Algo, Prob)
        for t = 1:Prob.T
            [V{t}, N{t}] = UniformPoint(Prob.N, Prob.M(t));
            population{t} = Initialization_One(Algo, Prob, t, Individual_PSO, N{t});
            archive{t} = population{t};
            population{t} = Algo.EnvironmentalSelection(population{t}, V{t}, (Algo.FE / Prob.maxFE)^2);
        end

        while Algo.notTerminated(Prob, archive)
            for t = 1:Prob.T
                fitness = Algo.calFitness(population{t}.Objs);
                if length(population{t}) >= 2
                    rank = randperm(length(population{t}), floor(length(population{t}) / 2) * 2);
                else
                    rank = [1, 1];
                end
                loser = rank(1:end / 2);
                winner = rank(end / 2 + 1:end);
                change = fitness(loser) >= fitness(winner);
                Temp = winner(change);
                winner(change) = loser(change);
                loser(change) = Temp;
                offspring = Algo.Generation(population{t}(loser), population{t}(winner));
                offspring = Algo.Evaluation(offspring, Prob, t);
                population{t} = Algo.EnvironmentalSelection([population{t}, offspring], V{t}, (Algo.FE / Prob.maxFE)^2);
                archive{t}(1:length(population{t})) = population{t};
            end
        end
    end

    function fitness = calFitness(Algo, PopObj)
        % Calculate the fitness by shift-based density
        N = size(PopObj, 1);
        fmax = max(PopObj, [], 1);
        fmin = min(PopObj, [], 1);
        PopObj = (PopObj - repmat(fmin, N, 1)) ./ repmat(fmax - fmin, N, 1);
        Dis = inf(N);
        for i = 1:N
            SPopObj = max(PopObj, repmat(PopObj(i, :), N, 1));
            for j = [1:i - 1, i + 1:N]
                Dis(i, j) = norm(PopObj(i, :) - SPopObj(j, :));
            end
        end
        fitness = min(Dis, [], 2);
    end

    function offspring = Generation(Algo, loser, winner)
        % The competitive swarm optimizer of LMOCSO
        off_loser = loser;
        for i = 1:length(loser)
            r1 = rand(); r2 = rand();

            % Velocity update
            off_loser(i).V = r1 * loser(i).V + ...
                r2 .* (winner(i).Dec - loser(i).Dec);

            % Position update
            off_loser(i).Dec = loser(i).Dec + r1 * (off_loser(i).V - loser(i).V);
        end

        offspring = [off_loser, winner];
        for i = 1:length(offspring)
            offspring(i).Dec = GA_Mutation(offspring(i).Dec, 20);
            offspring(i).Dec = max(0, min(1, offspring(i).Dec));
        end
    end

    function population = EnvironmentalSelection(Algo, population, V, theta)
        % The environmental selection of LMOCSO

        population = population(NDSort(population.Objs, 1) == 1);
        PopObj = population.Objs;
        [N, M] = size(PopObj);
        NV = size(V, 1);

        %% Translate the population
        PopObj = PopObj - repmat(min(PopObj, [], 1), N, 1);

        %% Calculate the degree of violation of each solution
        CV = population.CVs;

        %% Calculate the smallest angle value between each vector and others
        cosine = 1 - pdist2(V, V, 'cosine');
        cosine(logical(eye(length(cosine)))) = 0;
        gamma = min(acos(cosine), [], 2);

        %% Associate each solution to a reference vector
        Angle = acos(1 - pdist2(PopObj, V, 'cosine'));
        [~, associate] = min(Angle, [], 2);

        %% Select one solution for each reference vector
        Next = zeros(1, NV);
        for i = unique(associate)'
            current1 = find(associate == i & CV == 0);
            current2 = find(associate == i & CV ~= 0);
            if ~isempty(current1)
                % Calculate the APD value of each solution
                APD = (1 + M * theta * Angle(current1, i) / gamma(i)) .* sqrt(sum(PopObj(current1, :).^2, 2));
                % Select the one with the minimum APD value
                [~, best] = min(APD);
                Next(i) = current1(best);
            elseif ~isempty(current2)
                % Select the one with the minimum CV value
                [~, best] = min(CV(current2));
                Next(i) = current2(best);
            end
        end
        % population for next generation
        population = population(Next(Next ~= 0));
    end
end
end
