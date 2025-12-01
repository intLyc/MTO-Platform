classdef SaDE < Algorithm
% <Single-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Qin2009SaDE,
%   title      = {Differential Evolution Algorithm With Strategy Adaptation for Global Numerical Optimization},
%   author     = {Qin, A. K. and Huang, V. L. and Suganthan, P. N.},
%   journal    = {IEEE Transactions on Evolutionary Computation},
%   year       = {2009},
%   number     = {2},
%   pages      = {398-417},
%   volume     = {13},
%   doi        = {10.1109/TEVC.2008.927706},
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
    LP = 30
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'LP: Learning Period', num2str(Algo.LP)};
    end

    function Algo = setParameter(Algo, Parameter)
        Algo.LP = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialization
        population = Initialization(Algo, Prob, Individual_DE);
        for t = 1:Prob.T
            succ{t} = []; fail{t} = [];
            stProb{t} = ones(4, 1) / 4;
            for k = 1:4
                CRMem{t, k} = [];
            end
        end

        while Algo.notTerminated(Prob, population)
            for t = 1:Prob.T
                if Algo.Gen > Algo.LP
                    % Update strategy probability
                    S = sum(succ{t}, 2) ./ (sum(succ{t}, 2) + sum(fail{t}, 2)) + 0.01;
                    stProb{t} = S / sum(S);
                    if size(succ{t}, 2) > Algo.LP
                        succ{t} = succ{t}(:, end - Algo.LP + 1:end);
                        fail{t} = fail{t}(:, end - Algo.LP + 1:end);
                    end
                    % Update CR median
                    for k = 1:4
                        CRm(k) = median(CRMem{t, k});
                        if length(CRMem{t, k}) > Algo.LP
                            CRMem{t, k} = CRMem{t, k}(end - Algo.LP + 1:end);
                        end
                    end
                else
                    CRm = 0.5 * ones(4, 1);
                end

                % Generation
                [offspring, flag] = Algo.Generation(population{t}, stProb{t}, CRm);
                % Evaluation
                offspring = Algo.Evaluation(offspring, Prob, t);
                % Selection
                [population{t}, replace] = Selection_Tournament(population{t}, offspring);

                % Update succ and fail memory
                ns = accumarray(flag(:), replace(:), [4, 1], @sum, 0);
                nf = accumarray(flag(:), ~replace(:), [4, 1], @sum, 0);
                succ{t} = [succ{t}, ns];
                fail{t} = [fail{t}, nf];

                for k = 1:4
                    CRsucc = [offspring(flag == k & replace).CR];
                    CRMem{t, k} = [CRMem{t, k}, CRsucc];
                end
            end
        end
    end

    function [offspring, flag] = Generation(Algo, population, stProb, CRm)
        offspring = population;
        minCV = min([population.CVs]);
        idxCV = find([population.CVs] == minCV);
        [~, idxObj] = min([population(idxCV).Objs]);
        best = idxCV(idxObj);

        flag = zeros(1, length(population));
        for i = 1:length(population)
            k = find(rand() <= cumsum(stProb), 1);
            flag(i) = k;
            offspring(i).F = 0.5 + randn() * 0.3;
            offspring(i).CR = CRm(k) + randn() * 0.1;
            while offspring(i).CR > 1 || offspring(i).CR < 0
                offspring(i).CR = CRm(k) + randn() * 0.1;
            end
            switch k
                case 1 % DE/rand/1/bin
                    A = randperm(length(population), 4);
                    A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3);
                    offspring(i).Dec = population(x1).Dec + offspring(i).F * (population(x2).Dec - population(x3).Dec);
                    offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, offspring(i).CR);
                case 2 % DE/rand-to-best/2/bin
                    A = randperm(length(population), 5);
                    A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3); x4 = A(4);
                    offspring(i).Dec = population(i).Dec + offspring(i).F * (population(best).Dec - population(i).Dec) + ...
                        offspring(i).F * (population(x1).Dec - population(x2).Dec) + ...
                        offspring(i).F * (population(x3).Dec - population(x4).Dec);
                    offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, offspring(i).CR);
                case 3 % DE/rand/2/bin
                    A = randperm(length(population), 6);
                    A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3); x4 = A(4); x5 = A(5);
                    offspring(i).Dec = population(x1).Dec + offspring(i).F * (population(x2).Dec - population(x3).Dec) + ...
                        offspring(i).F * (population(x4).Dec - population(x5).Dec);
                    offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, offspring(i).CR);
                case 4 % DE/current-to-rand/1
                    A = randperm(length(population), 4);
                    A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3);
                    offspring(i).Dec = population(i).Dec + rand() * (population(x1).Dec - population(i).Dec) + ...
                        offspring(i).F * (population(x2).Dec - population(x3).Dec);
            end
            idx = offspring(i).Dec < 0 | offspring(i).Dec > 1;
            offspring(i).Dec(idx) = rand(size(offspring(i).Dec(idx)));
        end
    end
end
end
