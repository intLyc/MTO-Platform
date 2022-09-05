classdef CAL_SHADE < Algorithm
    % <Single> <Constrained>

    %------------------------------- Reference --------------------------------
    % @InProceedings{Zamuda2017CAL-SHADE,
    %   title     = {Adaptive Constraint Handling and Success History Differential Evolution for Cec 2017 Constrained Real-Parameter Optimization},
    %   author    = {Zamuda, Aleš},
    %   booktitle = {2017 IEEE Congress on Evolutionary Computation (CEC)},
    %   year      = {2017},
    %   pages     = {2443-2450},
    %   doi       = {10.1109/CEC.2017.7969601},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        p = 0.2
        H = 10
        arc_rate = 1
        ep_top = 0.2
        ep_tc = 0.8
        ep_cp = 5
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'p: 100p% top as pbest', num2str(obj.p), ...
                        'H: success memory size', num2str(obj.H), ...
                        'arc_rate: arcive size rate', num2str(obj.arc_rate), ...
                        'ep_top', num2str(obj.ep_top), ...
                        'ep_tc', num2str(obj.ep_tc), ...
                        'ep_cp', num2str(obj.ep_cp)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.p = str2double(Parameter{i}); i = i + 1;
            obj.H = str2double(Parameter{i}); i = i + 1;
            obj.arc_rate = str2double(Parameter{i}); i = i + 1;
            obj.ep_top = str2double(Parameter{i}); i = i + 1;
            obj.ep_tc = str2double(Parameter{i}); i = i + 1;
            obj.ep_cp = str2double(Parameter{i}); i = i + 1;
        end

        function data = run(obj, Tasks, RunPara)
            sub_pop = RunPara(1); sub_eva = RunPara(2);
            convergeObj = {}; convergeCV = {}; eva_gen = {}; bestDec = {};

            for sub_task = 1:length(Tasks)
                Task = Tasks(sub_task);

                % initialize
                pop_init = sub_pop;
                pop_min = 4;
                [population, fnceval_calls, bestDec_temp, bestObj, bestCV] = initialize(IndividualSHADE_CAL, pop_init, Task, Task.Dim);
                convergeObj_temp(1) = bestObj;
                convergeCV_temp(1) = bestCV;
                eva_gen_temp(1) = fnceval_calls;

                % initialize Parameter
                n = ceil(obj.ep_top * length(population));
                cv_temp = [population.CV];
                [~, idx] = sort(cv_temp);
                ep0 = cv_temp(idx(n));
                H_idx = 1;
                MF = 0.5 .* ones(obj.H, 1);
                MCR = 0.5 .* ones(obj.H, 1);
                arc = IndividualSHADE_CAL.empty();

                generation = 1;
                while fnceval_calls < sub_eva
                    generation = generation + 1;

                    % Linear Population Size Reduction
                    pop_size = round((pop_min - pop_init) ./ sub_eva .* fnceval_calls + pop_init);

                    % calculate individual F and CR
                    for i = 1:length(population)
                        idx = randi(obj.H);
                        uF = MF(idx);
                        population(i).F = uF + 0.1 * tan(pi * (rand - 0.5));
                        while (population(i).F <= 0)
                            population(i).F = uF + 0.1 * tan(pi * (rand - 0.5));
                        end
                        population(i).F(population(i).F > 1) = 1;

                        uCR = MCR(idx);
                        population(i).CR = normrnd(uCR, 0.1);
                        population(i).CR(population(i).CR > 1) = 1;
                        population(i).CR(population(i).CR < 0) = 0;
                    end

                    % calculate epsilon
                    if fnceval_calls < obj.ep_tc * sub_eva
                        Ep = ep0 * ((1 - fnceval_calls / (obj.ep_tc * sub_eva))^obj.ep_cp);
                    else
                        Ep = 0;
                    end

                    % generation
                    union = [population, arc];
                    [offspring, calls] = OperatorSHADE_CAL.generate(Task, population, union, obj.p, Ep);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    replace_cv = [population.CV] > [offspring.CV] & [population.CV] > Ep & [offspring.CV] > Ep;
                    equal_cv = [population.CV] <= Ep & [offspring.CV] <= Ep;
                    replace_obj = [population.Obj] > [offspring.Obj];
                    replace = (equal_cv & replace_obj) | replace_cv;

                    % calculate SF SCR
                    SF = [population(replace).F];
                    SCR = [population(replace).CR];
                    dif = 1e30 * abs([population(replace).CV] - [offspring(replace).CV]) + ...
                        abs([population(replace).Obj] - [offspring(replace).Obj]);
                    dif = dif ./ sum(dif);

                    % update MF MCR
                    if ~isempty(SF)
                        MF(H_idx) = sum(dif .* (SF.^2)) / sum(dif .* SF);
                        MCR(H_idx) = sum(dif .* SCR);
                    else
                        MF(H_idx) = MF(mod(H_idx + obj.H - 2, obj.H) + 1);
                        MCR(H_idx) = MCR(mod(H_idx + obj.H - 2, obj.H) + 1);
                    end
                    H_idx = mod(H_idx, obj.H) + 1;

                    % update archive
                    arc = [arc, population(replace)];
                    if length(arc) > round(pop_size * obj.arc_rate)
                        arc = arc(randperm(length(arc), round(pop_size * obj.arc_rate)));
                    end

                    population(replace) = offspring(replace);

                    % Linear Population Size Reduction
                    obj_list = [population.Obj];
                    cv_list = [population.CV];
                    cv_list(cv_list < Ep) = 0;
                    [~, rank] = sortrows([cv_list', obj_list'], [1, 2]);
                    population = population(rank(1:pop_size));

                    [bestObj_now, bestCV_now, best_idx] = min_FP([offspring.Obj], [offspring.CV]);
                    if bestCV_now < bestCV || (bestCV_now == bestCV && bestObj_now < bestObj)
                        bestObj = bestObj_now;
                        bestCV = bestCV_now;
                        bestDec_temp = offspring(best_idx).Dec;
                    end
                    convergeObj_temp(generation) = bestObj;
                    convergeCV_temp(generation) = bestCV;
                    eva_gen_temp(generation) = fnceval_calls;
                end
                convergeObj{sub_task} = convergeObj_temp;
                convergeCV{sub_task} = convergeCV_temp;
                eva_gen{sub_task} = eva_gen_temp;
                bestDec{sub_task} = bestDec_temp;
            end
            data.convergeObj = gen2eva(cell2matrix(convergeObj), cell2matrix(eva_gen));
            data.convergeCV = gen2eva(cell2matrix(convergeCV), cell2matrix(eva_gen));
            data.bestDec = uni2real(bestDec, Tasks);
        end
    end
end
