classdef CMOCSO < Algorithm
% <Single-task> <Multi-objective> <Constrained>

%------------------------------- Reference --------------------------------
% @Article{Ming2022CMOCSO,
%   title   = {A Competitive and Cooperative Swarm Optimizer for Constrained Multi-objective Optimization Problems},
%   author  = {Ming, Fei and Gong, Wenyin and Li, Dongcheng and Wang, Ling and Gao, Liang},
%   journal = {IEEE Transactions on Evolutionary Computation},
%   year    = {2022},
%   pages   = {1-1},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties (SetAccess = public)
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
        % Initialize
        population = Initialization(Algo, Prob, Individual_PSO);
        for t = 1:Prob.T
            CV = sum(max(0, population{t}.CVs), 2);
            CVmax = max(CV);
            epsilon_0 = CVmax;
            epsilon{t} = epsilon_0;
            [pop_com{t}, fit_com{t}] = Selection_SPEA2(population{t}, Prob.N, epsilon{t});
            [pop_coo{t}, fit_coo{t}] = Selection_SPEA2(population{t}, Prob.N, inf);
            population{t} = Selection_SPEA2(population{t}, Prob.N, 0);
        end
        Tc = 0.9 * ceil(Prob.maxFE / (Prob.N * Prob.T));
        cp = 2;
        alpha = 0.95;
        tao = 0.05;
        y = 10;
        G = Prob.maxFE / (Prob.N * Prob.T);

        while Algo.notTerminated(Prob, population)
            for t = 1:Prob.T
                CV = sum(max(0, pop_com{t}.CVs), 2);
                CV_max = max(CV);
                CVmax = max([CV_max, CVmax]);
                epsilon_0 = CVmax;
                rf = sum(CV <= 1e-6) / length(pop_com{t});
                epsilon{t} = Algo.Update_epsilon(tao, epsilon{t}, epsilon_0, rf, alpha, Algo.Gen, Tc, cp);

                rnd_idx = randperm(Prob.N);
                loser = rnd_idx(1:end / 2);
                winner = rnd_idx(end / 2 + 1:end);
                replace = fit_com{t}(winner) > fit_com{t}(loser);
                temp = winner(replace);
                winner(replace) = loser(replace);
                loser(replace) = temp;
                off_com = Algo.Generation_COM(pop_com{t}(loser), pop_com{t}(winner), y);

                learning_pool = TournamentSelection(2, Prob.N, fit_coo{t});
                off_coo = Algo.Generation_COO(pop_coo{t}(learning_pool));

                offspring = [off_com, off_coo];
                offspring = Algo.Evaluation(offspring, Prob, t);

                [pop_com{t}, fit_com{t}] = Selection_SPEA2([pop_com{t}, offspring], Prob.N, epsilon{t});
                [pop_coo{t}, fit_coo{t}] = Selection_SPEA2([pop_coo{t}, offspring], Prob.N, inf);
                population{t} = Selection_SPEA2([population{t}, offspring], Prob.N, 0);
            end
            y = (Prob.M(t))^2 * ((Algo.Gen / G) - 1)^2 + 1;
        end
    end

    function offspring = Generation_COM(Algo, loser, winner, y)
        % The competitive swarm optimizer
        count = 1;
        for i = 1:length(loser)
            offspring(count) = loser(i);
            offspring(count + 1) = winner(i);
            % Velocity update
            offspring(count).V = rand() * loser(i).V + ...
                rand() .* (winner(i).Dec - loser(i).Dec) * y;

            % Position update
            n = randi(2, 1, 1);
            offspring(count).Dec = loser(i).Dec + offspring(count).V + ...
                rand() .* (offspring(count).V - loser(i).V) * (-1)^n;

            offspring(count).Dec = GA_Mutation(offspring(count).Dec, Algo.MuM);
            offspring(count + 1).Dec = GA_Mutation(offspring(count + 1).Dec, Algo.MuM);

            for x = count:count + 1
                offspring(x).Dec(offspring(x).Dec > 1) = 1;
                offspring(x).Dec(offspring(x).Dec < 0) = 0;
            end
            count = count + 2;
        end
    end

    function offspring = Generation_COO(Algo, population)
        % The cooperative swarm optimizer based on GA formula
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

    function epsilon = Update_epsilon(Algo, tao, epsilon_k, epsilon_0, rf, alpha, gen, Tc, cp)
        if gen > Tc
            epsilon = 0;
        else
            if rf < alpha
                epsilon = (1 - tao) * epsilon_k;
            else
                epsilon = epsilon_0 * ((1 - (gen / Tc))^cp);
            end
        end
    end
end
end
