classdef MTEA_AD < Algorithm
    % <MT-SO> <None/Constrained>

    %------------------------------- Reference --------------------------------
    % @Article{Wang2021MTEA-AD,
    %   title      = {Solving Multi-task Optimization Problems with Adaptive Knowledge Transfer via Anomaly Detection},
    %   author     = {Wang, Chao and Liu, Jing and Wu, Kai and Wu, Zhaoyang},
    %   journal    = {IEEE Transactions on Evolutionary Computation},
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
        TRP = 0.1
        MuC = 2
        MuM = 5
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'TRP: Probability of the Knowledge Transfer', num2str(obj.TRP), ...
                        'MuC: Simulated Binary Crossover', num2str(obj.MuC), ...
                        'MuM: Polynomial Mutation', num2str(obj.MuM)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.TRP = str2double(Parameter{i}); i = i + 1;
            obj.MuC = str2double(Parameter{i}); i = i + 1;
            obj.MuM = str2double(Parameter{i}); i = i + 1;
        end

        function run(obj, Prob)
            % Initialization
            population = Initialization(obj, Prob, Individual);
            epsilon = zeros(1, Prob.T); % Parameter of the anomaly detection model

            while obj.notTerminated(Prob)
                for t = 1:Prob.T
                    % Generation
                    offspring = obj.Generation(population{t});

                    % Knowledge Transfer
                    if rand() < obj.TRP
                        if obj.Gen == 1
                            NL = 1;
                        else
                            NL = epsilon(t);
                        end
                        curr_pop_dec = reshape([offspring.Dec], length(offspring(1).Dec), length(offspring))';

                        his_pop_dec = [];
                        for k = 1:Prob.T
                            if k ~= t
                                his_pop_dec_t = reshape([population{k}.Dec], length(population{k}(1).Dec), length(population{k}))';
                                his_pop_dec = [his_pop_dec; his_pop_dec_t];
                            end
                        end

                        tfsol = learn_anomaly_detection(curr_pop_dec, his_pop_dec, NL);

                        transfer_pop = Individual.empty();
                        for i = 1:size(tfsol, 1)
                            c = Individual();
                            c.Dec = tfsol(i, :);
                            c.Dec(c.Dec > 1) = 1;
                            c.Dec(c.Dec < 0) = 0;
                            transfer_pop = [transfer_pop, c];
                        end

                        % Evaluation
                        offspring = obj.Evaluation(offspring, Prob, t);
                        transfer_pop = obj.Evaluation(transfer_pop, Prob, t);
                        % Selection
                        [population{t}, rank] = Selection_Elit(population{t}, [offspring, transfer_pop]);
                        succ_num = sum(rank(1:length(population{t})) > length(population{t}) + length(offspring));
                        % Parameter adaptation strategy via elitism
                        epsilon(t) = succ_num ./ size(tfsol, 1);
                    else
                        % Evaluation
                        offspring = obj.Evaluation(offspring, Prob, t);
                        % Selection
                        population{t} = Selection_Elit(population{t}, offspring);
                    end
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
