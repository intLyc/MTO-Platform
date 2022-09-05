classdef MFEA < Algorithm
    % <Multi> <None/Constrained>

    %------------------------------- Reference --------------------------------
    % @Article{Gupta2016MFEA,
    %   author     = {Gupta, Abhishek and Ong, Yew-Soon and Feng, Liang},
    %   journal    = {IEEE Transactions on Evolutionary Computation},
    %   title      = {Multifactorial Evolution: Toward Evolutionary Multitasking},
    %   year       = {2016},
    %   number     = {3},
    %   pages      = {343-357},
    %   volume     = {20},
    %   doi        = {10.1109/TEVC.2015.2458037},
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
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'rmp: Random Mating Probability', num2str(obj.rmp), ...
                        'mu: index of Simulated Binary Crossover', num2str(obj.mu), ...
                        'mum: index of polynomial mutation', num2str(obj.mum)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.rmp = str2double(Parameter{i}); i = i + 1;
            obj.mu = str2double(Parameter{i}); i = i + 1;
            obj.mum = str2double(Parameter{i}); i = i + 1;
        end

        function data = run(obj, Tasks, RunPara)
            sub_pop = RunPara(1); sub_eva = RunPara(2);
            pop_size = sub_pop * length(Tasks);
            eva_num = sub_eva * length(Tasks);

            % initialize
            [population, fnceval_calls, bestDec, bestObj, bestCV] = initializeMF(IndividualMF, pop_size, Tasks, max([Tasks.Dim]));
            convergeObj(:, 1) = bestObj;
            convergeCV(:, 1) = bestCV;

            generation = 1;
            while fnceval_calls < eva_num
                generation = generation + 1;

                % generation
                [offspring, calls] = OperatorMFEA.generate(population, Tasks, obj.rmp, obj.mu, obj.mum);
                fnceval_calls = fnceval_calls + calls;

                % selection
                [population, bestDec, bestObj, bestCV] = selectMF(population, offspring, Tasks, pop_size, bestDec, bestObj, bestCV);
                convergeObj(:, generation) = bestObj;
                convergeCV(:, generation) = bestCV;
            end
            data.convergeObj = gen2eva(convergeObj);
            data.convergeCV = gen2eva(convergeCV);
            data.bestDec = uni2real(bestDec, Tasks);
        end
    end
end
