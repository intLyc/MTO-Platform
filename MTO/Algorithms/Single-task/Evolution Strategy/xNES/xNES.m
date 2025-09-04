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
            if Algo.useN
                N{t} = Prob.N;
            else
                N{t} = fix(4 + 3 * log(Prob.D(t)));
            end
            etax{t} = 1;
            etas{t} = (9 + 3 * log(Prob.D(t))) / (5 * Prob.D(t) * sqrt(Prob.D(t)));
            etaB{t} = etas{t};
            shape{t} = max(0.0, log(N{t} / 2 + 1.0) - log(1:N{t}));
            shape{t} = shape{t} / sum(shape{t}) - 1 / N{t};

            % initialize
            x{t} = mean(unifrnd(zeros(Prob.D(t), N{t}), ones(Prob.D(t), N{t})), 2);
            s{t} = Algo.sigma0;
            B{t} = eye(Prob.D(t)); % B = A/s; A*A' = C = covariance matrix
            weights{t} = zeros(1, N{t});
            for i = 1:N{t}
                sample{t}(i) = Individual();
            end
        end

        taskFE = zeros(1, Prob.T);
        maxTaskFE = Prob.maxFE / Prob.T;
        while Algo.notTerminated(Prob, sample)
            for t = 1:Prob.T
                if taskFE(t) > maxTaskFE
                    continue;
                end
                % step 1: sampling & importance mixing
                Z{t} = randn(Prob.D(t), N{t});
                X{t} = repmat(x{t}, 1, N{t}) + s{t} * B{t} * Z{t};
                for i = 1:N{t}
                    sample{t}(i).Dec = X{t}(:, i)';
                end

                % step 2: fitness reshaping
                [sample{t}, rank{t}] = Algo.EvaluationAndSort(sample{t}, Prob, t);
                taskFE(t) = taskFE(t) + N{t};
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
        % Boundary constraint handling (projection method)
        for i = 1:length(sample)
            sample(i).Dec = max(0, min(1, sample(i).Dec));
        end
        sample = Algo.Evaluation(sample, Prob, t);
        [~, rank] = sortrows([sample.CVs, sample.Objs], [1, 2]);
    end
end
end
