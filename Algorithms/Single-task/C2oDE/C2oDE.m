classdef C2oDE < Algorithm
    % <Single> <Constrained>

    %------------------------------- Reference --------------------------------
    % @Article{Wang2019C2oDE,
    %   title    = {Composite Differential Evolution for Constrained Evolutionary Optimization},
    %   author   = {Wang, Bing-Chuan and Li, Han-Xiong and Li, Jia-Peng and Wang, Yong},
    %   journal  = {IEEE Transactions on Systems, Man, and Cybernetics: Systems},
    %   year     = {2019},
    %   number   = {7},
    %   pages    = {1482-1495},
    %   volume   = {49},
    %   doi      = {10.1109/TSMC.2018.2807785},
    % }
    %------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------
    properties (SetAccess = private)
        beta = 6
        mu = 1e-8
        p = 0.5
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'beta', num2str(obj.beta), ...
                        'mu', num2str(obj.mu), ...
                        'p', num2str(obj.p)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.beta = str2double(Parameter{i}); i = i + 1;
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

                Ep0 = max([population.CV]);
                X = 0;

                generation = 1;
                while fnceval_calls < sub_eva
                    generation = generation + 1;

                    cp = (-log(Ep0) - obj.beta) / log(1 - obj.p);
                    % adjust the threshold
                    if X < obj.p
                        Ep = Ep0 * (1 - X)^cp;
                    else
                        Ep = 0;
                    end
                    X = X + (sub_pop * 3) / sub_eva;

                    % diversity restart
                    if std([population.CV]) < obj.mu && isempty(find([population.CV] == 0))
                        [population, calls] = initialize(Individual, sub_pop, Task, Task.Dim);
                        fnceval_calls = fnceval_calls + calls;
                    end

                    % generation
                    [off_temp, calls] = OperatorC2oDE.generate(population, Task, F_pool, CR_pool);
                    fnceval_calls = fnceval_calls + calls;

                    % pre selection
                    for i = 1:length(population)
                        idx = [(i - 1) * 3 + 1, (i - 1) * 3 + 2, (i - 1) * 3 + 3];
                        [~, ~, best] = min_FP([off_temp(idx).Obj], [off_temp(idx).CV]);
                        offspring(i) = off_temp(idx(best));
                    end

                    % selection
                    replace_cv = [population.CV] > [offspring.CV] & [population.CV] > Ep & [offspring.CV] > Ep;
                    equal_cv = [population.CV] <= Ep & [offspring.CV] <= Ep;
                    replace_obj = [population.Obj] > [offspring.Obj];
                    replace = (equal_cv & replace_obj) | replace_cv;
                    population(replace) = offspring(replace);

                    % update best
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
