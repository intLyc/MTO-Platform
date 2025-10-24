classdef RVEA < Algorithm
% <Single-task> <Multi-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Cheng2016RVEA,
%   title    = {A Reference Vector Guided Evolutionary Algorithm for Many-Objective Optimization},
%   author   = {Cheng, Ran and Jin, Yaochu and Olhofer, Markus and Sendhoff, Bernhard},
%   journal  = {IEEE Transactions on Evolutionary Computation},
%   year     = {2016},
%   number   = {5},
%   pages    = {773-791},
%   volume   = {20},
%   doi      = {10.1109/TEVC.2016.2519378},
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
    Alpha = 2
    FR = 0.1
    MuC = 20
    MuM = 15
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'Alpha: Rate of change of penalty', num2str(Algo.Alpha), ...
                'FR: Frequency of employing reference vector adaptation', num2str(Algo.FR), ...
                'MuC: Simulated Binary Crossover', num2str(Algo.MuC), ...
                'MuM: Polynomial Mutation', num2str(Algo.MuM)};
    end

    function setParameter(Algo, Parameter)
        i = 1;
        Algo.Alpha = str2double(Parameter{i}); i = i + 1;
        Algo.FR = str2double(Parameter{i}); i = i + 1;
        Algo.MuC = str2double(Parameter{i}); i = i + 1;
        Algo.MuM = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        for t = 1:Prob.T
            % Generate the reference points and random population
            [V0{t}, N{t}] = UniformPoint(Prob.N, Prob.M(t));
            V{t} = V0{t};
            population{t} = Initialization_One(Algo, Prob, t, Individual, N{t});
            archive{t} = population{t};
        end

        while Algo.notTerminated(Prob, archive)
            flag = false;
            if ~mod(ceil(Algo.FE / N{t}), ceil(Algo.FR * Prob.maxFE / N{t}))
                flag = true;
            end

            for t = 1:Prob.T
                mating_pool = randi(length(population{t}), 1, N{t});
                offspring = Algo.Generation(population{t}(mating_pool));
                offspring = Algo.Evaluation(offspring, Prob, t);
                population{t} = Algo.EnvironmentalSelection([population{t}, offspring], V{t}, (Algo.FE / Prob.maxFE)^Algo.Alpha);
                archive{t}(1:length(population{t})) = population{t};
                if flag
                    PopObj = population{t}.Objs;
                    V{t}(1:N{t}, :) = V0{t} .* repmat(max(PopObj, [], 1) - min(PopObj, [], 1), size(V0{t}, 1), 1);
                end
            end
        end
    end

    function Population = EnvironmentalSelection(Algo, Population, V, theta)
        % The environmental selection of RVEA

        %------------------------------- Copyright --------------------------------
        % Copyright (c) 2022 BIMK Group. You are free to use the PlatEMO for
        % research purposes. All publications which use this platform or any code
        % in the platform should acknowledge the use of "PlatEMO" and reference "Ye
        % Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
        % for evolutionary multi-objective optimization [educational forum], IEEE
        % Computational Intelligence Magazine, 2017, 12(4): 73-87".
        %--------------------------------------------------------------------------

        PopObj = Population.Objs;
        [N, M] = size(PopObj);
        NV = size(V, 1);

        %% Translate the population
        PopObj = PopObj - repmat(min(PopObj, [], 1), N, 1);

        %% Calculate the degree of violation of each solution
        CV = Population.CVs;

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
        % Population for next generation
        Population = Population(Next(Next ~= 0));
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
