classdef SBO < Algorithm
    % <MaT-SO> <None/Constrained>

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
        function Parameter = getParameter(obj)
            Parameter = {'Benefit: Beneficial factor', num2str(obj.Benefit), ...
                        'Harm: Harmful factor', num2str(obj.Harm), ...
                        'MuC: Simulated Binary Crossover', num2str(obj.MuC), ...
                        'MuM: Polynomial Mutation', num2str(obj.MuM)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.Benefit = str2double(Parameter{i}); i = i + 1;
            obj.Harm = str2double(Parameter{i}); i = i + 1;
            obj.MuC = str2double(Parameter{i}); i = i + 1;
            obj.MuM = str2double(Parameter{i}); i = i + 1;
        end

        function run(obj, Prob)
            % Initialization
            population_temp = Initialization(obj, Prob, IndividualSBO);
            population = IndividualSBO.empty();
            for t = 1:Prob.T
                [~, rank] = sortrows([[population_temp{t}.CV]', [population_temp{t}.Obj]'], [1, 2]);
                for i = 1:length(population_temp{t})
                    population_temp{t}(rank(i)).rankO = i;
                    population_temp{t}(rank(i)).MFFactor = t;
                    population_temp{t}(rank(i)).BelongT = t;
                end
                population = [population, population_temp{t}];
            end

            RIJ = 0.5 * ones(Prob.T, Prob.T); % transfer rates
            MIJ = ones(Prob.T, Prob.T); % Benefit and Benefit
            NIJ = ones(Prob.T, Prob.T); % neutral and neutral
            CIJ = ones(Prob.T, Prob.T); % Harm and Harm
            OIJ = ones(Prob.T, Prob.T); % neutral and Benefit
            PIJ = ones(Prob.T, Prob.T); % Benefit and Harm
            AIJ = ones(Prob.T, Prob.T); % Harm and neutral

            while obj.notTerminated(Prob)
                offspring = IndividualSBO.empty();
                for t = 1:Prob.T
                    t_idx = [population.MFFactor] == t;
                    find_idx = find(t_idx);
                    % generation
                    offspring_t = obj.Generation(population(t_idx));
                    for i = 1:length(offspring_t)
                        offspring_t(i).MFFactor = t;
                        offspring_t(i).BelongT = t;
                        offspring_t(i).rankO = population(find_idx(i)).rankO;
                    end
                    offspring = [offspring, offspring_t];
                end

                for t = 1:Prob.T
                    t_idx = [offspring.MFFactor] == t;
                    find_idx = find(t_idx);
                    % knowledge transfer
                    [~, transfer_task] = max(RIJ(t, [1:t - 1, t + 1:end])); % find transferred task
                    if transfer_task >= t
                        transfer_task = transfer_task + 1;
                    end
                    if rand() < RIJ(t, transfer_task)
                        Si = floor(Prob.N * RIJ(t, transfer_task)); % transfer quantity
                        ind1 = randperm(Prob.N, Si);
                        ind2 = randperm(Prob.N, Si);
                        this_pos = find(t_idx);
                        trans_pos = find([offspring.MFFactor] == transfer_task);
                        for i = 1:Si
                            offspring(this_pos(ind1(i))).Dec = offspring(trans_pos(ind2(i))).Dec;
                            offspring(this_pos(ind1(i))).BelongT = transfer_task;
                        end
                    end

                    % Evaluation
                    offspring(t_idx) = obj.Evaluation(offspring(t_idx), Prob, t);

                    [~, rank] = sortrows([[offspring(t_idx).CV]', [offspring(t_idx).Obj]'], [1, 2]);
                    for i = 1:length(rank)
                        offspring(find_idx(rank(i))).rankC = i;
                    end

                    % selection
                    population_temp = [population(t_idx), offspring(t_idx)];
                    [~, rank] = sortrows([[population_temp.CV]', [population_temp.Obj]'], [1, 2]);
                    population(t_idx) = population_temp(rank(1:Prob.N));
                    [~, rank] = sortrows([[population(t_idx).CV]', [population(t_idx).Obj]'], [1, 2]);
                    for i = 1:length(rank)
                        population(find_idx(rank(i))).rankO = i;
                    end
                end

                for t = 1:Prob.T
                    % update symbiosis
                    t_idx = find([offspring.MFFactor] == t & [offspring.BelongT] ~= t);
                    find_idx = find(t_idx);
                    rankC = [offspring(t_idx).rankC];
                    rankO = [offspring(t_idx).rankO];
                    for k = 1:length(t_idx)
                        if rankC(k) < Prob.N * obj.Benefit
                            if rankO(k) < Prob.N * obj.Benefit
                                MIJ(t, offspring(find_idx(k)).BelongT) = MIJ(t, offspring(find_idx(k)).BelongT) + 1;
                            elseif rankO(k) > Prob.N * (1 - obj.Harm)
                                PIJ(t, offspring(find_idx(k)).BelongT) = PIJ(t, offspring(find_idx(k)).BelongT) + 1;
                            else
                                OIJ(t, offspring(find_idx(k)).BelongT) = OIJ(t, offspring(find_idx(k)).BelongT) + 1;
                            end
                        elseif rankC(k) > Prob.N * (1 - obj.Harm)
                            if rankO(k) > Prob.N * (1 - obj.Harm)
                                CIJ(t, offspring(find_idx(k)).BelongT) = CIJ(t, offspring(find_idx(k)).BelongT) + 1;
                            end
                        else
                            if rankO(k) > Prob.N * (1 - obj.Harm)
                                AIJ(t, offspring(find_idx(k)).BelongT) = AIJ(t, offspring(find_idx(k)).BelongT) + 1;
                            elseif rankO(k) >= Prob.N * obj.Benefit && rankO(k) <= Prob.N * (1 - obj.Harm)
                                NIJ(t, offspring(find_idx(k)).BelongT) = NIJ(t, offspring(find_idx(k)).BelongT) + 1;
                            end
                        end
                    end
                end
                % update transfer rates
                RIJ = (MIJ + OIJ + PIJ) ./ (MIJ + OIJ + PIJ + AIJ + CIJ + NIJ);
            end
        end

        function offspring = Generation(obj, population)
            indorder = randperm(length(population));
            count = 1;
            for i = 1:ceil(length(population) / 2)
                p1 = indorder(i);
                p2 = indorder(i + fix(length(population) / 2));
                offspring(count) = population(p1);
                offspring(count + 1) = population(p2);

                [offspring(count).Dec, offspring(count + 1).Dec] = GA_Crossover(population(p1).Dec, population(p2).Dec, obj.MuC);

                offspring(count).Dec = GA_Mutation(offspring(count).Dec, obj.MuM);
                offspring(count + 1).Dec = GA_Mutation(offspring(count + 1).Dec, obj.MuM);

                for x = count:count + 1
                    offspring(x).Dec(offspring(x).Dec > 1) = 1;
                    offspring(x).Dec(offspring(x).Dec < 0) = 0;
                end
                count = count + 2;
            end
        end
    end
end
