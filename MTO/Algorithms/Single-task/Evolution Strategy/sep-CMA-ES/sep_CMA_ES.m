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
            n{t} = Prob.D(t); % dimension
            if Algo.useN
                lambda{t} = Prob.N; % sample points number
            else
                lambda{t} = fix(4 + 3 * log(n{t})); % sample points number
            end
            mu{t} = round(lambda{t} / 2); % effective solutions number
            weights{t} = log(mu{t} + 0.5) - log(1:mu{t});
            weights{t} = weights{t} ./ sum(weights{t}); % weights{t}
            mueff{t} = 1 / sum(weights{t}.^2); % variance effective selection mass
            % Step size control parameters
            cs{t} = (mueff{t} + 2) / (n{t} + mueff{t} + 3);
            damps{t} = 1 + cs{t} + 2 * max(sqrt((mueff{t} - 1) / (n{t} + 1)) - 1, 0);
            % Covariance update parameters
            cc{t} = 4 / (4 + n{t});
            ccov{t} = (1 / mueff{t}) * (2 / (n{t} + sqrt(2))^2) + (1 - 1 / mueff{t}) * min(1, (2 * mueff{t} - 1) / ((n{t} + 2)^2 + mueff{t}));
            ccov{t} = (n{t} + 2) / 3 * ccov{t};
            % Initialization
            mDec{t} = rand(1, n{t});
            ps{t} = zeros(n{t}, 1);
            pc{t} = zeros(n{t}, 1);
            C{t} = ones(n{t}, 1);
            sigma{t} = Algo.sigma0;
            chiN{t} = sqrt(n{t}) * (1 - 1 / (4 * n{t}) + 1 / (21 * n{t}^2));
            for i = 1:lambda{t}
                sample{t}(i) = Individual();
            end
            rank{t} = [];
        end

        taskFE = zeros(1, Prob.T);
        maxTaskFE = Prob.maxFE / Prob.T;
        while Algo.notTerminated(Prob, sample)
            for t = 1:Prob.T
                if taskFE(t) > maxTaskFE
                    continue;
                end
                % Sample solutions
                for i = 1:lambda{t}
                    sample{t}(i).Dec = mDec{t} + sigma{t} * (sqrt(C{t}) .* randn(n{t}, 1))';
                end
                sample{t} = Algo.Evaluation(sample{t}, Prob, t);
                rank{t} = RankWithBoundaryHandling(sample{t}, Prob, 'projection');
                taskFE(t) = taskFE(t) + lambda{t};

                % Update mean decision variables
                oldDec = mDec{t};
                mDec{t} = weights{t} * sample{t}(rank{t}(1:mu{t})).Decs;
                % Update evolution paths
                ps{t} = (1 - cs{t}) * ps{t} + sqrt(cs{t} * (2 - cs{t}) * mueff{t}) * (mDec{t} - oldDec)' ./ sqrt(C{t}) / sigma{t};
                hsig = norm(ps{t}) / sqrt(1 - (1 - cs{t})^(2 * taskFE(t) / lambda{t})) / chiN{t} < 1.4 + 2 / (n{t} + 1);
                pc{t} = (1 - cc{t}) * pc{t} + hsig * sqrt(cc{t} * (2 - cc{t}) * mueff{t}) * (mDec{t} - oldDec)' / sigma{t};
                % Update covariance matrix
                artmp = (sample{t}(rank{t}(1:mu{t})).Decs - repmat(oldDec, mu{t}, 1))' / sigma{t};
                delta = (1 - hsig) * cc{t} * (2 - cc{t});
                C{t} = (1 - ccov{t}) * C{t} + (ccov{t} / mueff{t}) * (pc{t}.^2 + delta * C{t}) + ccov{t} * (1 - 1 / mueff{t}) * artmp.^2 * weights{t}';
                % Update step size
                sigma{t} = sigma{t} * exp(cs{t} / damps{t} * (norm(ps{t}) / chiN{t} - 1));
            end
        end
    end
end
end
