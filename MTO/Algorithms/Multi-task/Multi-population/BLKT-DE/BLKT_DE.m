classdef BLKT_DE < Algorithm
% <Multi-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Jiang2023BLKT-DE,
%   title    = {Block-Level Knowledge Transfer for Evolutionary Multitask Optimization},
%   author   = {Jiang, Yi and Zhan, Zhi-Hui and Tan, Kay Chen and Zhang, Jun},
%   journal  = {IEEE Transactions on Cybernetics},
%   year     = {2023},
%   pages    = {1-14},
%   doi      = {10.1109/TCYB.2023.3273625},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
%--------------------------------------------------------------------------

properties (SetAccess = private)
    F = 0.5
    CR = 0.7
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'F: Mutation Factor', num2str(Algo.F), ...
                'CR: Crossover Rate', num2str(Algo.CR)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.F = str2double(Parameter{i}); i = i + 1;
        Algo.CR = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialization
        population = Initialization(Algo, Prob, Individual);
        maxD = min(Prob.D);
        divD = randi([1, maxD]);
        minK = 2;
        maxK = Prob.N / 2;
        divK = randi([minK, maxK]);

        while Algo.notTerminated(Prob)
            corre = [];
            for t = 1:Prob.T
                for i = 1:Prob.N
                    for j = 1:ceil(Prob.D(t) / divD)
                        if j * divD > Prob.D(t)
                            corre = [corre; [t, i, 1 + (j - 1) * divD, Prob.D(t)]];
                        else
                            corre = [corre; [t, i, 1 + (j - 1) * divD, j * divD]];
                        end
                    end
                end
            end
            dimVal = [];
            for i = 1:size(corre, 1)
                dimVal = [dimVal; Algo.correDecode(population, corre(i, :), divD)];
            end
            idx = kmeans(dimVal, divK);
            subpop = cell(1, divK);
            for i = 1:divK
                subpop{i} = [];
            end
            for i = 1:length(idx)
                subpop{idx(i)} = [subpop{idx(i)}; corre(i, :)];
            end

            offspring_temp = [];
            off_corre = [];
            for k = 1:divK
                for i = 1:size(subpop{k}, 1)
                    if size(subpop{k}, 1) < 4
                        continue
                    end
                    A = randperm(size(subpop{k}, 1), 4);
                    A(A == i) = []; r1 = A(1); r2 = A(2); r3 = A(3);
                    dp1 = Algo.correDecode(population, subpop{k}(r1, :), divD);
                    dp2 = Algo.correDecode(population, subpop{k}(r2, :), divD);
                    dp3 = Algo.correDecode(population, subpop{k}(r3, :), divD);
                    v = dp1 + Algo.F * (dp2 - dp3);
                    v = min(1, max(0, v));
                    u = Algo.correDecode(population, subpop{k}(i, :), divD);
                    u = DE_Crossover(v, u, Algo.CR);
                    offspring_temp = [offspring_temp; u];
                    off_corre = [off_corre; subpop{k}(i, :)];
                end
            end

            offspring1 = population;
            for i = 1:size(off_corre, 1)
                data_seq = off_corre(i, :);
                offspring1{data_seq(1)}(data_seq(2)).Dec(data_seq(3):data_seq(4)) = offspring_temp(i, 1:data_seq(4) - data_seq(3) + 1);
            end

            for t = 1:Prob.T
                % Generation
                offspring2 = Algo.Generation(population{t});
                offspring = [offspring2, offspring1{t}];
                offspring = offspring(randperm(length(offspring), length(population{t})));
                % Evaluation
                [offspring, succ_flag(t)] = Algo.Evaluation(offspring, Prob, t);
                % Selection
                population{t} = Selection_Elit(population{t}, offspring);
            end

            if all(~succ_flag)
                divD = randi([1, maxD]);
                divK = randi([minK, maxK]);
            elseif any(~succ_flag)
                divD = min(maxD, max(1, randi([divD - 1, divD + 1])));
                divK = min(maxK, max(minK, randi([divK - 1, divK + 1])));
            end
        end
    end

    function result = correDecode(Algo, pop, correspond_vector, dim_div)
        task_index = correspond_vector(1);
        indv_index = correspond_vector(2);
        dim_start = correspond_vector(3);
        dim_end = correspond_vector(4);

        if dim_end - dim_start + 1 == dim_div
            result = pop{task_index}(indv_index).Dec(dim_start:dim_end);
        else
            result = zeros(1, dim_div);
            result(1, 1:dim_end - dim_start + 1) = pop{task_index}(indv_index).Dec(dim_start:dim_end);
        end
    end

    function offspring = Generation(Algo, population)
        for i = 1:length(population)
            offspring(i) = population(i);
            A = randperm(length(population), 4);
            A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3);

            offspring(i).Dec = population(x1).Dec + Algo.F * (population(x2).Dec - population(x3).Dec);
            offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, Algo.CR);
            offspring(i).Dec = min(1, max(0, offspring(i).Dec));
        end
    end
end
end
