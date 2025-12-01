classdef R1_NES < Algorithm
% <Single-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @InProceedings{Sun2013R1-NES,
%   title     = {A Linear Time Natural Evolution Strategy for Non-Separable Functions},
%   author    = {Sun, Yi and Schaul, Tom and Gomez, Faustino and Schmidhuber, J\"{u}rgen},
%   booktitle = {Proceedings of the 15th Annual Conference Companion on Genetic and Evolutionary Computation},
%   year      = {2013},
%   pages     = {61–62},
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
        normalize = @(v) v / sqrt(v' * v);
        for t = 1:Prob.T
            if Algo.useN
                N{t} = Prob.N;
            else
                N{t} = fix(4 + 3 * log(Prob.D(t)));
            end
            etax{t} = 1;
            etaa{t} = 0.1; % learning rate for the scale factor
            etac{t} = 0.1; % primary representation is <a,c,v>
            shape{t} = max(0.0, log(N{t} / 2 + 1.0) - log(1:N{t}));
            shape{t} = shape{t} / sum(shape{t}) - 1 / N{t};

            % initialize
            x{t} = rand(Prob.D(t), 1);
            a{t} = log(Algo.sigma0); % fixed diagonal strength
            c{t} = 0;
            v{t} = normalize(randn(Prob.D(t), 1));
            r{t} = exp(c{t});
            u{t} = r{t} * v{t};

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
                % step 1: sampling
                W{t} = randn(Prob.D(t), N{t}) + u{t} * randn(1, N{t});
                X{t} = repmat(x{t}, 1, N{t}) + exp(a{t}) * W{t};
                for i = 1:N{t}
                    sample{t}(i).Dec = X{t}(:, i)';
                end

                % step 2: fitness reshaping
                sample{t} = Algo.Evaluation(sample{t}, Prob, t);
                rank{t} = RankWithBoundaryHandling(sample{t}, Prob);
                taskFE(t) = taskFE(t) + N{t};
                weights{t}(rank{t}) = shape{t};

                % step 3: compute the gradient
                dx = exp(a{t}) * sum(repmat(weights{t}, Prob.D(t), 1) .* W{t}, 2);
                v{t} = u{t} / r{t};
                W{t} = W{t}(:, weights{t} ~= 0);
                weights{t} = weights{t}(weights{t} ~= 0);

                wws = sum(W{t}.^2, 1);
                wvs = v{t}' * W{t};
                kp1 = ((r{t}^2 - Prob.D(t) + 2) * (wvs.^2) - (r{t}^2 + 1) * wws) / (2 * r{t} * (Prob.D(t) - 1));
                kp2 = wvs / r{t};

                da = 1 / (2 * (Prob.D(t) - 1)) * ((wws - Prob.D(t)) - (wvs.^2 - 1)) * weights{t}';
                du = (kp1 * weights{t}') * v{t} + W{t} * (kp2 .* weights{t})';
                dc = (du' * v{t}) / r{t};
                dv = du / r{t} - dc * v{t};

                % step 4: compute the update
                x{t} = x{t} + etax{t} * dx;
                a{t} = a{t} + etaa{t} * da;

                r{t} = sqrt(u{t}' * u{t});
                eps = min(etac{t}, 2 * sqrt(r{t}^2 / (du' * du))); % prevent the update from getting crazy
                if dc > 0 % additive
                    u{t} = u{t} + eps * du;
                else % multiplicative
                    r{t} = r{t} * exp(eps * dc);
                    v{t} = normalize(u{t} / r{t} + eps * dv);
                    u{t} = r{t} * v{t};
                end
            end
        end
    end
end
end
