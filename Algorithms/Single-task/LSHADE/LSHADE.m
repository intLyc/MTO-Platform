classdef LSHADE < Algorithm
    % <Single> <None>

    %------------------------------- Reference --------------------------------
    % @InProceedings{Tanabe2014LSHADE,
    %   title     = {Improving the Search Performance of Shade Using Linear Population Size Reduction},
    %   author    = {Tanabe, Ryoji and Fukunaga, Alex S.},
    %   booktitle = {2014 IEEE Congress on Evolutionary Computation (CEC)},
    %   year      = {2014},
    %   pages     = {1658-1665},
    %   doi       = {10.1109/CEC.2014.6900380},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        p = 0.1;
        H = 100;
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'p: 100p% top as pbest', num2str(obj.p), ...
                        'H: success memory size', num2str(obj.H)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.p = str2double(Parameter{i}); i = i + 1;
            obj.H = str2double(Parameter{i}); i = i + 1;
        end

        function data = run(obj, Tasks, RunPara)
            sub_pop = RunPara(1); sub_eva = RunPara(2);
            convergeObj = {}; eva_gen = {}; bestDec = {};

            for sub_task = 1:length(Tasks)
                Task = Tasks(sub_task);

                % initialize
                pop_init = sub_pop;
                pop_min = 4;
                [population, fnceval_calls, bestDec_temp, bestObj] = initialize(IndividualLSHADE, pop_init, Task, Task.Dim);
                convergeObj_temp(1) = bestObj;
                eva_gen_temp(1) = fnceval_calls;

                % initialize Parameter
                H_idx = 1;
                MF = 0.5 .* ones(obj.H, 1);
                MCR = 0.5 .* ones(obj.H, 1);
                arc = IndividualLSHADE.empty();

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

                    % generation
                    union = [population, arc];
                    [offspring, calls] = OperatorLSHADE.generate(Task, population, union, obj.p);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    replace = [population.Obj] > [offspring.Obj];

                    % calculate SF SCR
                    SF = [population(replace).F];
                    SCR = [population(replace).CR];
                    dif = abs([population(replace).Obj] - [offspring(replace).Obj]);
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
                    if length(arc) > pop_size
                        arc = arc(randperm(length(arc), pop_size));
                    end

                    population(replace) = offspring(replace);

                    % Linear Population Size Reduction
                    if pop_size < length(population)
                        [~, rank] = sort([population.Obj]);
                        population = population(rank(1:pop_size));
                    end

                    [bestObj_now, idx] = min([population.Obj]);
                    if bestObj_now < bestObj
                        bestObj = bestObj_now;
                        bestDec_temp = population(idx).Dec;
                    end
                    convergeObj_temp(generation) = bestObj;
                    eva_gen_temp(generation) = fnceval_calls;
                end
                convergeObj{sub_task} = convergeObj_temp;
                eva_gen{sub_task} = eva_gen_temp;
                bestDec{sub_task} = bestDec_temp;
            end
            data.convergeObj = gen2eva(cell2matrix(convergeObj), cell2matrix(eva_gen));
            data.bestDec = uni2real(bestDec, Tasks);
        end
    end
end
