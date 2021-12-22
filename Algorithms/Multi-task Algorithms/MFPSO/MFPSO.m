classdef MFPSO < Algorithm
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
        wmax = 0.9; % inertia weight
        wmin = 0.4; % inertia weight
        c1 = 0.2;
        c2 = 0.2;
        c3 = 0.2;
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'rmp: Random Mating Probability', num2str(obj.rmp), ...
                        'wmax: Inertia Weight Max', num2str(obj.wmax), ...
                        'wmin: Inertia Weight Min', num2str(obj.wmin), ...
                        'c1', num2str(obj.c1), ...
                        'c2', num2str(obj.c2), ...
                        'c3', num2str(obj.c3)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.rmp = str2double(parameter_cell{count}); count = count + 1;
            obj.wmax = str2double(parameter_cell{count}); count = count + 1;
            obj.wmin = str2double(parameter_cell{count}); count = count + 1;
            obj.c1 = str2double(parameter_cell{count}); count = count + 1;
            obj.c2 = str2double(parameter_cell{count}); count = count + 1;
            obj.c3 = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            pop_size = run_parameter_list(1);
            iter_num = run_parameter_list(2);
            eva_num = run_parameter_list(3);
            pop_size = fixPopSize(pop_size, length(Tasks));
            tic

            % initialize
            [population, fnceval_calls, bestobj, bestCV, data.bestX] = initializeMF(IndividualPSO, pop_size, Tasks, length(Tasks));
            data.convergence(:, 1) = bestobj;
            data.convergence_cv(:, 1) = bestCV;
            % initialize pso
            for i = 1:pop_size
                population(i).pbest = population(i).rnvec;
                population(i).velocity = 0;
                population(i).pbestFitness = population(i).factorial_costs(population(i).skill_factor);
            end

            generation = 1;
            while generation < iter_num && fnceval_calls < eva_num
                generation = generation + 1;

                if iter_num == inf
                    w = obj.wmax - (obj.wmax - obj.wmin) * fnceval_calls / eva_num;
                else
                    w = obj.wmax - (obj.wmax - obj.wmin) * generation / iter_num;
                end

                % generation
                [population, calls] = OperatorMFPSO.generate(1, population, Tasks, obj.rmp, w, obj.c1, obj.c2, obj.c3, data.bestX);
                fnceval_calls = fnceval_calls + calls;

                % update best
                for t = 1:length(Tasks)
                    for i = 1:length(population)
                        factorial_costs(i) = population(i).factorial_costs(t);
                    end
                    [bestobj_offspring, idx] = min(factorial_costs);
                    if bestobj_offspring < bestobj(t)
                        bestobj(t) = bestobj_offspring;
                        data.bestX{t} = population(idx).rnvec;
                        data.convergence_cv(t, generation) = population(idx).constraint_violation(t);
                    else
                        data.convergence_cv(t, generation) = data.convergence_cv(t, generation - 1);
                    end
                    data.convergence(t, generation) = bestobj(t);
                end
            end
            data.bestX = bin2real(data.bestX, Tasks);
            data.clock_time = toc;
        end
    end
end
