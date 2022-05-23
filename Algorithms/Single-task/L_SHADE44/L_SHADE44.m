classdef L_SHADE44 < Algorithm
    % <Single> <Constrained>

    %------------------------------- Reference --------------------------------
    % @InProceedings{Polakova2017L-SHADE44,
    %   title     = {L-SHADE with competing strategies applied to constrained optimization},
    %   author    = {Poláková, Radka},
    %   booktitle = {2017 IEEE Congress on Evolutionary Computation (CEC)},
    %   year      = {2017},
    %   pages     = {1683-1689},
    %   doi       = {10.1109/CEC.2017.7969504},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        p = 0.11;
        H = 6;
        arc_rate = 2.6
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'p: 100p% top as pbest', num2str(obj.p), ...
                        'H: success memory size', num2str(obj.H), ...
                        'arc_rate: arcive size rate', num2str(obj.arc_rate)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.p = str2double(parameter_cell{count}); count = count + 1;
            obj.H = str2double(parameter_cell{count}); count = count + 1;
            obj.arc_rate = str2double(parameter_cell{count}); count = count + 1;
        end

        function [res, p_min] = roulete(obj, cutpoints)
            % returns an integer from [1, length(cutpoints)] with probability proportional
            % to cutpoints(i)/ summa cutpoints
            st_num = length(cutpoints);
            ss = sum(cutpoints);
            p_min = min(cutpoints) / ss;
            cp(1) = cutpoints(1);
            for i = 2:st_num
                cp(i) = cp(i - 1) + cutpoints(i);
            end
            cp = cp / ss;
            res = 1 + fix(sum(cp < rand(1)));
        end

        function data = run(obj, Tasks, run_parameter_list)
            sub_pop = run_parameter_list(1);
            sub_eva = run_parameter_list(2);

            convergence = [];
            convergence_cv = [];
            eva_gen = [];
            bestX = {};

            for sub_task = 1:length(Tasks)
                Task = Tasks(sub_task);

                % initialize
                % pop_init = Task.dims * 18;
                pop_init = sub_pop;
                pop_min = 4;
                [population, fnceval_calls] = initialize(IndividualSHADE44, pop_init, Task, Task.dims);
                [bestobj, bestCV, best_idx] = min_FP([population.factorial_costs], [population.constraint_violation]);
                bestX_temp = population(best_idx).rnvec;
                converge_temp(1) = bestobj;
                converge_cv_temp(1) = bestCV;
                eva_gen_temp(1) = fnceval_calls;

                % initialize parameter
                st_num = 4;
                n0 = 2;
                delta = 1 / (5 * st_num);
                ni = zeros(1, st_num) + n0;

                is_used = zeros(1, st_num);
                for k = 1:st_num
                    H_idx{k} = 1;
                    MF{k} = 0.5 .* ones(obj.H, 1);
                    MCR{k} = 0.5 .* ones(obj.H, 1);
                end
                arc = IndividualSHADE44.empty();

                generation = 1;
                while fnceval_calls < sub_eva
                    generation = generation + 1;

                    % Linear Population Size Reduction
                    pop_size = round((pop_min - pop_init) ./ sub_eva .* fnceval_calls + pop_init);

                    % calculate individual F and CR
                    for i = 1:length(population)
                        [st, pmin] = obj.roulete(ni);
                        if pmin < delta
                            ni = zeros(1, st_num) + n0;
                        end
                        idx = randi(obj.H);
                        uF = MF{st}(idx);
                        population(i).st = st;
                        population(i).F = uF + 0.1 * tan(pi * (rand - 0.5));
                        while (population(i).F <= 0)
                            population(i).F = uF + 0.1 * tan(pi * (rand - 0.5));
                        end
                        uCR = MCR{st}(idx);
                        population(i).F(population(i).F > 1) = 1;
                        population(i).CR = normrnd(uCR, 0.1);
                        population(i).CR(population(i).CR > 1) = 1;
                        population(i).CR(population(i).CR < 0) = 0;
                    end

                    % generation
                    union = [population, arc];
                    [offspring, calls] = OperatorSHADE44.generate(1, Task, population, union, obj.p);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    replace_cv = [population.constraint_violation] > [offspring.constraint_violation];
                    equal_cv = [population.constraint_violation] <= 0 & [offspring.constraint_violation] <= 0;
                    replace_obj = [population.factorial_costs] > [offspring.factorial_costs];
                    replace = (equal_cv & replace_obj) | replace_cv;

                    % calculate SF SCR
                    is_used = hist([population(replace).st], 1:st_num);
                    ni = ni + is_used;
                    for k = 1:st_num
                        k_idx = [population.st] == k;
                        SF = [population(replace & k_idx).F];
                        SCR = [population(replace & k_idx).CR];
                        dif = abs([population(replace & k_idx).constraint_violation] - [offspring(replace & k_idx).constraint_violation]);
                        dif_obj = abs([population(replace & k_idx).factorial_costs] - [offspring(replace & k_idx).factorial_costs]);
                        zero_cv = [population(replace & k_idx).constraint_violation] <= 0 & ...
                            [offspring(replace & k_idx).constraint_violation] <= 0;
                        dif(zero_cv) = dif_obj(zero_cv);
                        dif = dif ./ sum(dif);
                        % update MF MCR
                        if ~isempty(SF)
                            MF{k}(H_idx{k}) = sum(dif .* (SF.^2)) / sum(dif .* SF);
                            MCR{k}(H_idx{k}) = sum(dif .* SCR);
                        else
                            MF{k}(H_idx{k}) = MF{k}(mod(H_idx{k} + obj.H - 2, obj.H) + 1);
                            MCR{k}(H_idx{k}) = MCR{k}(mod(H_idx{k} + obj.H - 2, obj.H) + 1);
                        end
                        H_idx{k} = mod(H_idx{k}, obj.H) + 1;
                    end

                    % update archive
                    arc = [arc, population(replace)];
                    if length(arc) > round(pop_size * obj.arc_rate)
                        arc = arc(randperm(length(arc), round(pop_size * obj.arc_rate)));
                    end

                    population(replace) = offspring(replace);

                    % Linear Population Size Reduction
                    [~, rank] = sortrows([[population.factorial_costs]', [population.constraint_violation]'], [1, 2]);
                    population = population(rank(1:pop_size));

                    [bestobj_now, bestCV_now, best_idx] = min_FP([population.factorial_costs], [population.constraint_violation]);
                    if bestCV_now <= bestCV && bestobj_now <= bestobj
                        bestobj = bestobj_now;
                        bestCV = bestCV_now;
                        bestX_temp = population(best_idx).rnvec;
                    end
                    converge_temp(generation) = bestobj;
                    converge_cv_temp(generation) = bestCV;
                    eva_gen_temp(generation) = fnceval_calls;
                end
                convergence = [convergence; converge_temp];
                convergence_cv = [convergence_cv; converge_cv_temp];
                eva_gen = [eva_gen; eva_gen_temp];
                bestX = [bestX, bestX_temp];
            end
            data.convergence = gen2eva(convergence, eva_gen);
            data.convergence_cv = gen2eva(convergence_cv, eva_gen);
            data.bestX = uni2real(bestX, Tasks);
        end
    end
end
