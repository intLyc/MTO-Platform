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
        function parameter = getParameter(obj)
            parameter = {'rmp: Random Mating Probability', num2str(obj.rmp), ...
                        'mu: index of Simulated Binary Crossover', num2str(obj.mu), ...
                        'mum: index of polynomial mutation', num2str(obj.mum), ...
                        'p: 100p% top as pbest', num2str(obj.p)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.rmp = str2double(parameter_cell{count}); count = count + 1;
            obj.mu = str2double(parameter_cell{count}); count = count + 1;
            obj.mum = str2double(parameter_cell{count}); count = count + 1;
            obj.p = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            sub_pop = run_parameter_list(1);
            sub_eva = run_parameter_list(2);
            pop_size = sub_pop * length(Tasks);
            eva_num = sub_eva * length(Tasks);

            % initialize
            [population, fnceval_calls, bestobj, bestX] = initializeMF(Individual, pop_size, Tasks, max([Tasks.dims]));
            convergence(:, 1) = bestobj;

            generation = 1;
            while fnceval_calls < eva_num
                generation = generation + 1;

                % generation
                [offspring, calls] = OperatorMFEA_DV.generate(population, Tasks, obj.rmp, obj.mu, obj.mum, obj.p, sub_pop);
                fnceval_calls = fnceval_calls + calls;

                % selection
                [population, bestobj, bestX] = selectMF(population, offspring, Tasks, pop_size, bestobj, bestX);
                convergence(:, generation) = bestobj;
            end
            data.convergence = gen2eva(convergence);
            data.bestX = uni2real(bestX, Tasks);
        end
    end
end
