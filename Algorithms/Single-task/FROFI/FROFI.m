classdef FROFI < Algorithm
    % <Single> <Constrained>

    %------------------------------- Reference --------------------------------
    % @Article{Wang2016FROFI,
    %   title    = {Incorporating Objective Function Information Into the Feasibility Rule for Constrained Evolutionary Optimization},
    %   author   = {Wang, Yong and Wang, Bing-Chuan and Li, Han-Xiong and Yen, Gary G.},
    %   journal  = {IEEE Transactions on Cybernetics},
    %   year     = {2016},
    %   number   = {12},
    %   pages    = {2938-2952},
    %   volume   = {46},
    %   doi      = {10.1109/TCYB.2015.2493239},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods
        function data = run(obj, Tasks, run_parameter_list)
            sub_pop = run_parameter_list(1);
            sub_eva = run_parameter_list(2);

            F_pool = [0.6, 0.8, 1.0];
            CR_pool = [0.1, 0.2, 1.0];

            convergence = {};
            convergence_cv = {};
            bestX = {};

            for sub_task = 1:length(Tasks)
                Task = Tasks(sub_task);

                % initialize
                [population, fnceval_calls] = initialize(Individual, sub_pop, Task, Task.dims);
                [bestobj, bestCV, best_idx] = min_FP([population.factorial_costs], [population.constraint_violation]);
                bestX_temp = population(best_idx).rnvec;
                converge_temp(1) = bestobj;
                converge_cv_temp(1) = bestCV;

                generation = 1;
                while fnceval_calls < sub_eva
                    generation = generation + 1;

                    % generation
                    [offspring, calls] = OperatorFROFI.generate(population, Task, F_pool, CR_pool);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    archive_idx = [offspring.constraint_violation] > [population.constraint_violation] & [offspring.factorial_costs] < [population.factorial_costs];
                    archive = offspring(archive_idx);

                    replace_cv = [population.constraint_violation] > [offspring.constraint_violation];
                    equal_cv = [population.constraint_violation] == [offspring.constraint_violation];
                    replace_obj = [population.factorial_costs] > [offspring.factorial_costs];
                    replace = (equal_cv & replace_obj) | replace_cv;
                    population(replace) = offspring(replace);

                    % replace operator
                    N = round(max(5, length(population) / 2)); % the maximum number of vectors to be replaced
                    Nf = round(length(population) / N); % the number of parts to be divided
                    [~, rank] = sort(- [population.factorial_costs]);
                    population = population(rank);
                    for i = 1:floor(length(population) / Nf)
                        len = length(archive);
                        if len == 0
                            break;
                        end
                        current = (i - 1) * Nf + 1:i * Nf;
                        [~, worst] = max([population(current).constraint_violation]);
                        [~, best] = min([archive.constraint_violation]);

                        if archive(best).factorial_costs < population(current(worst)).factorial_costs
                            population(current(worst)) = archive(best);
                            archive(best) = [];
                        end
                    end

                    % mutate operator
                    if min([population.constraint_violation]) > 0
                        [~, worst] = max([population.constraint_violation]);

                        temp = population(randi(end));
                        k = randi(length(temp.rnvec));
                        temp.rnvec(k) = rand();

                        [temp, calls] = evaluate(temp, Task, 1);
                        fnceval_calls = fnceval_calls + calls;

                        if population(worst).factorial_costs > temp.factorial_costs
                            population(worst) = temp;
                        end
                    end

                    % update best
                    [bestobj_now, bestCV_now, best_idx] = min_FP([offspring.factorial_costs], [offspring.constraint_violation]);
                    if bestCV_now < bestCV || (bestCV_now == bestCV && bestobj_now < bestobj)
                        bestobj = bestobj_now;
                        bestCV = bestCV_now;
                        bestX_temp = offspring(best_idx).rnvec;
                    end
                    converge_temp(generation) = bestobj;
                    converge_cv_temp(generation) = bestCV;
                end
                convergence{sub_task} = converge_temp;
                convergence_cv{sub_task} = converge_cv_temp;
                bestX{sub_task} = bestX_temp;
            end
            data.convergence = gen2eva(cell2matrix(convergence));
            data.convergence_cv = gen2eva(cell2matrix(convergence_cv));
            data.bestX = uni2real(bestX, Tasks);
        end
    end
end
