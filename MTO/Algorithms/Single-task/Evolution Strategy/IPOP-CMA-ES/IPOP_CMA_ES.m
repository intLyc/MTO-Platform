classdef IPOP_CMA_ES < Algorithm
% <Single-task> <Single-objective> <None>

%------------------------------- Reference --------------------------------
% @InProceedings{Auger2005IPOP-CMA-ES,
%   title     = {A Restart CMA Evolution Strategy with Increasing Population Size},
%   author    = {Auger, A. and Hansen, N.},
%   booktitle = {2005 IEEE Congress on Evolutionary Computation},
%   year      = {2005},
%   pages     = {1769-1776 Vol. 2},
%   volume    = {2},
%   doi       = {10.1109/CEC.2005.1554902},
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
        for t = 1:Prob.T
            n{t} = Prob.D(t); % dimension
            lambda{t} = fix(4 + 3 * log(n{t})); % sample points number
            mu{t} = round(lambda{t} / 2); % effective solutions number
            weights{t} = log(mu{t} + 0.5) - log(1:mu{t});
            weights{t} = weights{t} ./ sum(weights{t}); % weights{t}
            mueff{t} = 1 / sum(weights{t}.^2); % variance effective selection mass
            % Step size control parameters
            cs{t} = (mueff{t} + 2) / (n{t} + mueff{t} + 5);
            damps{t} = 1 + cs{t} + 2 * max(sqrt((mueff{t} - 1) / (n{t} + 1)) - 1, 0);
            % Covariance update parameters
            cc{t} = (4 + mueff{t} / n{t}) / (4 + n{t} + 2 * mueff{t} / n{t});
            c1{t} = 2 / ((n{t} + 1.3)^2 + mueff{t});
            cmu{t} = min(1 - c1{t}, 2 * (mueff{t} - 2 + 1 / mueff{t}) / ((n{t} + 2)^2 + 2 * mueff{t} / 2));
            % Initialization
            mDec{t} = rand(1, n{t});
            ps{t} = zeros(n{t}, 1);
            pc{t} = zeros(n{t}, 1);
            B{t} = eye(n{t}, n{t});
            D{t} = ones(n{t}, 1);
            C{t} = B{t} * diag(D{t}.^2) * B{t}';
            invsqrtC{t} = B{t} * diag(D{t}.^-1) * B{t}';
            sigma{t} = Algo.sigma0;
            eigenFE{t} = 0;
            chiN{t} = sqrt(n{t}) * (1 - 1 / (4 * n{t}) + 1 / (21 * n{t}^2));
            hth{t} = (1.4 + 2 / (n{t} + 1)) * chiN{t};
            for i = 1:lambda{t}
                sample{t}(i) = Individual();
            end
            rank{t} = [];
            ObjHist{t} = [];
        end

        taskFE = zeros(1, Prob.T);
        maxTaskFE = Prob.maxFE / Prob.T;
        while Algo.notTerminated(Prob)
            for t = 1:Prob.T
                if taskFE(t) > maxTaskFE
                    continue;
                end
                % Sample solutions
                for i = 1:lambda{t}
                    sample{t}(i).Dec = mDec{t} + sigma{t} * (B{t} * (D{t} .* randn(n{t}, 1)))';
                end
                [sample{t}, rank{t}] = Algo.EvaluationAndSort(sample{t}, Prob, t);
                if isempty(ObjHist{t})
                    ObjHist{t} = sample{t}(rank{t}(1)).Obj;
                else
                    ObjHist{t} = [ObjHist{t}, min(ObjHist{t}(end), sample{t}(rank{t}(1)).Obj)];
                end
                taskFE(t) = taskFE(t) + lambda{t};

                % Update mean decision variables
                oldDec = mDec{t};
                mDec{t} = weights{t} * sample{t}(rank{t}(1:mu{t})).Decs;
                % Update evolution paths
                ps{t} = (1 - cs{t}) * ps{t} + sqrt(cs{t} * (2 - cs{t}) * mueff{t}) * invsqrtC{t} * (mDec{t} - oldDec)' / sigma{t};
                hsig = norm(ps{t}) / sqrt(1 - (1 - cs{t})^(2 * (ceil((Algo.FE - lambda{t} * (t - 1)) / (lambda{t} * Prob.T)) + 1))) < hth{t};
                pc{t} = (1 - cc{t}) * pc{t} + hsig * sqrt(cc{t} * (2 - cc{t}) * mueff{t}) * (mDec{t} - oldDec)' / sigma{t};
                % Update covariance matrix
                artmp = (sample{t}(rank{t}(1:mu{t})).Decs - repmat(oldDec, mu{t}, 1))' / sigma{t};
                delta = (1 - hsig) * cc{t} * (2 - cc{t});
                C{t} = (1 - c1{t} - cmu{t}) * C{t} + c1{t} * (pc{t} * pc{t}' + delta * C{t}) + cmu{t} * artmp * diag(weights{t}) * artmp';
                % Update step size
                sigma{t} = sigma{t} * exp(cs{t} / damps{t} * (norm(ps{t}) / chiN{t} - 1));

                if (Algo.FE - lambda{t} * (t - 1)) - eigenFE{t} > (lambda{t} * Prob.T) / (c1{t} + cmu{t}) / n{t} / 10 % to achieve O(N^2)
                    eigenFE{t} = Algo.FE;
                    C{t} = triu(C{t}) + triu(C{t}, 1)'; % enforce symmetry
                    [B{t}, D{t}] = eig(C{t}); % eigen decomposition, B==normalized eigenvectors
                    D{t} = sqrt(diag(D{t})); % D contains standard deviations now
                    invsqrtC{t} = B{t} * diag(D{t}.^-1) * B{t}';
                end

                % Restart strategy IPOP
                preGen = 10 + (30 * fix(n{t} / lambda{t}));
                ObjHist{t} = ObjHist{t}(max(1, length(ObjHist{t}) - preGen):end);
                ObjList = [ObjHist{t}, [sample{t}.Objs]'];
                if all(sigma{t} * (max(abs(pc{t}), sqrt(diag(C{t})))) < 1e-12 * Algo.sigma0) || ...
                        any(sigma{t} * sqrt(diag(C{t})) > 1e8) || ...
                        sigma{t} * max(D{t}) == 0 || ...
                        max(ObjList) - min(ObjList) < 1e-12
                    mDec{t} = rand(1, n{t});
                    sigma{t} = Algo.sigma0;
                    lambda{t} = lambda{t} * 2;
                    mu{t} = round(lambda{t} / 2); % effective solutions number
                    weights{t} = log(mu{t} + 0.5) - log(1:mu{t});
                    weights{t} = weights{t} ./ sum(weights{t}); % weights{t}
                    mueff{t} = 1 / sum(weights{t}.^2); % variance effective selection mass
                    cs{t} = (mueff{t} + 2) / (n{t} + mueff{t} + 5);
                    damps{t} = 1 + cs{t} + 2 * max(sqrt((mueff{t} - 1) / (n{t} + 1)) - 1, 0);
                    cc{t} = (4 + mueff{t} / n{t}) / (4 + n{t} + 2 * mueff{t} / n{t});
                    c1{t} = 2 / ((n{t} + 1.3)^2 + mueff{t});
                    cmu{t} = min(1 - c1{t}, 2 * (mueff{t} - 2 + 1 / mueff{t}) / ((n{t} + 2)^2 + 2 * mueff{t} / 2));
                    ObjHist{t} = [];
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
