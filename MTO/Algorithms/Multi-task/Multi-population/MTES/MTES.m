classdef MTES < Algorithm
% <Multi-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Bai2022MTES,
%   title      = {From Multitask Gradient Descent to Gradient-Free Evolutionary Multitasking: A Proof of Faster Convergence},
%   author     = {Bai, Lu and Lin, Wu and Gupta, Abhishek and Ong, Yew-Soon},
%   journal    = {IEEE Transactions on Cybernetics},
%   year       = {2022},
%   number     = {8},
%   pages      = {8561-8573},
%   volume     = {52},
%   doi        = {10.1109/TCYB.2021.3052509},
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
    sigma = 0.3 % Initial step size
    sigma_decay = 0.2 % Decay rate for sigma
    lr = 0.1 % Learning rate
    lr_decay = 0.1 % Decay rate for learning rate
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'sigma', num2str(Algo.sigma), ...
                'sigma decay', num2str(Algo.sigma_decay), ...
                'learning rate', num2str(Algo.lr), ...
                'lr decay', num2str(Algo.lr_decay)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.sigma = str2double(Parameter{i}); i = i + 1;
        Algo.sigma_decay = str2double(Parameter{i}); i = i + 1;
        Algo.lr = str2double(Parameter{i}); i = i + 1;
        Algo.lr_decay = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        if mod(Prob.N, 2) ~= 0
            N = Prob.N + 1;
        else
            N = Prob.N;
        end

        % Initialization
        for t = 1:Prob.T
            % Initialize Mean x
            x{t} = [initESMean(Prob, t)'; rand(max(Prob.D) - Prob.D(t), 1)];
            Algo.Mean{t} = x{t}';

            % Initialize individuals
            for i = 1:N
                sample{t}(i) = Individual();
            end

            % Initial sigma per task
            sigma_init{t} = Algo.sigma * initESSigmaScale(Prob, t);
        end

        % ---- Initialize D^0 (Static) ----
        % Calculate initial distances between all task pairs
        current_dist = zeros(Prob.T);
        for t = 1:Prob.T
            for k = t:Prob.T
                current_dist(t, k) = norm(x{t} - x{k});
                current_dist(k, t) = current_dist(t, k);
            end
        end

        D0 = zeros(1, Prob.T);
        for t = 1:Prob.T
            % Average distance to other tasks (excluding self if T > 1)
            if Prob.T > 1
                dists = current_dist(t, :);
                dists(t) = [];
                D0(t) = mean(dists);
            else
                D0(t) = 1.0; % Fallback for single task
            end
        end

        % Store distance for the first iteration (D_{t-1})
        last_dist = current_dist;

        % Main Loop
        while Algo.notTerminated(Prob, sample)
            xold = x; % Store x^t for calculating update

            % Update Hyperparameters
            progress = Algo.FE / Prob.maxFE;
            sigma_decay_factor = Algo.sigma_decay^progress;
            lr_decay_factor = Algo.lr_decay^progress;
            current_lr = Algo.lr * lr_decay_factor;

            % --- Step 1: Compute Gradients (Standard SGD) ---
            sgd_step = cell(1, Prob.T);

            for t = 1:Prob.T
                current_sigma = sigma_init{t} * sigma_decay_factor;

                % Sampling
                Z = randn(max(Prob.D), N);
                X = repmat(x{t}, 1, N) + current_sigma * Z;

                for i = 1:N
                    sample{t}(i).Dec = X(:, i)';
                end

                sample{t} = Algo.Evaluation(sample{t}, Prob, t);

                % Centered Rank Shaping
                sortedIdx = RankWithBoundaryHandling(sample{t}, Prob);
                ranks = zeros(1, N);
                ranks(sortedIdx) = N - 1:-1:0; % Minimizing fitness
                shaped = ranks / (N - 1) - 0.5;

                % Gradient estimation
                grad = (Z * shaped') / (N * current_sigma);

                % SGD Update
                sgd_step{t} = current_lr * grad;
            end

            % --- Step 2: Calculate Transfer Coefficients ---
            current_dist = zeros(Prob.T);
            for t = 1:Prob.T
                for k = t:Prob.T
                    current_dist(t, k) = norm(x{t} - x{k});
                    current_dist(k, t) = current_dist(t, k);
                end
            end

            for t = 1:Prob.T
                % Calculate raw transfer coefficients
                m_raw = zeros(1, Prob.T);
                for k = 1:Prob.T
                    if k == t
                        continue;
                    end

                    % Calculate distance change
                    delta = last_dist(t, k) - current_dist(t, k);

                    % Logic check
                    if delta <= 0
                        m_raw(k) = 0;
                    else
                        m_raw(k) = delta;
                    end
                end

                % Normalize
                denom = sum(m_raw) + D0(t);

                if denom > 1e-15
                    m_norm = m_raw / denom;
                else
                    m_norm = zeros(1, Prob.T);
                end

                % Self coefficient
                m_self = 1 - sum(m_norm);

                % --- Step 3: Update Mean Vector ---
                weighted_means = zeros(max(Prob.D), 1);

                % Add contribution from other tasks
                for k = 1:Prob.T
                    if k ~= t
                        weighted_means = weighted_means + m_norm(k) * xold{k};
                    end
                end

                % Add contribution from self
                weighted_means = weighted_means + m_self * xold{t};

                % Apply mixture + SGD Step
                x{t} = weighted_means + sgd_step{t};

                % Boundary Constraint
                x{t} = max(0, min(1, x{t}));
                Algo.Mean{t} = x{t}';
            end

            % Update history for next generation
            last_dist = current_dist;
        end
    end
end
end
