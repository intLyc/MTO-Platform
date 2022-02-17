classdef MTDE < Algorithm
    % <Multi> <None/Competitive>

    % @Article{Li2022CompetitiveMTO,
    %   author     = {Li, Genghui and Zhang, Qingfu and Wang, Zhenkun},
    %   journal    = {IEEE Transactions on Evolutionary Computation},
    %   title      = {Evolutionary Competitive Multitasking Optimization},
    %   year       = {2022},
    %   pages      = {1-1},
    %   doi        = {10.1109/TEVC.2022.3141819},
    % }

    properties (SetAccess = private)
        F = 0.5
        CR = 0.9
        alpha = 0.5
        rmp0 = 0.3
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'F: Mutation Factor', num2str(obj.F), ...
                        'CR: Crossover Probability', num2str(obj.CR), ...
                        'alpha', num2str(obj.alpha), ...
                        'rmp0: Initial random mating probability', num2str(obj.rmp0)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.F = str2double(parameter_cell{count}); count = count + 1;
            obj.CR = str2double(parameter_cell{count}); count = count + 1;
            obj.alpha = str2double(parameter_cell{count}); count = count + 1;
            obj.rmp0 = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            sub_pop = run_parameter_list(1);
            iter_num = run_parameter_list(2);
            eva_num = run_parameter_list(3) * length(Tasks);
            tic

            pop_size = sub_pop * length(Tasks);
            population = {};
            fnceval_calls = 0;
            if iter_num == inf
                gen = (eva_num - (pop_size * length(Tasks) - 1)) / pop_size;
                delta_rmp = 1 / gen;
            else
                delta_rmp = 1 / iter_num;
            end
            rmp = obj.rmp0 * ones(length(Tasks), length(Tasks)) / (length(Tasks) - 1);
            rmp(logical(eye(size(rmp)))) = (1 - obj.rmp0);

            for t = 1:length(Tasks)
                for i = 1:sub_pop
                    population{t}(i) = Individual();
                    population{t}(i).rnvec = rand(1, max([Tasks.dims]));
                end
                [population{t}, calls] = evaluate(population{t}, Tasks(t), 1);
                fnceval_calls = fnceval_calls + calls;

                [bestobj(t), idx] = min([population{t}.factorial_costs]);
                data.bestX{t} = population{t}(idx).rnvec;
                data.convergence(t, 1) = bestobj(t);
            end

            generation = 1;
            while generation < iter_num && fnceval_calls < eva_num
                generation = generation + 1;

                for k = 1:length(Tasks)
                    % generate
                    [offspring, r1_task, calls] = OperatorDEORA.generate(1, population, Tasks, k, rmp, obj.F, obj.CR);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    fit_old = [population{k}.factorial_costs];
                    replace = [population{k}.factorial_costs] > [offspring.factorial_costs];
                    population{k}(replace) = offspring(replace);
                    fit_new = [population{k}.factorial_costs];

                    [bestobj_now, idx] = min([population{k}.factorial_costs]);
                    if bestobj_now < bestobj(k)
                        bestobj(k) = bestobj_now;
                        data.bestX{k} = population{k}(idx).rnvec;
                    end

                    % calculate the reward
                    R_p = max((fit_old - fit_new) ./ (fit_old), 0);
                    R_b = max((bestobj(k) - min(fit_new)) / bestobj(k), 0);
                    R = zeros(length(Tasks), 1);
                    for t = 1:length(Tasks)
                        if t == k %The main task
                            R(t) = obj.alpha * R_b + (1 - obj.alpha) * (sum(R_p) / pop_size);
                        else % The auxiliary task
                            index = find(r1_task == t);
                            if isempty(index)
                                R(t) = 0;
                            else
                                [~, minid] = min(fit_new);
                                R(t) = obj.alpha * (r1_task(minid) == t) * R_b + (1 - obj.alpha) * (sum(R_p(index)) / length(index));
                            end
                        end
                    end

                    % update rmp
                    for t = 1:length(Tasks)
                        if t == k
                            continue;
                        end
                        if R(t) >= R(k)
                            rmp(k, t) = min(rmp(k, t) + delta_rmp, 1);
                            rmp(k, k) = max(rmp(k, k) - delta_rmp, 0);
                        else
                            rmp(k, t) = max(rmp(k, t) - delta_rmp, 0);
                            rmp(k, k) = min(rmp(k, k) + delta_rmp, 1);
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