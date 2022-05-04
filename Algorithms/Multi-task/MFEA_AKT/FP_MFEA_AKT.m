classdef FP_MFEA_AKT < Algorithm
    % <Multi> <Constrained>

    % MFEA-AKT with Feasibility Priority for Constrained MTOPs

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        rmp = 0.3
        ginterval = 20;
        mu = 2;
        mum = 5;
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'rmp: Random Mating Probability', num2str(obj.rmp), ...
                        'ginterval', num2str(obj.ginterval), ...
                        'mu: index of Simulated Binary Crossover', num2str(obj.mu), ...
                        'mum: index of polynomial mutation', num2str(obj.mum)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.rmp = str2double(parameter_cell{count}); count = count + 1;
            obj.ginterval = str2double(parameter_cell{count}); count = count + 1;
            obj.mu = str2double(parameter_cell{count}); count = count + 1;
            obj.mum = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            sub_pop = run_parameter_list(1);
            sub_eva = run_parameter_list(2);
            pop_size = sub_pop * length(Tasks);
            eva_num = sub_eva * length(Tasks);
            tic

            % initialize
            [population, fnceval_calls, bestobj, bestCV, data.bestX] = initializeMF_FP(IndividualAKT, pop_size, Tasks, max(Tasks.dims));
            data.convergence(:, 1) = bestobj;
            data.convergence_cv(:, 1) = bestCV;

            % initialize akt
            cfb_record = [];
            for i = 1:pop_size
                population(i).isTran = 0;
                population(i).cx_factor = randi(6);
                population(i).parNum = 0;
            end

            generation = 1;
            while fnceval_calls < eva_num
                generation = generation + 1;

                % generation
                [offspring, calls] = OperatorMFEA_AKT.generate(1, population, Tasks, obj.rmp, obj.mu, obj.mum);
                fnceval_calls = fnceval_calls + calls;

                % calculate best cx_factor
                imp_num = zeros(1, 6);
                for i = 1:length(offspring)
                    if offspring(i).parNum ~= 0
                        cfc = offspring(i).factorial_costs(offspring(i).skill_factor) + offspring(i).constraint_violation(offspring(i).skill_factor);
                        pfc = population(offspring(i).parNum).factorial_costs(population(offspring(i).parNum).skill_factor) + population(offspring(i).parNum).constraint_violation(population(offspring(i).parNum).skill_factor);
                        if (pfc - cfc) / pfc > imp_num(offspring(i).cx_factor)
                            imp_num(offspring(i).cx_factor) = (pfc - cfc) / pfc;
                        end
                    end
                end
                % ginterval
                prcfb_count = zeros(1, 6);
                if any(imp_num)
                    [max_num, max_idx] = max(imp_num);
                else % have not better cx_factor
                    if generation <= obj.ginterval + 1 % former generation
                        prcfb_count(cfb_record(2:generation - 1)) = prcfb_count(cfb_record(2:generation - 1)) + 1;
                    else
                        prcfb_count(cfb_record(generation - obj.ginterval:generation - 1)) = prcfb_count(cfb_record(generation - obj.ginterval:generation - 1)) + 1;
                    end
                    [max_num, max_idx] = max(prcfb_count);
                end
                cfb_record(generation) = max_idx;
                % adaptive cx_factor
                for i = 1:length(offspring)
                    if offspring(i).parNum ~= 0
                        cfc = offspring(i).factorial_costs(offspring(i).skill_factor) + offspring(i).constraint_violation(offspring(i).skill_factor);
                        pfc = population(offspring(i).parNum).factorial_costs(population(offspring(i).parNum).skill_factor) + population(offspring(i).parNum).constraint_violation(population(offspring(i).parNum).skill_factor);
                        if (pfc - cfc) / pfc < 0
                            offspring(i).cx_factor = max_idx;
                        end
                    else
                        p = [max_idx, randi(6)];
                        offspring(i).cx_factor = p(randi(2));
                    end
                end

                % selection
                [population, bestobj, bestCV, data.bestX] = selectMF_FP(population, offspring, Tasks, pop_size, bestobj, bestCV, data.bestX);
                data.convergence(:, generation) = bestobj;
                data.convergence_cv(:, generation) = bestCV;
            end
            data.convergence(data.convergence_cv > 0) = NaN;
            data.bestX = uni2real(data.bestX, Tasks);
            data.clock_time = toc;
        end
    end
end