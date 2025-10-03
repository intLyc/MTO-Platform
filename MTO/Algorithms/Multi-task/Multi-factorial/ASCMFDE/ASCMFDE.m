classdef ASCMFDE < Algorithm
% <Multi-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Tang2021ASCMFDE,
%   title   = {Regularized Evolutionary Multitask Optimization: Learning to Intertask Transfer in Aligned Subspace},
%   author  = {Tang, Zedong and Gong, Maoguo and Wu, Yue and Liu, Wenfeng and Xie, Yu},
%   journal = {IEEE Transactions on Evolutionary Computation},
%   year    = {2021},
%   number  = {2},
%   pages   = {262-276},
%   volume  = {25},
%   doi     = {10.1109/TEVC.2020.3023480},
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
    RMP = 0.3
    F = 0.5
    CR = 0.7
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'RMP: Random Mating Probability', num2str(Algo.RMP), ...
                'F: Mutation Factor', num2str(Algo.F), ...
                'CR: Crossover Rate', num2str(Algo.CR)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.RMP = str2double(Parameter{i}); i = i + 1;
        Algo.F = str2double(Parameter{i}); i = i + 1;
        Algo.CR = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialize
        population = Initialization_MF(Algo, Prob, Individual_MF);

        while Algo.notTerminated(Prob, population)
            PopDec = {};
            for t = 1:Prob.T
                PopDec{t} = population([population.MFFactor] == t).Decs;
                Pm(t, :) = mean(PopDec{t}, 1);
                PopDec{t} = PopDec{t} - repmat(Pm(t, :), size(PopDec{t}, 1), 1);
            end

            dim = Inf;
            for t = 1:Prob.T
                [popNew{t}, pcaModel{t}] = ftProc_pca_tr(PopDec{t}, [], struct('pcaCoef', 0));
                if size(pcaModel{t}.W_prj, 2) < dim
                    dim = size(pcaModel{t}.W_prj, 2);
                end
            end
            dim = floor(0.8 * dim);
            for t = 1:Prob.T
                QQ{t} = pcaModel{t}.W_prj(:, 1:dim);
            end

            M = cell(Prob.T, Prob.T);
            for t = 1:Prob.T
                for j = t:Prob.T
                    if t == j
                        M{t, j} = eye(dim);
                    else
                        M{t, j} = QQ{t}' * QQ{j};
                        M{j, t} = QQ{j}' * QQ{t};
                    end
                end
            end

            % Generation
            offspring = Algo.Generation(population, Pm, QQ, dim, M, Prob.T);
            % Evaluation
            offspring_temp = Individual_MF.empty();
            for t = 1:Prob.T
                offspring_t = offspring([offspring.MFFactor] == t);
                offspring_t = Algo.Evaluation(offspring_t, Prob, t);
                for i = 1:length(offspring_t)
                    offspring_t(i).MFObj = inf(1, Prob.T);
                    offspring_t(i).MFCV = inf(1, Prob.T);
                    offspring_t(i).MFObj(t) = offspring_t(i).Obj;
                    offspring_t(i).MFCV(t) = offspring_t(i).CV;
                end
                offspring_temp = [offspring_temp, offspring_t];
            end
            offspring = offspring_temp;
            % selection
            population = Selection_MF(population, offspring, Prob);
        end
    end

    function offspring = Generation(Algo, population, Pm, QQ, dim, M, T)
        for t = 1:T
            pop{t} = population([population.MFFactor] == t);
        end

        for i = 1:length(population)
            offspring(i) = population(i);

            target = population(i).MFFactor;
            offspring(i).MFFactor = target;

            if rand() < Algo.RMP
                source = randi(T);
                while source == target
                    source = randi(T);
                end
                pop_M = [pop{target}, pop{source}];
                A = randperm(length(pop_M), 3);
                x1 = A(1); x2 = A(2); x3 = A(3);

                p2 = (pop_M(x2).Dec - Pm(pop_M(x2).MFFactor, :)) * QQ{pop_M(x2).MFFactor};
                p3 = (pop_M(x3).Dec - Pm(pop_M(x3).MFFactor, :)) * QQ{pop_M(x3).MFFactor};

                nn = randi(3);
                switch nn
                    case 1
                        newpos = Algo.F * (rand(1, dim) .* (p2 - p3)) * ...
                            M{pop_M(x2).MFFactor, target} * QQ{target}';
                    case 2
                        newpos = Algo.F * (rand(1, dim) .* (p2 - p3)) * ...
                            M{pop_M(x2).MFFactor, target} * QQ{target}' + ...
                            0.5 * Algo.F * (Pm(pop_M(x2).MFFactor, :) - Pm(pop_M(x3).MFFactor, :));
                    case 3
                        newpos = Algo.F * ((pop_M(x2).Dec) - (pop_M(x3).Dec));
                end
                offspring(i).Dec = pop_M(x1).Dec + newpos;
                offspring(i).Dec = Algo.mutate(offspring(i).Dec, 0.01);
                offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, Algo.CR);
            else
                A = randperm(length(pop{target}), 3);
                x1 = A(1); x2 = A(2); x3 = A(3);

                offspring(i).Dec = pop{target}(x1).Dec + Algo.F * (pop{target}(x2).Dec - pop{target}(x3).Dec);
                offspring(i).Dec = Algo.mutate(offspring(i).Dec, 0.01);
                offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, Algo.CR);
            end

            offspring(i).Dec(offspring(i).Dec > 1) = 1;
            offspring(i).Dec(offspring(i).Dec < 0) = 0;
        end
    end

    function object = mutate(Algo, p, mum)
        dim = length(p);
        rnvec_temp = p;
        for i = 1:dim
            if rand() < mum
                rnvec_temp(i) = rand();
            end
        end
        rnvec_temp(rnvec_temp > 1) = rand();
        rnvec_temp(rnvec_temp < 0) = rand();
        object = rnvec_temp;
    end
end
end
