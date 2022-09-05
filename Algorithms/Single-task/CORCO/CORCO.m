classdef CORCO < Algorithm
    % <Single> <Constrained>

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
        lp = 0.05
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'lp: learning period', num2str(obj.lp)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.lp = str2double(Parameter{i}); i = i + 1;
        end

        function data = run(obj, Tasks, RunPara)
            sub_pop = RunPara(1); sub_eva = RunPara(2);
            convergeObj = {}; convergeCV = {}; bestDec = {};

            F_pool = [0.6, 0.8, 1.0];
            CR_pool = [0.1, 0.2, 1.0];

            for sub_task = 1:length(Tasks)
                Task = Tasks(sub_task);

                % initialize
                [population, fnceval_calls, bestDec_temp, bestObj, bestCV] = initialize(Individual, sub_pop, Task, Task.Dim);
                convergeObj_temp(1) = bestObj;
                convergeCV_temp(1) = bestCV;

                archive = population;
                X = 0;
                cor_idx = 0;
                div_delta = 0;
                p = reshape([population.Dec], length(population(1).Dec), length(population))';
                div_init = sum(std(p)) / size(p, 2);
                betterRecord1 = [];
                betterRecord2 = [];

                generation = 1;
                while fnceval_calls < obj.lp * sub_eva
                    generation = generation + 1;

                    % learning stage
                    weights = WeightGenerator(length(population), [population.CV], [population.Obj], X, cor_idx, div_delta, 1);

                    % generation
                    [offspring, calls] = OperatorCORCO.generate(population, Task, F_pool, CR_pool, weights);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    [population] = selectCORCO(population, offspring, weights);
                    [archive] = selectCORCOarchive(archive, offspring, 1);

                    [con_obj_betterNum, obj_con_betterNum] = InterCompare([archive.Obj], [archive.CV], [population.Obj], [population.CV]);
                    p = reshape([population.Dec], length(population(1).Dec), length(population))';
                    div_idx = sum(std(p)) / size(p, 2);
                    betterRecord1 = [betterRecord1, con_obj_betterNum];
                    betterRecord2 = [betterRecord2, obj_con_betterNum];

                    [bestObj_now, bestCV_now, best_idx] = min_FP([offspring.Obj], [offspring.CV]);
                    if bestCV_now < bestCV || (bestCV_now == bestCV && bestObj_now < bestObj)
                        bestObj = bestObj_now;
                        bestCV = bestCV_now;
                        bestDec_temp = offspring(best_idx).Dec;
                    end
                    convergeObj_temp(generation) = bestObj;
                    convergeCV_temp(generation) = bestCV;
                end

                recordLength = length(betterRecord1);
                betterLength1 = sum(betterRecord1 ~= 0);
                betterLength2 = sum(betterRecord2 ~= 0);
                betterLength = min(betterLength1, betterLength2);
                cor_idx = betterLength / recordLength;
                div_delta = div_init - div_idx;

                while fnceval_calls < sub_eva
                    generation = generation + 1;

                    weights = WeightGenerator(length(population), [population.CV], [population.Obj], X, cor_idx, div_delta, 2);
                    X = X + sub_pop / sub_eva;

                    % generation
                    [offspring, calls] = OperatorCORCO.generate(population, Task, F_pool, CR_pool, weights);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    [population] = selectCORCO(population, offspring, weights);
                    [archive] = selectCORCOarchive(archive, offspring, 2);

                    [bestObj_now, bestCV_now, best_idx] = min_FP([offspring.Obj], [offspring.CV]);
                    if bestCV_now < bestCV || (bestCV_now == bestCV && bestObj_now < bestObj)
                        bestObj = bestObj_now;
                        bestCV = bestCV_now;
                        bestDec_temp = offspring(best_idx).Dec;
                    end
                    convergeObj_temp(generation) = bestObj;
                    convergeCV_temp(generation) = bestCV;
                end
                convergeObj{sub_task} = convergeObj_temp;
                convergeCV{sub_task} = convergeCV_temp;
                bestDec{sub_task} = bestDec_temp;
            end
            data.convergeObj = gen2eva(cell2matrix(convergeObj));
            data.convergeCV = gen2eva(cell2matrix(convergeCV));
            data.bestDec = uni2real(bestDec, Tasks);
        end
    end
end
