classdef DES < Algorithm
% <Single-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Arabas2020DES,
%   title      = {Toward a Matrix-Free Covariance Matrix Adaptation Evolution Strategy},
%   author     = {Arabas, Jarosław and Jagodziński, Dariusz},
%   journal    = {IEEE Transactions on Evolutionary Computation},
%   year       = {2020},
%   number     = {1},
%   pages      = {84-98},
%   volume     = {24},
%   doi        = {10.1109/TEVC.2019.2907266},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

methods
    function run(Algo, Prob)
        population = Initialization(Algo, Prob, Individual);
        lambda = Prob.N; % sample points number
        mu = round(lambda / 2); % effective solutions number
        maxn = max(Prob.D);
        for t = 1:Prob.T
            n{t} = Prob.D(t); % dimension
            mDec{t} = initESMean(Prob, t);
            cc{t} = 1 / sqrt(n{t});
            cd{t} = mu / (mu + 2);
            ce{t} = 2 / (n{t}.^2);
            ep{t} = 10e-6;
            p{t} = zeros(1, maxn);
            [~, rank{t}] = sortrows([population{t}.CVs, population{t}.Objs], [1, 2]);
            H{t} = 6 + round(3 * sqrt(n{t}));
            xH{t}(1, :, :) = population{t}(rank{t}(1:mu)).Decs;
            deltaH{t} = zeros(1, maxn);
            pH{t} = zeros(1, maxn);
        end

        while Algo.notTerminated(Prob, population)
            for t = 1:Prob.T
                oldDec = mDec{t};
                mDec{t} = mean(population{t}(rank{t}(1:mu)).Decs);
                delta = mDec{t} - oldDec;
                p{t} = (1 - cc{t}) * p{t} + sqrt(cc{t} * (2 - cc{t}) * mu) * delta;

                offspring = population{t};
                for i = 1:lambda
                    tau(1) = randi(size(xH{t}, 1));
                    tau(2) = randi(size(deltaH{t}, 1));
                    tau(3) = randi(size(pH{t}, 1));
                    A = randperm(mu, 2);
                    vec = reshape(xH{t}(tau(1), A(1), :) - xH{t}(tau(1), A(2), :), 1, maxn);
                    d = sqrt(cd{t} / 2) * vec + ...
                        sqrt(cd{t}) * deltaH{t}(tau(2), :) * randn() + ...
                        sqrt(1 - cd{t}) * pH{t}(tau(3), :) * randn() + ...
                        ep{t} * (1 - ce{t})^(Algo.Gen / 2) * randn(1, maxn);
                    offspring(i).Dec = mDec{t} + d;
                end
                population{t} = offspring;
                population{t} = Algo.Evaluation(population{t}, Prob, t);
                rank{t} = RankWithBoundaryHandling(population{t}, Prob);

                x = [];
                x(1, :, :) = population{t}(rank{t}(1:mu)).Decs;
                xH{t} = [xH{t}; x];
                if size(xH{t}, 1) > H{t}
                    xH{t}(1:end - H{t}, :, :) = [];
                end
                deltaH{t} = [deltaH{t}; delta];
                if size(deltaH{t}, 1) > H{t}
                    deltaH{t}(1:end - H{t}, :) = [];
                end
                pH{t} = [pH{t}; p{t}];
                if size(pH{t}, 1) > H{t}
                    pH{t}(1:end - H{t}, :) = [];
                end
            end
        end
    end
end
end
