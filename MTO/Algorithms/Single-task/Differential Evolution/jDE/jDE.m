classdef jDE < Algorithm
% <Single-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Brest2006jDE,
%   title   = {Self-Adapting Control Parameters in Differential Evolution: A Comparative Study on Numerical Benchmark Problems},
%   author  = {Brest, Janez and Greiner, Sao and Boskovic, Borko and Mernik, Marjan and Zumer, Viljem},
%   journal = {IEEE Transactions on Evolutionary Computation},
%   year    = {2006},
%   number  = {6},
%   pages   = {646-657},
%   volume  = {10},
%   doi     = {10.1109/TEVC.2006.872133},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties (SetAccess = public)
    T1 = 0.1
    T2 = 0.1
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'T1: probability of F change', num2str(Algo.T1), ...
                'T2: probability of CR change', num2str(Algo.T2)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.T1 = str2double(Parameter{i}); i = i + 1;
        Algo.T2 = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialization
        population = Initialization(Algo, Prob, Individual_DE);
        for t = 1:Prob.T
            % initialize F and CR
            for i = 1:length(population{t})
                population{t}(i).F = rand() * 0.9 + 0.1;
                population{t}(i).CR = rand();
            end
        end

        while Algo.notTerminated(Prob, population)
            for t = 1:Prob.T
                % Generation
                offspring = Algo.Generation(population{t});
                % Evaluation
                offspring = Algo.Evaluation(offspring, Prob, t);
                % Selection
                population{t} = Selection_Tournament(population{t}, offspring);
            end
        end
    end

    function offspring = Generation(Algo, population)
        for i = 1:length(population)
            offspring(i) = population(i);

            % parameter self-adaptation
            offspring(i).F = population(i).F;
            offspring(i).CR = population(i).CR;
            if rand() < Algo.T1
                offspring(i).F = rand() * 0.9 + 0.1;
            end
            if rand() < Algo.T2
                offspring(i).CR = rand();
            end

            A = randperm(length(population), 4);
            A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3);

            offspring(i).Dec = population(x1).Dec + offspring(i).F * (population(x2).Dec - population(x3).Dec);
            offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, offspring(i).CR);

            offspring(i).Dec(offspring(i).Dec > 1) = 1;
            offspring(i).Dec(offspring(i).Dec < 0) = 0;
        end
    end
end
end
