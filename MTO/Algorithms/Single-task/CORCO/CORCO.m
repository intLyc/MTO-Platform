classdef CORCO < Algorithm
    % <ST-SO> <Constrained>

    %------------------------------- Reference --------------------------------
    % @Article{Wang2020CORCO,
    %   title    = {Utilizing the Correlation Between Constraints and Objective Function for Constrained Evolutionary Optimization},
    %   author   = {Wang, Yong and Li, Jia-Peng and Xue, Xihui and Wang, Bing-chuan},
    %   journal  = {IEEE Transactions on Evolutionary Computation},
    %   year     = {2020},
    %   number   = {1},
    %   pages    = {29-43},
    %   volume   = {24},
    %   doi      = {10.1109/TEVC.2019.2904900},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        LP = 0.05
    end

    methods
        function Parameter = getParameter(Algo)
            Parameter = {'LP: Learning Period', num2str(Algo.LP)};
        end

        function Algo = setParameter(Algo, Parameter)
            i = 1;
            Algo.LP = str2double(Parameter{i}); i = i + 1;
        end

        function run(Algo, Prob)
            F_pool = [0.6, 0.8, 1.0];
            CR_pool = [0.1, 0.2, 1.0];

            % Initialization
            population = Initialization(Algo, Prob, Individual);
            archive = population;
            for t = 1:Prob.T
                X{t} = 0;
                cor_idx{t} = 0;
                div_delta{t} = 0;
                p = reshape([population{t}.Dec], length(population{t}(1).Dec), length(population{t}))';
                div_init{t} = sum(std(p)) / size(p, 2);
                betterRecord1{t} = [];
                betterRecord2{t} = [];
                cor_flag{t} = false;
            end

            while Algo.notTerminated(Prob)
                for t = 1:Prob.T
                    if Algo.FE < Algo.LP * Prob.maxFE
                        stage = 1;
                    else
                        stage = 2;
                        X{t} = X{t} + Prob.N / (Prob.maxFE / Prob.T);
                        if ~cor_flag{t}
                            recordLength = length(betterRecord1{t});
                            betterLength1 = sum(betterRecord1{t} ~= 0);
                            betterLength2 = sum(betterRecord2{t} ~= 0);
                            betterLength = min(betterLength1, betterLength2);
                            cor_idx{t} = betterLength / recordLength;
                            div_delta{t} = div_init{t} - div_idx{t};
                            cor_flag{t} = true;
                        end
                    end
                    weights = WeightGenerator(length(population{t}), population{t}.CVs, population{t}.Objs, X{t}, cor_idx{t}, div_delta{t}, stage);

                    % Generation
                    offspring = Algo.Generation(population{t}, F_pool, CR_pool, weights);
                    % Evaluation
                    offspring = Algo.Evaluation(offspring, Prob, t);

                    % selection
                    population{t} = Algo.Selection(population{t}, offspring, weights);
                    archive{t} = Algo.SelectionArchive(archive{t}, offspring, stage);

                    [con_obj_betterNum, obj_con_betterNum] = InterCompare(archive{t}.Objs, archive{t}.CVs, population{t}.Objs, population{t}.CVs);
                    p = reshape([population{t}.Dec], length(population{t}(1).Dec), length(population{t}))';
                    div_idx{t} = sum(std(p)) / size(p, 2);
                    betterRecord1{t} = [betterRecord1{t}, con_obj_betterNum];
                    betterRecord2{t} = [betterRecord2{t}, obj_con_betterNum];
                end
            end
        end

        function offspring = Generation(Algo, population, F_pool, CR_pool, weights)
            Obj = population.Objs; CV = population.CVs;
            normal_Obj = (Obj - min(Obj)) ./ (max(Obj) - min(Obj) + 1e-15);
            normal_CV = (CV - min(CV)) ./ (max(CV) - min(CV) + 1e-15);

            for i = 1:length(population)
                offspring(i) = population(i);
                A = randperm(length(population), 4);
                A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3);
                F = F_pool(randi(length(F_pool)));
                CR = CR_pool(randi(length(CR_pool)));

                if rand() < 0.5
                    % rand-to-best
                    fit = weights(i) * normal_Obj + (1 - weights(i)) * normal_CV;
                    [~, best] = min(fit);

                    offspring(i).Dec = population(x1).Dec + ...
                        F * (population(best).Dec - population(x1).Dec) + ...
                        F * (population(x2).Dec - population(x3).Dec);
                    offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, CR);
                else
                    % current-to-rand
                    offspring(i).Dec = population(i).Dec + ...
                    rand() * (population(x1).Dec - population(i).Dec) + ...
                        F * (population(x2).Dec - population(x3).Dec);
                end

                % offspring(i).Dec(offspring(i).Dec > 1) = 1;
                % offspring(i).Dec(offspring(i).Dec < 0) = 0;

                vio_low = find(offspring(i).Dec < 0);
                if rand() < 0.5
                    offspring(i).Dec(vio_low) = 2 * 0 - offspring(i).Dec(vio_low);
                    vio_temp = offspring(i).Dec(vio_low) > 1;
                    offspring(i).Dec(vio_low(vio_temp)) = 1;
                else
                    if rand() < 0.5
                        offspring(i).Dec(vio_low) = 0;
                    else
                        offspring(i).Dec(vio_low) = 1;
                    end
                end
                vio_up = find(offspring(i).Dec > 1);
                if rand() < 0.5
                    offspring(i).Dec(vio_up) = 2 * 1 - offspring(i).Dec(vio_up);
                    vio_temp = offspring(i).Dec(vio_up) < 0;
                    offspring(i).Dec(vio_up(vio_temp)) = 1;
                else
                    if rand() < 0.5
                        offspring(i).Dec(vio_up) = 0;
                    else
                        offspring(i).Dec(vio_up) = 1;
                    end
                end
            end
        end

        function population = Selection(Algo, population, offspring, weights)
            Obj = [population.Objs', offspring.Objs'];
            CV = [population.CVs', offspring.CVs'];
            normal_Obj = (Obj - min(Obj)) ./ (max(Obj) - min(Obj) + 1e-15);
            normal_CV = (CV - min(CV)) ./ (max(CV) - min(CV) + 1e-15);

            normal_pop_obj = normal_Obj(1:length(population));
            normal_off_obj = normal_Obj(length(population) + 1:end);
            normal_pop_cv = normal_CV(1:length(population));
            normal_off_cv = normal_CV(length(population) + 1:end);

            pop_fit = weights .* normal_pop_obj + (1 - weights) .* normal_pop_cv;
            off_fit = weights .* normal_off_obj + (1 - weights) .* normal_off_cv;

            replace = pop_fit > off_fit;
            population(replace) = offspring(replace);
        end

        function archive = SelectionArchive(Algo, archive, offspring, stage)
            if stage == 1
                replace = [archive.CV] > [offspring.CV];
                archive(replace) = offspring(replace);
            else
                archive = Selection_Tournament(archive, offspring);
            end
        end
    end
end
