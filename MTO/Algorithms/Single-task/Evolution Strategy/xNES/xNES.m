classdef xNES < Algorithm
% <Single-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @InProceedings{Glasmachers2010xNES,
%   title      = {Exponential Natural Evolution Strategies},
%   author     = {Glasmachers, Tobias and Schaul, Tom and Yi, Sun and Wierstra, Daan and Schmidhuber, J\"{u}rgen},
%   booktitle  = {Proceedings of the 12th Annual Conference on Genetic and Evolutionary Computation},
%   year       = {2010},
%   pages      = {393–400},
% }
% @Article{Wierstra2014NES,
%   title      = {Natural Evolution Strategies},
%   author     = {Daan Wierstra and Tom Schaul and Tobias Glasmachers and Yi Sun and Jan Peters and J\"{u}rgen Schmidhuber},
%   journal    = {Journal of Machine Learning Research},
%   year       = {2014},
%   number     = {27},
%   pages      = {949--980},
%   volume     = {15},
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
        N = Prob.N;
        for t = 1:Prob.T
            etax{t} = 1;
            etas{t} = (9 + 3 * log(Prob.D(t))) / (5 * Prob.D(t) * sqrt(Prob.D(t)));
            etaB{t} = etas{t};
            shape{t} = max(0.0, log(N / 2 + 1.0) - log(1:N));
            shape{t} = shape{t} / sum(shape{t}) - 1 / N;

            % initialize
            x{t} = mean(unifrnd(zeros(Prob.D(t), N), ones(Prob.D(t), N)), 2);
            s{t} = Algo.sigma0;
            B{t} = eye(Prob.D(t)); % B = A/s; A*A' = C = covariance matrix
            weights{t} = zeros(1, N);
            for i = 1:N
                sample{t}(i) = Individual();
            end
        end

        while Algo.notTerminated(Prob, sample)
            for t = 1:Prob.T
                % step 1: sampling & importance mixing
                Z{t} = randn(Prob.D(t), N);
                X{t} = repmat(x{t}, 1, N) + s{t} * B{t} * Z{t};
                for i = 1:N
                    sample{t}(i).Dec = X{t}(:, i)';
                end

                % step 2: fitness reshaping
                [sample{t}, rank{t}] = Algo.EvaluationAndSort(sample{t}, Prob, t);
                weights{t}(rank{t}) = shape{t};

                % step 3: compute the gradient for x, s, and B
                dx = etax{t} * s{t} * B{t} * (Z{t} * weights{t}');
                JM = (repmat(weights{t}, Prob.D(t), 1) .* Z{t}) * Z{t}' - sum(weights{t}) * eye(Prob.D(t));
                Js = trace(JM) / Prob.D(t);
                ds = 0.5 * etas{t} * Js;
                dB = 0.5 * etaB{t} * (JM - Js * eye(Prob.D(t)));

                % step 4: compute the update
                x{t} = x{t} + dx;
                s{t} = s{t} * exp(ds);
                B{t} = B{t} * expm(dB);
                B{t} = triu(B{t}) + triu(B{t}, 1)'; % enforce symmetry
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
