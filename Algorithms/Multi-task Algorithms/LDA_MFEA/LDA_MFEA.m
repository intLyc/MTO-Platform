classdef LDA_MFEA < Algorithm
    % @inproceedings{Bali2017LDA-MFEA,
    %   author    = {Bali, Kavitesh Kumar and Gupta, Abhishek and Feng, Liang and Ong, Yew Soon and Tan Puay Siew},
    %   booktitle = {2017 IEEE Congress on Evolutionary Computation (CEC)},
    %   title     = {Linearized Domain Adaptation in Evolutionary Multitasking},
    %   year      = {2017},
    %   pages     = {1295-1302},
    %   doi       = {10.1109/CEC.2017.7969454},
    % }

    properties (SetAccess = private)
        rmp = 0.3
        mu = 2; % index of Simulated Binary Crossover (tunable)
        mum = 5; % index of polynomial mutation
        store_max = 1000;
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'rmp: Random Mating Probability', num2str(obj.rmp), ...
                        'mu: index of Simulated Binary Crossover (tunable)', num2str(obj.mu), ...
                        'mum: index of polynomial mutation', num2str(obj.mum), ...
                        'store_max: gene store max length', num2str(obj.store_max)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.rmp = str2double(parameter_cell{count}); count = count + 1;
            obj.mu = str2double(parameter_cell{count}); count = count + 1;
            obj.mum = str2double(parameter_cell{count}); count = count + 1;
            obj.store_max = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            pop_size = run_parameter_list(1);
            iter_num = run_parameter_list(2);
            eva_num = run_parameter_list(3);
            pop_size = fixPopSize(pop_size, length(Tasks));
            tic

            % initialize
            [population, fnceval_calls, bestobj, bestCV, data.bestX] = initializeMF(Individual, pop_size, Tasks, length(Tasks));
            data.convergence(:, 1) = bestobj;
            data.convergence_cv(:, 1) = bestCV;
            % initialize lda
            for t = 1:length(Tasks)
                P{t} = [];
                M{t} = [];
            end

            generation = 1;
            while generation < iter_num && fnceval_calls < eva_num
                generation = generation + 1;

                % Extract Task specific Data Sets
                for t = 1:length(Tasks)
                    subpops(t).data = [];
                    f(t).cost = [];
                end
                for i = 1:length(population)
                    subpops(population(i).skill_factor).data = [subpops(population(i).skill_factor).data; population(i).rnvec];
                    f(population(i).skill_factor).cost = [f(population(i).skill_factor).cost; population(i).factorial_costs(population(i).skill_factor)];
                end

                for t = 1:length(Tasks)
                    if size(P{t}, 1) > obj.store_max
                        P{t} = P{t}(end - obj.store_max:end, :);
                    end
                    % accumulate all historical points of t  and sort according to factorial cost
                    temp = [P{t}; [subpops(t).data, f(t).cost]];
                    temp = sortrows(temp, max([Tasks.dims]) + 1);
                    P{t} = temp;
                    M{t} = temp(:, 1:end - 1); %extract chromosomes except the last column(factorial_costs), store into matrix
                end

                % generation
                [offspring, calls] = OperatorMFEA_LDA.generate(1, population, Tasks, obj.rmp, obj.mu, obj.mum, M);
                fnceval_calls = fnceval_calls + calls;

                % selection
                [population, bestobj, bestCV, data.bestX] = selectMF(population, offspring, Tasks, pop_size, bestobj, bestCV, data.bestX);
                data.convergence(:, generation) = bestobj;
                data.convergence_cv(:, generation) = bestCV;
            end
            data.convergence(data.convergence_cv > 0) = NaN;
            data.convergence_fr = zeros(size(data.convergence));
            data.bestX = bin2real(data.bestX, Tasks);
            data.clock_time = toc;
        end
    end
end
