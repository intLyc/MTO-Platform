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

properties (SetAccess = private)
    alpha0 = 0.1
    sigma0 = 0.3
    adjustGen = 100
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'alpha0', num2str(Algo.alpha0), ...
                'sigma0', num2str(Algo.sigma0), ...
                'adjustGen', num2str(Algo.adjustGen)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.alpha0 = str2double(Parameter{i}); i = i + 1;
        Algo.sigma0 = str2double(Parameter{i}); i = i + 1;
        Algo.adjustGen = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        N = Prob.N;
        for t = 1:Prob.T
            alpha{t} = Algo.alpha0;
            sigma{t} = Algo.sigma0;
            shape{t} = max(0.0, log(N / 2 + 1.0) - log(1:N));
            shape{t} = shape{t} / sum(shape{t}) - 1 / N;

            x{t} = mean(unifrnd(zeros(Prob.D(t), N), ones(Prob.D(t), N)), 2);
            weights{t} = zeros(1, N);
            for i = 1:N
                sample{t}(i) = Individual();
            end
        end

        while Algo.notTerminated(Prob)
            for t = 1:Prob.T
                % sampling
                Z{t} = randn(Prob.D(t), N);
                X{t} = repmat(x{t}, 1, N) + sigma{t} * Z{t};
                for i = 1:N
                    sample{t}(i).Dec = X{t}(:, i)';
                end

                % fitness reshaping
                [sample{t}, rank{t}] = Algo.EvaluationAndSort(sample{t}, Prob, t);
                weights{t}(rank{t}) = shape{t};

                % compute the update
                xold = x{t};
                x{t} = x{t} + alpha{t} / (N * sigma{t}) * Z{t} * weights{t}';
                if mod(Algo.Gen, Algo.adjustGen) == 0
                    % Adaptive sigma and alpha
                    sigma{t} = min(median(abs(x{t} - xold)), 1);
                    alpha{t} = sigma{t}^2;
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
