classdef IMEA < Algorithm
    % <MT-SO> <None/Constrained>

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
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        TGap = 10
        TNum = 10
        MuC = 2
        MuM = 5
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'TGap: Transfer Interval', num2str(obj.TGap), ...
                        'TNum: Transfer Number', num2str(obj.TNum), ...
                        'MuC: Simulated Binary Crossover', num2str(obj.MuC), ...
                        'MuM: Polynomial Mutation', num2str(obj.MuM)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.TGap = str2double(Parameter{i}); i = i + 1;
            obj.TNum = str2double(Parameter{i}); i = i + 1;
            obj.MuC = str2double(Parameter{i}); i = i + 1;
            obj.MuM = str2double(Parameter{i}); i = i + 1;
        end

        function run(obj, Prob)
            % Initialization
            population = Initialization(obj, Prob, Individual);

            while obj.notTerminated(Prob)
                for t = 1:Prob.T
                    % Knowledge Transfer
                    parent = population{t};
                    if obj.TNum > 0 && mod(obj.Gen, obj.TGap) == 0
                        transfer_num = round(obj.TNum ./ (Prob.T - 1));
                        transfer_pop = Individual.empty();
                        for k = 1:Prob.T
                            if t == k
                                continue;
                            end
                            transfer_idx = randperm(length(population{k}), transfer_num);
                            tmp_pop = population{k}(transfer_idx);
                            transfer_pop = [transfer_pop, tmp_pop];
                        end
                        [~, replace_idx] = sortrows([[population{t}.CV]', [population{t}.Obj]'], [1, 2]);
                        parent(replace_idx(1:length(transfer_pop))) = transfer_pop;
                    end
                    % Generation
                    offspring = obj.Generation(parent);
                    % Evaluation
                    offspring = obj.Evaluation(offspring, Prob, t);
                    % Selection
                    population{t} = Selection_Elit(population{t}, offspring);
                end
            end
        end

        function offspring = Generation(obj, population)
            indorder = randperm(length(population));
            count = 1;
            for i = 1:ceil(length(population) / 2)
                p1 = indorder(i);
                p2 = indorder(i + fix(length(population) / 2));
                offspring(count) = population(p1);
                offspring(count + 1) = population(p2);

                [offspring(count).Dec, offspring(count + 1).Dec] = GA_Crossover(population(p1).Dec, population(p2).Dec, obj.MuC);

                offspring(count).Dec = GA_Mutation(offspring(count).Dec, obj.MuM);
                offspring(count + 1).Dec = GA_Mutation(offspring(count + 1).Dec, obj.MuM);

                for x = count:count + 1
                    offspring(x).Dec(offspring(x).Dec > 1) = 1;
                    offspring(x).Dec(offspring(x).Dec < 0) = 0;
                end
                count = count + 2;
            end
        end
    end
end
