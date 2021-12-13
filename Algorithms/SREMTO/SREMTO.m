classdef SREMTO < Algorithm
    % @Article{Zheng2020SREMTO,
    %   author     = {Zheng, Xiaolong and Qin, A. K. and Gong, Maoguo and Zhou, Deyun},
    %   journal    = {IEEE Transactions on Evolutionary Computation},
    %   title      = {Self-Regulated Evolutionary Multitask Optimization},
    %   year       = {2020},
    %   number     = {1},
    %   pages      = {16-28},
    %   volume     = {24},
    %   doi        = {10.1109/TEVC.2019.2904696},
    %   file       = {:Zheng2020SREMTO - Self Regulated Evolutionary Multitask Optimization.pdf:PDF},
    %   groups     = {MT, SO, Algorithm},
    %   readstatus = {read},
    % }

    properties (SetAccess = private)
        TH = 0.9;
        mu = 2;
        mum = 5;
    end

    methods

        function parameter = getParameter(obj)
            parameter = {'TH: two line segments point', num2str(obj.TH), ...
                        'mu: index of Simulated Binary Crossover (tunable)', num2str(obj.mu), ...
                        'mum: index of polynomial mutation', num2str(obj.mum)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.TH = str2double(parameter_cell{count}); count = count + 1;
            obj.mu = str2double(parameter_cell{count}); count = count + 1;
            obj.mum = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            pop_size = run_parameter_list(1);
            iter_num = run_parameter_list(2);
            eva_num = run_parameter_list(3);
            pop_size = fixPopSize(pop_size, length(Tasks));
            tic

            sub_pop = round(pop_size / length(Tasks));
            a1 = (obj.TH - 1) ./ (sub_pop - 1);
            b1 = (sub_pop - obj.TH) ./ (sub_pop - 1);
            a2 = (- obj.TH) ./ (pop_size - sub_pop);
            b2 = (pop_size .* obj.TH) ./ (pop_size - sub_pop);

            % initialize
            [population, fnceval_calls] = initialize(IndividualSRE, pop_size, Tasks, length(Tasks));

            for t = 1:length(Tasks)
                for i = 1:pop_size
                    factorial_costs(i) = population(i).factorial_costs(t);
                end
                [~, rank] = sort(factorial_costs);
                for i = 1:pop_size
                    population(i).factorial_ranks(t) = rank(i);
                    % get ability vector
                    if population(i).factorial_ranks(t) <= sub_pop
                        population(i).ability_vector(t) = a1 * population(i).factorial_ranks(t) + b1;
                    else
                        population(i).ability_vector(t) = a2 * population(i).factorial_ranks(t) + b2;
                    end
                end
                bestobj(t) = population(rank(1)).factorial_costs(t);
                data.bestX{t} = population(rank(1)).rnvec;
            end
            data.convergence(:, 1) = bestobj;

            generation = 1;
            while generation < iter_num && fnceval_calls < eva_num
                generation = generation + 1;

                int_population = population;
                for t = 1:length(Tasks)
                    parent = IndividualSRE.empty();
                    for i = 1:length(population)
                        if population(i).factorial_ranks(t) <= sub_pop
                            parent = [parent, population(i)];
                        end
                    end

                    % generation
                    [offspring, calls] = OperatorGA_SRE.generate(1, parent, Tasks, t, obj.mu, obj.mum);
                    fnceval_calls = fnceval_calls + calls;
                    int_population = [int_population, offspring];
                end

                % selection
                population = IndividualSRE.empty();
                factorial_costs = [];
                for t = 1:length(Tasks)
                    for i = 1:length(int_population)
                        factorial_costs(i) = int_population(i).factorial_costs(t);
                    end
                    [bestobj_offspring, idx] = min(factorial_costs);
                    if bestobj_offspring < bestobj(t)
                        bestobj(t) = bestobj_offspring;
                        data.bestX{t} = int_population(idx).rnvec;
                    end

                    [~, rank] = sort(factorial_costs);
                    for i = 1:length(int_population)
                        int_population(rank(i)).factorial_ranks(t) = i;
                    end
                end
                % select next generation population
                next_idx = [];
                for t = 1:length(Tasks)
                    for i = 1:length(int_population)
                        if int_population(i).factorial_ranks(t) <= sub_pop
                            % population = [population, int_population(i)];
                            next_idx = [next_idx, i];
                        end
                    end
                end

                population = int_population(unique(next_idx));
                % get ability vector
                for t = 1:length(Tasks)
                    for i = 1:length(population)
                        if population(i).factorial_ranks(t) <= sub_pop
                            population(i).ability_vector(t) = a1 * population(i).factorial_ranks(t) + b1;
                        else
                            population(i).ability_vector(t) = a2 * population(i).factorial_ranks(t) + b2;
                        end
                    end
                end
                data.convergence(:, generation) = bestobj;
            end
            data.bestX = bin2real(data.bestX, Tasks);
            data.clock_time = toc;
        end
    end
end
