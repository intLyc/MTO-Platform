classdef EMEA < Algorithm
    % <Multi> <None>

    %------------------------------- Reference --------------------------------
    % @Article{Feng2019EMEA,
    %   author     = {Feng, Liang and Zhou, Lei and Zhong, Jinghui and Gupta, Abhishek and Ong, Yew-Soon and Tan, Kay-Chen and Qin, A. K.},
    %   journal    = {IEEE Transactions on Cybernetics},
    %   title      = {Evolutionary Multitasking via Explicit Autoencoding},
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
        Op = 'GA/DE';
        Snum = 10;
        Gap = 10;
        GA_mu = 2;
        GA_mum = 5;
        DE_F = 0.5;
        DE_CR = 0.9;
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'Op: Operator (Split with /)', obj.Op, ...
                        'S: Transfer num', num2str(obj.Snum), ...
                        'G: Transfer Gap', num2str(obj.Gap), ...
                        'mu: index of Simulated Binary Crossover', num2str(obj.GA_mu), ...
                        'mum: index of polynomial mutation', num2str(obj.GA_mum), ...
                        'F: DE Mutation Factor', num2str(obj.DE_F), ...
                        'CR: DE Crossover Probability', num2str(obj.DE_CR)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.Op = Parameter{i}; i = i + 1;
            obj.Snum = str2double(Parameter{i}); i = i + 1;
            obj.Gap = str2double(Parameter{i}); i = i + 1;
            obj.GA_mu = str2double(Parameter{i}); i = i + 1;
            obj.GA_mum = str2double(Parameter{i}); i = i + 1;
            obj.DE_F = str2double(Parameter{i}); i = i + 1;
            obj.DE_CR = str2double(Parameter{i}); i = i + 1;
        end

        function data = run(obj, Tasks, RunPara)
            sub_pop = RunPara(1); sub_eva = RunPara(2);
            eva_num = sub_eva * length(Tasks);

            op_list = split(obj.Op, '/');

            % initialize
            [population, fnceval_calls, bestDec, bestObj] = initializeMT(Individual, sub_pop, Tasks, [Tasks.Dim]);
            convergeObj(:, 1) = bestObj;

            generation = 1;
            while fnceval_calls < eva_num
                generation = generation + 1;

                for t = 1:length(Tasks)
                    parent = population{t};

                    % generation
                    op_idx = mod(t - 1, length(op_list)) + 1;
                    op = op_list{op_idx};
                    switch op
                        case 'GA'
                            offspring = OperatorEMEA_GA.generate(parent, obj.GA_mu, obj.GA_mum);
                        case 'DE'
                            offspring = OperatorEMEA_DE.generate(parent, obj.DE_F, obj.DE_CR);
                    end

                    % Transfer
                    if obj.Snum > 0 && mod(generation, obj.Gap) == 0
                        inject_num = round(obj.Snum ./ (length(Tasks) - 1));
                        inject_pop = Individual.empty();
                        for tt = 1:length(Tasks)
                            if t == tt
                                continue;
                            end
                            [~, curr_best_idx] = sort([population{t}.Obj]);
                            curr_pop = population{t}(curr_best_idx);
                            curr_pop_dec = reshape([curr_pop.Dec], length(curr_pop(1).Dec), length(curr_pop))';

                            [~, his_best_idx] = sort([population{tt}.Obj]);
                            his_pop = population{tt}(his_best_idx);
                            his_pop_dec = reshape([his_pop.Dec], length(his_pop(1).Dec), length(his_pop))';
                            his_best_dec = his_pop_dec(1:inject_num, :);

                            % map to original
                            curr_pop_dec = (Tasks(t).Ub - Tasks(t).Lb) .* curr_pop_dec + Tasks(t).Lb;
                            his_pop_dec = (Tasks(tt).Ub - Tasks(tt).Lb) .* his_pop_dec + Tasks(tt).Lb;
                            his_best_dec = (Tasks(tt).Ub - Tasks(tt).Lb) .* his_best_dec + Tasks(tt).Lb;

                            inject = mDA(curr_pop_dec, his_pop_dec, his_best_dec);

                            % mat to [0,1]
                            inject = (inject - Tasks(t).Lb) ./ (Tasks(t).Ub - Tasks(t).Lb);

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

                    [offspring, calls] = evaluate(offspring, Tasks(t), 1);
                    fnceval_calls = fnceval_calls + calls;

                    [bestObj_offspring, idx] = min([offspring.Obj]);
                    if bestObj_offspring < bestObj(t)
                        bestObj(t) = bestObj_offspring;
                        bestDec{t} = offspring(idx).Dec;
                    end
                    convergeObj(t, generation) = bestObj(t);

                    % selection
                    switch op
                        case 'GA'
                            population{t} = [population{t}, offspring];
                            [~, rank] = sort([population{t}.Obj]);
                            population{t} = population{t}(rank(1:sub_pop));
                        case 'DE'
                            replace = [population{t}.Obj] > [offspring.Obj];
                            population{t}(replace) = offspring(replace);
                    end
                end
            end
            data.convergeObj = gen2eva(convergeObj);
            data.bestDec = uni2real(bestDec, Tasks);
        end
    end
end
