classdef MTEA_AD < Algorithm
    % <Multi/Many> <None>

    %------------------------------- Reference --------------------------------
    % @Article{Wang2021MTEA-AD,
    %   author     = {Wang, Chao and Liu, Jing and Wu, Kai and Wu, Zhaoyang},
    %   journal    = {IEEE Transactions on Evolutionary Computation},
    %   title      = {Solving Multi-task Optimization Problems with Adaptive Knowledge Transfer via Anomaly Detection},
    %   year       = {2021},
    %   pages      = {1-1},
    %   doi        = {10.1109/TEVC.2021.3068157},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        TRP = 0.1;
        mu = 2;
        mum = 5;
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'TRP: probability of the knowledge transfer', num2str(obj.TRP), ...
                        'mu: index of Simulated Binary Crossover', num2str(obj.mu), ...
                        'mum: index of polynomial mutation', num2str(obj.mum)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.TRP = str2double(parameter_cell{count}); count = count + 1;
            obj.mu = str2double(parameter_cell{count}); count = count + 1;
            obj.mum = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            sub_pop = run_parameter_list(1);
            sub_eva = run_parameter_list(2);
            pop_size = sub_pop * length(Tasks);
            eva_num = sub_eva * length(Tasks);
            tic

            epsilon = zeros(1, length(Tasks)); % Parameter of the anomaly detection model

            % initialize
            [population, fnceval_calls, bestobj, data.bestX] = initializeMT(Individual, sub_pop, Tasks, [Tasks.dims]);
            data.convergence(:, 1) = bestobj;

            generation = 1;
            while fnceval_calls < eva_num
                generation = generation + 1;

                for t = 1:length(Tasks)
                    % generation
                    offspring = OperatorGA.generate(0, population{t}, Tasks(t), obj.mu, obj.mum);

                    % Knowledge Transfer
                    if rand < obj.TRP
                        if generation == 1
                            NL = 1;
                        else
                            NL = epsilon(t);
                        end
                        curr_pop = reshape([offspring.rnvec], length(offspring(1).rnvec), length(offspring))';
                        curr_pop = curr_pop(:, 1:Tasks(t).dims);
                        his_pop = [];
                        for tt = 1:length(Tasks)
                            if tt ~= t
                                his_pop_tt = reshape([population{tt}.rnvec], length(population{tt}(1).rnvec), length(population{tt}))';
                                his_pop_tt = [his_pop_tt, rand(size(his_pop_tt, 1), max([Tasks.dims]) - Tasks(tt).dims)];
                                his_pop = [his_pop; his_pop_tt(:, 1:Tasks(t).dims)];
                            end
                        end

                        tfsol = learn_anomaly_detection(curr_pop, his_pop, NL);

                        transfer_pop = Individual.empty();
                        for i = 1:size(tfsol, 1)
                            c = Individual();
                            c.rnvec = tfsol(i, :);
                            c.rnvec(c.rnvec > 1) = 1;
                            c.rnvec(c.rnvec < 0) = 0;
                            transfer_pop = [transfer_pop, c];
                        end

                        % selection
                        [offspring, calls] = evaluate(offspring, Tasks(t), 1);
                        fnceval_calls = fnceval_calls + calls;
                        [transfer_pop, calls] = evaluate(transfer_pop, Tasks(t), 1);
                        fnceval_calls = fnceval_calls + calls;

                        population{t} = [population{t}, offspring, transfer_pop];
                        [~, rank] = sort([population{t}.factorial_costs]);
                        population{t} = population{t}(rank(1:sub_pop));

                        succ_num = sum(rank(1:length(population{t})) > length(population{t}) + length(offspring));

                        % Parameter adaptation strategy via elitism
                        epsilon(t) = succ_num ./ size(tfsol, 1);
                    else
                        % selection
                        [offspring, calls] = evaluate(offspring, Tasks(t), 1);
                        fnceval_calls = fnceval_calls + calls;
                        population{t} = [population{t}, offspring];
                        [~, rank] = sort([population{t}.factorial_costs]);
                        population{t} = population{t}(rank(1:sub_pop));
                    end

                    [bestobj_temp, idx] = min([population{t}.factorial_costs]);
                    if bestobj_temp < bestobj(t)
                        bestobj(t) = bestobj_temp;
                        data.bestX{t} = population{t}(idx).rnvec;
                    end
                    data.convergence(t, generation) = bestobj(t);
                end
            end
            data.convergence = gen2eva(data.convergence);
            data.bestX = uni2real(data.bestX, Tasks);
            data.clock_time = toc;
        end
    end
end
