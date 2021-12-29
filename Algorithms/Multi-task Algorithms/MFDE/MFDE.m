classdef MFDE < Algorithm
    % @InProceedings{Feng2017MFDE-MFPSO,
    %   author     = {Feng, L. and Zhou, W. and Zhou, L. and Jiang, S. W. and Zhong, J. H. and Da, B. S. and Zhu, Z. X. and Wang, Y.},
    %   booktitle  = {2017 IEEE Congress on Evolutionary Computation (CEC)},
    %   title      = {An Empirical Study of Multifactorial PSO and Multifactorial DE},
    %   year       = {2017},
    %   pages      = {921-928},
    %   doi        = {10.1109/CEC.2017.7969407},
    % }

    properties (SetAccess = private)
        rmp = 0.3
        F = 0.5
        pCR = 0.9
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'rmp: Random Mating Probability', num2str(obj.rmp), ...
                        'F: Mutation Factor', num2str(obj.F), ...
                        'pCR: Crossover Probability', num2str(obj.pCR)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.rmp = str2double(parameter_cell{count}); count = count + 1;
            obj.F = str2double(parameter_cell{count}); count = count + 1;
            obj.pCR = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            sub_pop = run_parameter_list(1);
            iter_num = run_parameter_list(2);
            eva_num = run_parameter_list(3);
            tic

            pop_size = sub_pop * length(Tasks);

            % initialize
            [population, fnceval_calls, bestobj, data.bestX] = initializeMF(Individual, pop_size, Tasks, length(Tasks));
            data.convergence(:, 1) = bestobj;

            generation = 1;
            while generation < iter_num && fnceval_calls < eva_num
                generation = generation + 1;

                % generation
                [offspring, calls] = OperatorMFDE.generate(1, population, Tasks, obj.rmp, obj.F, obj.pCR);
                fnceval_calls = fnceval_calls + calls;

                % selection
                [population, bestobj, data.bestX] = selectMF(population, offspring, Tasks, pop_size, bestobj, data.bestX);
                data.convergence(:, generation) = bestobj;
            end
            data.bestX = bin2real(data.bestX, Tasks);
            data.clock_time = toc;
        end
    end
end
