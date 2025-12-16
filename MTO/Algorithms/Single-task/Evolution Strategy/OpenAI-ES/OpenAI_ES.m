classdef OpenAI_ES < Algorithm
% <Single-task> <Single-objective> <None>

%------------------------------- Reference --------------------------------
% @Misc{Salimans2017OpenAI-ES,
%   title         = {Evolution Strategies as a Scalable Alternative to Reinforcement Learning},
%   author        = {Tim Salimans and Jonathan Ho and Xi Chen and Szymon Sidor and Ilya Sutskever},
%   year          = {2017},
%   archiveprefix = {arXiv},
%   eprint        = {1703.03864},
%   primaryclass  = {stat.ML},
% }
%--------------------------------------------------------------------------

properties (SetAccess = public)
    sigma = 0.1 % Initial step size
    lr = 0.01 % Learning rate (Adam typically requires smaller LR than SGD)
    beta1 = 0.9 % Exponential decay rate for the first moment estimates
    beta2 = 0.999 % Exponential decay rate for the second moment estimates
    epsilon = 1e-8 % Small constant to prevent division by zero
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'sigma', num2str(Algo.sigma), ...
                'learning rate', num2str(Algo.lr), ...
                'beta1', num2str(Algo.beta1), ...
                'beta2', num2str(Algo.beta2), ...
                'epsilon', num2str(Algo.epsilon)};
    end

    function Algo = setParameter(Algo, Parameter)
        Algo.sigma = str2double(Parameter{1});
        Algo.lr = str2double(Parameter{2});
        Algo.beta1 = str2double(Parameter{3});
        Algo.beta2 = str2double(Parameter{4});
        Algo.epsilon = str2double(Parameter{5});
    end

    function run(Algo, Prob)
        if mod(Prob.N, 2) ~= 0
            N = Prob.N + 1;
        else
            N = Prob.N;
        end

        for t = 1:Prob.T
            % Initialize x in [0, 1]
            x{t} = rand(Prob.D(t), 1);

            % Adam: Initialize 1st moment vector (m) and 2nd moment vector (v)
            m{t} = zeros(Prob.D(t), 1);
            v{t} = zeros(Prob.D(t), 1);

            sample{t}(1:N) = Individual();
        end

        while Algo.notTerminated(Prob, sample)
            % ---- Linear Sigma Decay ----
            % Decay sigma from 100% to 10% over the course of optimization
            progress = Algo.FE / Prob.maxFE;
            decay = 1 - 0.99 * progress;

            for t = 1:Prob.T
                % Apply decay to sigma
                current_sigma = Algo.sigma * decay;

                % ---- Antithetic Sampling ----
                Z_half = randn(Prob.D(t), N / 2);
                Z = [Z_half, -Z_half];

                % Add noise in normalized space
                X = repmat(x{t}, 1, N) + current_sigma * Z;

                % ---- Decode samples ----
                for i = 1:N
                    sample{t}(i).Dec = X(:, i)';
                end

                % ---- Evaluate fitness ----
                mean_sample = Individual();
                mean_sample.Dec = x{t}';
                sample{t} = Algo.Evaluation([sample{t}, mean_sample], Prob, t);
                sample{t} = sample{t}(1:N);

                % ---- Centered rank shaping ----
                fitness = [sample{t}.Objs];
                [~, sortIdx] = sort(fitness);
                ranks = zeros(1, N);
                ranks(sortIdx) = N - 1:-1:0; % Minimizing fitness
                shaped = ranks / (N - 1) - 0.5;

                % ---- Gradient estimation ----
                % Note: As sigma decreases, this raw gradient magnitude increases.
                % Adam will handle this scaling automatically.
                grad = (Z * shaped') / (N * current_sigma);

                % ---- Adam Optimizer Update ----
                % 1. Update biased first moment estimate
                m{t} = Algo.beta1 * m{t} + (1 - Algo.beta1) * grad;

                % 2. Update biased second raw moment estimate
                v{t} = Algo.beta2 * v{t} + (1 - Algo.beta2) * (grad.^2);

                % 3. Compute bias-corrected first moment estimate
                m_hat = m{t} / (1 - Algo.beta1^Algo.Gen);

                % 4. Compute bias-corrected second raw moment estimate
                v_hat = v{t} / (1 - Algo.beta2^Algo.Gen);

                % 5. Update parameters
                % Using '+' because 'grad' points to higher fitness rank (better solution)
                x{t} = x{t} + Algo.lr * m_hat ./ (sqrt(v_hat) + Algo.epsilon);
                if Prob.Bounded
                    x{t} = max(0, min(1, x{t}));
                end
            end
        end
    end
end
end
