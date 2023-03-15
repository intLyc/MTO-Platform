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
        lambda = Prob.N; % sample points number
        mu = round(lambda / 2); % effective solutions number
        weights = log(mu + 0.5) - log(1:mu);
        weights = weights ./ sum(weights); % weights
        mueff = 1 / sum(weights.^2); % variance effective selection mass
        for t = 1:Prob.T
            n{t} = Prob.D(t); % dimension
            % Step size control parameters
            cs{t} = (mueff + 2) / (n{t} + mueff + 5);
            damps{t} = 1 + cs{t} + 2 * max(sqrt((mueff - 1) / (n{t} + 1)) - 1, 0);
            % Covariance update parameters
            cc{t} = (4 + mueff / n{t}) / (4 + n{t} + 2 * mueff / n{t});
            c1{t} = 2 / ((n{t} + 1.3)^2 + mueff);
            cmu{t} = min(1 - c1{t}, 2 * (mueff - 2 + 1 / mueff) / ((n{t} + 2)^2 + 2 * mueff / 2));
            % Initialization
            mDec{t} = unifrnd(zeros(1, n{t}), ones(1, n{t}));
            ps{t} = zeros(n{t}, 1);
            pc{t} = zeros(n{t}, 1);
            B{t} = eye(n{t}, n{t});
            D{t} = ones(n{t}, 1);
            C{t} = B{t} * diag(D{t}.^2) * B{t}';
            invsqrtC{t} = B{t} * diag(D{t}.^-1) * B{t}';
            sigma{t} = 0.1;
            eigenFE{t} = 0;
            chiN{t} = sqrt(n{t}) * (1 - 1 / (4 * n{t}) + 1 / (21 * n{t}^2));
            hth{t} = (1.4 + 2 / (n{t} + 1)) * chiN{t};
            for i = 1:lambda
                sample{t}(i) = Individual();
            end
        end

        while Algo.notTerminated(Prob)
            for t = 1:Prob.T
                % Sample solutions
                for i = 1:lambda
                    sample{t}(i).Dec = mDec{t} + sigma{t} * (B{t} * (D{t} .* randn(n{t}, 1)))';
                    sample{t}(i).Dec(sample{t}(i).Dec > 1) = 1;
                    sample{t}(i).Dec(sample{t}(i).Dec < 0) = 0;
                end
                sample{t} = Algo.Evaluation(sample{t}, Prob, t);
                [~, rank] = sortrows([sample{t}.CVs, sample{t}.Objs], [1, 2]);

                % Update mean decision variables
                oldDec = mDec{t};
                mDec{t} = weights * sample{t}(rank(1:mu)).Decs;
                % Update evolution paths
                ps{t} = (1 - cs{t}) * ps{t} + sqrt(cs{t} * (2 - cs{t}) * mueff) * invsqrtC{t} * (mDec{t} - oldDec)' / sigma{t};
                hsig = norm(ps{t}) / sqrt(1 - (1 - cs{t})^(2 * (ceil((Algo.FE - lambda * (t - 1)) / (lambda * Prob.T)) + 1))) < hth{t};
                pc{t} = (1 - cc{t}) * pc{t} + hsig * sqrt(cc{t} * (2 - cc{t}) * mueff) * (mDec{t} - oldDec)' / sigma{t};
                % Update covariance matrix
                artmp = (sample{t}(rank(1:mu)).Decs - repmat(oldDec, mu, 1))' / sigma{t};
                delta = (1 - hsig) * cc{t} * (2 - cc{t});
                C{t} = (1 - c1{t} - cmu{t}) * C{t} + c1{t} * (pc{t} * pc{t}' + delta * C{t}) + cmu{t} * artmp * diag(weights) * artmp';
                % Update step size
                sigma{t} = sigma{t} * exp(cs{t} / damps{t} * (norm(ps{t}) / chiN{t} - 1))^0.3;

                if (Algo.FE - lambda * (t - 1)) - eigenFE{t} > (lambda * Prob.T) / (c1{t} + cmu{t}) / n{t} / 10 % to achieve O(N^2)
                    eigenFE{t} = Algo.FE;
                    C{t} = triu(C{t}) + triu(C{t}, 1)'; % enforce symmetry
                    [B{t}, D{t}] = eig(C{t}); % eigen decomposition, B==normalized eigenvectors
                    D{t} = sqrt(diag(D{t})); % D contains standard deviations now
                    invsqrtC{t} = B{t} * diag(D{t}.^-1) * B{t}';
                end
            end
        end
    end
end
end
