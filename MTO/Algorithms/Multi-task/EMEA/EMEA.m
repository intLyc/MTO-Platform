classdef EMEA < Algorithm
    % <MT-SO> <None/Constrained>

    %------------------------------- Reference --------------------------------
    % @Article{Feng2019EMEA,
    %   title      = {Evolutionary Multitasking via Explicit Autoencoding},
    %   author     = {Feng, Liang and Zhou, Lei and Zhong, Jinghui and Gupta, Abhishek and Ong, Yew-Soon and Tan, Kay-Chen and Qin, A. K.},
    %   journal    = {IEEE Transactions on Cybernetics},
    %   year       = {2019},
    %   number     = {9},
    %   pages      = {3457-3470},
    %   volume     = {49},
    %   doi        = {10.1109/TCYB.2018.2845361},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        Operator = 'GA/DE'
        SNum = 10
        TGap = 10
        GA_MuC = 2
        GA_MuM = 5
        DE_F = 0.5
        DE_CR = 0.9
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'Operator (Split with /)', obj.Operator, ...
                        'S: Transfer num', num2str(obj.SNum), ...
                        'G: Transfer TGap', num2str(obj.TGap), ...
                        'MuC: Simulated Binary Crossover', num2str(obj.GA_MuC), ...
                        'MuM: Polynomial Mutation', num2str(obj.GA_MuM), ...
                        'F: DE Mutation Factor', num2str(obj.DE_F), ...
                        'CR: DE Crossover Probability', num2str(obj.DE_CR)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.Operator = Parameter{i}; i = i + 1;
            obj.SNum = str2double(Parameter{i}); i = i + 1;
            obj.TGap = str2double(Parameter{i}); i = i + 1;
            obj.GA_MuC = str2double(Parameter{i}); i = i + 1;
            obj.GA_MuM = str2double(Parameter{i}); i = i + 1;
            obj.DE_F = str2double(Parameter{i}); i = i + 1;
            obj.DE_CR = str2double(Parameter{i}); i = i + 1;
        end

        function run(obj, Prob)
            operator = split(obj.Operator, '/');

            % Initialization
            population = Initialization(obj, Prob, Individual);

            while obj.notTerminated(Prob)
                for t = 1:Prob.T
                    % Generation
                    op_idx = mod(t - 1, length(operator)) + 1;
                    op = operator{op_idx};
                    switch op
                        case 'GA'
                            offspring = obj.Generation_GA(population{t});
                        case 'DE'
                            offspring = obj.Generation_DE(population{t});
                    end

                    % Knowledge Transfer
                    if obj.SNum > 0 && mod(obj.Gen, obj.TGap) == 0
                        inject_num = round(obj.SNum ./ (Prob.T - 1));
                        inject_pop = Individual.empty();
                        for k = 1:Prob.T
                            if t == k
                                continue;
                            end
                            [~, curr_rank] = sortrows([[population{t}.CV]', [population{t}.Obj]'], [1, 2]);
                            curr_pop = population{t}(curr_rank);
                            curr_pop_dec = reshape([curr_pop.Dec], length(curr_pop(1).Dec), length(curr_pop))';
                            curr_pop_dec = curr_pop_dec(:, 1:Prob.D(t));

                            [~, his_rank] = sortrows([[population{k}.CV]', [population{k}.Obj]'], [1, 2]);
                            his_pop = population{k}(his_rank);
                            his_pop_dec = reshape([his_pop.Dec], length(his_pop(1).Dec), length(his_pop))';
                            his_pop_dec = his_pop_dec(:, 1:Prob.D(k));
                            his_best_dec = his_pop_dec(1:inject_num, :);

                            % map to original
                            curr_pop_dec = (Prob.Ub{t} - Prob.Lb{t}) .* curr_pop_dec + Prob.Lb{t};
                            his_pop_dec = (Prob.Ub{k} - Prob.Lb{k}) .* his_pop_dec + Prob.Lb{k};
                            his_best_dec = (Prob.Ub{k} - Prob.Lb{k}) .* his_best_dec + Prob.Lb{k};

                            inject = mDA(curr_pop_dec, his_pop_dec, his_best_dec);

                            % mat to [0,1]
                            inject = (inject - Prob.Lb{t}) ./ (Prob.Ub{t} - Prob.Lb{t});

                            for i = 1:size(inject, 1)
                                c = Individual();
                                c.Dec = inject(i, :);
                                c.Dec(c.Dec > 1) = 1;
                                c.Dec(c.Dec < 0) = 0;
                                inject_pop = [inject_pop, c];
                            end
                        end
                        replace_idx = randperm(length(offspring), length(inject_pop));
                        offspring(replace_idx) = inject_pop;
                    end

                    % Evaluation
                    offspring = obj.Evaluation(offspring, Prob, t);

                    % Selection
                    switch op
                        case 'GA'
                            population{t} = Selection_Elit(population{t}, offspring);
                        case 'DE'
                            population{t} = Selection_Tournament(population{t}, offspring);
                    end
                end
            end
        end

        function offspring = Generation_GA(obj, population)
            indorder = randperm(length(population));
            count = 1;
            for i = 1:ceil(length(population) / 2)
                p1 = indorder(i);
                p2 = indorder(i + fix(length(population) / 2));
                offspring(count) = population(p1);
                offspring(count + 1) = population(p2);

                [offspring(count).Dec, offspring(count + 1).Dec] = GA_Crossover(population(p1).Dec, population(p2).Dec, obj.GA_MuC);

                offspring(count).Dec = GA_Mutation(offspring(count).Dec, obj.GA_MuM);
                offspring(count + 1).Dec = GA_Mutation(offspring(count + 1).Dec, obj.GA_MuM);

                for x = count:count + 1
                    offspring(x).Dec(offspring(x).Dec > 1) = 1;
                    offspring(x).Dec(offspring(x).Dec < 0) = 0;
                end
                count = count + 2;
            end
        end

        function offspring = Generation_DE(obj, population)
            for i = 1:length(population)
                offspring(i) = population(i);
                A = randperm(length(population), 4);
                A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3);

                offspring(i).Dec = population(x1).Dec + obj.DE_F * (population(x2).Dec - population(x3).Dec);
                offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, obj.DE_CR);

                offspring(i).Dec(offspring(i).Dec > 1) = 1;
                offspring(i).Dec(offspring(i).Dec < 0) = 0;
            end
        end
    end
end
