classdef MFEA2 < Algorithm
    % @article{bali2019MFEA2,
    %     author = {Bali, Kavitesh Kumar and Ong, Yew - Soon and Gupta, Abhishek and Tan, Puay Siew},
    %     journal = {IEEE Transactions on Evolutionary Computation},
    %     title = {Multifactorial Evolutionary Algorithm With Online Transfer Parameter Estimation:MFEA - II},
    %     year = {2020},
    %     volume = {24},
    %     number = {1},
    %     pages = {69 - 83},
    %     doi = {10.1109 / TEVC.2019.2906927},
    % }

    properties (SetAccess = private)
        mu = 2; % index of Simulated Binary Crossover (tunable)
        mum = 5; % index of polynomial mutation
        probswap = 0.5; % probability of variable swap
    end

    methods

        function parameter = getParameter(obj)
            parameter = {'mu: index of Simulated Binary Crossover (tunable)', num2str(obj.mu), ...
                        'mum: index of polynomial mutation', num2str(obj.mum), ...
                        'probSwap: Variable Swap Probability', num2str(obj.probswap)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.mu = str2double(parameter_cell{count}); count = count + 1;
            obj.mum = str2double(parameter_cell{count}); count = count + 1;
            obj.probswap = str2double(parameter_cell{count}); count = count + 1;
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

                % Extract task specific data sets
                for t = 1:length(Tasks)
                    subpops(t).data = [];
                end
                for i = 1:length(population)
                    subpops(population(i).skill_factor).data = [subpops(population(i).skill_factor).data; population(i).rnvec];
                end
                RMP = learnRMP(subpops, [Tasks.dims]); % learning RMP matrix online at every generation.

                % generation
                [offspring, calls] = OperatorGA_2.generateMF(1, population, Tasks, RMP, obj.mu, obj.mum, obj.probswap);
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
