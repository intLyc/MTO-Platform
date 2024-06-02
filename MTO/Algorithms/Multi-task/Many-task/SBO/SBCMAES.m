classdef SBCMAES < Algorithm
% <Many-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Liaw2019SBO,
%   title      = {Evolutionary Manytasking Optimization Based on Symbiosis in Biocoenosis},
%   author     = {Liaw, Rung-Tzuo and Ting, Chuan-Kang},
%   journal    = {Proceedings of the AAAI Conference on Artificial Intelligence},
%   year       = {2019},
%   month      = {Jul.},
%   number     = {01},
%   pages      = {4295-4303},
%   volume     = {33},
%   doi        = {10.1609/aaai.v33i01.33014295},
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
    Benefit = 0.25
    Harm = 0.5
    sigma0 = 0.3
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'Benefit: Beneficial factor', num2str(Algo.Benefit), ...
                'Harm: Harmful factor', num2str(Algo.Harm), ...
                'sigma0', num2str(Algo.sigma0)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.Benefit = str2double(Parameter{i}); i = i + 1;
        Algo.Harm = str2double(Parameter{i}); i = i + 1;
        Algo.sigma0 = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        D = max(Prob.D);
        lambda = Prob.N;
        mu = round(lambda / 2); % effective solutions number
        weights = log(mu + 0.5) - log(1:mu);
        weights = weights ./ sum(weights); % weights
        mueff = 1 / sum(weights.^2); % variance effective selection mass
        chiN = sqrt(D) * (1 - 1 / (4 * D) + 1 / (21 * D^2));
        hth = (1.4 + 2 / (D + 1)) * chiN;
        for t = 1:Prob.T
            % Step size control parameters
            cs{t} = (mueff + 2) / (D + mueff + 5);
            damps{t} = 1 + cs{t} + 2 * max(sqrt((mueff - 1) / (D + 1)) - 1, 0);
            % Covariance update parameters
            cc{t} = (4 + mueff / D) / (4 + D + 2 * mueff / D);
            c1{t} = 2 / ((D + 1.3)^2 + mueff);
            cmu{t} = min(1 - c1{t}, 2 * (mueff - 2 + 1 / mueff) / ((D + 2)^2 + 2 * mueff / 2));
            % Initialization
            ps{t} = zeros(D, 1);
            pc{t} = zeros(D, 1);
            MB{t} = eye(D, D);
            MD{t} = ones(D, 1);
            C{t} = MB{t} * diag(MD{t}.^2) * MB{t}';
            invsqrtC{t} = MB{t} * diag(MD{t}.^-1) * MB{t}';
            sigma{t} = Algo.sigma0;
            eigenFE{t} = 0;
        end

        % Initialization
        population = Initialization(Algo, Prob, IndividualSBO);
        for t = 1:Prob.T
            [~, rank] = sortrows([population{t}.CVs, population{t}.Objs], [1, 2]);
            for i = 1:length(population{t})
                population{t}(rank(i)).rankO = i;
                population{t}(rank(i)).MFFactor = t;
                population{t}(rank(i)).BelongT = t;
            end
            mDec{t} = weights * population{t}(rank(1:mu)).Decs;
        end

        RIJ = 0.5 * ones(Prob.T, Prob.T); % transfer rates
        MIJ = ones(Prob.T, Prob.T); % Benefit and Benefit
        NIJ = ones(Prob.T, Prob.T); % neutral and neutral
        CIJ = ones(Prob.T, Prob.T); % Harm and Harm
        OIJ = ones(Prob.T, Prob.T); % neutral and Benefit
        PIJ = ones(Prob.T, Prob.T); % Benefit and Harm
        AIJ = ones(Prob.T, Prob.T); % Harm and neutral

        while Algo.notTerminated(Prob, population)
            offspring = population;
            for t = 1:Prob.T
                % generation
                for i = 1:length(population{t})
                    offspring{t}(i).Dec = mDec{t} + sigma{t} * (MB{t} * (MD{t} .* randn(D, 1)))';
                    offspring{t}(i).MFFactor = t;
                    offspring{t}(i).BelongT = t;
                    offspring{t}(i).rankO = population{t}(i).rankO;
                end
            end

            for t = 1:Prob.T
                % knowledge transfer
                [~, transfer_task] = max(RIJ(t, [1:t - 1, t + 1:end])); % find transferred task
                if transfer_task >= t
                    transfer_task = transfer_task + 1;
                end
                if rand() < RIJ(t, transfer_task)
                    Si = floor(lambda * RIJ(t, transfer_task)); % transfer quantity
                    ind1 = randperm(lambda, Si);
                    ind2 = randperm(lambda, Si);
                    for i = 1:Si
                        offspring{t}(ind1(i)).Dec = offspring{transfer_task}(ind2(i)).Dec;
                        offspring{t}(ind1(i)).BelongT = transfer_task;
                    end
                end

                % Evaluation
                offspring{t} = Algo.Evaluation(offspring{t}, Prob, t);
                [~, rank] = sortrows([offspring{t}.CVs, offspring{t}.Objs], [1, 2]);
                for i = 1:length(rank)
                    offspring{t}(rank(i)).rankC = i;
                end

                % Update CMA variables
                % Update mean decision variables
                oldDec = mDec{t};
                mDec{t} = weights * offspring{t}(rank(1:mu)).Decs;
                % Update evolution paths
                ps{t} = (1 - cs{t}) * ps{t} + sqrt(cs{t} * (2 - cs{t}) * mueff) * invsqrtC{t} * (mDec{t} - oldDec)' / sigma{t};
                hsig = norm(ps{t}) / sqrt(1 - (1 - cs{t})^(2 * (ceil((Algo.FE - lambda * (t - 1)) / (lambda * Prob.T)) + 1))) < hth;
                pc{t} = (1 - cc{t}) * pc{t} + hsig * sqrt(cc{t} * (2 - cc{t}) * mueff) * (mDec{t} - oldDec)' / sigma{t};
                % Update covariance matrix
                artmp = (offspring{t}(rank(1:mu)).Decs - repmat(oldDec, mu, 1))' / sigma{t};
                delta = (1 - hsig) * cc{t} * (2 - cc{t});
                C{t} = (1 - c1{t} - cmu{t}) * C{t} + c1{t} * (pc{t} * pc{t}' + delta * C{t}) + cmu{t} * artmp * diag(weights) * artmp';
                % Update step size
                sigma{t} = sigma{t} * exp(cs{t} / damps{t} * (norm(ps{t}) / chiN - 1));

                if (Algo.FE - lambda * (t - 1)) - eigenFE{t} > (lambda * Prob.T) / (c1{t} + cmu{t}) / D / 10 % to achieve O(N^2)
                    eigenFE{t} = Algo.FE;
                    restart = false;
                    if ~(all(~isnan(C{t}), 'all') && all(~isinf(C{t}), 'all'))
                        restart = true;
                    else
                        C{t} = triu(C{t}) + triu(C{t}, 1)'; % enforce symmetry
                        [MB{t}, MD{t}] = eig(C{t}); % eigen decomposition, B==normalized eigenvectors
                        if min(diag(MD{t})) < 0
                            restart = true;
                        else
                            MD{t} = sqrt(diag(MD{t})); % D contains standard deviations now
                        end
                    end
                    if restart
                        ps{t} = zeros(D, 1);
                        pc{t} = zeros(D, 1);
                        MB{t} = eye(D, D);
                        MD{t} = ones(D, 1);
                        C{t} = MB{t} * diag(MD{t}.^2) * MB{t}';
                        sigma{t} = min(max(2 * sigma{t}, 0.01), 0.3);
                    end
                    invsqrtC{t} = MB{t} * diag(MD{t}.^-1) * MB{t}';
                end

                % selection
                population{t} = [population{t}, offspring{t}];
                [~, rank] = sortrows([population{t}.CVs, population{t}.Objs], [1, 2]);
                population{t} = population{t}(rank(1:lambda));
                rank = 1:lambda;
                for i = 1:length(rank)
                    population{t}(rank(i)).rankO = i;
                end
            end

            for t = 1:Prob.T
                % update symbiosis
                idx = find([offspring{t}.BelongT] ~= t);
                rankC = [offspring{t}(idx).rankC];
                rankO = [offspring{t}(idx).rankO];
                for k = 1:length(idx)
                    if rankC(k) < lambda * Algo.Benefit
                        if rankO(k) < lambda * Algo.Benefit
                            MIJ(t, offspring{t}(idx(k)).BelongT) = MIJ(t, offspring{t}(idx(k)).BelongT) + 1;
                        elseif rankO(k) > lambda * (1 - Algo.Harm)
                            PIJ(t, offspring{t}(idx(k)).BelongT) = PIJ(t, offspring{t}(idx(k)).BelongT) + 1;
                        else
                            OIJ(t, offspring{t}(idx(k)).BelongT) = OIJ(t, offspring{t}(idx(k)).BelongT) + 1;
                        end
                    elseif rankC(k) > lambda * (1 - Algo.Harm)
                        if rankO(k) > lambda * (1 - Algo.Harm)
                            CIJ(t, offspring{t}(idx(k)).BelongT) = CIJ(t, offspring{t}(idx(k)).BelongT) + 1;
                        end
                    else
                        if rankO(k) > lambda * (1 - Algo.Harm)
                            AIJ(t, offspring{t}(idx(k)).BelongT) = AIJ(t, offspring{t}(idx(k)).BelongT) + 1;
                        elseif rankO(k) >= lambda * Algo.Benefit && rankO(k) <= lambda * (1 - Algo.Harm)
                            NIJ(t, offspring{t}(idx(k)).BelongT) = NIJ(t, offspring{t}(idx(k)).BelongT) + 1;
                        end
                    end
                end
            end
            % update transfer rates
            RIJ = (MIJ + OIJ + PIJ) ./ (MIJ + OIJ + PIJ + AIJ + CIJ + NIJ);
        end
    end
end
end
