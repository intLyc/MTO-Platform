classdef Global_GA < Algorithm
% <Single-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Bull2024Global-GA,
%   title    = {On Cooperative Coevolution and Global Crossover},
%   author   = {Bull, Larry and Liu, Haixia},
%   journal  = {IEEE Transactions on Evolutionary Computation},
%   year     = {2024},
%   pages    = {1-1},
%   doi      = {10.1109/TEVC.2024.3355776},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties (SetAccess = private)
    S = 10
    MuC = 2
    MuM = 5
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'Global Crossover Points', num2str(Algo.S), ...
                'MuC: Simulated Binary Crossover', num2str(Algo.MuC), ...
                'MuM: Polynomial Mutation', num2str(Algo.MuM)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.S = str2double(Parameter{i}); i = i + 1;
        Algo.MuC = str2double(Parameter{i}); i = i + 1;
        Algo.MuM = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialization
        Algo.S = min(Algo.S, min(Prob.D));
        population = Initialization(Algo, Prob, Individual);

        while Algo.notTerminated(Prob, population)
            for t = 1:Prob.T
                % Generation
                offspring = Algo.Generation(population{t});
                % Evaluation
                offspring = Algo.Evaluation(offspring, Prob, t);
                % Selection
                population{t} = Selection_Elit(population{t}, offspring);
            end
        end
    end

    function offspring = Generation(Algo, population)
        N = length(population);
        indorder = TournamentSelection(2, N, 1:N);
        gidx = randperm(length(population(1).Dec), Algo.S);
        count = 1;
        for i = 1:ceil(N / 2)
            p1 = indorder(i);
            p2 = indorder(i + fix(N / 2));
            offspring(count) = population(p1);
            offspring(count + 1) = population(p2);

            for s = 1:Algo.S
                idx = TournamentSelection(2, 2, 1:N);
                p1 = idx(1); p2 = idx(2);
                offspring(count).Dec(gidx(s)) = population(p1).Dec(gidx(s));
                offspring(count + 1).Dec(gidx(s)) = population(p2).Dec(gidx(s));
            end

            [offspring(count).Dec, offspring(count + 1).Dec] = ...
                GA_Crossover(offspring(count).Dec, offspring(count + 1).Dec, Algo.MuC);

            offspring(count).Dec = GA_Mutation(offspring(count).Dec, Algo.MuM);
            offspring(count + 1).Dec = GA_Mutation(offspring(count + 1).Dec, Algo.MuM);

            for x = count:count + 1
                offspring(x).Dec = max(0, min(1, offspring(x).Dec));
            end
            count = count + 2;
        end
    end
end
end
