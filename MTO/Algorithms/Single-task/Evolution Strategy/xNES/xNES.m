classdef xNES < Algorithm
% <Single-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Wierstra2014Natural,
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
            etaA{t} = 0.5 * min(1.0 / Prob.D(t), 0.25);
            shape{t} = max(0.0, log(Prob.N / 2 + 1.0) - log(1:Prob.N));
            shape{t} = shape{t} / sum(shape{t});

            % initialize
            x{t} = mean(unifrnd(zeros(Prob.D(t), Prob.N), ones(Prob.D(t), Prob.N)), 2); % expectation
            A{t} = Algo.sigma0 * eye(Prob.D(t)); % A*A' = C = covariance matrix
            weights{t} = zeros(1, Prob.N);
            for i = 1:Prob.N
                sample{t}(i) = Individual();
            end
        end

        while Algo.notTerminated(Prob)
            for t = 1:Prob.T
                % step 1: sampling & importance mixing
                Z{t} = randn(Prob.D(t), Prob.N);
                X{t} = repmat(x{t}, 1, Prob.N) + A{t} * Z{t};
                for i = 1:Prob.N
                    sample{t}(i).Dec = X{t}(:, i)';
                end

                % step 2: fitness reshaping
                rank{t} = Algo.EvaluationAndSort(sample{t}, Prob, t);
                weights{t}(rank{t}) = shape{t};

                % step 3: compute the gradient for x and A
                dx = etax{t} * A{t} * (Z{t} * weights{t}');
                dA = etaA{t} * ((repmat(weights{t}, Prob.D(t), 1) .* Z{t}) * Z{t}' - sum(weights{t}) * eye(Prob.D(t)));

                % step 4: compute the update
                x{t} = x{t} + dx;
                A{t} = A{t} * expm(dA);
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
