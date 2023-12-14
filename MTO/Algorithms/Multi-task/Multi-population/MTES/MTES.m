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
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties (SetAccess = private)
    alpha0 = 0.1
    sigma0 = 0.1
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
        for t = 1:Prob.T
            alpha(t) = Algo.alpha0;
            sigma(t) = Algo.sigma0;
            x(:, t) = mean(unifrnd(zeros(max(Prob.D), Prob.N), ones(max(Prob.D), Prob.N)), 2);
            for i = 1:Prob.N
                sample{t}(i) = Individual();
            end
            shape{t} = max(0.0, log(Prob.N / 2 + 1.0) - log(1:Prob.N));
            shape{t} = shape{t} / sum(shape{t});
        end
        d = zeros(Prob.T);
        for t = 1:Prob.T
            for k = t:Prob.T
                d(t, k) = norm(x(:, t) - x(:, k));
                d(k, t) = d(t, k);
            end
            d0(t) = sum(d(t, :) / (Prob.T - 1));
        end

        while Algo.notTerminated(Prob)
            dold = d;
            xold = x;
            for t = 1:Prob.T
                Z{t} = randn(max(Prob.D), Prob.N);
                X{t} = repmat(x(:, t), 1, Prob.N) + sigma(t) * Z{t};
                for i = 1:Prob.N
                    sample{t}(i).Dec = X{t}(:, i)';
                end
                sample{t} = Algo.Evaluation(sample{t}, Prob, t);
                fitness = Algo.getFitness(sample{t});
                A = (fitness - mean(fitness)) / std(fitness);

                % Calculate transfer coefﬁcient
                m = zeros(1, Prob.T);
                for k = 1:Prob.T
                    if k == t
                        continue;
                    end
                    d(t, k) = norm(xold(:, t) - xold(:, k));
                    m(k) = max(0, dold(t, k) - d(t, k));
                end
                m = m / (sum(m) + d0(t));
                m(t) = 1 - sum(m);

                xtemp = x(:, t);
                x(:, t) = sum(repmat(m, max(Prob.D), 1) .* x, 2) + alpha(t) / (Prob.N * sigma(t)) * Z{t} * A;

                if mod(Algo.Gen, Algo.adjustGen) == 0
                    % Adjust sigma and alpha
                    sigma(t) = min(median(abs(x(:, t) - xtemp)), 1);
                    alpha(t) = sigma(t)^2;
                end
                x(:, t) = min(1, max(0, x(:, t)));
            end
        end
    end

    function fitness = getFitness(Algo, sample)
        %% Boundary Constraint
        boundCVs = zeros(length(sample), 1);
        for i = 1:length(sample)
            % Boundary Constraint Violation
            tempDec = sample(i).Dec;
            tempDec(tempDec < 0) = 0;
            tempDec(tempDec > 1) = 1;
            boundCVs(i) = sum((sample(i).Dec - tempDec).^2);
        end
        CVs = sample.CVs;
        boundCVs(boundCVs > 0) = boundCVs(boundCVs > 0) + max(CVs);
        CVs = CVs + boundCVs;
        fitness =- (1e6 * CVs + sample.Objs);
    end
end
end
