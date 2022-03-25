classdef FP_GA < Algorithm
    % <Single> <Constrained>

    % GA with Feasibility Priority for Constrained MTOPs

    properties (SetAccess = private)
        mu = 2; % index of Simulated Binary Crossover (tunable)
        mum = 5; % index of polynomial mutation
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'mu: index of Simulated Binary Crossover (tunable)', num2str(obj.mu), ...
                        'mum: index of polynomial mutation', num2str(obj.mum)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.mu = str2double(parameter_cell{count}); count = count + 1;
            obj.mum = str2double(parameter_cell{count}); count = count + 1;
        end

        function data = run(obj, Tasks, run_parameter_list)
            sub_pop = run_parameter_list(1);
            sub_eva = run_parameter_list(2);
            tic

            data.convergence = [];
            data.convergence_cv = [];
            data.bestX = {};

            for sub_task = 1:length(Tasks)
                Task = Tasks(sub_task);
                fnceval_calls = 0;

                [population, calls] = initialize(Individual, sub_pop, Task, 1);
                fnceval_calls = fnceval_calls + calls;

                bestCV = min([population.constraint_violation]);
                pop_temp = population([population.constraint_violation] == bestCV);
                [bestobj, idx] = min([pop_temp.factorial_costs]);
                bestX = pop_temp(idx).rnvec;
                convergence(1) = bestobj;
                convergence_cv(1) = pop_temp(idx).constraint_violation;

                generation = 1;
                while fnceval_calls < sub_eva
                    generation = generation + 1;

                    % generation
                    [offspring, calls] = OperatorGA.generate(1, population, Task, obj.mu, obj.mum);
                    fnceval_calls = fnceval_calls + calls;

                    % selection
                    population = [population, offspring];
                    feasible_num = sum([population.constraint_violation] == 0);
                    if feasible_num < sub_pop
                        % Feasibility Priority
                        [~, rank_cv] = sort([population.constraint_violation]);
                        population = population(rank_cv(1:sub_pop));
                    else
                        % Object Priority
                        pop_temp = population([population.constraint_violation] == 0);
                        [~, rank] = sort([pop_temp.factorial_costs]);
                        population = pop_temp(rank(1:sub_pop));
                    end

                    bestCV_now = min([population.constraint_violation]);
                    pop_temp = population([population.constraint_violation] == bestCV_now);
                    [bestobj_now, idx] = min([pop_temp.factorial_costs]);
                    if bestCV_now <= bestCV && bestobj_now < bestobj
                        bestobj = bestobj_now;
                        bestCV = bestCV_now;
                        bestX = pop_temp(idx).rnvec;
                    end
                    convergence(generation) = bestobj;
                    convergence_cv(generation) = bestCV;
                end
                data.convergence = [data.convergence; convergence];
                data.convergence_cv = [data.convergence_cv; convergence_cv];
                data.bestX = [data.bestX, bestX];
            end
            data.convergence(data.convergence_cv > 0) = NaN;
            data.bestX = uni2real(data.bestX, Tasks);
            data.clock_time = toc;
        end
    end
end
