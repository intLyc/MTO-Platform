classdef MFEA_II < Algorithm
    % <MT-SO> <None>

    %------------------------------- Reference --------------------------------
    % @Article{Bali2020MFEA2,
    %   author     = {Bali, Kavitesh Kumar and Ong, Yew-Soon and Gupta, Abhishek and Tan, Puay Siew},
    %   journal    = {IEEE Transactions on Evolutionary Computation},
    %   title      = {Multifactorial Evolutionary Algorithm With Online Transfer Parameter Estimation: MFEA-II},
    %   year       = {2020},
    %   number     = {1},
    %   pages      = {69-83},
    %   volume     = {24},
    %   doi        = {10.1109/TEVC.2019.2906927},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        MuC = 2
        MuM = 5
        Swap = 0.5
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'MuC: Simulated Binary Crossover', num2str(obj.MuC), ...
                        'MuM: Polynomial Mutation', num2str(obj.MuM), ...
                        'probSwap: Variable Swap Probability', num2str(obj.Swap)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.MuC = str2double(Parameter{i}); i = i + 1;
            obj.MuM = str2double(Parameter{i}); i = i + 1;
            obj.Swap = str2double(Parameter{i}); i = i + 1;
        end

        function run(obj, Prob)
            % Initialize
            population = Initialization_MF(obj, Prob, Individual_MF);

            while obj.notTerminated(Prob)
                % Extract task specific data sets
                for t = 1:Prob.T
                    subpops(t).data = [];
                end
                for i = 1:length(population)
                    subpops(population(i).MFFactor).data = [subpops(population(i).MFFactor).data; population(i).Dec];
                end
                RMP = learnRMP(subpops, Prob.D); % learning RMP matrix online at every generation.
                % Generation
                offspring = obj.Generation(population, RMP);
                % Evaluation
                offspring_temp = Individual_MF.empty();
                for t = 1:Prob.T
                    offspring_t = offspring([offspring.MFFactor] == t);
                    offspring_t = obj.Evaluation(offspring_t, Prob, t);
                    for i = 1:length(offspring_t)
                        offspring_t(i).MFObj = inf(1, Prob.T);
                        offspring_t(i).MFCV = inf(1, Prob.T);
                        offspring_t(i).MFObj(t) = offspring_t(i).Obj;
                        offspring_t(i).MFCV(t) = offspring_t(i).CV;
                    end
                    offspring_temp = [offspring_temp, offspring_t];
                end
                offspring = offspring_temp;
                % Selection
                population = Selection_MF(population, offspring, Prob);
            end
        end

        function offspring = Generation(obj, population, RMP)
            indorder = randperm(length(population));
            count = 1;
            for i = 1:ceil(length(population) / 2)
                p1 = indorder(i);
                p2 = indorder(i + fix(length(population) / 2));
                rmp = RMP(population(p1).MFFactor, population(p2).MFFactor);
                offspring(count) = population(p1);
                offspring(count + 1) = population(p2);

                if (population(p1).MFFactor == population(p2).MFFactor) || rand() < rmp
                    % crossover
                    [offspring(count).Dec, offspring(count + 1).Dec] = GA_Crossover(population(p1).Dec, population(p2).Dec, obj.MuC);
                    % mutation
                    offspring(count).Dec = GA_Mutation(offspring(count).Dec, obj.MuM);
                    offspring(count + 1).Dec = GA_Mutation(offspring(count + 1).Dec, obj.MuM);
                    % variable swap (uniform X)
                    swap_indicator = (rand(1, length(population(p1).Dec)) >= obj.Swap);
                    temp = offspring(count + 1).Dec(swap_indicator);
                    offspring(count + 1).Dec(swap_indicator) = offspring(count).Dec(swap_indicator);
                    offspring(count).Dec(swap_indicator) = temp;
                    % imitation
                    p = [p1, p2];
                    offspring(count).MFFactor = population(p(randi(2))).MFFactor;
                    offspring(count + 1).MFFactor = population(p(randi(2))).MFFactor;
                else
                    % Randomly pick another individual from the same task
                    p = [p1, p2];
                    for x = 1:2
                        find_idx = find([population.MFFactor] == population(p(x)).MFFactor);
                        idx = find_idx(randi(length(find_idx)));
                        while idx == p(x)
                            idx = find_idx(randi(length(find_idx)));
                        end
                        offspring_temp = population(idx);
                        % crossover
                        [offspring(count + x - 1).Dec, offspring_temp.Dec] = GA_Crossover(population(p(x)).Dec, population(idx).Dec, obj.MuC);
                        % mutation
                        offspring(count + x - 1).Dec = GA_Mutation(offspring(count + x - 1).Dec, obj.MuM);
                        offspring_temp.Dec = GA_Mutation(offspring_temp.Dec, obj.MuM);
                        % variable swap (uniform X)
                        swap_indicator = (rand(1, length(population(p(x)).Dec)) >= obj.Swap);
                        offspring(count + x - 1).Dec(swap_indicator) = offspring_temp.Dec(swap_indicator);
                        % imitate
                        offspring(count + x - 1).MFFactor = population(p(x)).MFFactor;
                    end
                end
                for x = count:count + 1
                    offspring(x).Dec(offspring(x).Dec > 1) = 1;
                    offspring(x).Dec(offspring(x).Dec < 0) = 0;
                end
                count = count + 2;
            end
        end
    end
end
