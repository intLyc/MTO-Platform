classdef MFEA_DV < Algorithm
    % <Multi> <None>

    %------------------------------- Reference --------------------------------
    % @Article{Yin2019MFEA-DV,
    %   author     = {Yin,Jian and Zhu, Anmin and Zhu, Zexuan and Yu, Yanan and Ma, Xiaoling},
    %   journal    = {IEEE Congress on Evolutionary Computation },
    %   title      = {Multifactorial Evolutionary Algorithm Enhanced with Cross-task Search Direction},
    %   year       = {2019},
    %   pages      = {2244-2251},
    %   doi        = {10.1109/CEC.2019.8789959},
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
        mu = 2;
        mum = 5;
        p = 0.1;
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'rmp: Random Mating Probability', num2str(obj.rmp), ...
                        'mu: index of Simulated Binary Crossover', num2str(obj.mu), ...
                        'mum: index of polynomial mutation', num2str(obj.mum), ...
                        'p: 100p% top as pbest', num2str(obj.p)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.rmp = str2double(Parameter{i}); i = i + 1;
            obj.mu = str2double(Parameter{i}); i = i + 1;
            obj.mum = str2double(Parameter{i}); i = i + 1;
            obj.p = str2double(Parameter{i}); i = i + 1;
        end

        function data = run(obj, Tasks, RunPara)
            sub_pop = RunPara(1); sub_eva = RunPara(2);
            pop_size = sub_pop * length(Tasks);
            eva_num = sub_eva * length(Tasks);

            % initialize
            [population, fnceval_calls, bestDec, bestObj] = initializeMF(IndividualMF, pop_size, Tasks, max([Tasks.Dim]));
            convergeObj(:, 1) = bestObj;

            generation = 1;
            while fnceval_calls < eva_num
                generation = generation + 1;

                % generation
                [offspring, calls] = OperatorMFEA_DV.generate(population, Tasks, obj.rmp, obj.mu, obj.mum, obj.p, sub_pop);
                fnceval_calls = fnceval_calls + calls;

                % selection
                [population, bestDec, bestObj] = selectMF(population, offspring, Tasks, pop_size, bestDec, bestObj);
                convergeObj(:, generation) = bestObj;
            end
            data.convergeObj = gen2eva(convergeObj);
            data.bestDec = uni2real(bestDec, Tasks);
        end
    end
end
