classdef SNES < Algorithm
% <Single-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @InProceedings{Schaul2011SNES,
%   title      = {High Dimensions and Heavy Tails for Natural Evolution Strategies},
%   author     = {Schaul, Tom and Glasmachers, Tobias and Schmidhuber, J\"{u}rgen},
%   booktitle  = {Proceedings of the 13th Annual Conference on Genetic and Evolutionary Computation},
%   year       = {2011},
%   pages      = {845–852},
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
            etaS{t} = (3 + log(Prob.D(t))) / (5 * sqrt(Prob.D(t))); % Learning rate
            shape{t} = max(0.0, log(N{t} / 2 + 1.0) - log(1:N{t}));
            shape{t} = shape{t} / sum(shape{t}) - 1 / N{t};

            % initialize
            x{t} = rand(Prob.D(t), 1);
            S{t} = Algo.sigma0 * ones(Prob.D(t), 1); % Sigma vector
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
                X{t} = repmat(x{t}, 1, N{t}) + repmat(S{t}, 1, N{t}) .* Z{t};
                for i = 1:N{t}
                    sample{t}(i).Dec = X{t}(:, i)';
                end

                % step 2: fitness reshaping
                [sample{t}, rank{t}] = Algo.EvaluationAndSort(sample{t}, Prob, t);
                taskFE(t) = taskFE(t) + N{t};
                weights{t}(rank{t}) = shape{t};

                % step 3: compute the gradient for x and S
                dx = etax{t} * S{t} .* (Z{t} * weights{t}');
                dS = 0.5 * etaS{t} * ((Z{t}.^2 - 1) * weights{t}');

                % step 4: compute the update
                x{t} = x{t} + dx;
                S{t} = S{t} .* exp(dS);
            end
        end
    end

    function [sample, rank] = EvaluationAndSort(Algo, sample, Prob, t)
        % boundary constraint handling
        Decs = sample.Decs;
        tempDecs = max(min(Decs, 1), 0);
        boundCVs = sum((Decs - tempDecs).^2, 2);
        sample = Algo.Evaluation(sample, Prob, t);
        [~, rank] = sortrows([sample.CVs, sample.Objs, boundCVs]);
    end
end
end
