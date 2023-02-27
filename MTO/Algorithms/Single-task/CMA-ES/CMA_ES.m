classdef CMA_ES < Algorithm
% <Single-task> <Single-objective> <None/Constrained>

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
    function run(Algo, Prob)
        % The code implementation is referenced from PlatEMO.
        % Number of parents
        mu = round(Prob.N / 2);
        % Parent weights
        w = log(mu + 0.5) - log(1:mu);
        w = w ./ sum(w);
        % Number of effective solutions
        mu_eff = 1 / sum(w.^2);
        for t = 1:Prob.T
            % Step size control parameters
            cs{t} = (mu_eff + 2) / (Prob.D(t) + mu_eff + 5);
            ds{t} = 1 + cs{t} + 2 * max(sqrt((mu_eff - 1) / (Prob.D(t) + 1)) - 1, 0);
            ENN{t} = sqrt(Prob.D(t)) * (1 - 1 / (4 * Prob.D(t)) + 1 / (21 * Prob.D(t)^2));
            % Covariance update parameters
            cc{t} = (4 + mu_eff / Prob.D(t)) / (4 + Prob.D(t) + 2 * mu_eff / Prob.D(t));
            c1{t} = 2 / ((Prob.D(t) + 1.3)^2 + mu_eff);
            cmu{t} = min(1 - c1{t}, 2 * (mu_eff - 2 + 1 / mu_eff) / ((Prob.D(t) + 2)^2 + 2 * mu_eff / 2));
            hth{t} = (1.4 + 2 / (Prob.D(t) + 1)) * ENN{t};
            % Initialization
            Mdec{t} = unifrnd(zeros(1, Prob.D(t)), ones(1, Prob.D(t)));
            ps{t} = zeros(1, Prob.D(t));
            pc{t} = zeros(1, Prob.D(t));
            C{t} = eye(Prob.D(t));
            sigma{t} = 0.1 * ones(1, Prob.D(t));
            for i = 1:Prob.N
                population{t}(i) = Individual();
            end
        end

        while Algo.notTerminated(Prob)
            for t = 1:Prob.T
                % Sample solutions
                Pstep = zeros(length(population{t}), Prob.D(t));
                for i = 1:Prob.N
                    Pstep(i, :) = mvnrnd(zeros(1, Prob.D(t)), C{t});
                    population{t}(i).Dec = Mdec{t} + sigma{t} .* Pstep(i, :);
                    population{t}(i).Dec(population{t}(i).Dec > 1) = 1;
                    population{t}(i).Dec(population{t}(i).Dec < 0) = 0;
                end
                population{t} = Algo.Evaluation(population{t}, Prob, t);
                [~, rank] = sortrows([population{t}.CVs, population{t}.Objs], [1, 2]);

                % Update mean
                Pstep = Pstep(rank(1:mu), :);
                Mstep = w * Pstep;
                Mdec{t} = Mdec{t} + sigma{t} .* Mstep;
                % Update parameters
                ps{t} = (1 - cs{t}) * ps{t} + sqrt(cs{t} * (2 - cs{t}) * mu_eff) * Mstep / chol(C{t})';
                sigma{t} = sigma{t} * exp(cs{t} / ds{t} * (norm(ps{t}) / ENN{t} - 1))^0.3;
                hs = norm(ps{t}) / sqrt(1 - (1 - cs{t})^(2 * (ceil(Algo.FE / (Prob.N * Prob.T)) + 1))) < hth{t};
                delta = (1 - hs) * cc{t} * (2 - cc{t});
                pc{t} = (1 - cc{t}) * pc{t} + hs * sqrt(cc{t} * (2 - cc{t}) * mu_eff) * Mstep;
                C{t} = (1 - c1{t} - cmu{t}) * C{t} + c1{t} * (pc{t}' * pc{t} + delta * C{t}) + cmu{t} * Pstep' * diag(w) * Pstep;

                C{t} = triu(C{t}) + triu(C{t}, 1)';
                [V, E] = eig(C{t});
                if any(diag(E) < 0)
                    C{t} = V * max(E, 0) / V;
                end
            end
        end
    end
end
end
