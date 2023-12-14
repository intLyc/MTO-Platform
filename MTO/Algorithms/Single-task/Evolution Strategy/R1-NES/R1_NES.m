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
        normalize = @(v) v / sqrt(v' * v);
        for t = 1:Prob.T
            etax{t} = 1;
            etaa{t} = 0.1; % learning rate for the scale factor
            etac{t} = 0.1; % primary representation is <a,c,v>
            shape{t} = max(0.0, log(N / 2 + 1.0) - log(1:N));
            shape{t} = shape{t} / sum(shape{t}) - 1 / N;

            % initialize
            x{t} = mean(unifrnd(zeros(Prob.D(t), N), ones(Prob.D(t), N)), 2);
            a{t} = log(Algo.sigma0); % fixed diagonal strength
            c{t} = 0;
            v{t} = normalize(randn(Prob.D(t), 1));
            r{t} = exp(c{t});
            u{t} = r{t} * v{t};

            weights{t} = zeros(1, N);
            for i = 1:N
                sample{t}(i) = Individual();
            end
        end

        while Algo.notTerminated(Prob)
            for t = 1:Prob.T
                % step 1: sampling
                W{t} = randn(Prob.D(t), N) + u{t} * randn(1, N);
                X{t} = repmat(x{t}, 1, N) + exp(a{t}) * W{t};
                for i = 1:N
                    sample{t}(i).Dec = X{t}(:, i)';
                end

                % step 2: fitness reshaping
                rank{t} = Algo.EvaluationAndSort(sample{t}, Prob, t);
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

    function rank = EvaluationAndSort(Algo, sample, Prob, t)
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
