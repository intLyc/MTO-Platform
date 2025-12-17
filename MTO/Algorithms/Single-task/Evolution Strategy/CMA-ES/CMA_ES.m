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
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties (SetAccess = public)
    sigma0 = 0.3
    useN = 1 % use Prob.N for sample points number
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'sigma0', num2str(Algo.sigma0), ...
                'useN: (1: use Prob.N, 0: use 4+3*log(D))', num2str(Algo.useN)};
    end

    function Algo = setParameter(Algo, Parameter)
        Algo.sigma0 = str2double(Parameter{1});
        Algo.useN = str2double(Parameter{2});
    end

    function run(Algo, Prob)
        for t = 1:Prob.T
            n{t} = Prob.D(t); % dimension
            if Algo.useN
                lambda{t} = Prob.N; % sample points number
            else
                lambda{t} = fix(4 + 3 * log(n{t})); % sample points number
            end
            mu{t} = round(lambda{t} / 2); % effective solutions number
            weights{t} = log(mu{t} + 0.5) - log(1:mu{t});
            weights{t} = weights{t} ./ sum(weights{t}); % weights{t}
            mueff{t} = 1 / sum(weights{t}.^2); % variance effective selection mass
            % Step size control parameters
            cs{t} = (mueff{t} + 2) / (n{t} + mueff{t} + 5);
            damps{t} = 1 + cs{t} + 2 * max(sqrt((mueff{t} - 1) / (n{t} + 1)) - 1, 0);
            % Covariance update parameters
            cc{t} = (4 + mueff{t} / n{t}) / (4 + n{t} + 2 * mueff{t} / n{t});
            c1{t} = 2 / ((n{t} + 1.3)^2 + mueff{t});
            cmu{t} = min(1 - c1{t}, 2 * (mueff{t} - 2 + 1 / mueff{t}) / ((n{t} + 2)^2 + 2 * mueff{t} / 2));
            % Initialization
            mDec{t} = initESMean(Prob, t);
            ps{t} = zeros(n{t}, 1);
            pc{t} = zeros(n{t}, 1);
            B{t} = eye(n{t}, n{t});
            D{t} = ones(n{t}, 1);
            C{t} = B{t} * diag(D{t}.^2) * B{t}';
            invsqrtC{t} = B{t} * diag(D{t}.^-1) * B{t}';
            sigma{t} = Algo.sigma0 * initESSigmaScale(Prob);
            eigenFE{t} = 0;
            chiN{t} = sqrt(n{t}) * (1 - 1 / (4 * n{t}) + 1 / (21 * n{t}^2));
            for i = 1:lambda{t}
                sample{t}(i) = Individual();
            end
            rank{t} = [];
        end

        taskFE = zeros(1, Prob.T);
        maxTaskFE = Prob.maxFE / Prob.T;
        while Algo.notTerminated(Prob, sample)
            for t = 1:Prob.T
                if taskFE(t) > maxTaskFE
                    continue;
                end
                % Sample solutions
                for i = 1:lambda{t}
                    sample{t}(i).Dec = mDec{t} + sigma{t} * (B{t} * (D{t} .* randn(n{t}, 1)))';
                end
                sample{t} = Algo.Evaluation(sample{t}, Prob, t);
                rank{t} = RankWithBoundaryHandling(sample{t}, Prob);
                taskFE(t) = taskFE(t) + lambda{t};

                % Update mean decision variables
                oldDec = mDec{t};
                mDec{t} = weights{t} * sample{t}(rank{t}(1:mu{t})).Decs;
                % Update evolution paths
                ps{t} = (1 - cs{t}) * ps{t} + sqrt(cs{t} * (2 - cs{t}) * mueff{t}) * invsqrtC{t} * (mDec{t} - oldDec)' / sigma{t};
                hsig = norm(ps{t}) / sqrt(1 - (1 - cs{t})^(2 * taskFE(t) / lambda{t})) / chiN{t} < 1.4 + 2 / (n{t} + 1);
                pc{t} = (1 - cc{t}) * pc{t} + hsig * sqrt(cc{t} * (2 - cc{t}) * mueff{t}) * (mDec{t} - oldDec)' / sigma{t};
                % Update covariance matrix
                artmp = (sample{t}(rank{t}(1:mu{t})).Decs - repmat(oldDec, mu{t}, 1))' / sigma{t};
                delta = (1 - hsig) * cc{t} * (2 - cc{t});
                C{t} = (1 - c1{t} - cmu{t}) * C{t} + c1{t} * (pc{t} * pc{t}' + delta * C{t}) + cmu{t} * artmp * diag(weights{t}) * artmp';
                % Update step size
                sigma{t} = sigma{t} * exp(cs{t} / damps{t} * (norm(ps{t}) / chiN{t} - 1));

                if taskFE(t) - eigenFE{t} > lambda{t} / (c1{t} + cmu{t}) / n{t} / 10 % to achieve O(N^2)
                    eigenFE{t} = taskFE(t);
                    C{t} = triu(C{t}) + triu(C{t}, 1)'; % enforce symmetry
                    [B{t}, D{t}] = eig(C{t}); % eigen decomposition, B==normalized eigenvectors
                    if min(diag(D{t})) <= 0
                        B{t} = eye(n{t}, n{t});
                        D{t} = ones(n{t}, 1);
                        C{t} = eye(n{t}, n{t});
                        warning('CMA-ES: Covariance matrix is not positive definite, resetting to identity matrix.');
                    else
                        D{t} = sqrt(diag(D{t})); % D contains standard deviations now
                    end
                    invsqrtC{t} = B{t} * diag(D{t}.^-1) * B{t}';
                end
            end
        end
    end
end
end
