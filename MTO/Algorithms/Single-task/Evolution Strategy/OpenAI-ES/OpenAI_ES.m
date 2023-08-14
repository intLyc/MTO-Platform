classdef OpenAI_ES < Algorithm
% <Single-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Misc{Salimans2017OpenAI-ES,
%   title         = {Evolution Strategies as a Scalable Alternative to Reinforcement Learning},
%   author        = {Tim Salimans and Jonathan Ho and Xi Chen and Szymon Sidor and Ilya Sutskever},
%   year          = {2017},
%   archiveprefix = {arXiv},
%   eprint        = {1703.03864},
%   primaryclass  = {stat.ML},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
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
            alpha{t} = Algo.alpha0;
            sigma{t} = Algo.sigma0;
            x{t} = mean(unifrnd(zeros(max(Prob.D), Prob.N), ones(max(Prob.D), Prob.N)), 2);
            for i = 1:Prob.N
                sample{t}(i) = Individual();
            end
        end

        while Algo.notTerminated(Prob)
            for t = 1:Prob.T
                Z{t} = randn(Prob.D(t), Prob.N);
                X{t} = repmat(x{t}, 1, Prob.N) + sigma{t} * Z{t};
                for i = 1:Prob.N
                    sample{t}(i).Dec = X{t}(:, i)';
                end
                sample{t} = Algo.Evaluation(sample{t}, Prob, t);
                fitness = Algo.getFitness(sample{t});
                A = (fitness - mean(fitness)) / std(fitness);

                xold = x{t};
                x{t} = x{t} + alpha{t} / (Prob.N * sigma{t}) * Z{t} * A;
                if mod(Algo.Gen, Algo.adjustGen) == 0
                    % Adaptive sigma and alpha
                    sigma{t} = min(median(abs(x{t} - xold)), 1);
                    alpha{t} = sigma{t}^2;
                end
                x{t}(x{t} < 0) = 0;
                x{t}(x{t} > 1) = 1;
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
