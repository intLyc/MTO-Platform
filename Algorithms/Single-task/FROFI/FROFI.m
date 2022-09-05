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
        function data = run(obj, Tasks, RunPara)
            sub_pop = RunPara(1); sub_eva = RunPara(2);
            convergeObj = {}; convergeCV = {}; bestDec = {};

            F_pool = [0.6, 0.8, 1.0];
            CR_pool = [0.1, 0.2, 1.0];

            for sub_task = 1:length(Tasks)
                Task = Tasks(sub_task);

                % initialize
                [population, fnceval_calls, bestDec_temp, bestObj, bestCV] = initialize(Individual, sub_pop, Task, Task.Dim);
                convergeObj_temp(1) = bestObj;
                convergeCV_temp(1) = bestCV;

                generation = 1;
                while fnceval_calls < sub_eva
                    generation = generation + 1;

                    % generation
                    [offspring, calls] = OperatorFROFI.generate(population, Task, F_pool, CR_pool);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    archive_idx = [offspring.CV] > [population.CV] & [offspring.Obj] < [population.Obj];
                    archive = offspring(archive_idx);

                    replace_cv = [population.CV] > [offspring.CV];
                    equal_cv = [population.CV] == [offspring.CV];
                    replace_obj = [population.Obj] > [offspring.Obj];
                    replace = (equal_cv & replace_obj) | replace_cv;
                    population(replace) = offspring(replace);

                    % replace operator
                    N = round(max(5, length(population) / 2)); % the maximum number of vectors to be replaced
                    Nf = round(length(population) / N); % the number of parts to be divided
                    [~, rank] = sort(- [population.Obj]);
                    population = population(rank);
                    for i = 1:floor(length(population) / Nf)
                        len = length(archive);
                        if len == 0
                            break;
                        end
                        current = (i - 1) * Nf + 1:i * Nf;
                        [~, worst] = max([population(current).CV]);
                        [~, best] = min([archive.CV]);

                        if archive(best).Obj < population(current(worst)).Obj
                            population(current(worst)) = archive(best);
                            archive(best) = [];
                        end
                    end

                    % mutate operator
                    if min([population.CV]) > 0
                        [~, worst] = max([population.CV]);

                        temp = population(randi(end));
                        k = randi(length(temp.Dec));
                        temp.Dec(k) = rand();

                        [temp, calls] = evaluate(temp, Task, 1);
                        fnceval_calls = fnceval_calls + calls;

                        if population(worst).Obj > temp.Obj
                            population(worst) = temp;
                        end
                    end

                    % update best
                    [bestObj_now, bestCV_now, best_idx] = min_FP([offspring.Obj], [offspring.CV]);
                    if bestCV_now < bestCV || (bestCV_now == bestCV && bestObj_now < bestObj)
                        bestObj = bestObj_now;
                        bestCV = bestCV_now;
                        bestDec_temp = offspring(best_idx).Dec;
                    end
                    convergeObj_temp(generation) = bestObj;
                    convergeCV_temp(generation) = bestCV;
                end
                convergeObj{sub_task} = convergeObj_temp;
                convergeCV{sub_task} = convergeCV_temp;
                bestDec{sub_task} = bestDec_temp;
            end
            data.convergeObj = gen2eva(cell2matrix(convergeObj));
            data.convergeCV = gen2eva(cell2matrix(convergeCV));
            data.bestDec = uni2real(bestDec, Tasks);
        end
    end
end
