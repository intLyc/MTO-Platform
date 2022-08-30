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
        function parameter = getParameter(obj)
            parameter = {'p: 100p% top as pbest', num2str(obj.p), ...
                        'H: success memory size', num2str(obj.H)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.p = str2double(parameter_cell{count}); count = count + 1;
            obj.H = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            sub_pop = run_parameter_list(1);
            sub_eva = run_parameter_list(2);

            convergence = [];
            eva_gen = [];
            bestX = {};
            for sub_task = 1:length(Tasks)
                Task = Tasks(sub_task);

                % initialize
                pop_init = sub_pop;
                pop_min = 4;
                [population, fnceval_calls, bestobj, bestX_temp] = initialize(IndividualLSHADE, pop_init, Task, Task.dims);
                converge_temp(1) = bestobj;
                eva_gen_temp(1) = fnceval_calls;

                % initialize parameter
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
                    replace = [population.factorial_costs] > [offspring.factorial_costs];

                    % calculate SF SCR
                    SF = [population(replace).F];
                    SCR = [population(replace).CR];
                    dif = abs([population(replace).factorial_costs] - [offspring(replace).factorial_costs]);
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
                        [~, rank] = sort([population.factorial_costs]);
                        population = population(rank(1:pop_size));
                    end

                    [bestobj_now, idx] = min([population.factorial_costs]);
                    if bestobj_now < bestobj
                        bestobj = bestobj_now;
                        bestX_temp = population(idx).rnvec;
                    end
                    converge_temp(generation) = bestobj;
                    eva_gen_temp(generation) = fnceval_calls;
                end
                convergence(sub_task, :) = converge_temp;
                eva_gen(sub_task, :) = eva_gen_temp;
                bestX{sub_task} = bestX_temp;
            end
            data.convergence = gen2eva(convergence, eva_gen);
            data.bestX = uni2real(bestX, Tasks);
        end
    end
end
