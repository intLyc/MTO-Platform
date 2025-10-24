classdef OpenAI_ES < Algorithm
% <Single-task> <Single-objective> <None/Constrained>

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

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties (SetAccess = public)
    sigma = 1
    lr = 1e-3
    momentum = 0.9
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'sigma', num2str(Algo.sigma), ...
                'learning rate', num2str(Algo.lr), ...
                'momentum', num2str(Algo.momentum)};
    end

    function Algo = setParameter(Algo, Parameter)
        Algo.sigma = str2double(Parameter{1});
        Algo.lr = str2double(Parameter{2});
        Algo.momentum = str2double(Parameter{3});
    end

    function run(Algo, Prob)
        if mod(Prob.N, 2) ~= 0
            N = Prob.N + 1;
        else
            N = Prob.N;
        end

        for t = 1:Prob.T
            range = mean(Prob.Ub{t} - Prob.Lb{t});
            sigma{t} = Algo.sigma / range;
            x{t} = mean(unifrnd(zeros(Prob.D(t), N), ones(Prob.D(t), N)), 2);
            v{t} = zeros(Prob.D(t), 1);
            sample{t}(1:N) = Individual();
        end

        while Algo.notTerminated(Prob, sample)
            for t = 1:Prob.T
                % ---- Antithetic Sampling ----
                Z_half = randn(Prob.D(t), N / 2);
                Z = [Z_half, -Z_half];
                X = repmat(x{t}, 1, N) + sigma{t} * Z;

                % ---- Decode samples ----
                for i = 1:N
                    sample{t}(i).Dec = X(:, i)';
                end

                % ---- Evaluate fitness ----
                mean_sample = Individual();
                mean_sample.Dec = x{t}'; % mean decision variable
                sample{t} = Algo.Evaluation([sample{t}, mean_sample], Prob, t);
                sample{t} = sample{t}(1:N);

                % ---- Centered rank shaping ----
                fitness = [sample{t}.Objs];
                [~, sortIdx] = sort(fitness);
                ranks = zeros(1, N);
                ranks(sortIdx) = N - 1:-1:0; % Minimizing fitness
                shaped = ranks / (N - 1) - 0.5;

                % ---- Gradient estimation ----
                grad = (Z * shaped') / (N * sigma{t});

                % ---- Momentum update ----
                v{t} = Algo.momentum * v{t} + (1 - Algo.momentum) * grad;
                x{t} = x{t} + Algo.lr * v{t};
            end
        end
    end
end
end
