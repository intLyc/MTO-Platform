classdef xNES_as < Algorithm
% <Single-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @InProceedings{Schaul2012xNES-as,
%   title      = {Benchmarking Natural Evolution Strategies with Adaptation Sampling on the Noiseless and Noisy Black-Box Optimization Testbeds},
%   author     = {Schaul, Tom},
%   booktitle  = {Proceedings of the 14th Annual Conference Companion on Genetic and Evolutionary Computation},
%   year       = {2012},
%   pages      = {229–236},
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
            if Algo.useN
                N{t} = Prob.N;
            else
                N{t} = fix(4 + 3 * log(Prob.D(t)));
            end
            etax{t} = 1;
            etas0{t} = (9 + 3 * log(Prob.D(t))) / (5 * Prob.D(t) * sqrt(Prob.D(t)));
            etas{t} = etas0{t};
            etaB{t} = etas{t};
            shape{t} = max(0.0, log(N{t} / 2 + 1.0) - log(1:N{t}));
            shape{t} = shape{t} / sum(shape{t}) - 1 / N{t};

            % initialize
            x{t} = initESMean(Prob, t)';
            Algo.Mean{t} = x{t}';
            s{t} = Algo.sigma0 * initESSigmaScale(Prob);
            vs{t} = s{t};
            B{t} = eye(Prob.D(t)); % B = A/s; A*A' = C = covariance matrix
            weights{t} = zeros(1, N{t});
            for i = 1:N{t}
                sample{t}(i) = Individual();
                sample2{t}(i) = Individual();
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
                sample{t} = Algo.Evaluation(sample{t}, Prob, t);
                rank{t} = RankWithBoundaryHandling(sample{t}, Prob);
                taskFE(t) = taskFE(t) + N{t};
                weights{t}(rank{t}) = shape{t};

                % as: adaptation sampling
                vX = repmat(x{t}, 1, N{t}) + vs{t} * B{t} * Z{t};
                w = mvnpdf(X{t}', x{t}', s{t} * B{t} * B{t}') ...
                    ./ mvnpdf(vX', x{t}', vs{t} * B{t} * B{t}');
                [~, rank_temp] = sort(rank{t});
                try
                    if ranksum(rank_temp, w .* rank_temp) < 0.5 - 1 / (3 * Prob.D(t) + 1)
                        etas{t} = 0.9 * etas{t} + 0.1 * etas0{t};
                    else
                        etas{t} = min(1, 1.1 * etas{t});
                    end
                end

                % step 3: compute the gradient for x, s, and B
                dx = etax{t} * s{t} * B{t} * (Z{t} * weights{t}');
                JM = (repmat(weights{t}, Prob.D(t), 1) .* Z{t}) * Z{t}' - sum(weights{t}) * eye(Prob.D(t));
                Js = trace(JM) / Prob.D(t);
                ds = 0.5 * etas{t} * Js;
                dB = 0.5 * etaB{t} * (JM - Js * eye(Prob.D(t)));

                % step 4: compute the update
                x{t} = x{t} + dx;
                Algo.Mean{t} = x{t}';
                vs{t} = s{t} * exp(1.5 * ds);
                s{t} = s{t} * exp(ds);
                B{t} = B{t} * expm(dB);
                B{t} = triu(B{t}) + triu(B{t}, 1)'; % enforce symmetry
            end
        end
    end
end
end
