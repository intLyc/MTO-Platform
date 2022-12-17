classdef MO_MFEA_II < Algorithm
% <Multi-task> <Multi-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Bali2021MO-MFEA2,
%   title    = {Cognizant Multitasking in Multiobjective Multifactorial Evolution: MO-MFEA-II},
%   author   = {Bali, Kavitesh Kumar and Gupta, Abhishek and Ong, Yew-Soon and Tan, Puay Siew},
%   journal  = {IEEE Transactions on Cybernetics},
%   year     = {2021},
%   number   = {4},
%   pages    = {1784-1796},
%   volume   = {51},
%   doi      = {10.1109/TCYB.2020.2981733},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
%--------------------------------------------------------------------------

properties (SetAccess = private)
    MuC = 20
    MuM = 15
    Swap = 0.5
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'MuC: Simulated Binary Crossover', num2str(Algo.MuC), ...
                'MuM: Polynomial Mutation', num2str(Algo.MuM), ...
                'probSwap: Variable Swap Probability', num2str(Algo.Swap)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.MuC = str2double(Parameter{i}); i = i + 1;
        Algo.MuM = str2double(Parameter{i}); i = i + 1;
        Algo.Swap = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialize
        population = Initialization(Algo, Prob, Individual_MF);
        for t = 1:Prob.T
            for i = 1:Prob.N
                population{t}(i).MFFactor = t;
            end
            rank = NSGA2Sort(population{t});
            population{t} = population{t}(rank);
        end

        while Algo.notTerminated(Prob, population)
            % Extract task specific data sets
            for t = 1:Prob.T
                subpops(t).data = [];
                for i = 1:length(population{t})
                    subpops(t).data = [subpops(t).data; population{t}(i).Dec];
                end
            end
            RMP = learnRMP(subpops, Prob.D); % learning RMP matrix online at every generation.

            % Generation
            mating_pool = TournamentSelection(2, Prob.N * Prob.T, repmat(1:Prob.N, 1, Prob.T));
            parent = [population{:}];
            offspring = Algo.Generation(parent(mating_pool), RMP);
            for t = 1:Prob.T
                % Evaluation
                offspring_t = offspring([offspring.MFFactor] == t);
                offspring_t = Algo.Evaluation(offspring_t, Prob, t);
                % Selection
                population{t} = [population{t}, offspring_t];
                rank = NSGA2Sort(population{t});
                population{t} = population{t}(rank(1:Prob.N));
            end
        end
    end

    function offspring = Generation(Algo, population, RMP)
        count = 1;
        for i = 1:ceil(length(population) / 2)
            p1 = i; p2 = i + fix(length(population) / 2);
            rmp = RMP(population(p1).MFFactor, population(p2).MFFactor);
            % multifactorial generation
            offspring(count) = population(p1);
            offspring(count + 1) = population(p2);
            if (population(p1).MFFactor == population(p2).MFFactor) || rand() < rmp
                % crossover
                [offspring(count).Dec, offspring(count + 1).Dec] = GA_Crossover(population(p1).Dec, population(p2).Dec, Algo.MuC);
                % mutation
                offspring(count).Dec = GA_Mutation(offspring(count).Dec, Algo.MuM);
                offspring(count + 1).Dec = GA_Mutation(offspring(count + 1).Dec, Algo.MuM);
                % variable swap (uniform X)
                swap_indicator = (rand(1, length(population(p1).Dec)) >= Algo.Swap);
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
                    [offspring(count + x - 1).Dec, offspring_temp.Dec] = GA_Crossover(population(p(x)).Dec, population(idx).Dec, Algo.MuC);
                    % mutation
                    offspring(count + x - 1).Dec = GA_Mutation(offspring(count + x - 1).Dec, Algo.MuM);
                    offspring_temp.Dec = GA_Mutation(offspring_temp.Dec, Algo.MuM);
                    % variable swap (uniform X)
                    swap_indicator = (rand(1, length(population(p(x)).Dec)) >= Algo.Swap);
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
