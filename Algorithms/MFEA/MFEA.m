classdef MFEA < Algorithm
    % @article{Gupta2016MFEA,
    %     author = {Gupta, Abhishek and Ong, Yew - Soon and Feng, Liang},
    %     journal = {IEEE Transactions on Evolutionary Computation},
    %     title = {Multifactorial Evolution:Toward Evolutionary Multitasking},
    %     year = {2016},
    %     number = {3},
    %     pages = {343 - 357},
    %     volume = {20},
    %     doi = {10.1109 / TEVC.2015.2458037},
    % }

    properties (SetAccess = private)
        rmp = 0.3
        mu = 2; % index of Simulated Binary Crossover (tunable)
        mum = 5; % index of polynomial mutation
    end

    methods

        function parameter = getParameter(obj)
            parameter = {'rmp: Random Mating Probability', num2str(obj.rmp), ...
                        'mu: index of Simulated Binary Crossover (tunable)', num2str(obj.mu), ...
                        'mum: index of polynomial mutation', num2str(obj.mum)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.rmp = str2double(parameter_cell{count}); count = count + 1;
            obj.mu = str2double(parameter_cell{count}); count = count + 1;
            obj.mum = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            pop_size = run_parameter_list(1);
            iter_num = run_parameter_list(2);
            eva_num = run_parameter_list(3);
            pop_size = fixPopSize(pop_size, length(Tasks));
            tic

            % initialize
            [population, fnceval_calls, bestobj, data.bestX] = initializeMF(Individual, pop_size, Tasks, length(Tasks));
            data.convergence(:, 1) = bestobj;

            generation = 1;
            while generation < iter_num && fnceval_calls < eva_num
                generation = generation + 1;

                % generation
                [offspring, calls] = OperatorGA.generateMF(1, population, Tasks, obj.rmp, obj.mu, obj.mum);
                fnceval_calls = fnceval_calls + calls;

                % selection
                [population, bestobj_now, bestX_now] = selectMF(population, offspring, Tasks, pop_size, bestobj);
                for t = 1:length(Tasks)
                    if bestobj(t) ~= bestobj_now(t)
                        bestobj(t) = bestobj_now(t);
                        data.bestX{t} = bestX_now{t};
                    end
                end
                data.convergence(:, generation) = bestobj;
            end
            % map to real bound
            for t = 1:length(Tasks)
                data.bestX{t} = Tasks(t).Lb + data.bestX{t}(1:Tasks(t).dims) .* (Tasks(t).Ub - Tasks(t).Lb);
            end
            data.clock_time = toc;
        end
    end
end
