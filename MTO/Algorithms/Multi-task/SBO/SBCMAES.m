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
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
%--------------------------------------------------------------------------

properties (SetAccess = private)
    Benefit = 0.25
    Harm = 0.5
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'Benefit: Beneficial factor', num2str(Algo.Benefit), ...
                'Harm: Harmful factor', num2str(Algo.Harm)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.Benefit = str2double(Parameter{i}); i = i + 1;
        Algo.Harm = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        D = max(Prob.D);
        mu = round(Prob.N / 2); % effective solutions number
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
            sigma{t} = 0.1;
            eigenFE{t} = 0;
        end

        % Initialization
        population_temp = Initialization(Algo, Prob, IndividualSBO);
        population = IndividualSBO.empty();
        for t = 1:Prob.T
            [~, rank] = sortrows([population_temp{t}.CVs, population_temp{t}.Objs], [1, 2]);
            for i = 1:length(population_temp{t})
                population_temp{t}(rank(i)).rankO = i;
                population_temp{t}(rank(i)).MFFactor = t;
                population_temp{t}(rank(i)).BelongT = t;
            end
            mDec{t} = weights * population_temp{t}(rank(1:mu)).Decs;
            population = [population, population_temp{t}];
        end

        RIJ = 0.5 * ones(Prob.T, Prob.T); % transfer rates
        MIJ = ones(Prob.T, Prob.T); % Benefit and Benefit
        NIJ = ones(Prob.T, Prob.T); % neutral and neutral
        CIJ = ones(Prob.T, Prob.T); % Harm and Harm
        OIJ = ones(Prob.T, Prob.T); % neutral and Benefit
        PIJ = ones(Prob.T, Prob.T); % Benefit and Harm
        AIJ = ones(Prob.T, Prob.T); % Harm and neutral

        while Algo.notTerminated(Prob)
            offspring = IndividualSBO.empty();
            for t = 1:Prob.T
                t_idx = [population.MFFactor] == t;
                find_idx = find(t_idx);
                % Sample solutions
                for i = 1:Prob.N
                    offspring_t(i) = IndividualSBO();
                    offspring_t(i).Dec = mDec{t} + sigma{t} * (MB{t} * (MD{t} .* randn(D, 1)))';

                    offspring_t(i).MFFactor = t;
                    offspring_t(i).BelongT = t;
                    offspring_t(i).rankO = population(find_idx(i)).rankO;
                end
                offspring = [offspring, offspring_t];
            end

            for t = 1:Prob.T
                t_idx = [offspring.MFFactor] == t;
                find_idx = find(t_idx);
                % knowledge transfer
                [~, transfer_task] = max(RIJ(t, [1:t - 1, t + 1:end])); % find transferred task
                if transfer_task >= t
                    transfer_task = transfer_task + 1;
                end
                if rand() < RIJ(t, transfer_task)
                    Si = floor(Prob.N * RIJ(t, transfer_task)); % transfer quantity
                    ind1 = randperm(Prob.N, Si);
                    ind2 = randperm(Prob.N, Si);
                    this_pos = find(t_idx);
                    trans_pos = find([offspring.MFFactor] == transfer_task);
                    for i = 1:Si
                        offspring(this_pos(ind1(i))).Dec = offspring(trans_pos(ind2(i))).Dec;
                        offspring(this_pos(ind1(i))).BelongT = transfer_task;
                    end
                end

                % Evaluation
                offspring(t_idx) = Algo.Evaluation(offspring(t_idx), Prob, t);

                [~, rank] = sortrows([offspring(t_idx).CVs, offspring(t_idx).Objs], [1, 2]);
                for i = 1:length(rank)
                    offspring(find_idx(rank(i))).rankC = i;
                end

                offspring_t = offspring(t_idx);
                % Update mean decision variables
                oldDec = mDec{t};
                mDec{t} = weights * offspring_t(rank(1:mu)).Decs;
                % Update evolution paths
                ps{t} = (1 - cs{t}) * ps{t} + sqrt(cs{t} * (2 - cs{t}) * mueff) * invsqrtC{t} * (mDec{t} - oldDec)' / sigma{t};
                hsig = norm(ps{t}) / sqrt(1 - (1 - cs{t})^(2 * (ceil((Algo.FE - Prob.N * (t - 1)) / (Prob.N * Prob.T)) + 1))) < hth;
                pc{t} = (1 - cc{t}) * pc{t} + hsig * sqrt(cc{t} * (2 - cc{t}) * mueff) * (mDec{t} - oldDec)' / sigma{t};
                % Update covariance matrix
                artmp = (offspring_t(rank(1:mu)).Decs - repmat(oldDec, mu, 1))' / sigma{t};
                delta = (1 - hsig) * cc{t} * (2 - cc{t});
                C{t} = (1 - c1{t} - cmu{t}) * C{t} + c1{t} * (pc{t} * pc{t}' + delta * C{t}) + cmu{t} * artmp * diag(weights) * artmp';
                % Update step size
                sigma{t} = sigma{t} * exp(cs{t} / damps{t} * (norm(ps{t}) / chiN - 1))^0.3;

                if (Algo.FE - Prob.N * (t - 1)) - eigenFE{t} > (Prob.N * Prob.T) / (c1{t} + cmu{t}) / D / 10 % to achieve O(N^2)
                    eigenFE{t} = Algo.FE;
                    C{t} = triu(C{t}) + triu(C{t}, 1)'; % enforce symmetry
                    [MB{t}, MD{t}] = eig(C{t}); % eigen decomposition, B==normalized eigenvectors
                    if min(diag(MD{t})) < 0
                        error('The covariance matrix is not positive definite!')
                    end
                    MD{t} = sqrt(diag(MD{t})); % D contains standard deviations now
                    invsqrtC{t} = MB{t} * diag(MD{t}.^-1) * MB{t}';
                end

                % selection
                population_temp = [population(t_idx), offspring(t_idx)];
                [~, rank] = sortrows([population_temp.CVs, population_temp.Objs], [1, 2]);
                population(t_idx) = population_temp(rank(1:Prob.N));
                [~, rank] = sortrows([population(t_idx).CVs, population(t_idx).Objs], [1, 2]);
                for i = 1:length(rank)
                    population(find_idx(rank(i))).rankO = i;
                end
            end

            for t = 1:Prob.T
                % update symbiosis
                t_idx = find([offspring.MFFactor] == t & [offspring.BelongT] ~= t);
                find_idx = find(t_idx);
                rankC = [offspring(t_idx).rankC];
                rankO = [offspring(t_idx).rankO];
                for k = 1:length(t_idx)
                    if rankC(k) < Prob.N * Algo.Benefit
                        if rankO(k) < Prob.N * Algo.Benefit
                            MIJ(t, offspring(find_idx(k)).BelongT) = MIJ(t, offspring(find_idx(k)).BelongT) + 1;
                        elseif rankO(k) > Prob.N * (1 - Algo.Harm)
                            PIJ(t, offspring(find_idx(k)).BelongT) = PIJ(t, offspring(find_idx(k)).BelongT) + 1;
                        else
                            OIJ(t, offspring(find_idx(k)).BelongT) = OIJ(t, offspring(find_idx(k)).BelongT) + 1;
                        end
                    elseif rankC(k) > Prob.N * (1 - Algo.Harm)
                        if rankO(k) > Prob.N * (1 - Algo.Harm)
                            CIJ(t, offspring(find_idx(k)).BelongT) = CIJ(t, offspring(find_idx(k)).BelongT) + 1;
                        end
                    else
                        if rankO(k) > Prob.N * (1 - Algo.Harm)
                            AIJ(t, offspring(find_idx(k)).BelongT) = AIJ(t, offspring(find_idx(k)).BelongT) + 1;
                        elseif rankO(k) >= Prob.N * Algo.Benefit && rankO(k) <= Prob.N * (1 - Algo.Harm)
                            NIJ(t, offspring(find_idx(k)).BelongT) = NIJ(t, offspring(find_idx(k)).BelongT) + 1;
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
