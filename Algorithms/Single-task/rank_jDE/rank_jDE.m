classdef rank_jDE < Algorithm
    % <Single> <None>

    %------------------------------- Reference --------------------------------
    % @Article{Gong2013rank-DE,
    %   author     = {Gong, Wenyin and Cai, Zhihua},
    %   journal    = {IEEE Transactions on Cybernetics},
    %   title      = {Differential Evolution With Ranking-Based Mutation Operators},
    %   year       = {2013},
    %   number     = {6},
    %   pages      = {2066-2081},
    %   volume     = {43},
    %   doi        = {10.1109/TCYB.2013.2239988},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        t1 = 0.1;
        t2 = 0.1;
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'t1: probability of F change', num2str(obj.t1), ...
                        't2: probability of CR change', num2str(obj.t2)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.t1 = str2double(parameter_cell{count}); count = count + 1;
            obj.t2 = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            sub_pop = run_parameter_list(1);
            sub_eva = run_parameter_list(2);

            convergence = [];
            bestX = {};

            for sub_task = 1:length(Tasks)
                Task = Tasks(sub_task);

                % initialize
                [population, fnceval_calls, bestobj, bestX_temp] = initialize(IndividualjDE, sub_pop, Task, Task.dims);
                converge_temp(1) = bestobj;

                % initialize F and CR
                for i = 1:length(population)
                    population(i).F = rand * 0.9 + 0.1;
                    population(i).CR = rand;
                end

                generation = 1;
                while fnceval_calls < sub_eva
                    generation = generation + 1;

                    % generation
                    [offspring, calls] = OperatorjDE_rank.generate(1, population, Task, obj.t1, obj.t2);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    replace = [population.factorial_costs] > [offspring.factorial_costs];
                    population(replace) = offspring(replace);
                    [bestobj_now, idx] = min([population.factorial_costs]);
                    if bestobj_now < bestobj
                        bestobj = bestobj_now;
                        bestX_temp = population(idx).rnvec;
                    end
                    converge_temp(generation) = bestobj;
                end
                convergence = [convergence; converge_temp];
                bestX = [bestX, bestX_temp];
            end
            data.convergence = gen2eva(convergence);
            data.bestX = uni2real(bestX, Tasks);
        end
    end
end
