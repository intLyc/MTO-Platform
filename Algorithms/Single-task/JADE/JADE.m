classdef JADE < Algorithm
    % <Single> <None>

    % @InProceedings{Zhang2007JADE,
    %   author     = {Jingqiao Zhang and Sanderson, Arthur C.},
    %   booktitle  = {2007 IEEE Congress on Evolutionary Computation},
    %   title      = {Jade: Self-adaptive Differential Evolution with Fast and Reliable Convergence Performance},
    %   year       = {2007},
    %   pages      = {2251-2258},
    %   doi        = {10.1109/CEC.2007.4424751},
    % }

    properties (SetAccess = private)
        p = 0.1;
        c = 0.1;
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'p: 100p% top as pbest', num2str(obj.p), ...
                        'c: life span of uF and uCR', num2str(obj.c)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.p = str2double(parameter_cell{count}); count = count + 1;
            obj.c = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            sub_pop = run_parameter_list(1);
            iter_num = run_parameter_list(2);
            eva_num = run_parameter_list(3) * length(Tasks);
            tic

            data.convergence = [];
            data.bestX = {};

            for sub_task = 1:length(Tasks)
                Task = Tasks(sub_task);

                % initialize
                [population, fnceval_calls] = initialize(IndividualJADE, sub_pop, Task, 1);

                % initialize uF uCR
                uF = 0.5;
                uCR = 0.5;

                [bestobj, idx] = min([population.factorial_costs]);
                bestX = population(idx).rnvec;
                convergence(1) = bestobj;

                generation = 1;
                while generation < iter_num && fnceval_calls < round(eva_num / length(Tasks))
                    generation = generation + 1;

                    % calculate individual F and pCR
                    for i = 1:length(population)
                        population(i).F = cauchyrnd(uF, 0.1);
                        while (population(i).F <= 0)
                            population(i).F = cauchyrnd(uF, 0.1);
                        end
                        population(i).F(population(i).F > 1) = 1;

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

                    % update uF uCR
                    for i = 1:length(SF)
                        newSF = sum(SF.^2) ./ sum(SF);
                        uF = (1 - obj.c) * uF + obj.c .* newSF;
                        uCR = (1 - obj.c) * uCR + obj.c .* mean(SCR);
                    end

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
