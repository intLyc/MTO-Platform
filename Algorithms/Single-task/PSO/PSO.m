classdef PSO < Algorithm
    % <Single> <None>

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        wmax = 0.9;
        wmin = 0.4;
        c1 = 0.2;
        c2 = 0.2;
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'wmax: Inertia Weight Max', num2str(obj.wmax), ...
                        'wmin: Inertia Weight Min', num2str(obj.wmin), ...
                        'c1', num2str(obj.c1), ...
                        'c2', num2str(obj.c2)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.wmax = str2double(Parameter{i}); i = i + 1;
            obj.wmin = str2double(Parameter{i}); i = i + 1;
            obj.c1 = str2double(Parameter{i}); i = i + 1;
            obj.c2 = str2double(Parameter{i}); i = i + 1;
        end

        function data = run(obj, Tasks, RunPara)
            sub_pop = RunPara(1); sub_eva = RunPara(2);
            convergeObj = {}; bestDec = {};

            for sub_task = 1:length(Tasks)
                Task = Tasks(sub_task);

                % initialize
                [population, fnceval_calls, bestDec_temp, bestObj] = initialize(IndividualPSO, sub_pop, Task, Task.Dim);
                convergeObj_temp(1) = bestObj;
                % initialize pso
                for i = 1:sub_pop
                    population(i).pbest = population(i).Dec;
                    population(i).velocity = 0;
                    population(i).pbestFitness = population(i).Obj;
                end

                generation = 1;
                while fnceval_calls < sub_eva
                    generation = generation + 1;

                    w = obj.wmax - (obj.wmax - obj.wmin) * fnceval_calls / sub_eva;

                    % generation
                    [population, calls] = OperatorPSO.generate(population, Task, w, obj.c1, obj.c2, bestDec_temp);
                    fnceval_calls = fnceval_calls + calls;

                    % update best
                    [bestObj_offspring, idx] = min([population.Obj]);
                    if bestObj_offspring < bestObj
                        bestObj = bestObj_offspring;
                        bestDec_temp = population(idx).Dec;
                    end
                    convergeObj_temp(generation) = bestObj;
                end
                convergeObj{sub_task} = convergeObj_temp;
                bestDec{sub_task} = bestDec_temp;
            end
            data.convergeObj = gen2eva(cell2matrix(convergeObj));
            data.bestDec = uni2real(bestDec, Tasks);
        end
    end
end
