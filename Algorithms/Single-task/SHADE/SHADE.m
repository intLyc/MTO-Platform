classdef SHADE < Algorithm
    % @InProceedings{Tanabe2013SHADE,
    %   author     = {Tanabe, Ryoji and Fukunaga, Alex},
    %   booktitle  = {2013 IEEE Congress on Evolutionary Computation},
    %   title      = {Success-history based parameter adaptation for Differential Evolution},
    %   year       = {2013},
    %   pages      = {71-78},
    %   doi        = {10.1109/CEC.2013.6557555},
    % }

    properties (SetAccess = private)
        p = 0.1;
        H = 50;
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
            iter_num = run_parameter_list(2);
            eva_num = run_parameter_list(3) * length(tasks);
            tic

            data.convergence = [];
            data.bestX = {};
            for sub_task = 1:length(Tasks)
                Task = Tasks(sub_task);

                % initialize
                [population, fnceval_calls] = initialize(IndividualJADE, sub_pop, Task, 1);

                % initialize parameter
                H_idx = 1;
                MF = 0.5 .* ones(obj.H, 1);
                MCR = 0.5 .* ones(obj.H, 1);

                [bestobj, idx] = min([population.factorial_costs]);
                bestX = population(idx).rnvec;
                convergence(1) = bestobj;

                generation = 1;
                while generation < iter_num && fnceval_calls < round(eva_num / length(Tasks))
                    generation = generation + 1;

                    % calculate individual F and pCR
                    for i = 1:length(population)
                        idx = randi(obj.H);
                        uF = MF(idx);
                        population(i).F = uF + 0.1 * tan(pi * (rand - 0.5));
                        while (population(i).F <= 0)
                            population(i).F = uF + 0.1 * tan(pi * (rand - 0.5));
                        end
                        population(i).F(population(i).F > 1) = 1;

                        uCR = MCR(idx);
                        population(i).pCR = normrnd(uCR, 0.1);
                        population(i).pCR(population(i).pCR > 1) = 1;
                        population(i).pCR(population(i).pCR < 0) = 0;
                    end

                    % generation
                    [offspring, calls] = OperatorJADE.generate(1, population, Task, obj.p);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    replace = [population.factorial_costs] > [offspring.factorial_costs];

                    % calculate SF SCR
                    SF = [population(replace).F];
                    SCR = [population(replace).pCR];
                    dif = abs([population(replace).factorial_costs] - [offspring(replace).factorial_costs]);
                    dif = dif ./ sum(dif);

                    % update MF MCR
                    if ~isempty(SF)
                        MF(H_idx) = (dif * (SF'.^2)) / (dif * SF');
                        MCR(H_idx) = (dif * (SCR'.^2)) / (dif * SCR');
                    else
                        MF(H_idx) = MF(mod(H_idx + obj.H - 2, obj.H) + 1);
                        MCR(H_idx) = MCR(mod(H_idx + obj.H - 2, obj.H) + 1);
                    end
                    H_idx = mod(H_idx, obj.H) + 1;

                    population(replace) = offspring(replace);
                    [bestobj_now, idx] = min([population.factorial_costs]);
                    if bestobj_now < bestobj
                        bestobj = bestobj_now;
                        bestX = population(idx).rnvec;
                    end
                    convergence(generation) = bestobj;
                end
                data.convergence = [data.convergence; convergence];
                data.bestX = [data.bestX, bestX];
            end
            data.bestX = uni2real(data.bestX, Tasks);
            data.clock_time = toc;
        end
    end
end
