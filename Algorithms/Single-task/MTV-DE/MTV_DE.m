classdef MTV_DE < Algorithm
    % <Single> <Constrained>

    %------------------------------- Reference --------------------------------
    % @article{MezuraMontes2007MTV-DE,
    %   author    = {E. Mezura-Montes and C. A. Coello Coello and J. Velázquez-Reyes and L. Muñoz-Dávila},
    %   title     = {Multiple Trial Vectors in Differential Evolution for Engineering Design},
    %   doi       = {10.1080/03052150701364022},
    %   journal   = {Engineering Optimization},
    %   number    = {5},
    %   pages     = {567-589},
    %   publisher = {Taylor & Francis},
    %   volume    = {39},
    %   year      = {2007}
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        F = 0.5
        CR = 0.9
        no = 5
        sr = 0.45
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'F: Mutation Factor', num2str(obj.F), ...
                        'CR: Crossover Probability', num2str(obj.CR), ...
                        'no: number of trial vectors', num2str(obj.no), ...
                        'sr: stochastic ranking rate', num2str(obj.sr)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.F = str2double(Parameter{i}); i = i + 1;
            obj.CR = str2double(Parameter{i}); i = i + 1;
            obj.no = str2double(Parameter{i}); i = i + 1;
            obj.sr = str2double(Parameter{i}); i = i + 1;
        end

        function data = run(obj, Tasks, RunPara)
            sub_pop = RunPara(1); sub_eva = RunPara(2);
            convergeObj = {}; convergeCV = {}; bestDec = {};

            for sub_task = 1:length(Tasks)
                Task = Tasks(sub_task);

                % initialize
                [population, fnceval_calls, bestDec_temp, bestObj, bestCV] = initialize(Individual, sub_pop, Task, Task.Dim);
                convergeObj_temp(1) = bestObj;
                convergeCV_temp(1) = bestCV;

                generation = 1;
                while fnceval_calls < sub_eva
                    generation = generation + 1;

                    % generation
                    [offspring, calls] = OperatorDE_MTV.generate(population, Task, obj.F, obj.CR, obj.no);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    replace_cv = [population.CV] > [offspring.CV];
                    equal_cv = [population.CV] <= 0 & [offspring.CV] <= 0;
                    replace_obj = [population.Obj] > [offspring.Obj];
                    replace = (equal_cv & replace_obj) | replace_cv;

                    % rand<=sr:obj else rand>sr:fp
                    idx_sr = rand(1, length(population)) <= obj.sr;
                    replace(idx_sr) = replace_obj(idx_sr);

                    population(replace) = offspring(replace);

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
