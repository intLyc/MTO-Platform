classdef OpenAI_ES < Algorithm
% <Single-task> <Single-objective> <None>

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

methods
    function run(Algo, Prob)
        for t = 1:Prob.T
            sigma{t} = 0.1;
            alpha{t} = 0.01;
            x{t} = unifrnd(zeros(Prob.D(t), 1), ones(Prob.D(t), 1));
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
                if mod(Algo.Gen, 100) == 0
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
        fitness =- (sample.Objs +1e-6 * boundCVs);
    end
end
end
