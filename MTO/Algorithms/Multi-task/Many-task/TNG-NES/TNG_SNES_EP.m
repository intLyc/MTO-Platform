classdef TNG_SNES_EP < Algorithm
% <Many-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Li2024TNG-NES,
%   title   = {Transfer Task-averaged Natural Gradient for Efficient Many-task Optimization},
%   author  = {Li, Yanchi and Gong, Wenyin and Gu, Qiong},
%   journal = {IEEE Transactions on Evolutionary Computation},
%   year    = {2024},
%   doi     = {10.1109/TEVC.2024.3459862},
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
    rho0 = 0.1
    alpha0 = 0.7
    adjGap = 100
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'sigma0', num2str(Algo.sigma0), ...
                'rho0', num2str(Algo.rho0), ...
                'alpha0', num2str(Algo.alpha0), ...
                'adjGap', num2str(Algo.adjGap)};
    end

    function Algo = setParameter(Algo, Parameter)
        Algo.sigma0 = str2double(Parameter{1});
        Algo.rho0 = str2double(Parameter{2});
        Algo.alpha0 = str2double(Parameter{3});
        Algo.adjGap = str2double(Parameter{4});
    end

    function run(Algo, Prob)
        % initialize parameters
        N = Prob.N;
        maxD = max(Prob.D);
        x = zeros(maxD, Prob.T); % expectation
        S = zeros(maxD, Prob.T); % standard deviation
        Gx = ones(maxD, Prob.T); % natural gradient of x
        GS = ones(maxD, Prob.T); % natural gradient of S
        etax = zeros(1, Prob.T); % learning rate of x
        etaS = zeros(1, Prob.T); % learning rate of S
        shape = max(0.0, log(N / 2 + 1.0) - log(1:N));
        shape = shape / sum(shape) - 1 / N; % utility function shape
        mueff = 1 / sum(shape.^2);
        weights = zeros(1, N);
        for t = 1:Prob.T
            etax(t) = 1;
            etaS(t) = (3 + log(maxD)) / (5 * sqrt(maxD)); % Learning rate
            x(:, t) = mean(unifrnd(zeros(maxD, N), ones(maxD, N)), 2);

            % Step size control parameters
            cs{t} = (mueff + 2) / (maxD + mueff + 3);
            damps{t} = 1 + cs{t} + 2 * max(sqrt((mueff - 1) / (maxD + 1)) - 1, 0);
            % Covariance update parameters
            cc{t} = 4 / (4 + maxD);
            ccov{t} = (1 / mueff) * (2 / (maxD + sqrt(2))^2) + (1 - 1 / mueff) * min(1, (2 * mueff - 1) / ((maxD + 2)^2 + mueff));
            ccov{t} = (maxD + 2) / 3 * ccov{t};
            % Initialization
            ps{t} = zeros(maxD, 1);
            pc{t} = zeros(maxD, 1);
            C{t} = ones(maxD, 1);
            sigma{t} = Algo.sigma0;
            S(:, t) = sigma{t} * sqrt(C{t}); % Sigma vector
            chiN{t} = sqrt(maxD) * (1 - 1 / (4 * maxD) + 1 / (21 * maxD^2));
            hth{t} = (1.4 + 2 / (maxD + 1)) * chiN{t};

            for i = 1:N
                sample{t}(i) = Individual();
            end
        end
        vx = x; % virtual x for adaptive transfer control
        vS = S; % virtual S for adaptive transfer control
        rho = Algo.rho0 * ones(1, Prob.T); % utilization factor
        alpha = Algo.alpha0 * ones(1, Prob.T); % transfer rate

        while Algo.notTerminated(Prob, sample)
            for t = 1:Prob.T
                S(:, t) = sigma{t} * sqrt(C{t}); % Sigma vector
                % sampling
                Z = randn(maxD, N);
                X = repmat(x(:, t), 1, N) + repmat(S(:, t), 1, N) .* Z;
                for i = 1:N
                    sample{t}(i).Dec = X(:, i)';
                end

                % fitness reshaping
                [sample{t}, rank] = Algo.EvaluationAndSort(sample{t}, Prob, t);
                weights(rank) = shape;

                % adaptive transfer control
                if mod(Algo.Gen, Algo.adjGap) == 0
                    vS(:, t) = sigma{t} * sqrt(vC{t}); % Sigma vector
                    temp_sample = sample{t};
                    vX = repmat(vx(:, t), 1, N) + repmat(vS(:, t), 1, N) .* Z;
                    for i = 1:N
                        temp_sample(i).Dec = vX(:, i)';
                    end
                    temp_sample = Algo.Evaluation(temp_sample, Prob, t);
                    Fit = 1e8 * mean(sample{t}.CVs) + mean(sample{t}.Objs);
                    vFit = 1e8 * mean(temp_sample.CVs) + mean(temp_sample.Objs);
                    if vFit > Fit
                        rho(t) = 2/3 * rho(t);
                        alpha(t) = 2/3 * alpha(t);
                    else
                        rho(t) = min(1, 3/2 * rho(t));
                        alpha(t) = min(1, 3/2 * alpha(t));
                    end
                end

                % compute the gradient for x and S
                Gx(:, t) = Z * weights';
                GS(:, t) = (Z.^2 - 1) * weights';
            end

            % compute task-averaged natural gradient
            TaGx = mean(Gx, 2);
            TaGS = mean(GS, 2);

            for t = 1:Prob.T
                tGx = Gx(:, t);
                tGS = GS(:, t);

                % compute virtual parameter for adaptive transfer control
                if mod(Algo.Gen + 1, Algo.adjGap) == 0
                    vtGx = tGx +3/2 * rho(t) * TaGx;
                    vtGS = tGS +3/2 * rho(t) * TaGS;
                    vdx = etax(t) * S(:, t) .* vtGx;
                    vdS = 0.5 * vtGS;
                    vx(:, t) = x(:, t) + vdx;
                    vS(:, t) = S(:, t) .* exp(vdS);
                    vps{t} = (1 - cs{t}) * ps{t} + sqrt(cs{t} * (2 - cs{t}) * mueff) * (vx(:, t) - oldDec) ./ sqrt(C{t}) / sigma{t};
                    hsig = norm(vps{t}) / sqrt(1 - (1 - cs{t})^(2 * (ceil((Algo.FE - N * (t - 1)) / (N * Prob.T)) + 1))) < hth{t};
                    vpc{t} = (1 - cc{t}) * pc{t} + hsig * sqrt(cc{t} * (2 - cc{t}) * mueff) * (vx(:, t) - oldDec) / sigma{t};
                    % Update covariance matrix
                    delta = (1 - hsig) * cc{t} * (2 - cc{t});
                    vC{t} = (1 - ccov{t}) * C{t} + (ccov{t} / mueff) * (pc{t}.^2 + delta * C{t}) + ccov{t} * (1 - 1 / mueff) * vS(:, t).^2;
                end

                % transfer task-averaged natural gradient
                if rand() < alpha(t) || mod(Algo.Gen + 1, Algo.adjGap) == 0
                    tGx = tGx + rho(t) * TaGx;
                    tGS = tGS + rho(t) * TaGS;
                end

                oldDec = x(:, t);
                % update distribution parameter
                dx = etax(t) * S(:, t) .* tGx;
                x(:, t) = x(:, t) + dx;

                dS = 0.5 * tGS;
                S(:, t) = S(:, t) .* exp(dS);

                % Update evolution paths
                ps{t} = (1 - cs{t}) * ps{t} + sqrt(cs{t} * (2 - cs{t}) * mueff) * (x(:, t) - oldDec) ./ sqrt(C{t}) / sigma{t};
                hsig = norm(ps{t}) / sqrt(1 - (1 - cs{t})^(2 * (ceil((Algo.FE - N * (t - 1)) / (N * Prob.T)) + 1))) < hth{t};
                pc{t} = (1 - cc{t}) * pc{t} + hsig * sqrt(cc{t} * (2 - cc{t}) * mueff) * (x(:, t) - oldDec) / sigma{t};
                % Update covariance matrix
                delta = (1 - hsig) * cc{t} * (2 - cc{t});
                C{t} = (1 - ccov{t}) * C{t} + (ccov{t} / mueff) * (pc{t}.^2 + delta * C{t}) + ccov{t} * (1 - 1 / mueff) * S(:, t).^2;
                % Update step size
                sigma{t} = sigma{t} * exp(cs{t} / damps{t} * (norm(ps{t}) / chiN{t} - 1));

            end
        end
    end

    function [sample, rank] = EvaluationAndSort(Algo, sample, Prob, t)
        % boundary constraint
        boundCVs = zeros(length(sample), 1);
        for i = 1:length(sample)
            tempDec = max(0, min(1, sample(i).Dec));
            boundCVs(i) = sum((sample(i).Dec - tempDec).^2);
        end
        sample = Algo.Evaluation(sample, Prob, t);
        boundCVs(boundCVs > 0) = boundCVs(boundCVs > 0) + max(sample.CVs);
        % get rank based on constraint and objective
        [~, rank] = sortrows([sample.CVs + boundCVs, sample.Objs], [1, 2]);
    end
end
end
