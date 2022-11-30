classdef EMT_PD < Algorithm
    % <Multi-task> <Multi-objective> <None/Constrained>

    %------------------------------- Reference --------------------------------
    % @Article{Liang2021EMT-PD,
    %   title    = {Multiobjective Evolutionary Multitasking With Two-Stage Adaptive Knowledge Transfer Based on Population Distribution},
    %   author   = {Liang, Zhengping and Liang, Weiqi and Wang, Zhiqiang and Ma, Xiaoliang and Liu, Ling and Zhu, Zexuan},
    %   journal  = {IEEE Transactions on Systems, Man, and Cybernetics: Systems},
    %   year     = {2021},
    %   pages    = {1-13},
    %   doi      = {10.1109/TSMC.2021.3096220},
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
        G = 5
        MuC = 20
        MuM = 15
    end

    methods
        function Parameter = getParameter(Algo)
            Parameter = {'RMP: Random Mating Probability', num2str(Algo.RMP), ...
                        'G: Transfer Gap', num2str(Algo.G), ...
                        'MuC: Simulated Binary Crossover', num2str(Algo.MuC), ...
                        'MuM: Polynomial Mutation', num2str(Algo.MuM)};
        end

        function setParameter(Algo, Parameter)
            i = 1;
            Algo.RMP = str2double(Parameter{i}); i = i + 1;
            Algo.G = str2double(Parameter{i}); i = i + 1;
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
                rank = NSGA2Sort(population{t});
                population{t} = population{t}(rank);
            end

            while Algo.notTerminated(Prob, population)
                if mod(Algo.Gen, Algo.G) ~= 0
                    % Generation
                    mating_pool = TournamentSelection(2, Prob.N * Prob.T, repmat(1:Prob.N, 1, Prob.T));
                    parent = [population{:}];
                    offspring = Algo.Generation(parent(mating_pool));
                else
                    % Transfer
                    offspring = Algo.Transfer(Prob, population);
                end
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

        function offspring = Transfer(Algo, Prob, population)
            model_size = min([Prob.N, 40]);
            count = 1;
            for t = 1:Prob.T
                P = population{t}(1:model_size).Decs';
                task_pool = 1:Prob.T;
                task_pool(task_pool == t) = [];
                k = task_pool(randi(length(task_pool)));
                Q = population{k}(1:model_size).Decs';
                for dim1 = 1:max(Prob.D)
                    a = P(dim1, :);
                    c = Q(dim1, :);
                    for dim2 = 1:max(Prob.D)
                        b = P(dim2, :);
                        d = Q(dim2, :);
                        e = cov(a, b);
                        A_t(dim1, dim2) = e(1, 2);
                        f = cov(c, d);
                        A_k(dim1, dim2) = f(1, 2);
                    end
                end
                avg_P = mean(P, 2);
                avg_Q = mean(Q, 2);
                A = inv(inv(A_t) + inv(A_k));
                avg_n = A * (inv(A_t) * avg_P + inv(A_k) * avg_Q);
                max_n = max(avg_n);
                min_n = min(avg_n);
                avg_n = (avg_n - min_n) / (max_n - min_n);
                w1 = avg_P - avg_n;
                for i = 1:Prob.N
                    a = randi(model_size);
                    b = randi(model_size);
                    offspring(count) = Individual_MF();
                    offspring(count).MFFactor = t;
                    offspring(count).Dec = w1' .* P(:, a)' + (1 - w1)' .* Q(:, b)';
                    offspring(count).Dec = GA_Mutation(offspring(count).Dec, Algo.MuM);
                    offspring(count).Dec(offspring(count).Dec > 1) = 1;
                    offspring(count).Dec(offspring(count).Dec < 0) = 0;
                    idx = find(isnan(offspring(count).Dec));
                    offspring(count).Dec(idx) = rand(1, length(idx));
                    count = count + 1;
                end
            end
        end

        function offspring = Generation(Algo, population)
            count = 1;
            for i = 1:ceil(length(population) / 2)
                p1 = i; p2 = i + fix(length(population) / 2);
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
    end
end
