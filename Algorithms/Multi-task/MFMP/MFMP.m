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
        c = 0.3;
        p = 0.1;
        H = 100;
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'theta', num2str(obj.theta), ...
                        'c', num2str(obj.c), ...
                        'p: 100p% top as pbest', num2str(obj.p), ...
                        'H: success memory size', num2str(obj.H)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.theta = str2double(parameter_cell{count}); count = count + 1;
            obj.c = str2double(parameter_cell{count}); count = count + 1;
            obj.p = str2double(parameter_cell{count}); count = count + 1;
            obj.H = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            sub_pop = run_parameter_list(1);
            sub_eva = run_parameter_list(2);
            pop_size = sub_pop * length(Tasks);
            eva_num = sub_eva * length(Tasks);
            tic

            SR(:, 1) = ones(length(Tasks), 1);
            rmp(:, 1) = 0.5 * ones(length(Tasks), 1);
            H_idx = ones(length(Tasks), 1);
            for t = 1:length(Tasks)
                MF{t} = 0.5 .* ones(1, obj.H);
                MCR{t} = 0.5 * ones(1, obj.H);
                arc{t} = IndividualJADE.empty();
            end

            % initialize
            [population, fnceval_calls, bestobj, data.bestX] = initializeMT(IndividualJADE, sub_pop, Tasks, max([Tasks.dims]) * ones(1, length(Tasks)));
            data.convergence(:, 1) = bestobj;

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
                    [offspring, calls, flag] = OperatorMFMP.generate(1, Tasks(t), population{t}, union, population{c_idx}, c_union, rmp(t, generation - 1), obj.p);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    replace = [population{t}.factorial_costs] > [offspring.factorial_costs];

                    % update archive
                    arc{t} = [arc{t}, population{t}(replace)];
                    if length(arc{t}) > length(population{t})
                        rnd = randperm(length(arc{t}));
                        arc{t} = arc{t}(rnd(1:length(population{t})));
                    end

                    % calculate SF SCR
                    SF = [population{t}(replace).F];
                    SCR = [population{t}(replace).CR];
                    dif = abs([population{t}(replace).factorial_costs] - [offspring(replace).factorial_costs]);
                    dif = dif ./ sum(dif);

                    % update MF MCR
                    if ~isempty(SF)
                        MF{t}(H_idx(t)) = (dif * (SF'.^2)) / (dif * SF');
                        MCR{t}(H_idx(t)) = (dif * (SCR'.^2)) / (dif * SCR');
                    else
                        MF{t}(H_idx(t)) = MF{t}(mod(H_idx(t) + obj.H - 2, obj.H) + 1);
                        MCR{t}(H_idx(t)) = MCR{t}(mod(H_idx(t) + obj.H - 2, obj.H) + 1);
                    end
                    H_idx(t) = mod(H_idx(t), obj.H) + 1;

                    % update rmp
                    SR(t, generation) = sum(~replace) / length(population{t});
                    if SR(t, generation) >= obj.theta
                        rmp(t, generation) = rmp(t, generation - 1);
                    else
                        if sum(flag) == 0
                            rmp(t, generation) = min(rmp(t, generation - 1) + obj.c * (1 - SR(t, generation)), 1);
                        else
                            temp = (sum(~replace & flag) / sum(flag));
                            if temp > SR(t, generation)
                                rmp(t, generation) = min(rmp(t, generation - 1) + obj.c * temp, 1);
                            else
                                rmp(t, generation) = max(rmp(t, generation - 1) - obj.c * (1 - temp), 0);
                            end
                        end
                    end

                    population{t}(replace) = offspring(replace);
                    [bestobj_now, idx] = min([population{t}.factorial_costs]);
                    if bestobj_now < bestobj(t)
                        bestobj(t) = bestobj_now;
                        data.bestX{t} = population{t}(idx).rnvec;
                    end
                    data.convergence(t, generation) = bestobj(t);
                end
            end
            data.bestX = uni2real(data.bestX, Tasks);
            data.clock_time = toc;
        end
    end
end
