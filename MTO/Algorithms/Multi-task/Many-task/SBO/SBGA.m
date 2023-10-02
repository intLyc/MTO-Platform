classdef SBGA < Algorithm
% <Many-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Liaw2019SBO,
%   title      = {Evolutionary Manytasking Optimization Based on Symbiosis in Biocoenosis},
%   author     = {Liaw, Rung-Tzuo and Ting, Chuan-Kang},
%   journal    = {Proceedings of the AAAI Conference on Artificial Intelligence},
%   year       = {2019},
%   month      = {Jul.},
%   number     = {01},
%   pages      = {4295-4303},
%   volume     = {33},
%   doi        = {10.1609/aaai.v33i01.33014295},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
%--------------------------------------------------------------------------

properties (SetAccess = private)
    Benefit = 0.25
    Harm = 0.5
    MuC = 2
    MuM = 5
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'Benefit: Beneficial factor', num2str(Algo.Benefit), ...
                'Harm: Harmful factor', num2str(Algo.Harm), ...
                'MuC: Simulated Binary Crossover', num2str(Algo.MuC), ...
                'MuM: Polynomial Mutation', num2str(Algo.MuM)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.Benefit = str2double(Parameter{i}); i = i + 1;
        Algo.Harm = str2double(Parameter{i}); i = i + 1;
        Algo.MuC = str2double(Parameter{i}); i = i + 1;
        Algo.MuM = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialization
        population = Initialization(Algo, Prob, IndividualSBO);
        for t = 1:Prob.T
            [~, rank] = sortrows([population{t}.CVs, population{t}.Objs], [1, 2]);
            for i = 1:length(population{t})
                population{t}(rank(i)).rankO = i;
                population{t}(rank(i)).MFFactor = t;
                population{t}(rank(i)).BelongT = t;
            end
        end

        RIJ = 0.5 * ones(Prob.T, Prob.T); % transfer rates
        MIJ = ones(Prob.T, Prob.T); % Benefit and Benefit
        NIJ = ones(Prob.T, Prob.T); % neutral and neutral
        CIJ = ones(Prob.T, Prob.T); % Harm and Harm
        OIJ = ones(Prob.T, Prob.T); % neutral and Benefit
        PIJ = ones(Prob.T, Prob.T); % Benefit and Harm
        AIJ = ones(Prob.T, Prob.T); % Harm and neutral

        while Algo.notTerminated(Prob)
            offspring = population;
            for t = 1:Prob.T
                % generation
                offspring{t} = Algo.Generation(population{t});
                for i = 1:length(offspring{t})
                    offspring{t}(i).MFFactor = t;
                    offspring{t}(i).BelongT = t;
                    offspring{t}(i).rankO = population{t}(i).rankO;
                end
            end

            for t = 1:Prob.T
                % knowledge transfer
                [~, transfer_task] = max(RIJ(t, [1:t - 1, t + 1:end])); % find transferred task
                if transfer_task >= t
                    transfer_task = transfer_task + 1;
                end
                if rand() < RIJ(t, transfer_task)
                    Si = floor(Prob.N * RIJ(t, transfer_task)); % transfer quantity
                    ind1 = randperm(Prob.N, Si);
                    ind2 = randperm(Prob.N, Si);
                    for i = 1:Si
                        offspring{t}(ind1(i)).Dec = offspring{transfer_task}(ind2(i)).Dec;
                        offspring{t}(ind1(i)).BelongT = transfer_task;
                    end
                end

                % Evaluation
                offspring{t} = Algo.Evaluation(offspring{t}, Prob, t);
                [~, rank] = sortrows([offspring{t}.CVs, offspring{t}.Objs], [1, 2]);
                for i = 1:length(rank)
                    offspring{t}(rank(i)).rankC = i;
                end

                % selection
                population{t} = [population{t}, offspring{t}];
                [~, rank] = sortrows([population{t}.CVs, population{t}.Objs], [1, 2]);
                population{t} = population{t}(rank(1:Prob.N));
                rank = 1:Prob.N;
                for i = 1:length(rank)
                    population{t}(rank(i)).rankO = i;
                end
            end

            for t = 1:Prob.T
                % update symbiosis
                idx = find([offspring{t}.BelongT] ~= t);
                rankC = [offspring{t}(idx).rankC];
                rankO = [offspring{t}(idx).rankO];
                for k = 1:length(idx)
                    if rankC(k) < Prob.N * Algo.Benefit
                        if rankO(k) < Prob.N * Algo.Benefit
                            MIJ(t, offspring{t}(idx(k)).BelongT) = MIJ(t, offspring{t}(idx(k)).BelongT) + 1;
                        elseif rankO(k) > Prob.N * (1 - Algo.Harm)
                            PIJ(t, offspring{t}(idx(k)).BelongT) = PIJ(t, offspring{t}(idx(k)).BelongT) + 1;
                        else
                            OIJ(t, offspring{t}(idx(k)).BelongT) = OIJ(t, offspring{t}(idx(k)).BelongT) + 1;
                        end
                    elseif rankC(k) > Prob.N * (1 - Algo.Harm)
                        if rankO(k) > Prob.N * (1 - Algo.Harm)
                            CIJ(t, offspring{t}(idx(k)).BelongT) = CIJ(t, offspring{t}(idx(k)).BelongT) + 1;
                        end
                    else
                        if rankO(k) > Prob.N * (1 - Algo.Harm)
                            AIJ(t, offspring{t}(idx(k)).BelongT) = AIJ(t, offspring{t}(idx(k)).BelongT) + 1;
                        elseif rankO(k) >= Prob.N * Algo.Benefit && rankO(k) <= Prob.N * (1 - Algo.Harm)
                            NIJ(t, offspring{t}(idx(k)).BelongT) = NIJ(t, offspring{t}(idx(k)).BelongT) + 1;
                        end
                    end
                end
            end
            % update transfer rates
            RIJ = (MIJ + OIJ + PIJ) ./ (MIJ + OIJ + PIJ + AIJ + CIJ + NIJ);
        end
    end

    function offspring = Generation(Algo, population)
        indorder = randperm(length(population));
        count = 1;
        for i = 1:ceil(length(population) / 2)
            p1 = indorder(i);
            p2 = indorder(i + fix(length(population) / 2));
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
