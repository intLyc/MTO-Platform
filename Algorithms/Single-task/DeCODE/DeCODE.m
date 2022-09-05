classdef DeCODE < Algorithm
    % <Single> <Constrained>

    %------------------------------- Reference --------------------------------
    % @Article{Wang2021DeCODE,
    %   title    = {Decomposition-Based Multiobjective Optimization for Constrained Evolutionary Optimization},
    %   author   = {Wang, Bing-Chuan and Li, Han-Xiong and Zhang, Qingfu and Wang, Yong},
    %   journal  = {IEEE Transactions on Systems, Man, and Cybernetics: Systems},
    %   year     = {2021},
    %   number   = {1},
    %   pages    = {574-587},
    %   volume   = {51},
    %   doi      = {10.1109/TSMC.2018.2876335},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------
    properties (SetAccess = private)
        alpha = 0.75
        beta = 6
        gama = 30
        mu = 1e-6
        p = 0.85
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'alpha', num2str(obj.alpha), ...
                        'beta', num2str(obj.beta), ...
                        'gama', num2str(obj.gama), ...
                        'mu', num2str(obj.mu), ...
                        'p', num2str(obj.p)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.alpha = str2double(Parameter{i}); i = i + 1;
            obj.beta = str2double(Parameter{i}); i = i + 1;
            obj.gama = str2double(Parameter{i}); i = i + 1;
            obj.mu = str2double(Parameter{i}); i = i + 1;
            obj.p = str2double(Parameter{i}); i = i + 1;
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
                Ep0 = min(10^(Task.Dim / 2), max([population.CV]));
                cp = (-log(Ep0) - obj.beta) / log(1 - obj.p);
                pmax = 1;
                X = 0;

                generation = 1;
                while fnceval_calls < sub_eva
                    generation = generation + 1;

                    if X < obj.p
                        Ep = Ep0 * (1 - X)^cp;
                    else
                        Ep = 0;
                    end
                    X = X + sub_pop / sub_eva;

                    if length(find([population.CV] == 0)) > obj.p * length(population)
                        Ep = 0;
                    end

                    rand_idx = randperm(length(population));
                    population = population(rand_idx);
                    archive = archive(rand_idx);

                    if isempty(find([population.CV] < Ep))
                        pmax = 1e-18;
                    end

                    pr = max(1e-18, pmax / (1 + exp(obj.gama * (fnceval_calls / sub_eva - obj.alpha))));

                    % diversity restart
                    if std([population.CV]) < obj.mu && isempty(find([population.CV] == 0))
                        [population, calls] = initialize(Individual, sub_pop, Task, Task.Dim);
                        fnceval_calls = fnceval_calls + calls;
                    end

                    weights = [0:pr / length(population):pr - pr / length(population)];
                    weights(randperm(length(weights))) = weights;

                    % generation
                    [offspring, calls] = OperatorDeCODE.generate(population, Task, F_pool, CR_pool, weights, fnceval_calls, sub_eva);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    [population] = selectDeCODE(population, offspring, weights);
                    [archive] = selectDeCODEarchive(archive, offspring);

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
