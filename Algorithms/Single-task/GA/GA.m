classdef GA < Algorithm
    % <Single> <None/Constrained>

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        mu = 2;
        mum = 5;
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'mu: index of Simulated Binary Crossover', num2str(obj.mu), ...
                        'mum: index of polynomial mutation', num2str(obj.mum)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.mu = str2double(Parameter{i}); i = i + 1;
            obj.mum = str2double(Parameter{i}); i = i + 1;
        end

        function data = run(obj, Tasks, RunPara)
            sub_pop = RunPara(1); sub_eva = RunPara(2);
            convergeObj = {}; convergeCV = {}; bestDec = {};

            for sub_task = 1:length(Tasks)
                Task = Tasks(sub_task);

                [population, fnceval_calls, bestDec_temp, bestObj, bestCV] = initialize(Individual, sub_pop, Task, Task.Dim);
                convergeObj_temp(1) = bestObj;
                convergeCV_temp(1) = bestCV;

                generation = 1;
                while fnceval_calls < sub_eva
                    generation = generation + 1;

                    % generation
                    [offspring, calls] = OperatorGA.generate(population, Task, obj.mu, obj.mum);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    population = [population, offspring];
                    [~, rank] = sortrows([[population.CV]', [population.Obj]'], [1, 2]);
                    population = population(rank(1:sub_pop));

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
