classdef FP_MFEA < Algorithm
    % <Multi> <Constrained>

    % MFEA with Feasibility Priority for Constrained MTOPs

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
            [population, fnceval_calls, bestobj, bestCV, bestX] = initializeCMF(Individual, pop_size, Tasks, max([Tasks.dims]));
            convergence(:, 1) = bestobj;
            convergence_cv(:, 1) = bestCV;

            generation = 1;
            while fnceval_calls < eva_num
                generation = generation + 1;

                % generation
                [offspring, calls] = OperatorMFEA.generate(population, Tasks, obj.rmp, obj.mu, obj.mum);
                fnceval_calls = fnceval_calls + calls;

                % selection
                [population, bestobj, bestCV, bestX] = selectCMF(population, offspring, Tasks, pop_size, bestobj, bestCV, bestX);
                convergence(:, generation) = bestobj;
                convergence_cv(:, generation) = bestCV;
            end
            data.convergence = gen2eva(convergence);
            data.convergence_cv = gen2eva(convergence_cv);
            data.bestX = uni2real(bestX, Tasks);
        end
    end
end
