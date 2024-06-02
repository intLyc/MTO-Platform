classdef sep_CMA_ES < Algorithm
% <Single-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @InProceedings{Ros2008sep-CMA-ES,
%   title      = {A Simple Modification in CMA-ES Achieving Linear Time and Space Complexity},
%   author     = {Ros, Raymond and Hansen, Nikolaus},
%   booktitle  = {Parallel Problem Solving from Nature -- PPSN X},
%   year       = {2008},
%   address    = {Berlin, Heidelberg},
%   editor     = {Rudolph, G{\"u}nter and Jansen, Thomas and Beume, Nicola and Lucas, Simon and Poloni, Carlo},
%   pages      = {296--305},
%   publisher  = {Springer Berlin Heidelberg},
%   isbn       = {978-3-540-87700-4},
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
        lambda = Prob.N; % sample points number
        mu = round(lambda / 2); % effective solutions number
        weights = log(mu + 0.5) - log(1:mu);
        weights = weights ./ sum(weights); % weights
        mueff = 1 / sum(weights.^2); % variance effective selection mass
        for t = 1:Prob.T
            n{t} = Prob.D(t); % dimension
            % Step size control parameters
            cs{t} = (mueff + 2) / (n{t} + mueff + 3);
            damps{t} = 1 + cs{t} + 2 * max(sqrt((mueff - 1) / (n{t} + 1)) - 1, 0);
            % Covariance update parameters
            cc{t} = 4 / (4 + n{t});
            ccov{t} = (1 / mueff) * (2 / (n{t} + sqrt(2))^2) + (1 - 1 / mueff) * min(1, (2 * mueff - 1) / ((n{t} + 2)^2 + mueff));
            ccov{t} = (n{t} + 2) / 3 * ccov{t};
            % Initialization
            mDec{t} = mean(unifrnd(zeros(lambda, n{t}), ones(lambda, n{t})));
            ps{t} = zeros(n{t}, 1);
            pc{t} = zeros(n{t}, 1);
            C{t} = ones(n{t}, 1);
            sigma{t} = Algo.sigma0;
            chiN{t} = sqrt(n{t}) * (1 - 1 / (4 * n{t}) + 1 / (21 * n{t}^2));
            hth{t} = (1.4 + 2 / (n{t} + 1)) * chiN{t};
            for i = 1:lambda
                sample{t}(i) = Individual();
            end
        end

        while Algo.notTerminated(Prob, sample)
            for t = 1:Prob.T
                % Sample solutions
                for i = 1:lambda
                    sample{t}(i).Dec = mDec{t} + sigma{t} * (sqrt(C{t}) .* randn(n{t}, 1))';
                end
                [sample{t}, rank] = Algo.EvaluationAndSort(sample{t}, Prob, t);

                % Update mean decision variables
                oldDec = mDec{t};
                mDec{t} = weights * sample{t}(rank(1:mu)).Decs;
                % Update evolution paths
                ps{t} = (1 - cs{t}) * ps{t} + sqrt(cs{t} * (2 - cs{t}) * mueff) * (mDec{t} - oldDec)' ./ sqrt(C{t}) / sigma{t};
                hsig = norm(ps{t}) / sqrt(1 - (1 - cs{t})^(2 * (ceil((Algo.FE - lambda * (t - 1)) / (lambda * Prob.T)) + 1))) < hth{t};
                pc{t} = (1 - cc{t}) * pc{t} + hsig * sqrt(cc{t} * (2 - cc{t}) * mueff) * (mDec{t} - oldDec)' / sigma{t};
                % Update covariance matrix
                artmp = (sample{t}(rank(1:mu)).Decs - repmat(oldDec, mu, 1))' / sigma{t};
                delta = (1 - hsig) * cc{t} * (2 - cc{t});
                C{t} = (1 - ccov{t}) * C{t} + (ccov{t} / mueff) * (pc{t}.^2 + delta * C{t}) + ccov{t} * (1 - 1 / mueff) * artmp.^2 * weights';
                % Update step size
                sigma{t} = sigma{t} * exp(cs{t} / damps{t} * (norm(ps{t}) / chiN{t} - 1));
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
