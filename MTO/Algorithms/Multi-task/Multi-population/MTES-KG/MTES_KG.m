classdef MTES_KG < Algorithm
% <Multi-task/Many-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Li2023MTES-KG,
%   title      = {Multitask Evolution Strategy With Knowledge-Guided External Sampling},
%   author     = {Li, Yanchi and Gong, Wenyin and Li, Shuijia},
%   journal    = {IEEE Transactions on Evolutionary Computation},
%   year       = {2024},
%   number     = {6},
%   pages      = {1733-1745},
%   volume     = {28},
%   doi        = {10.1109/TEVC.2023.3330265},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties (SetAccess = public)
    tau0 = 2
    alpha = 0.5
    adjGap = 50
    sigma0 = 0.3
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'tau0: External Sample Number', num2str(Algo.tau0), ...
                'alpha: DoS/SaS Probability', num2str(Algo.alpha), ...
                'adjGap: Gap of Adjust tau', num2str(Algo.adjGap), ...
                'sigma0', num2str(Algo.sigma0)};
    end

    function Algo = setParameter(Algo, Parameter)
        Algo.tau0 = str2double(Parameter{1});
        Algo.alpha = str2double(Parameter{2});
        Algo.adjGap = str2double(Parameter{3});
        Algo.sigma0 = str2double(Parameter{4});
    end

    function run(Algo, Prob)
        n = max(Prob.D); % dimension
        lambda = Prob.N; % sample points number
        mu = round(lambda / 2); % effective solutions number
        weights = log(mu + 0.5) - log(1:mu);
        weights = weights ./ sum(weights); % weights
        mueff = 1 / sum(weights.^2); % variance effective selection mass
        % expectation of the Euclidean norm of a N(0,I) distributed random vector
        chiN = sqrt(n) * (1 - 1 / (4 * n) + 1 / (21 * n^2));
        hth = (1.4 + 2 / (n + 1)) * chiN;
        for t = 1:Prob.T
            % Step size control parameters
            cs{t} = (mueff + 2) / (n + mueff + 5);
            damps{t} = 1 + cs{t} + 2 * max(sqrt((mueff - 1) / (n + 1)) - 1, 0);
            % Covariance update parameters
            cc{t} = (4 + mueff / n) / (4 + n + 2 * mueff / n);
            c1{t} = 2 / ((n + 1.3)^2 + mueff);
            cmu{t} = min(1 - c1{t}, 2 * (mueff - 2 + 1 / mueff) / ((n + 2)^2 + 2 * mueff / 2));
            % Initialization
            mDec{t} = mean(unifrnd(zeros(lambda, n), ones(lambda, n)));
            ps{t} = zeros(n, 1);
            pc{t} = zeros(n, 1);
            B{t} = eye(n, n);
            D{t} = ones(n, 1);
            C{t} = B{t} * diag(D{t}.^2) * B{t}';
            invsqrtC{t} = B{t} * diag(D{t}.^-1) * B{t}';
            sigma{t} = Algo.sigma0;
            eigenFE{t} = 0;
            for i = 1:lambda
                sample{t}(i) = Individual();
            end
            mStep{t} = 0; % mean sample step
            numExS{t} = []; % external sample number memory
            sucExS{t} = []; % external sample success number memory
            tau(t) = Algo.tau0; % external sample number
            record_tau{t} = tau(t);
        end
        rank = {};

        while Algo.notTerminated(Prob, sample)
            %% Sample new solutions
            oldsample = sample;
            sample{t} = sample{t}(1:lambda);
            for t = 1:Prob.T
                for i = 1:lambda
                    sample{t}(i).Dec = mDec{t} + sigma{t} * (B{t} * (D{t} .* randn(n, 1)))';
                end
                mStep{t} = mean(sqrt(sum((sample{t}.Decs - mDec{t}).^2, 2)));
            end

            %% Sample external solutions
            for t = 1:Prob.T
                % Select auxiliary task
                idx = 1:Prob.T; idx(t) = [];
                k = idx(randi(end));

                for i = lambda + 1:lambda + tau(t)
                    if Algo.Gen < 2
                        sample{t}(i).Dec = mDec{t} + sigma{t} * (B{t} * (D{t} .* randn(n, 1)))';
                        continue;
                    end
                    if rand() < Algo.alpha
                        % Optimal domain knowledge-guided external sampling (DoS)
                        sample_k = mDec{k} + sigma{k} * (B{k} * (D{k} .* randn(n, 1)))';
                        vec = (sample_k - mDec{t});
                        if norm(vec) < mStep{t}
                            sample{t}(i).Dec = sample_k;
                        else
                            uni_vec = vec ./ norm(vec);
                            sample{t}(i).Dec = mDec{t} + uni_vec * mStep{t};
                        end
                    else
                        % Function shape knowledge-guided external sampling (SaS)
                        idx = 1:mu; idx(randi(end)) = [];
                        vec = mean(oldsample{k}(rank{k}(idx)).Decs);
                        vec = (vec - mDec{k}) ./ sigma{k};
                        sample{t}(i).Dec = mDec{t} + sigma{t} * (B{t} * (D{t} .* (B{k}' * (D{k}.^-1 .* vec'))))';
                    end
                end
            end

            %% Update algorithm parameters
            for t = 1:Prob.T
                [sample{t}, rank{t}] = Algo.EvaluationAndSort(sample{t}, Prob, t);

                % Storage number and success of external samples
                numExS{t}(Algo.Gen) = tau(t);
                sucExS{t}(Algo.Gen) = length(find(rank{t}(1:mu) > lambda));

                % Negative transfer mitigation
                if mod(Algo.Gen, Algo.adjGap) == 0
                    numAll = sum(numExS{t}(Algo.Gen - Algo.adjGap + 1:Algo.Gen));
                    sucAll = sum(sucExS{t}(Algo.Gen - Algo.adjGap + 1:Algo.Gen));

                    if (numAll > 0 && sucAll / numAll > 0.5) || (numAll == 0)
                        tau(t) = min([Algo.tau0, tau(t) + 1]);
                    else
                        tau(t) = max(0, tau(t) - 1);
                    end
                end

                % Update CMA parameters
                % Update mean decision variables
                oldDec = mDec{t};
                mDec{t} = weights * sample{t}(rank{t}(1:mu)).Decs;
                % Update evolution paths
                ps{t} = (1 - cs{t}) * ps{t} + sqrt(cs{t} * (2 - cs{t}) * mueff) * invsqrtC{t} * (mDec{t} - oldDec)' / sigma{t};
                hsig = norm(ps{t}) / sqrt(1 - (1 - cs{t})^(2 * (ceil((Algo.FE - lambda * (t - 1)) / (lambda * Prob.T)) + 1))) < hth;
                pc{t} = (1 - cc{t}) * pc{t} + hsig * sqrt(cc{t} * (2 - cc{t}) * mueff) * (mDec{t} - oldDec)' / sigma{t};
                % Update covariance matrix
                artmp = (sample{t}(rank{t}(1:mu)).Decs - repmat(oldDec, mu, 1))' / sigma{t};
                delta = (1 - hsig) * cc{t} * (2 - cc{t});
                C{t} = (1 - c1{t} - cmu{t}) * C{t} + c1{t} * (pc{t} * pc{t}' + delta * C{t}) + cmu{t} * artmp * diag(weights) * artmp';
                % Update step size
                sigma{t} = sigma{t} * exp(cs{t} / damps{t} * (norm(ps{t}) / chiN - 1));
                % Check distribution correctness
                if (Algo.FE - lambda * (t - 1)) - eigenFE{t} > (lambda * Prob.T) / (c1{t} + cmu{t}) / n / 10 % to achieve O(N^2)
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
                        ps{t} = zeros(n, 1);
                        pc{t} = zeros(n, 1);
                        B{t} = eye(n, n);
                        D{t} = ones(n, 1);
                        C{t} = B{t} * diag(D{t}.^2) * B{t}';
                        sigma{t} = min(max(2 * sigma{t}, 0.01), 0.3);
                    end
                    invsqrtC{t} = B{t} * diag(D{t}.^-1) * B{t}';
                end
                record_tau{t} = [record_tau{t}; tau(t)];
            end
        end
    end

    function [sample, rank] = EvaluationAndSort(Algo, sample, Prob, t)
        %% Boundary constraint handling
        boundCVs = zeros(length(sample), 1);
        for i = 1:length(sample)
            % Boundary constraint violation
            tempDec = sample(i).Dec;
            tempDec(tempDec < -0.05) = -0.05;
            tempDec(tempDec > 1.05) = 1.05;
            boundCVs(i) = sum((sample(i).Dec - tempDec).^2);
        end
        sample = Algo.Evaluation(sample, Prob, t);
        boundCVs(boundCVs > 0) = boundCVs(boundCVs > 0) + max(sample.CVs);
        [~, rank] = sortrows([sample.CVs + boundCVs, sample.Objs], [1, 2]);
    end
end
end
