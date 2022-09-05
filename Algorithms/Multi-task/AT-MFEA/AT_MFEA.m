classdef AT_MFEA < Algorithm
    % <Multi> <None/Constrained>

    %------------------------------- Reference --------------------------------
    % @article{Xue2020AT-MFEA,
    %   title      = {Affine Transformation-Enhanced Multifactorial Optimization for Heterogeneous Problems},
    %   author     = {Xue, Xiaoming and Zhang, Kai and Tan, Kay Chen and Feng, Liang and Wang, Jian and Chen, Guodong and Zhao, Xinggang and Zhang, Liming and Yao, Jun},
    %   doi        = {10.1109/TCYB.2020.3036393},
    %   journal    = {IEEE Transactions on Cybernetics},
    %   pages      = {1-15},
    %   year       = {2020}
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
        probswap = 0.5;
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'rmp: Random Mating Probability', num2str(obj.rmp), ...
                        'mu: index of Simulated Binary Crossover', num2str(obj.mu), ...
                        'mum: index of polynomial mutation', num2str(obj.mum), ...
                        'probSwap: Variable Swap Probability', num2str(obj.probswap)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.rmp = str2double(Parameter{i}); i = i + 1;
            obj.mu = str2double(Parameter{i}); i = i + 1;
            obj.mum = str2double(Parameter{i}); i = i + 1;
            obj.probswap = str2double(Parameter{i}); i = i + 1;
        end

        function data = run(obj, Tasks, RunPara)
            sub_pop = RunPara(1); sub_eva = RunPara(2);
            pop_size = sub_pop * length(Tasks);
            eva_num = sub_eva * length(Tasks);

            % initialize
            [population, fnceval_calls, bestDec, bestObj, bestCV] = initializeMF(IndividualMF, pop_size, Tasks, max([Tasks.Dim]));
            convergeObj(:, 1) = bestObj;
            convergeCV(:, 1) = bestCV;
            % initialize affine transformation
            [mu_tasks, Sigma_tasks] = InitialDistribution(population, length(Tasks));

            generation = 1;
            while fnceval_calls < eva_num
                generation = generation + 1;

                % generation
                [offspring, calls] = OperatorMFEA_AT.generate(population, Tasks, obj.rmp, obj.mu, obj.mum, obj.probswap, mu_tasks, Sigma_tasks);
                fnceval_calls = fnceval_calls + calls;

                % selection
                [population, bestDec, bestObj, bestCV] = selectMF(population, offspring, Tasks, pop_size, bestDec, bestObj, bestCV);
                convergeObj(:, generation) = bestObj;
                convergeCV(:, generation) = bestCV;

                % Updates of the progresisonal representation models
                [mu_tasks, Sigma_tasks] = DistributionUpdate(mu_tasks, Sigma_tasks, population, length(Tasks));
            end
            data.convergeObj = gen2eva(convergeObj);
            data.convergeCV = gen2eva(convergeCV);
            data.bestDec = uni2real(bestDec, Tasks);
        end
    end
end
