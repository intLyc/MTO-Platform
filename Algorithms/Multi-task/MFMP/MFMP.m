classdef MFMP < Algorithm
    % <Multi> <None>

    %------------------------------- Reference --------------------------------
    % @Article{Li2020MFMP,
    %   title      = {Multifactorial Optimization Via Explicit Multipopulation Evolutionary Framework},
    %   author     = {Genghui Li and Qiuzhen Lin and Weifeng Gao},
    %   journal    = {Information Sciences},
    %   year       = {2020},
    %   issn       = {0020-0255},
    %   pages      = {1555-1570},
    %   volume     = {512},
    %   doi        = {https://doi.org/10.1016/j.ins.2019.10.066},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        theta = 0.2
        c = 0.3
        alpha = 0.25
        p = 0.1
        H = 100
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'theta', num2str(obj.theta), ...
                        'c', num2str(obj.c), ...
                        'alpha', num2str(obj.alpha), ...
                        'p: 100p% top as pbest', num2str(obj.p), ...
                        'H: success memory size', num2str(obj.H)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.theta = str2double(Parameter{i}); i = i + 1;
            obj.c = str2double(Parameter{i}); i = i + 1;
            obj.alpha = str2double(Parameter{i}); i = i + 1;
            obj.p = str2double(Parameter{i}); i = i + 1;
            obj.H = str2double(Parameter{i}); i = i + 1;
        end

        function data = run(obj, Tasks, RunPara)
            sub_pop = RunPara(1); sub_eva = RunPara(2);
            eva_num = sub_eva * length(Tasks);

            SR(:, 1) = ones(length(Tasks), 1);
            rmp(:, 1) = 0.5 * ones(length(Tasks), 1);
            H_idx = ones(length(Tasks), 1);
            for t = 1:length(Tasks)
                MF{t} = 0.5 .* ones(1, obj.H);
                MCR{t} = 0.5 * ones(1, obj.H);
                arc{t} = IndividualMFMP.empty();
            end
            reduce_flag = false;

            % initialize
            [population, fnceval_calls, bestDec, bestObj] = initializeMT(IndividualMFMP, sub_pop, Tasks, max([Tasks.Dim]) * ones(1, length(Tasks)));
            convergeObj(:, 1) = bestObj;

            generation = 1;
            while fnceval_calls < eva_num
                generation = generation + 1;

                for t = 1:length(Tasks)
                    union = [population{t}, arc{t}];

                    %randomly choose an task to communicate
                    task_idx = 1:length(Tasks);
                    task_idx(t) = [];
                    c_idx = task_idx(randi(length(task_idx)));
                    c_union = [population{c_idx}, arc{c_idx}];

                    % calculate individual F and CR
                    for i = 1:length(population{t})
                        idx = randi(obj.H);
                        uF = MF{t}(idx);
                        population{t}(i).F = uF + 0.1 * tan(pi * (rand - 0.5));
                        while (population{t}(i).F <= 0)
                            population{t}(i).F = uF + 0.1 * tan(pi * (rand - 0.5));
                        end
                        population{t}(i).F(population{t}(i).F > 1) = 1;

                        uCR = MCR{t}(idx);
                        population{t}(i).CR = normrnd(uCR, 0.1);
                        population{t}(i).CR(population{t}(i).CR > 1) = 1;
                        population{t}(i).CR(population{t}(i).CR < 0) = 0;
                    end

                    % generation
                    [offspring, calls, flag] = OperatorMFMP.generate(Tasks(t), population{t}, union, population{c_idx}, c_union, rmp(t, generation - 1), obj.p);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    replace = [population{t}.Obj] > [offspring.Obj];

                    % update archive
                    arc{t} = [arc{t}, population{t}(replace)];
                    if length(arc{t}) > sub_pop
                        arc{t} = arc{t}(randperm(length(arc{t}), sub_pop));
                    end

                    % calculate SF SCR
                    SF = [population{t}(replace).F];
                    SCR = [population{t}(replace).CR];
                    dif = abs([population{t}(replace).Obj] - [offspring(replace).Obj]);
                    dif = dif ./ sum(dif);

                    % update MF MCR
                    if ~isempty(SF)
                        MF{t}(H_idx(t)) = sum(dif .* (SF.^2)) / sum(dif .* SF);
                        MCR{t}(H_idx(t)) = sum(dif .* SCR);
                    else
                        MF{t}(H_idx(t)) = MF{t}(mod(H_idx(t) + obj.H - 2, obj.H) + 1);
                        MCR{t}(H_idx(t)) = MCR{t}(mod(H_idx(t) + obj.H - 2, obj.H) + 1);
                    end
                    H_idx(t) = mod(H_idx(t), obj.H) + 1;

                    % update rmp
                    SR(t, generation) = sum(replace) / length(population{t});
                    if SR(t, generation) >= obj.theta
                        rmp(t, generation) = rmp(t, generation - 1);
                    else
                        if sum(flag) == 0
                            rmp(t, generation) = min(rmp(t, generation - 1) + obj.c * (1 - SR(t, generation)), 1);
                        else
                            temp = (sum(replace & flag) / sum(flag));
                            if temp > SR(t, generation)
                                rmp(t, generation) = min(rmp(t, generation - 1) + obj.c * temp, 1);
                            else
                                rmp(t, generation) = max(rmp(t, generation - 1) - obj.c * (1 - temp), 0);
                            end
                        end
                    end

                    population{t}(replace) = offspring(replace);
                    [bestObj_now, idx] = min([population{t}.Obj]);
                    if bestObj_now < bestObj(t)
                        bestObj(t) = bestObj_now;
                        bestDec{t} = population{t}(idx).Dec;
                    end
                    convergeObj(t, generation) = bestObj(t);
                end

                % population reduction
                if ~reduce_flag && fnceval_calls >= eva_num * obj.alpha
                    pop_size = round(sub_pop / 2);
                    for t = 1:length(Tasks)
                        [~, rank] = sort([population{t}.Obj]);

                        % save to archive
                        arc{t} = [arc{t}, population{t}(rank(pop_size + 1:end))];
                        if length(arc{t}) > sub_pop
                            arc{t} = arc{t}(randperm(length(arc{t}), sub_pop));
                        end
                        % reduce
                        population{t} = population{t}(rank(1:pop_size));
                    end
                    reduce_flag = true;
                end
            end
            data.convergeObj = gen2eva(convergeObj);
            data.bestDec = uni2real(bestDec, Tasks);
        end
    end
end
