classdef MOMFEA_SADE < Algorithm
% <Multi-task> <Multi-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Liang2020MOMFEA-SADE,
%   title    = {Evolutionary Multitasking for Multiobjective Optimization With Subspace Alignment and Adaptive Differential Evolution},
%   author   = {Liang, Zhengping and Dong, Hao and Liu, Cheng and Liang, Weiqi and Zhu, Zexuan},
%   journal  = {IEEE Transactions on Cybernetics},
%   year     = {2020},
%   pages    = {1-14},
%   doi      = {10.1109/TCYB.2020.2980888},
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
    RMP = 0.3
    LP = 30
    F1 = 0.6
    F2 = 0.5
    LCR = 0.3
    UCR = 0.9
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'RMP: Random Mating Probability', num2str(Algo.RMP), ...
                'LP: Learning Period', num2str(Algo.LP), ...
                'F1: Mutation Factor 1', num2str(Algo.F1), ...
                'F2: Mutation Factor 2', num2str(Algo.F2), ...
                'LCR: Lower Crossover Rate', num2str(Algo.LCR), ...
                'UCR: Upper Crossover Rate', num2str(Algo.UCR)};
    end

    function setParameter(Algo, Parameter)
        i = 1;
        Algo.RMP = str2double(Parameter{i}); i = i + 1;
        Algo.LP = str2double(Parameter{i}); i = i + 1;
        Algo.F1 = str2double(Parameter{i}); i = i + 1;
        Algo.F2 = str2double(Parameter{i}); i = i + 1;
        Algo.LCR = str2double(Parameter{i}); i = i + 1;
        Algo.UCR = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialize
        population = Initialization(Algo, Prob, Individual_MOSADE);
        STNum = 3;
        R_Used = []; R_Succ = [];

        while Algo.notTerminated(Prob, population)
            if Algo.Gen <= Algo.LP
                DE_Pro = ones(1, STNum);
            else
                DE_Pro = sum(R_Succ(Algo.Gen - Algo.LP:Algo.Gen - 1, :) + 1, 1) ./ sum(R_Used(Algo.Gen - Algo.LP:Algo.Gen - 1, :) + 1, 1);
            end

            Best = Algo.getBest(population);
            for t = 1:Prob.T
                % DE Strategies
                DE_Pool{t} = Algo.getDEPool(DE_Pro, Prob.N);
                % Generation
                for i = 1:length(population{t})
                    population{t}(i).isChild = false;
                end
                offspring = Algo.Generation(population, Best, DE_Pool{t}, t);
                % Evaluation
                offspring = Algo.Evaluation(offspring, Prob, t);
                % Selection
                population{t} = [population{t}, offspring];
                rank = NSGA2Sort(population{t});
                population{t} = population{t}(rank(1:Prob.N));
            end
            % DE Strategies Probabilities Updation
            R_Used(Algo.Gen, :) = hist([DE_Pool{:}], 1:STNum);
            pop_all = [population{:}];
            child_idx = [pop_all.isChild] == true;
            DE_Succ = [pop_all(child_idx).ST];
            R_Succ(Algo.Gen, :) = hist(DE_Succ, 1:STNum);
        end
    end

    function offspring = Generation(Algo, population, Best, DE_Pool, t)
        other_task = 1:length(population);
        other_task(other_task == t) = [];
        for t = 1:length(population)
            pop_Dec{t} = population{t}.Decs;
        end

        x1_task = other_task(randi(length(other_task)));
        x1_Dec_other = Algo.domainAdaption(pop_Dec{t}, pop_Dec{x1_task}, randi(length(population{t}), 1, length(population{t})));
        x2_task = other_task(randi(length(other_task)));
        x2_Dec_other = Algo.domainAdaption(pop_Dec{t}, pop_Dec{x2_task}, randi(length(population{t}), 1, length(population{t})));
        x3_task = other_task(randi(length(other_task)));
        x3_Dec_other = Algo.domainAdaption(pop_Dec{t}, pop_Dec{x3_task}, randi(length(population{t}), 1, length(population{t})));

        for i = 1:length(population{t})
            offspring(i) = population{t}(i);
            A = randperm(length(population{t}), 4);
            A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3);
            CR = Algo.LCR + rand() .* (Algo.UCR - Algo.LCR);

            if rand() < Algo.RMP % Random Mating
                x1_Dec = x1_Dec_other(i, :);
                x2_Dec = x2_Dec_other(i, :);
                x3_Dec = x3_Dec_other(i, :);
                switch DE_Pool(i)
                    case 1 % DE/best/1/bin
                        offspring(i).Dec = population{t}(Best{t}(randi(length(Best{t})))).Dec + Algo.F1 * (x1_Dec - x2_Dec);
                        offspring(i).Dec = DE_Crossover(offspring(i).Dec, population{t}(i).Dec, CR);
                    case 2 % DE/rand/1/bin
                        offspring(i).Dec = x1_Dec + Algo.F1 * (x2_Dec - x3_Dec);
                        offspring(i).Dec = DE_Crossover(offspring(i).Dec, population{t}(i).Dec, CR);
                    case 3 % DE/current-to-rand/1
                        offspring(i).Dec = population{t}(i).Dec + Algo.F2 * (x1_Dec - population{t}(i).Dec) + Algo.F1 * (x2_Dec - x3_Dec);
                end
            else
                switch DE_Pool(i)
                    case 1 % DE/best/1/bin
                        offspring(i).Dec = population{t}(Best{t}(randi(length(Best{t})))).Dec + Algo.F1 * (population{t}(x1).Dec - population{t}(x2).Dec);
                        offspring(i).Dec = DE_Crossover(offspring(i).Dec, population{t}(i).Dec, CR);
                    case 2 % DE/rand/1/bin
                        offspring(i).Dec = population{t}(x1).Dec + Algo.F1 * (population{t}(x2).Dec - population{t}(x3).Dec);
                        offspring(i).Dec = DE_Crossover(offspring(i).Dec, population{t}(i).Dec, CR);
                    case 3 % DE/current-to-rand/1
                        offspring(i).Dec = population{t}(i).Dec + Algo.F2 * (population{t}(x1).Dec - population{t}(i).Dec) + Algo.F1 * (population{t}(x2).Dec - population{t}(x3).Dec);
                end
            end

            offspring(i).Dec(offspring(i).Dec > 1) = 1;
            offspring(i).Dec(offspring(i).Dec < 0) = 0;

            offspring(i).isChild = true;
            offspring(i).ST = DE_Pool(i);
        end
    end

    function Best = getBest(Algo, population)
        Best = {};
        for t = 1:length(population)
            FrontNo = NDSort(population{t}.Objs, population{t}.CVs, inf);
            Best{t} = find(FrontNo == 1);
        end
    end

    function DE_Pool = getDEPool(Algo, DE_Pro, N)
        DE_Pool = [];
        roulette = DE_Pro / sum(DE_Pro);
        for i = 1:N
            r = rand();
            for k = 1:length(DE_Pro)
                if r <= sum(roulette(1:k))
                    DE_Pool(i) = k;
                    break;
                end
            end
        end
    end

    function TransferredDec = domainAdaption(Algo, TDecs, ODecs, x)
        dim = size(ODecs, 2);
        coeff_t = pca(TDecs, 'NumComponents', dim * 0.5);
        coeff_o = pca(ODecs, 'NumComponents', dim * 0.5);

        orth_coeff_t = orth(coeff_t);
        orth_coeff_o = orth(coeff_o);

        Xb = orth_coeff_t * orth_coeff_o' * orth_coeff_t;

        o_pca_sa = ODecs * Xb;
        o_pca_sa_re = o_pca_sa * coeff_t';
        max_v = max(max(o_pca_sa_re));
        min_v = min(min(o_pca_sa_re));

        TransferredDec = (o_pca_sa_re(x, :) - min_v) ./ (max_v - min_v);
    end
end
end
