classdef CMA_ES < Algorithm
    % <Single> <None>

    %------------------------------- Reference --------------------------------
    % @article{Hansen2001CMA-ES,
    %   title    = {Completely Derandomized Self-Adaptation in Evolution Strategies},
    %   author   = {Hansen, Nikolaus and Ostermeier, Andreas},
    %   doi      = {10.1162/106365601750190398},
    %   journal  = {Evolutionary Computation},
    %   number   = {2},
    %   pages    = {159-195},
    %   volume   = {9},
    %   year     = {2001}
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods
        function data = run(obj, Tasks, run_parameter_list)
            sub_pop = run_parameter_list(1);
            sub_eva = run_parameter_list(2);

            data.convergence = [];
            data.bestX = {};

            for sub_task = 1:length(Tasks)
                Task = Tasks(sub_task);

                % The code implementation is referenced from PlatEMO.
                % Number of parents
                mu = round(sub_pop / 2);
                % Parent weights
                w = log(mu + 0.5) - log(1:mu);
                w = w ./ sum(w);
                % Number of effective solutions
                mu_eff = 1 / sum(w.^2);
                % Step size control parameters
                cs = (mu_eff + 2) / (Task.dims + mu_eff + 5);
                ds = 1 + cs + 2 * max(sqrt((mu_eff - 1) / (Task.dims + 1)) - 1, 0);
                ENN = sqrt(Task.dims) * (1 - 1 / (4 * Task.dims) + 1 / (21 * Task.dims^2));
                % Covariance update parameters
                cc = (4 + mu_eff / Task.dims) / (4 + Task.dims + 2 * mu_eff / Task.dims);
                c1 = 2 / ((Task.dims + 1.3)^2 + mu_eff);
                cmu = min(1 - c1, 2 * (mu_eff - 2 + 1 / mu_eff) / ((Task.dims + 2)^2 + 2 * mu_eff / 2));
                hth = (1.4 + 2 / (Task.dims + 1)) * ENN;
                % Initialization
                Mdec = unifrnd(Task.Lb, Task.Ub);
                ps = zeros(1, Task.dims);
                pc = zeros(1, Task.dims);
                C = eye(Task.dims);
                sigma = 0.1 * (Task.Ub - Task.Lb);

                for i = 1:sub_pop
                    population(i) = Individual();
                end
                fnceval_calls = 0;

                generation = 0;
                while fnceval_calls < sub_eva
                    generation = generation + 1;

                    % Sample solutions
                    Pstep = zeros(length(population), Task.dims);
                    for i = 1:sub_pop
                        Pstep(i, :) = mvnrnd(zeros(1, Task.dims), C);
                        population(i).rnvec = Mdec + sigma .* Pstep(i, :);
                        population(i).rnvec(population(i).rnvec > Task.Ub) = Task.Ub(population(i).rnvec > Task.Ub);
                        population(i).rnvec(population(i).rnvec < Task.Lb) = Task.Lb(population(i).rnvec < Task.Lb);
                    end
                    [population, calls] = evaluate(population, Task, 1, 'real');
                    fnceval_calls = fnceval_calls + calls;

                    [~, rank] = sort([population.factorial_costs]);
                    bestobj_now = population(rank(1)).factorial_costs;
                    if generation == 1
                        bestobj = bestobj_now;
                        bestX = population(rank(1)).rnvec;
                    else
                        if bestobj_now < bestobj
                            bestobj = bestobj_now;
                            bestX = population(rank(1)).rnvec;
                        end
                    end
                    convergence(generation) = bestobj;

                    % Update mean
                    Pstep = Pstep(rank, :);
                    Mstep = w * Pstep(1:mu, :);
                    Mdec = Mdec + sigma .* Mstep;
                    % Update parameters
                    ps = (1 - cs) * ps + sqrt(cs * (2 - cs) * mu_eff) * Mstep / chol(C)';
                    sigma = sigma * exp(cs / ds * (norm(ps) / ENN - 1))^0.3;
                    hs = norm(ps) / sqrt(1 - (1 - cs)^(2 * (ceil(sub_eva / sub_pop) + 1))) < hth;
                    delta = (1 - hs) * cc * (2 - cc);
                    pc = (1 - cc) * pc + hs * sqrt(cc * (2 - cc) * mu_eff) * Mstep;
                    C = (1 - c1 - cmu) * C + c1 * (pc' * pc + delta * C);
                    for i = 1:mu
                        C = C + cmu * w(i) * Pstep(i, :)' * Pstep(i, :);
                    end
                    [V, E] = eig(C);
                    if any(diag(E) < 0)
                        C = V * max(E, 0) / V;
                    end
                end
                data.convergence = [data.convergence; convergence];
                data.bestX = [data.bestX, bestX];
            end
            data.convergence = gen2eva(data.convergence);
        end
    end
end
