classdef MFDE < Algorithm
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
        F = 0.5
        CR = 0.9
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'rmp: Random Mating Probability', num2str(obj.rmp), ...
                        'F: Mutation Factor', num2str(obj.F), ...
                        'CR: Crossover Probability', num2str(obj.CR)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.rmp = str2double(Parameter{i}); i = i + 1;
            obj.F = str2double(Parameter{i}); i = i + 1;
            obj.CR = str2double(Parameter{i}); i = i + 1;
        end

        function data = run(obj, Tasks, RunPara)
            sub_pop = RunPara(1); sub_eva = RunPara(2);
            pop_size = sub_pop * length(Tasks);
            eva_num = sub_eva * length(Tasks);

            % initialize
            [population, fnceval_calls, bestobj, bestX] = initializeMF(Individual, pop_size, Tasks, max([Tasks.dims]));
            convergence(:, 1) = bestobj;

            generation = 1;
            while fnceval_calls < eva_num
                generation = generation + 1;

                % generation
                [offspring, calls] = OperatorMFDE.generate(population, Tasks, obj.rmp, obj.F, obj.CR);
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
