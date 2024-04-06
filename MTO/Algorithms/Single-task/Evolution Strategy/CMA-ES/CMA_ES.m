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
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------
properties (SetAccess = private)
    sigma0 = 0.3
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'sigma0', num2str(Algo.sigma0)};
    end

    function Algo = setParameter(Algo, Parameter)
        Algo.sigma0 = str2double(Parameter{1});
    end

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
            mDec{t} = mean(unifrnd(zeros(lambda, n{t}), ones(lambda, n{t})));
            ps{t} = zeros(n{t}, 1);
            pc{t} = zeros(n{t}, 1);
            B{t} = eye(n{t}, n{t});
            D{t} = ones(n{t}, 1);
            C{t} = B{t} * diag(D{t}.^2) * B{t}';
            invsqrtC{t} = B{t} * diag(D{t}.^-1) * B{t}';
            sigma{t} = Algo.sigma0;
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
                end
                [sample{t}, rank] = Algo.EvaluationAndSort(sample{t}, Prob, t);

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
                sigma{t} = sigma{t} * exp(cs{t} / damps{t} * (norm(ps{t}) / chiN{t} - 1));

                if (Algo.FE - lambda * (t - 1)) - eigenFE{t} > (lambda * Prob.T) / (c1{t} + cmu{t}) / n{t} / 10 % to achieve O(N^2)
                    eigenFE{t} = Algo.FE;
                    restart = false;
                    if ~(all(~isnan(C{t}), 'all') && all(~isinf(C{t}), 'all'))
                        restart = true;
                    else
                        C{t} = triu(C{t}) + triu(C{t}, 1)'; % enforce symmetry
                        [B{t}, D{t}] = eig(C{t}); % eigen decomposition, B==normalized eigenvectors
                        if min(diag(D{t})) < 0
                            restart = true;
                        else
                            D{t} = sqrt(diag(D{t})); % D contains standard deviations now
                        end
                    end
                    if restart
                        ps{t} = zeros(n{t}, 1);
                        pc{t} = zeros(n{t}, 1);
                        B{t} = eye(n{t}, n{t});
                        D{t} = ones(n{t}, 1);
                        C{t} = B{t} * diag(D{t}.^2) * B{t}';
                        sigma{t} = min(max(2 * sigma{t}, 0.01), 0.3);
                    end
                    invsqrtC{t} = B{t} * diag(D{t}.^-1) * B{t}';
                end
            end
        end
    end

    function [sample, rank] = EvaluationAndSort(Algo, sample, Prob, t)
        %% Boundary Constraint
        boundCVs = zeros(length(sample), 1);
        for i = 1:length(sample)
            % Boundary Constraint Violation
            tempDec = sample(i).Dec;
            tempDec(tempDec < 0) = 0;
            tempDec(tempDec > 1) = 1;
            boundCVs(i) = sum((sample(i).Dec - tempDec).^2);
        end
        sample = Algo.Evaluation(sample, Prob, t);
        boundCVs(boundCVs > 0) = boundCVs(boundCVs > 0) + max(sample.CVs);
        [~, rank] = sortrows([sample.CVs + boundCVs, sample.Objs], [1, 2]);
    end
end
end
