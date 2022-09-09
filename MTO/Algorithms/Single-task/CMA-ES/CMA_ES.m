classdef CMA_ES < Algorithm
    % <ST-SO> <None/Constrained>

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
        function run(obj, Prob)
            % The code implementation is referenced from PlatEMO.
            for t = 1:Prob.T
                % Number of parents
                mu = round(Prob.N / 2);
                % Parent weights
                w = log(mu + 0.5) - log(1:mu);
                w = w ./ sum(w);
                % Number of effective solutions
                mu_eff = 1 / sum(w.^2);
                % Step size control parameters
                cs = (mu_eff + 2) / (Prob.D(t) + mu_eff + 5);
                ds{t} = 1 + cs + 2 * max(sqrt((mu_eff - 1) / (Prob.D(t) + 1)) - 1, 0);
                ENN = sqrt(Prob.D(t)) * (1 - 1 / (4 * Prob.D(t)) + 1 / (21 * Prob.D(t)^2));
                % Covariance update parameters
                cc{t} = (4 + mu_eff / Prob.D(t)) / (4 + Prob.D(t) + 2 * mu_eff / Prob.D(t));
                c1 = 2 / ((Prob.D(t) + 1.3)^2 + mu_eff);
                cmu{t} = min(1 - c1, 2 * (mu_eff - 2 + 1 / mu_eff) / ((Prob.D(t) + 2)^2 + 2 * mu_eff / 2));
                hth{t} = (1.4 + 2 / (Prob.D(t) + 1)) * ENN;
                % Initialization
                Mdec{t} = unifrnd(Prob.Lb{t}, Prob.Ub{t});
                ps{t} = zeros(1, Prob.D(t));
                pc{t} = zeros(1, Prob.D(t));
                C{t} = eye(Prob.D(t));
                sigma{t} = 0.1 * (Prob.Ub{t} - Prob.Lb{t});
            end
            for i = 1:Prob.N
                population{t}(i) = Individual();
            end

            while obj.notTerminated(Prob)
                for t = 1:Prob.T
                    % Sample solutions
                    Pstep = zeros(length(population), Prob.D(t));
                    for i = 1:Prob.N
                        Pstep(i, :) = mvnrnd(zeros(1, Prob.D(t)), C{t});
                        population{t}(i).Dec = Mdec{t} + sigma{t} .* Pstep(i, :);
                        population{t}(i).Dec(population{t}(i).Dec > Prob.Ub{t}) = Prob.Ub{t}(population{t}(i).Dec > Prob.Ub{t});
                        population{t}(i).Dec(population{t}(i).Dec < Prob.Lb{t}) = Prob.Lb{t}(population{t}(i).Dec < Prob.Lb{t});
                    end
                    population{t} = obj.Evaluation(population{t}, Prob, t, 'real');
                    [~, rank] = sortrows([[population{t}.CV]', [population{t}.Obj]'], [1, 2]);

                    % Update mean
                    Pstep = Pstep(rank, :);
                    Mstep = w * Pstep(1:mu, :);
                    Mdec{t} = Mdec{t} + sigma{t} .* Mstep;
                    % Update parameters
                    ps{t} = (1 - cs) * ps{t} + sqrt(cs * (2 - cs) * mu_eff) * Mstep / chol(C{t})';
                    sigma{t} = sigma{t} * exp(cs / ds{t} * (norm(ps{t}) / ENN - 1))^0.3;
                    hs = norm(ps{t}) / sqrt(1 - (1 - cs)^(2 * (ceil(Prob.maxFE / Prob.N) + 1))) < hth{t};
                    delta = (1 - hs) * cc{t} * (2 - cc{t});
                    pc{t} = (1 - cc{t}) * pc{t} + hs * sqrt(cc{t} * (2 - cc{t}) * mu_eff) * Mstep;
                    C{t} = (1 - c1 - cmu{t}) * C{t} + c1 * (pc{t}' * pc{t} + delta * C{t});
                    for i = 1:mu
                        C{t} = C{t} + cmu{t} * w(i) * Pstep(i, :)' * Pstep(i, :);
                    end
                    [V, E] = eig(C{t});
                    if any(diag(E) < 0)
                        C{t} = V * max(E, 0) / V;
                    end
                end
            end
        end
    end
end
