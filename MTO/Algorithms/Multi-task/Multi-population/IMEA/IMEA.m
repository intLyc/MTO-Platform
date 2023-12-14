classdef IMEA < Algorithm
% <Multi-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @InProceedings{Hashimoto2018IMEA,
%   title     = {Analysis of Evolutionary Multi-Tasking as an Island Model},
%   author    = {Hashimoto, Ryuichi and Ishibuchi, Hisao and Masuyama, Naoki and Nojima, Yusuke},
%   booktitle = {Proceedings of the Genetic and Evolutionary Computation Conference Companion},
%   year      = {2018},
%   address   = {New York, NY, USA},
%   pages     = {1894–1897},
%   publisher = {Association for Computing Machinery},
%   series    = {GECCO '18},
%   doi       = {10.1145/3205651.3208228},
%   isbn      = {9781450357647},
%   location  = {Kyoto, Japan},
%   numpages  = {4},
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
    TGap = 10
    TNum = 10
    MuC = 2
    MuM = 5
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'TGap: Transfer Interval', num2str(Algo.TGap), ...
                'TNum: Transfer Number', num2str(Algo.TNum), ...
                'MuC: Simulated Binary Crossover', num2str(Algo.MuC), ...
                'MuM: Polynomial Mutation', num2str(Algo.MuM)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.TGap = str2double(Parameter{i}); i = i + 1;
        Algo.TNum = str2double(Parameter{i}); i = i + 1;
        Algo.MuC = str2double(Parameter{i}); i = i + 1;
        Algo.MuM = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialization
        population = Initialization(Algo, Prob, Individual);

        while Algo.notTerminated(Prob)
            for t = 1:Prob.T
                % Knowledge Transfer
                parent = population{t};
                if Algo.TNum > 0 && mod(Algo.Gen, Algo.TGap) == 0
                    transfer_num = round(Algo.TNum ./ (Prob.T - 1));
                    transfer_pop = Individual.empty();
                    for k = 1:Prob.T
                        if t == k
                            continue;
                        end
                        transfer_idx = randperm(length(population{k}), transfer_num);
                        tmp_pop = population{k}(transfer_idx);
                        transfer_pop = [transfer_pop, tmp_pop];
                    end
                    [~, rank] = sortrows([population{t}.CVs, population{t}.Objs], [1, 2]);
                    parent(rank(end - length(transfer_pop) + 1:end)) = transfer_pop;
                end
                % Generation
                offspring = Algo.Generation(parent);
                % Evaluation
                offspring = Algo.Evaluation(offspring, Prob, t);
                % Selection
                population{t} = Selection_Elit(population{t}, offspring);
            end
        end
    end

    function offspring = Generation(Algo, population)
        indorder = randperm(length(population));
        count = 1;
        for i = 1:ceil(length(population) / 2)
            p1 = indorder(i);
            p2 = indorder(i + fix(length(population) / 2));
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
end
end
