classdef SHADE < Algorithm
    % <Single> <None>

    %------------------------------- Reference --------------------------------
    % @InProceedings{Tanabe2013SHADE,
    %   author     = {Tanabe, Ryoji and Fukunaga, Alex},
    %   booktitle  = {2013 IEEE Congress on Evolutionary Computation},
    %   title      = {Success-history based Parameter adaptation for Differential Evolution},
    %   year       = {2013},
    %   pages      = {71-78},
    %   doi        = {10.1109/CEC.2013.6557555},
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
            convergeObj = {}; bestDec = {};

            for sub_task = 1:length(Tasks)
                Task = Tasks(sub_task);

                % initialize
                [population, fnceval_calls, bestDec_temp, bestObj] = initialize(IndividualSHADE, sub_pop, Task, Task.Dim);
                convergeObj_temp(1) = bestObj;

                % initialize Parameter
                H_idx = 1;
                MF = 0.5 .* ones(obj.H, 1);
                MCR = 0.5 .* ones(obj.H, 1);
                arc = IndividualSHADE.empty();

                generation = 1;
                while fnceval_calls < sub_eva
                    generation = generation + 1;

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
                    [offspring, calls] = OperatorSHADE.generate(Task, population, union, obj.p);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    replace = [population.Obj] > [offspring.Obj];

                    % update archive
                    arc = [arc, population(replace)];
                    if length(arc) > length(population)
                        rnd = randperm(length(arc));
                        arc = arc(rnd(1:length(population)));
                    end

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

                    population(replace) = offspring(replace);
                    [bestObj_now, idx] = min([population.Obj]);
                    if bestObj_now < bestObj
                        bestObj = bestObj_now;
                        bestDec_temp = population(idx).Dec;
                    end
                    convergeObj_temp(generation) = bestObj;
                end
                convergeObj{sub_task} = convergeObj_temp;
                bestDec{sub_task} = bestDec_temp;
            end
            data.convergeObj = gen2eva(cell2matrix(convergeObj));
            data.bestDec = uni2real(bestDec, Tasks);
        end
    end
end
