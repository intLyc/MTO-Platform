classdef JADE < Algorithm
    % <Single> <None>

    %------------------------------- Reference --------------------------------
    % @InProceedings{Zhang2007JADE,
    %   author     = {Jingqiao Zhang and Sanderson, Arthur C.},
    %   booktitle  = {2007 IEEE Congress on Evolutionary Computation},
    %   title      = {Jade: Self-adaptive Differential Evolution with Fast and Reliable Convergence Performance},
    %   year       = {2007},
    %   pages      = {2251-2258},
    %   doi        = {10.1109/CEC.2007.4424751},
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
            sub_eva = run_parameter_list(2);
            tic

            data.convergence = [];
            data.bestX = {};

            for sub_task = 1:length(Tasks)
                Task = Tasks(sub_task);

                % initialize
                [population, fnceval_calls, bestobj, bestX] = initialize(IndividualJADE, sub_pop, Task, Task.dims);
                convergence(1) = bestobj;

                % initialize parameter
                uF = 0.5;
                uCR = 0.5;
                arc = IndividualJADE.empty();

                generation = 1;
                while fnceval_calls < sub_eva
                    generation = generation + 1;

                    % calculate individual F and CR
                    for i = 1:length(population)
                        population(i).F = cauchyrnd(uF, 0.1);
                        while (population(i).F <= 0)
                            population(i).F = cauchyrnd(uF, 0.1);
                        end
                        population(i).F(population(i).F > 1) = 1;

                        population(i).CR = normrnd(uCR, 0.1);
                        population(i).CR(population(i).CR > 1) = 1;
                        population(i).CR(population(i).CR < 0) = 0;
                    end

                    % generation
                    union = [population, arc];
                    [offspring, calls] = OperatorJADE.generate(1, Task, population, union, obj.p);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    replace = [population.factorial_costs] > [offspring.factorial_costs];

                    % update archive
                    arc = [arc, population(replace)];
                    if length(arc) > length(population)
                        rnd = randperm(length(arc));
                        arc = arc(rnd(1:length(population)));
                    end

                    % calculate SF SCR
                    SF = [population(replace).F];
                    SCR = [population(replace).CR];

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
