classdef GA < Algorithm

    properties (SetAccess = private)
        selection_process = 'elitist'
        p_il = 0
        mu = 10 % 模拟二进制交叉的染色体长度
        sigma = 0.02 % 高斯变异的标准差
    end

    methods

        function parameter = getParameter(obj)
            parameter = {'elitist / roulette wheel', obj.selection_process, ...
                        'Local Search Probability (p_il)', num2str(obj.p_il), ...
                        'SBX Crossover length (mu)', num2str(obj.mu), ...
                        'Mutation Sigma (sigma)', num2str(obj.sigma)};
        end

        function obj = setParameter(obj, parameter_cell)
            obj.selection_process = parameter_cell{1};
            obj.p_il = str2double(parameter_cell{2});
            obj.mu = str2num(parameter_cell{3});
            obj.sigma = str2double(parameter_cell{4});
        end

        function data = run(obj, Tasks, run_parameter_list)
            pop = run_parameter_list(1);
            gen = run_parameter_list(2);
            eva_num = run_parameter_list(3);
            selection_process = obj.selection_process;
            p_il = obj.p_il;
            mu = obj.mu;
            sigma = obj.sigma;
            data.convergence = [];

            tic

            no_of_tasks = length(Tasks); % 任务数量

            if mod(pop, no_of_tasks) ~= 0
                pop = pop + no_of_tasks - mod(pop, no_of_tasks);
            end

            sub_pop = int32(pop / no_of_tasks);

            for sub_task = 1:no_of_tasks
                Task = Tasks(sub_task);

                D = Task.dims;
                options = optimoptions(@fminunc, 'Display', 'off', 'Algorithm', 'quasi-newton', 'MaxIter', 5);

                fnceval_calls = 0;
                calls_per_individual = zeros(1, sub_pop);
                % EvBestFitness = zeros(1, gen);
                % TotalEvaluations = zeros(1, gen);

                for i = 1:sub_pop
                    population(i) = Chromosome_MFEA();
                    population(i) = initialize(population(i), D);
                end

                for i = 1:sub_pop
                    [population(i), calls_per_individual(i)] = evaluate_SOO(population(i), Task, p_il, options);
                end

                fnceval_calls = fnceval_calls + sum(calls_per_individual);
                TotalEvaluations(1) = fnceval_calls;
                bestobj = min([population.factorial_costs]);
                EvBestFitness(1) = bestobj;

                generation = 1;

                while generation < gen && TotalEvaluations(generation) < int32(eva_num / no_of_tasks)
                    generation = generation + 1;
                    indorder = randperm(length(population));
                    count = 1;

                    for i = 1:ceil(length(population) / 2)
                        p1 = indorder(i);
                        p2 = indorder(i + fix(length(population) / 2));
                        child(count) = Chromosome_MFEA();
                        child(count + 1) = Chromosome_MFEA();
                        u = rand(1, D);
                        cf = zeros(1, D);
                        cf(u <= 0.5) = (2 * u(u <= 0.5)).^(1 / (mu + 1));
                        cf(u > 0.5) = (2 * (1 - u(u > 0.5))).^(-1 / (mu + 1));
                        child(count) = crossover(child(count), population(p1), population(p2), cf);
                        child(count + 1) = crossover(child(count + 1), population(p2), population(p1), cf);

                        if rand(1) < 0.1
                            child(count) = mutate(child(count), child(count), D, sigma);
                            child(count + 1) = mutate(child(count + 1), child(count + 1), D, sigma);
                        end

                        count = count + 2;
                    end

                    for i = 1:sub_pop
                        [child(i), calls_per_individual(i)] = evaluate_SOO(child(i), Task, p_il, options);
                    end

                    fnceval_calls = fnceval_calls + sum(calls_per_individual);
                    TotalEvaluations(generation) = fnceval_calls;

                    intpopulation(1:sub_pop) = population;
                    intpopulation(sub_pop + 1:2 * sub_pop) = child(1:sub_pop);
                    [xxx, y] = sort([intpopulation.factorial_costs]);
                    intpopulation = intpopulation(y);

                    for i = 1:2 * sub_pop
                        intpopulation(i).scalar_fitness = 1 / i;
                    end

                    if intpopulation(1).factorial_costs <= bestobj
                        bestobj = intpopulation(1).factorial_costs;
                        bestInd_data = intpopulation(1);
                    end

                    EvBestFitness(generation) = bestobj;

                    if strcmp(selection_process, 'elitist')
                        [xxx, y] = sort(- [intpopulation.scalar_fitness]);
                        intpopulation = intpopulation(y);
                        population = intpopulation(1:sub_pop);
                    elseif strcmp(selection_process, 'roulette wheel')

                        for i = 1:sub_pop
                            population(i) = intpopulation(RouletteWheelSelection([intpopulation.scalar_fitness]));
                        end

                    end

                    % disp(['SOO Generation ', num2str(generation), ' best objective = ', num2str(bestobj)])
                end

                data.convergence = [data.convergence; EvBestFitness];
            end

            data.clock_time = toc;

        end

    end

end
