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
        % Number of parents
        mu = round(Prob.N / 2);
        % Parent weights
        w = log(mu + 0.5) - log(1:mu);
        w = w ./ sum(w);
        % Number of effective solutions
        mu_eff = 1 / sum(w.^2);
        D = max(Prob.D);
        for t = 1:Prob.T
            % Step size control parameters
            cs{t} = (mu_eff + 2) / (D + mu_eff + 5);
            ds{t} = 1 + cs{t} + 2 * max(sqrt((mu_eff - 1) / (D + 1)) - 1, 0);
            ENN{t} = sqrt(D) * (1 - 1 / (4 * D) + 1 / (21 * D^2));
            % Covariance update parameters
            cc{t} = (4 + mu_eff / D) / (4 + D + 2 * mu_eff / D);
            c1{t} = 2 / ((D + 1.3)^2 + mu_eff);
            cmu{t} = min(1 - c1{t}, 2 * (mu_eff - 2 + 1 / mu_eff) / ((D + 2)^2 + 2 * mu_eff / 2));
            hth{t} = (1.4 + 2 / (D + 1)) * ENN{t};
            % Initialization
            Mdec{t} = unifrnd(zeros(1, D), ones(1, D));
            ps{t} = zeros(1, D);
            pc{t} = zeros(1, D);
            C{t} = eye(D);
            sigma{t} = 0.1 * ones(1, D);
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
                Pstep{t} = zeros(Prob.N, D);
                for i = 1:Prob.N
                    offspring_t(i) = IndividualSBO();
                    Pstep{t}(i, :) = mvnrnd(zeros(1, D), C{t});
                    offspring_t(i).Dec = Mdec{t} + sigma{t} .* Pstep{t}(i, :);
                    offspring_t(i).Dec(offspring_t(i).Dec > 1) = 1;
                    offspring_t(i).Dec(offspring_t(i).Dec < 0) = 0;
                    Pstep{t}(i, :) = (offspring_t(i).Dec - Mdec{t}) ./ sigma{t};

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

                % Update mean
                Pstep{t} = Pstep{t}(rank(1:mu), :);
                Mstep = w * Pstep{t};
                Mdec{t} = Mdec{t} + sigma{t} .* Mstep;
                % Update parameters
                ps{t} = (1 - cs{t}) * ps{t} + sqrt(cs{t} * (2 - cs{t}) * mu_eff) * Mstep / chol(C{t})';
                sigma{t} = sigma{t} * exp(cs{t} / ds{t} * (norm(ps{t}) / ENN{t} - 1))^0.3;
                hs = norm(ps{t}) / sqrt(1 - (1 - cs{t})^(2 * (ceil((Algo.FE - (t - 1) * Prob.N) / (Prob.N * Prob.T)) + 1))) < hth{t};
                delta = (1 - hs) * cc{t} * (2 - cc{t});
                pc{t} = (1 - cc{t}) * pc{t} + hs * sqrt(cc{t} * (2 - cc{t}) * mu_eff) * Mstep;
                C{t} = (1 - c1{t} - cmu{t}) * C{t} + c1{t} * (pc{t}' * pc{t} + delta * C{t}) + cmu{t} * Pstep{t}' * diag(w) * Pstep{t};

                C{t} = triu(C{t}) + triu(C{t}, 1)';
                [V, E] = eig(C{t});
                if any(diag(E) < 0)
                    C{t} = V * max(E, 0) / V;
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
