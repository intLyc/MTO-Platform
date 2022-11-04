classdef MO_MFEA < Algorithm
    % <MT-MO> <None/Constrained>

    %------------------------------- Reference --------------------------------
    % @article{Gupta2017MO-MFEA,
    %   title      = {Multiobjective Multifactorial Optimization in Evolutionary Multitasking},
    %   author     = {Gupta, Abhishek and Ong, Yew-Soon and Feng, Liang and Tan, Kay Chen},
    %   journal    = {IEEE Transactions on Cybernetics},
    %   number     = {7},
    %   pages      = {1652-1665},
    %   volume     = {47},
    %   year       = {2017}
    %   doi        = {10.1109/TCYB.2016.2554622},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        RMP = 0.3
        MuC = 10
        MuM = 10
    end

    methods
        function Parameter = getParameter(Algo)
            Parameter = {'RMP: Random Mating Probability', num2str(Algo.RMP), ...
                        'MuC: Simulated Binary Crossover', num2str(Algo.MuC), ...
                        'MuM: Polynomial Mutation', num2str(Algo.MuM)};
        end

        function setParameter(Algo, Parameter)
            i = 1;
            Algo.RMP = str2double(Parameter{i}); i = i + 1;
            Algo.MuC = str2double(Parameter{i}); i = i + 1;
            Algo.MuM = str2double(Parameter{i}); i = i + 1;
        end

        function run(Algo, Prob)
            % Initialize
            population = Initialization(Algo, Prob, Individual_MF);
            for t = 1:Prob.T
                for i = 1:Prob.N
                    population{t}(i).MFFactor = t;
                end
            end

            while Algo.notTerminated(Prob, population)
                % Generation
                population = Algo.MFSort(population);
                offspring = Algo.Generation([population{:}]);
                for t = 1:Prob.T
                    % Evaluation
                    offspring_t = offspring([offspring.MFFactor] == t);
                    offspring_t = Algo.Evaluation(offspring_t, Prob, t);
                    % Selection
                    population{t} = [population{t}, offspring_t];
                    [FrontNo, MaxFNo] = NDSort(population{t}.Objs, population{t}.CVs, Prob.N);
                    Next = FrontNo < MaxFNo;
                    CrowdDis = CrowdingDistance(population{t}.Objs, FrontNo);
                    Last = find(FrontNo == MaxFNo);
                    [~, Rank] = sort(CrowdDis(Last), 'descend');
                    Next(Last(Rank(1:Prob.N - sum(Next)))) = true;
                    population{t} = population{t}(Next);
                end
            end
        end

        function offspring = Generation(Algo, population)
            count = 1;
            for i = 1:ceil(length(population) / 2)
                % parent tournament selection
                t1 = randi(length(population)); t2 = randi(length(population));
                if population(t1).MFRank < population(t1).MFRank
                    p1 = t1;
                else
                    p1 = t2;
                end
                t1 = randi(length(population)); t2 = randi(length(population));
                if population(t1).MFRank < population(t1).MFRank
                    p2 = t1;
                else
                    p2 = t2;
                end

                % multifactorial generation
                offspring(count) = population(p1);
                offspring(count + 1) = population(p2);
                if (population(p1).MFFactor == population(p2).MFFactor) || rand() < Algo.RMP
                    % crossover
                    [offspring(count).Dec, offspring(count + 1).Dec] = GA_Crossover(population(p1).Dec, population(p2).Dec, Algo.MuC);
                    % mutation
                    offspring(count).Dec = GA_Mutation(offspring(count).Dec, Algo.MuM);
                    offspring(count + 1).Dec = GA_Mutation(offspring(count + 1).Dec, Algo.MuM);
                    % imitation
                    p = [p1, p2];
                    offspring(count).MFFactor = population(p(randi(2))).MFFactor;
                    offspring(count + 1).MFFactor = population(p(randi(2))).MFFactor;
                else
                    % mutation
                    offspring(count).Dec = GA_Mutation(population(p1).Dec, Algo.MuM);
                    offspring(count + 1).Dec = GA_Mutation(population(p2).Dec, Algo.MuM);
                    % imitation
                    offspring(count).MFFactor = population(p1).MFFactor;
                    offspring(count + 1).MFFactor = population(p2).MFFactor;
                end
                for x = count:count + 1
                    offspring(x).Dec(offspring(x).Dec > 1) = 1;
                    offspring(x).Dec(offspring(x).Dec < 0) = 0;
                end
                count = count + 2;
            end
        end

        function population = MFSort(Algo, population)
            for t = 1:length(population)
                FrontNo = NDSort(population{t}.Objs, population{t}.CVs, inf);
                CrowdDis = CrowdingDistance(population{t}.Objs, FrontNo);
                [~, rank] = sortrows([FrontNo', -CrowdDis']);
                for i = 1:length(population{t})
                    population{t}(rank(i)).MFRank = i;
                end
            end
        end
    end
end
