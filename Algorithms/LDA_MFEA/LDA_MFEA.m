classdef LDA_MFEA < Algorithm
    % @inproceedings{bali2017LDA-MFEA,
    %     author    = {Bali, Kavitesh Kumar and Gupta, Abhishek and Feng, Liang and Ong, Yew Soon and Tan Puay Siew},
    %     booktitle = {2017 IEEE Congress on Evolutionary Computation (CEC)},
    %     title     = {Linearized domain adaptation in evolutionary multitasking},
    %     year      = {2017},
    %     volume    = {},
    %     number    = {},
    %     pages     = {1295-1302},
    %     doi       = {10.1109/CEC.2017.7969454},
    % }

    properties (SetAccess = private)
        rmp = 0.3
        selection_process = 'elitist'
        p_il = 0;
        mu = 2; % index of Simulated Binary Crossover (tunable)
        mum = 5; % index of polynomial mutation
    end

    methods

        function parameter = getParameter(obj)
            parameter = {'rmp: Random Mating Probability', num2str(obj.rmp), ...
                        '("elitist"/"roulette wheel"): Selection Type', obj.selection_process, ...
                        'p_il: Local Search Probability', num2str(obj.p_il), ...
                        'mu: index of Simulated Binary Crossover (tunable)', num2str(obj.mu), ...
                        'mum: index of polynomial mutation', num2str(obj.mum)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.rmp = str2double(parameter_cell{count}); count = count + 1;
            obj.selection_process = parameter_cell{count}; count = count + 1;
            obj.p_il = str2double(parameter_cell{count}); count = count + 1;
            obj.mu = str2num(parameter_cell{count}); count = count + 1;
            obj.mum = str2num(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            pop = run_parameter_list(1);
            gen = run_parameter_list(2);
            eva_num = run_parameter_list(3);
            rmp = obj.rmp;
            selection_process = obj.selection_process;
            p_il = obj.p_il;
            mu = obj.mu;
            mum = obj.mum;

            tic
            no_of_tasks = length(Tasks);
            if mod(pop, no_of_tasks) ~= 0
                pop = pop + no_of_tasks - mod(pop, no_of_tasks);
            end
            if no_of_tasks <= 1
                error('At least 2 tasks required for MFEA');
            end
            D = zeros(1, no_of_tasks);
            for i = 1:no_of_tasks
                D(i) = Tasks(i).dims;
            end
            D_multitask = max(D);

            options = optimoptions(@fminunc, 'Display', 'off', 'Algorithm', 'quasi-newton', 'MaxIter', 2); % local search - optional.

            fnceval_calls = zeros(1);
            calls_per_individual = zeros(1, pop);
            bestobj = Inf(1, no_of_tasks);

            for i = 1:pop
                population(i) = Chromosome_LDA_MFEA();
                population(i) = initialize(population(i), D_multitask);
                population(i).skill_factor = 0;
            end

            temp_points = zeros(pop, D_multitask);
            temp_skill = zeros(pop, 1);
            points_skill = zeros(pop * gen, 1);

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
                population = population(y);
                for j = 1:pop
                    population(j).factorial_ranks(i) = j;
                end
                bestobj(i) = population(1).factorial_costs(i);
                EvBestFitness(i, 1) = bestobj(i);
                bestInd_data(i) = population(1);
            end
            for i = 1:pop
                [xxx, yyy] = min(population(i).factorial_ranks);
                x = find(population(i).factorial_ranks == xxx);
                equivalent_skills = length(x);
                if equivalent_skills > 1
                    population(i).skill_factor = x(1 + round((equivalent_skills - 1) * rand(1)));
                    tmp = population(i).factorial_costs(population(i).skill_factor);
                    population(i).factorial_costs(1:no_of_tasks) = inf;
                    population(i).factorial_costs(population(i).skill_factor) = tmp;
                else
                    population(i).skill_factor = yyy;
                    tmp = population(i).factorial_costs(population(i).skill_factor);
                    population(i).factorial_costs(1:no_of_tasks) = inf;
                    population(i).factorial_costs(population(i).skill_factor) = tmp;
                end
            end

            generation = 1;

            %for accumulating historic points.
            PA = [];
            PB = [];

            while generation < gen && TotalEvaluations(generation) < eva_num
                generation = generation + 1;

                %Extract Task specific Data Sets
                for i = 1:no_of_tasks
                    subpops(i).data = [];
                    f(i).cost = [];
                end

                for i = 1:pop
                    subpops(population(i).skill_factor).data = [subpops(population(i).skill_factor).data; population(i).rnvec];
                    f(population(i).skill_factor).cost = [f(population(i).skill_factor).cost; population(i).factorial_costs(population(i).skill_factor)];
                end

                tempA = [subpops(1).data, f(1).cost];
                % accumulate all historical points of T1  and sort according to
                % factorial cost
                tempA = [PA; tempA];
                tempA = sortrows(tempA, D_multitask + 1); %D(1)+1
                PA = tempA;
                A = tempA(:, 1:end - 1); %extract chromosomes except the last column(factorial_costs)
                %store into matrix A

                tempB = [subpops(2).data, f(2).cost];
                % accumulate all historical points of T2  and sort according to
                % factorial cost
                tempB = [PB; tempB];
                tempB = sortrows(tempB, D_multitask + 1); %D(2)+1
                PB = tempB;
                B = tempB(:, 1:end - 1); %extract chromosomes except the last column(factorial_costs)
                %store into matrix B

                s_a = size(A, 1);
                s_b = size(B, 1);

                diff = abs(s_a - s_b);
                %same number of rows for both task populations.
                %for matrix mapping
                if s_a < s_b
                    %trim b
                    B = B(1:end - diff, :);
                else
                    A = A(1:end - diff, :);
                end
                %current row count of each of the populations row (a == b).
                % curr_row1 = size(A,1);
                %curr_row2 = size(B,1);

                %find Linear Least square mapping between two tasks.

                if (D(1) > D(2)) %Different dimensions : map T2 to T1
                    [m1, m2] = obj.mapping(B(:, 1:D(2)), A);

                else
                    [m1, m2] = obj.mapping(A, B); %Same dimensions : map T1 to T2
                end

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Evolution phase: Crossover or LDA + Crossover
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                tempv = Chromosome_LDA_MFEA();
                indorder = randperm(pop);
                count = 1;
                for i = 1:pop / 2
                    p1 = indorder(i);
                    p2 = indorder(i + (pop / 2));
                    child(count) = Chromosome_LDA_MFEA();
                    child(count + 1) = Chromosome_LDA_MFEA();

                    %----------CROSSOVER
                    if (population(p1).skill_factor == population(p2).skill_factor || rand(1) < rmp) % crossover
                        u = rand(1, D_multitask);
                        cf = zeros(1, D_multitask);
                        cf(u <= 0.5) = (2 * u(u <= 0.5)).^(1 / (mu + 1));
                        cf(u > 0.5) = (2 * (1 - u(u > 0.5))).^(-1 / (mu + 1));
                        child(count) = crossover(child(count), population(p1), population(p2), cf);
                        child(count + 1) = crossover(child(count + 1), population(p2), population(p1), cf);
                        % if rand(1) < 1
                        %     child(count) = mutate(child(count), child(count), D_multitask, mum);
                        %     child(count + 1) = mutate(child(count + 1), child(count + 1), D_multitask, mum);
                        % end
                        sf1 = 1 + round(rand(1));
                        sf2 = 1 + round(rand(1));
                        if sf1 == 1 % skill factor selection
                            child(count).skill_factor = population(p1).skill_factor;
                        else
                            child(count).skill_factor = population(p2).skill_factor;
                        end

                        if sf2 == 1
                            child(count + 1).skill_factor = population(p1).skill_factor;
                        else
                            child(count + 1).skill_factor = population(p2).skill_factor;
                        end

                    else
                        %%%%%% ----------LDA + CROSSOVER--------------------------

                        %same dimensions : assuming mapping is always from T1
                        %to T2 for D1 = D2.
                        if (D(1) == D(2))
                            if (population(p1).skill_factor == 1)

                                tempv.rnvec = population(p1).rnvec * m1;

                                %crossover
                                u = rand(1, D_multitask);
                                cf = zeros(1, D_multitask);
                                cf(u <= 0.5) = (2 * u(u <= 0.5)).^(1 / (mu + 1));
                                cf(u > 0.5) = (2 * (1 - u(u > 0.5))).^(-1 / (mu + 1));
                                child(count) = crossover(child(count), tempv, population(p2), cf);
                                child(count + 1) = crossover(child(count + 1), population(p2), tempv, cf);

                                sf1 = 1 + round(rand(1));
                                sf2 = 1 + round(rand(1));
                                if sf1 == 1 % skill factor selection
                                    child(count).skill_factor = population(p1).skill_factor;
                                    child(count).rnvec = child(count).rnvec * m2;
                                else
                                    child(count).skill_factor = population(p2).skill_factor;
                                end

                                if sf2 == 1
                                    child(count + 1).skill_factor = population(p1).skill_factor;
                                    child(count + 1).rnvec = child(count + 1).rnvec * m2;
                                else
                                    child(count + 1).skill_factor = population(p2).skill_factor;
                                end

                                %else P(2).skill_factor ==1
                            else
                                tempv.rnvec = population(p2).rnvec * m1;

                                %crossover
                                u = rand(1, D_multitask);
                                cf = zeros(1, D_multitask);
                                cf(u <= 0.5) = (2 * u(u <= 0.5)).^(1 / (mu + 1));
                                cf(u > 0.5) = (2 * (1 - u(u > 0.5))).^(-1 / (mu + 1));
                                child(count) = crossover(child(count), tempv, population(p1), cf);
                                child(count + 1) = crossover(child(count + 1), population(p1), tempv, cf);

                                sf1 = 1 + round(rand(1));
                                sf2 = 1 + round(rand(1));
                                if sf1 == 1 % skill factor selection
                                    child(count).skill_factor = population(p2).skill_factor;
                                    child(count).rnvec = child(count).rnvec * m2;
                                else
                                    child(count).skill_factor = population(p1).skill_factor;
                                end

                                if sf2 == 1
                                    child(count + 1).skill_factor = population(p2).skill_factor;
                                    child(count + 1).rnvec = child(count + 1).rnvec * m2;
                                else
                                    child(count + 1).skill_factor = population(p1).skill_factor;
                                end

                            end % if population(p1).skill_factor == 1)

                        end %if (D(1)==D(2))

                        %different dimensions : map T2 to T1 (Prob 6)
                        if (D(1) > D(2))

                            if (population(p1).skill_factor == 1)

                                tempv.rnvec = population(p2).rnvec(1:D(2)) * m1;

                                %crossover
                                u = rand(1, D_multitask);
                                cf = zeros(1, D_multitask);
                                cf(u <= 0.5) = (2 * u(u <= 0.5)).^(1 / (mu + 1));
                                cf(u > 0.5) = (2 * (1 - u(u > 0.5))).^(-1 / (mu + 1));
                                child(count) = crossover(child(count), tempv, population(p1), cf);
                                child(count + 1) = crossover(child(count + 1), population(p1), tempv, cf);

                                sf1 = 1 + round(rand(1));
                                sf2 = 1 + round(rand(1));
                                if sf1 == 1 % skill factor selection
                                    child(count).skill_factor = population(p1).skill_factor;

                                else
                                    child(count).skill_factor = population(p2).skill_factor;
                                    child(count).rnvec(1:D(2)) = child(count).rnvec * m2;
                                end

                                if sf2 == 1
                                    child(count + 1).skill_factor = population(p1).skill_factor;
                                else
                                    child(count + 1).skill_factor = population(p2).skill_factor;
                                    child(count + 1).rnvec(1:D(2)) = child(count + 1).rnvec * m2;
                                end

                            else % P(2).skill_factor == 1

                                tempv.rnvec = population(p1).rnvec(1:D(2)) * m1;

                                %crossover
                                u = rand(1, D_multitask);
                                cf = zeros(1, D_multitask);
                                cf(u <= 0.5) = (2 * u(u <= 0.5)).^(1 / (mu + 1));
                                cf(u > 0.5) = (2 * (1 - u(u > 0.5))).^(-1 / (mu + 1));
                                child(count) = crossover(child(count), tempv, population(p2), cf);
                                child(count + 1) = crossover(child(count + 1), population(p2), tempv, cf);

                                sf1 = 1 + round(rand(1));
                                sf2 = 1 + round(rand(1));
                                if sf1 == 1 % skill factor selection
                                    child(count).skill_factor = population(p2).skill_factor;

                                else
                                    child(count).skill_factor = population(p1).skill_factor;
                                    child(count).rnvec(1:D(2)) = child(count).rnvec * m2;
                                end

                                if sf2 == 1
                                    child(count + 1).skill_factor = population(p2).skill_factor;

                                else
                                    child(count + 1).skill_factor = population(p1).skill_factor;
                                    child(count + 1).rnvec(1:D(2)) = child(count + 1).rnvec * m2;
                                end

                            end

                        end
                        % if D(1) > D(2)
                        %     child(count) = mutate(child(count), population(p1), D_multitask, mum);
                        %     child(count).skill_factor = population(p1).skill_factor;
                        %     child(count + 1) = mutate(child(count + 1), population(p2), D_multitask, mum);
                        %     child(count + 1).skill_factor = population(p2).skill_factor;
                        % end
                    end
                    count = count + 2;
                end

                for i = 1:pop
                    [child(i), calls_per_individual(i)] = evaluate(child(i), Tasks, p_il, no_of_tasks, options);
                end
                fnceval_calls = fnceval_calls + sum(calls_per_individual);
                TotalEvaluations(generation) = fnceval_calls;

                intpopulation(1:pop) = population;
                intpopulation(pop + 1:2 * pop) = child;
                factorial_cost = zeros(1, 2 * pop);
                for i = 1:no_of_tasks
                    for j = 1:2 * pop
                        factorial_cost(j) = intpopulation(j).factorial_costs(i);
                    end
                    [xxx, y] = sort(factorial_cost);
                    intpopulation = intpopulation(y);
                    for j = 1:2 * pop
                        intpopulation(j).factorial_ranks(i) = j;
                    end
                    if intpopulation(1).factorial_costs(i) <= bestobj(i)
                        bestobj(i) = intpopulation(1).factorial_costs(i);
                        bestInd_data(i) = intpopulation(1);
                    end
                    EvBestFitness(i, generation) = bestobj(i);
                end
                for i = 1:2 * pop
                    [xxx, yyy] = min(intpopulation(i).factorial_ranks);
                    intpopulation(i).skill_factor = yyy;
                    intpopulation(i).scalar_fitness = 1 / xxx;
                end

                if strcmp(selection_process, 'elitist')
                    [xxx, y] = sort(- [intpopulation.scalar_fitness]);
                    intpopulation = intpopulation(y);
                    population = intpopulation(1:pop);
                elseif strcmp(selection_process, 'roulette wheel')
                    for i = 1:no_of_tasks
                        skill_group(i).individuals = intpopulation([intpopulation.skill_factor] == i);
                    end
                    count = 0;
                    while count < pop
                        count = count + 1;
                        skill = mod(count, no_of_tasks) + 1;
                        population(count) = skill_group(skill).individuals(RouletteWheelSelection([skill_group(skill).individuals.scalar_fitness]));
                    end
                end
            end
            data.clock_time = toc;
            data.convergence = EvBestFitness;
        end

        function [m1, m2] = mapping(obj, a, b)

            %   if size(a)~= size(b)
            %       error ('matrix dimensions much match - pad extra zeros  needed')
            %   end

            m1 = (inv(transpose(a) * a)) * (transpose(a) * b);
            m2 = transpose(m1) * (inv(m1 * transpose(m1)));
        end
    end
end
