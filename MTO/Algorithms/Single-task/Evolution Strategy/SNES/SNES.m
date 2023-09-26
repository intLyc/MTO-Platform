classdef SNES < Algorithm
% <Single-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
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
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
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
            etax{t} = 1;
            etaS{t} = (3 + log(Prob.D(t))) / (5 * sqrt(Prob.D(t))); % Learning rate
            shape{t} = max(0.0, log(Prob.N / 2 + 1.0) - log(1:Prob.N));
            shape{t} = shape{t} / sum(shape{t});

            % initialize
            x{t} = mean(unifrnd(zeros(Prob.D(t), Prob.N), ones(Prob.D(t), Prob.N)), 2);
            S{t} = Algo.sigma0 * ones(Prob.D(t), 1); % Sigma vector
            weights{t} = zeros(1, Prob.N);
            for i = 1:Prob.N
                sample{t}(i) = Individual();
            end
        end

        while Algo.notTerminated(Prob)
            for t = 1:Prob.T
                % step 1: sampling & importance mixing
                Z{t} = randn(Prob.D(t), Prob.N);
                X{t} = repmat(x{t}, 1, Prob.N) + repmat(S{t}, 1, Prob.N) .* Z{t};
                for i = 1:Prob.N
                    sample{t}(i).Dec = X{t}(:, i)';
                end

                % step 2: fitness reshaping
                rank{t} = Algo.EvaluationAndSort(sample{t}, Prob, t);
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
