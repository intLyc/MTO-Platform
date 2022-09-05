classdef MTEA_AD < Algorithm
    % <Multi/Many> <None>

    %------------------------------- Reference --------------------------------
    % @Article{Wang2021MTEA-AD,
    %   author     = {Wang, Chao and Liu, Jing and Wu, Kai and Wu, Zhaoyang},
    %   journal    = {IEEE Transactions on Evolutionary Computation},
    %   title      = {Solving Multi-task Optimization Problems with Adaptive Knowledge Transfer via Anomaly Detection},
    %   year       = {2021},
    %   pages      = {1-1},
    %   doi        = {10.1109/TEVC.2021.3068157},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        TRP = 0.1;
        mu = 2;
        mum = 5;
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'TRP: probability of the knowledge transfer', num2str(obj.TRP), ...
                        'mu: index of Simulated Binary Crossover', num2str(obj.mu), ...
                        'mum: index of polynomial mutation', num2str(obj.mum)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.TRP = str2double(Parameter{i}); i = i + 1;
            obj.mu = str2double(Parameter{i}); i = i + 1;
            obj.mum = str2double(Parameter{i}); i = i + 1;
        end

        function data = run(obj, Tasks, RunPara)
            sub_pop = RunPara(1); sub_eva = RunPara(2);
            eva_num = sub_eva * length(Tasks);

            epsilon = zeros(1, length(Tasks)); % Parameter of the anomaly detection model

            % initialize
            [population, fnceval_calls, bestDec, bestObj] = initializeMT(Individual, sub_pop, Tasks, [Tasks.Dim]);
            convergeObj(:, 1) = bestObj;

            generation = 1;
            while fnceval_calls < eva_num
                generation = generation + 1;

                for t = 1:length(Tasks)
                    % generation
                    offspring = OperatorMTEA_AD.generate(population{t}, obj.mu, obj.mum);

                    % Knowledge Transfer
                    if rand < obj.TRP
                        if generation == 1
                            NL = 1;
                        else
                            NL = epsilon(t);
                        end
                        curr_pop = reshape([offspring.Dec], length(offspring(1).Dec), length(offspring))';
                        curr_pop = curr_pop(:, 1:Tasks(t).Dim);
                        his_pop = [];
                        for tt = 1:length(Tasks)
                            if tt ~= t
                                his_pop_tt = reshape([population{tt}.Dec], length(population{tt}(1).Dec), length(population{tt}))';
                                his_pop_tt = [his_pop_tt, rand(size(his_pop_tt, 1), max([Tasks.Dim]) - Tasks(tt).Dim)];
                                his_pop = [his_pop; his_pop_tt(:, 1:Tasks(t).Dim)];
                            end
                        end

                        tfsol = learn_anomaly_detection(curr_pop, his_pop, NL);

                        transfer_pop = Individual.empty();
                        for i = 1:size(tfsol, 1)
                            c = Individual();
                            c.Dec = tfsol(i, :);
                            c.Dec(c.Dec > 1) = 1;
                            c.Dec(c.Dec < 0) = 0;
                            transfer_pop = [transfer_pop, c];
                        end

                        % selection
                        [offspring, calls] = evaluate(offspring, Tasks(t), 1);
                        fnceval_calls = fnceval_calls + calls;
                        [transfer_pop, calls] = evaluate(transfer_pop, Tasks(t), 1);
                        fnceval_calls = fnceval_calls + calls;

                        population{t} = [population{t}, offspring, transfer_pop];
                        [~, rank] = sort([population{t}.Obj]);
                        population{t} = population{t}(rank(1:sub_pop));

                        succ_num = sum(rank(1:length(population{t})) > length(population{t}) + length(offspring));

                        % Parameter adaptation strategy via elitism
                        epsilon(t) = succ_num ./ size(tfsol, 1);
                    else
                        % selection
                        [offspring, calls] = evaluate(offspring, Tasks(t), 1);
                        fnceval_calls = fnceval_calls + calls;
                        population{t} = [population{t}, offspring];
                        [~, rank] = sort([population{t}.Obj]);
                        population{t} = population{t}(rank(1:sub_pop));
                    end

                    [bestObj_temp, idx] = min([population{t}.Obj]);
                    if bestObj_temp < bestObj(t)
                        bestObj(t) = bestObj_temp;
                        bestDec{t} = population{t}(idx).Dec;
                    end
                    convergeObj(t, generation) = bestObj(t);
                end
            end
            data.convergeObj = gen2eva(convergeObj);
            data.bestDec = uni2real(bestDec, Tasks);
        end
    end
end
