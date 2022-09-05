classdef MFPSO < Algorithm
    % <Multi> <None>

    %------------------------------- Reference --------------------------------
    % @InProceedings{Feng2017MFDE-MFPSO,
    %   author     = {Feng, L. and Zhou, W. and Zhou, L. and Jiang, S. W. and Zhong, J. H. and Da, B. S. and Zhu, Z. X. and Wang, Y.},
    %   booktitle  = {2017 IEEE Congress on Evolutionary Computation (CEC)},
    %   title      = {An Empirical Study of Multifactorial PSO and Multifactorial DE},
    %   year       = {2017},
    %   pages      = {921-928},
    %   doi        = {10.1109/CEC.2017.7969407},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        rmp = 0.3
        wmax = 0.9;
        wmin = 0.4;
        c1 = 0.2;
        c2 = 0.2;
        c3 = 0.2;
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'rmp: Random Mating Probability', num2str(obj.rmp), ...
                        'wmax: Inertia Weight Max', num2str(obj.wmax), ...
                        'wmin: Inertia Weight Min', num2str(obj.wmin), ...
                        'c1', num2str(obj.c1), ...
                        'c2', num2str(obj.c2), ...
                        'c3', num2str(obj.c3)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.rmp = str2double(Parameter{i}); i = i + 1;
            obj.wmax = str2double(Parameter{i}); i = i + 1;
            obj.wmin = str2double(Parameter{i}); i = i + 1;
            obj.c1 = str2double(Parameter{i}); i = i + 1;
            obj.c2 = str2double(Parameter{i}); i = i + 1;
            obj.c3 = str2double(Parameter{i}); i = i + 1;
        end

        function data = run(obj, Tasks, RunPara)
            sub_pop = RunPara(1); sub_eva = RunPara(2);
            pop_size = sub_pop * length(Tasks);
            eva_num = sub_eva * length(Tasks);

            % initialize
            [population, fnceval_calls, bestDec, bestObj] = initializeMF(IndividualMFPSO, pop_size, Tasks, max([Tasks.Dim]));
            convergeObj(:, 1) = bestObj;
            % initialize pso
            for i = 1:pop_size
                population(i).pbest = population(i).Dec;
                population(i).velocity = 0;
                population(i).pbestFitness = population(i).Obj(population(i).skill_factor);
            end

            generation = 1;
            while fnceval_calls < eva_num
                generation = generation + 1;

                w = obj.wmax - (obj.wmax - obj.wmin) * fnceval_calls / eva_num;

                % generation
                [population, calls] = OperatorMFPSO.generate(population, Tasks, obj.rmp, w, obj.c1, obj.c2, obj.c3, bestDec);
                fnceval_calls = fnceval_calls + calls;

                % update best
                for t = 1:length(Tasks)
                    for i = 1:length(population)
                        Obj(i) = population(i).Obj(t);
                    end
                    [bestObj_offspring, idx] = min(Obj);
                    if bestObj_offspring < bestObj(t)
                        bestObj(t) = bestObj_offspring;
                        bestDec{t} = population(idx).Dec;
                    end
                    convergeObj(t, generation) = bestObj(t);
                end
            end
            data.convergeObj = gen2eva(convergeObj);
            data.bestDec = uni2real(bestDec, Tasks);
        end
    end
end
