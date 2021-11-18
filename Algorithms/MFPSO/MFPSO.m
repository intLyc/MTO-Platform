classdef MFPSO < Algorithm
    % @InProceedings{Feng2017MFDE-MFPSO,
    %     author    = {Feng, L. and Zhou, W. and Zhou, L. and Jiang, S. W. and Zhong, J. H. and Da, B. S. and Zhu, Z. X. and Wang, Y.},
    %     booktitle = {2017 IEEE Congress on Evolutionary Computation (CEC)},
    %     title     = {An empirical study of multifactorial PSO and multifactorial DE},
    %     year      = {2017},
    %     pages     = {921-928},
    %     doi       = {10.1109/CEC.2017.7969407},
    % }

    properties (SetAccess = private)
        rmp = 0.3
        selection_process = 'elitist'
        p_il = 0
        wmax = 0.9; % inertia weight
        wmin = 0.4; % inertia weight
        c1 = 0.2;
        c2 = 0.2;
        c3 = 0.2;
    end

    methods

        function parameter = getParameter(obj)
            parameter = {'Random Mating Probability (rmp)', num2str(obj.rmp), ...
                        'elitist / roulette wheel', obj.selection_process, ...
                        'Local Search Probability (p_il)', num2str(obj.p_il), ...
                        'Inertia Weight Max (wmax)', num2str(obj.wmax), ...
                        'Inertia Weight Min (wmin)', num2str(obj.wmin), ...
                        'c1', num2str(obj.c1), ...
                        'c2', num2str(obj.c2), ...
                        'c3', num2str(obj.c3)};
        end

        function obj = setParameter(obj, parameter_cell)
            obj.rmp = str2double(parameter_cell{1});
            obj.selection_process = parameter_cell{2};
            obj.p_il = str2double(parameter_cell{3});
            obj.wmax = str2double(parameter_cell{4});
            obj.wmin = str2double(parameter_cell{5});
            obj.c1 = sgtr2double(parameter_cell{6});
            obj.c2 = sgtr2double(parameter_cell{7});
            obj.c3 = sgtr2double(parameter_cell{8});
        end

        function data = run(obj, Tasks, run_parameter_list)
            pop = run_parameter_list(1);
            gen = run_parameter_list(2);
            eva_num = run_parameter_list(3);
            rmp = obj.rmp;
            selection_process = obj.selection_process;
            p_il = obj.p_il;
            wmax = obj.wmax;
            wmin = obj.wmin;
            c1 = obj.c1;
            c2 = obj.c2;
            c3 = obj.c3;

            tic

            no_of_tasks = length(Tasks);

            if mod(pop, no_of_tasks) ~= 0
                pop = pop + no_of_tasks - mod(pop, no_of_tasks);
            end

            if no_of_tasks <= 1
                error('At least 2 tasks required for MFEA');
            end

            w11 = gen;
            c11 = gen;
            c22 = gen;
            c33 = gen;

            D = zeros(1, no_of_tasks);

            for i = 1:no_of_tasks
                D(i) = Tasks(i).dims;
            end

            D_multitask = max(D);

            options = optimoptions(@fminunc, 'Display', 'off', 'Algorithm', 'quasi-newton', 'MaxIter', 2); % settings for individual learning

            fnceval_calls = zeros(1);
            calls_per_individual = zeros(1, pop);
            bestobj = Inf(1, no_of_tasks);

            for i = 1:pop
                population(i) = Particle();
                population(i) = initialize(population(i), D_multitask);
                population(i).skill_factor = 0;
            end

            for i = 1:pop
                [population(i), calls_per_individual(i)] = evaluate(population(i), Tasks, p_il, no_of_tasks, options);
            end

            fnceval_calls = fnceval_calls + sum(calls_per_individual);
            TotalEvaluations(1) = fnceval_calls;

            factorial_cost = zeros(1, pop);

            for i = 1:no_of_tasks

                for j = 1:pop
                    factorial_cost(j) = population(j).factorial_costs(i);
                end

                [xxx, y] = sort(factorial_cost);
                population = population(y); % reorder the population according to factorial_cost of current task

                for j = 1:pop
                    population(j).factorial_ranks(i) = j;
                end

                bestobj(i) = population(1).factorial_costs(i);
                gbest(i, :) = population(1).rnvec;
                EvBestFitness(i, 1) = bestobj(i);
                bestInd_data(i) = population(1);
            end

            for i = 1:pop
                [xxx, yyy] = min(population(i).factorial_ranks);
                x = find(population(i).factorial_ranks == xxx);
                equivalent_skills = length(x);

                if equivalent_skills > 1 % If having best fitness on multiple tasks, random choose one and set the factorial_costs of others as inf
                    population(i).skill_factor = x(1 + round((equivalent_skills - 1) * rand(1)));
                    tmp = population(i).factorial_costs(population(i).skill_factor);
                    population(i).factorial_costs(1:no_of_tasks) = inf;
                    population(i).factorial_costs(population(i).skill_factor) = tmp;
                    population(i).pbestFitness = tmp;
                else % else, just set the skill_factor and set the factorial_costs of others as inf
                    population(i).skill_factor = yyy;
                    tmp = population(i).factorial_costs(population(i).skill_factor);
                    population(i).factorial_costs(1:no_of_tasks) = inf;
                    population(i).factorial_costs(population(i).skill_factor) = tmp;
                    population(i).pbestFitness = tmp;
                end

            end

            ite = 1;
            noImpove = 0;

            while ite < gen && TotalEvaluations(ite) < eva_num

                if gen == inf
                    w1 = wmax - (wmax - wmin) * TotalEvaluations(ite) / eva_num;
                else
                    w1 = wmax - (wmax - wmin) * ite / gen;
                end

                if ~mod(ite, 10) && noImpove >= 20
                    %restart
                    for i = 1:pop
                        population(i) = velocityUpdate(population(i), gbest, rmp, w11, c11, c22, c33, no_of_tasks);
                    end

                else

                    for i = 1:pop
                        population(i) = velocityUpdate(population(i), gbest, rmp, w1, c1, c2, c3, no_of_tasks);
                    end

                end

                for i = 1:pop
                    population(i) = positionUpdate(population(i));
                end

                for i = 1:pop
                    population(i) = pbestUpdate(population(i));
                end

                for i = 1:pop
                    [population(i), calls_per_individual(i)] = evaluate(population(i), Tasks, p_il, no_of_tasks, options);
                end

                fnceval_calls = fnceval_calls + sum(calls_per_individual);
                TotalEvaluations(ite + 1) = fnceval_calls;

                factorial_cost = zeros(1, pop);

                for i = 1:no_of_tasks

                    for j = 1:pop
                        factorial_cost(j) = population(j).factorial_costs(i);
                    end

                    [xxx, y] = sort(factorial_cost);
                    population = population(y);

                    for j = 1:pop
                        population(j).factorial_ranks(i) = j;
                    end

                    if population(1).factorial_costs(i) <= bestobj(i)
                        bestobj(i) = population(1).factorial_costs(i);
                        gbest(i, :) = population(1).rnvec;
                        bestInd_data(i) = population(1);
                        noImpove = 0;
                    else
                        noImpove = noImpove + 1;
                    end

                    EvBestFitness(i, ite + 1) = bestobj(i);

                end

                % disp(['MFPSO iteration = ', num2str(ite), ' best factorial costs = ', num2str(bestobj)]);
                ite = ite + 1;
            end

            data.clock_time = toc; % 计时结束
            data.convergence = EvBestFitness;
        end

    end

end
