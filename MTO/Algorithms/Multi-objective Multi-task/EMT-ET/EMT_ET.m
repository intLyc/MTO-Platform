classdef EMT_ET < Algorithm
    % <Multi-task> <Multi-objective> <None/Constrained>

    %------------------------------- Reference --------------------------------
    % @Article{Lin2021EMT-ET,
    %   title      = {An Effective Knowledge Transfer Approach for Multiobjective Multitasking Optimization},
    %   author     = {Lin, Jiabin and Liu, Hai-Lin and Tan, Kay Chen and Gu, Fangqing},
    %   journal    = {IEEE Transactions on Cybernetics},
    %   year       = {2021},
    %   number     = {6},
    %   pages      = {3238-3248},
    %   volume     = {51},
    %   doi        = {10.1109/TCYB.2020.2969025},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        G = 8
        P = 0.5
        MuC = 20
        MuM = 15
    end

    methods
        function Parameter = getParameter(Algo)
            Parameter = {'G: Transfer Solutions Number', num2str(Algo.G), ...
                        'P: Distrib Probability', num2str(Algo.P), ...
                        'MuC: Simulated Binary Crossover', num2str(Algo.MuC), ...
                        'MuM: Polynomial Mutation', num2str(Algo.MuM)};
        end

        function setParameter(Algo, Parameter)
            i = 1;
            Algo.G = str2double(Parameter{i}); i = i + 1;
            Algo.P = str2double(Parameter{i}); i = i + 1;
            Algo.MuC = str2double(Parameter{i}); i = i + 1;
            Algo.MuM = str2double(Parameter{i}); i = i + 1;
        end

        function run(Algo, Prob)
            % Initialize
            population = Initialization(Algo, Prob, Individual_ET);
            for t = 1:Prob.T
                [rank, FrontNo] = NSGA2Sort(population{t});
                for i = 1:length(population{t})
                    population{t}(i).FrontNo = FrontNo(i);
                end
                population{t} = population{t}(rank);
            end

            while Algo.notTerminated(Prob, population)
                for t = 1:Prob.T
                    % Transfer
                    transfer_pop = Algo.Transfer(population, t);
                    transfer_pop = Algo.Evaluation(transfer_pop, Prob, t);
                    for i = 1:length(population{t})
                        population{t}(i).isTrans = false;
                    end
                    % Generation
                    population{t} = [population{t}, transfer_pop];
                    mating_pool = TournamentSelection(2, Prob.N - Algo.G, [1:Prob.N, ones(1, Algo.G)]);
                    offspring = Algo.Generation(population{t}(mating_pool));
                    % Evaluation
                    offspring = Algo.Evaluation(offspring, Prob, t);
                    % Selection
                    population{t} = [population{t}, offspring];
                    [rank, FrontNo] = NSGA2Sort(population{t});
                    for i = 1:length(population{t})
                        population{t}(i).FrontNo = FrontNo(i);
                    end
                    population{t} = population{t}(rank(1:Prob.N));
                end
            end
        end

        function transfer_pop = Transfer(Algo, population, t)
            transfer_pop = Individual_ET.empty();
            s = find([population{t}.isTrans] == true & [population{t}.FrontNo] < 2);
            if ~isempty(s)
                G_temp = ceil(Algo.G / length(s));
                for i = 1:length(s)
                    transfer_temp = Individual_ET.empty();
                    ot = population{t}(s(i)).OriginTask;
                    [~, idx] = sort(sqrt(sum((repmat(population{t}(s(i)).Dec, length(population{ot}), 1) - population{ot}.Decs).^2, 2)));
                    for j = 1:G_temp
                        transfer_temp(j) = population{ot}(idx(j));
                        transfer_temp(j).OriginTask = ot;
                        transfer_temp(j).isTrans = true;
                    end
                    transfer_pop = [transfer_pop, transfer_temp];
                end
                transfer_pop = transfer_pop(1:Algo.G);
            else
                task_pool = 1:length(population);
                task_pool(task_pool == t) = [];
                for i = 1:Algo.G
                    ot = task_pool(randi(length(task_pool)));
                    transfer_pop(i) = population{ot}(randi(length(population{ot})));
                    transfer_pop(i).OriginTask = ot;
                    transfer_pop(i).isTrans = true;
                end
            end
            % Disturb
            for i = 1:Algo.G
                if rand() < Algo.P
                    transfer_pop(i).Dec = 2 * rand() * transfer_pop(i).Dec;
                    transfer_pop(i).Dec(transfer_pop(i).Dec > 1) = 1;
                    transfer_pop(i).Dec(transfer_pop(i).Dec < 0) = 0;
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
    end
end
