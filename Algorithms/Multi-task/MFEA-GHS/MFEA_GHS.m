classdef MFEA_GHS < Algorithm
    % <Multi> <None>

    %------------------------------- Reference --------------------------------
    % @Article{Liang2019MFEA-GHS,
    %   author   = {Zhengping Liang and Jian Zhang and Liang Feng and Zexuan Zhu},
    %   journal  = {Expert Systems with Applications},
    %   title    = {A Hybrid of Genetic Transform and Hyper-rectangle Search Strategies for Evolutionary Multi-tasking},
    %   year     = {2019},
    %   volume   = {138},
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
            [population, fnceval_calls, bestobj, bestX] = initializeMFone(IndividualMF, pop_size, Tasks, max([Tasks.dims]));
            convergence(:, 1) = bestobj;
            [max_T, min_T] = cal_max_min(population, Tasks);
            M = {};
            for t = 1:length(Tasks)
                M{t} = ones(1, max(Tasks.dims));
            end

            generation = 1;
            while fnceval_calls < eva_num
                generation = generation + 1;

                % generation
                a = mod(generation, 2);
                [offspring, calls] = OperatorMFEA_GHS.generate(population, Tasks, obj.rmp, obj.mu, obj.mum, a, max_T, min_T, M);
                fnceval_calls = fnceval_calls + calls;

                % selection
                [population, bestobj, bestX] = selectMF(population, offspring, Tasks, pop_size, bestobj, bestX);
                convergence(:, generation) = bestobj;

                % update
                [max_T, min_T] = cal_max_min(population, Tasks);
                M = domain_ad(population, Tasks);
            end
            data.convergence = gen2eva(convergence);
            data.bestX = uni2real(bestX, Tasks);
        end
    end
end
