classdef SREMTO < Algorithm
    % <Multi> <None>

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
        TH = 0.3;
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
            sub_pop = run_parameter_list(1);
            sub_eva = run_parameter_list(2);
            pop_size = sub_pop * length(Tasks);
            eva_num = sub_eva * length(Tasks);
            tic

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
                    population(rank(i)).factorial_ranks(t) = i;
                    % get ability vector
                    if population(rank(i)).factorial_ranks(t) <= sub_pop
                        population(rank(i)).ability_vector(t) = a1 * population(rank(i)).factorial_ranks(t) + b1;
                    else
                        population(rank(i)).ability_vector(t) = a2 * population(rank(i)).factorial_ranks(t) + b2;
                    end
                end
                bestobj(t) = population(rank(1)).factorial_costs(t);
                bestCV(t) = population(rank(1)).constraint_violation(t);
                data.bestX{t} = population(rank(1)).rnvec;
            end
            data.convergence(:, 1) = bestobj;

            generation = 1;
            while fnceval_calls < eva_num
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
                        bestCV(t) = int_population(idx).constraint_violation(t);
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
            data.bestX = uni2real(data.bestX, Tasks);
            data.clock_time = toc;
        end
    end
end
