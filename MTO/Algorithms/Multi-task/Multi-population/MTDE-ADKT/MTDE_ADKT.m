classdef MTDE_ADKT < Algorithm
% <Multi-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Zhang2024MTDE-ADKT,
%   title      = {Multitask Differential Evolution with Adaptive Dual Knowledge Transfer},
%   author     = {Tingyu Zhang and Wenyin Gong and Yanchi Li},
%   journal    = {Applied Soft Computing},
%   year       = {2024},
%   issn       = {1568-4946},
%   pages      = {112040},
%   volume     = {165},
%   doi        = {https://doi.org/10.1016/j.asoc.2024.112040},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties (SetAccess = private)
    P = 0.1
    H = 100
    Gap = 50
    Alpha = 0.25
    RMP0 = 0.15
    Beta = 0.9
    TGap = 1
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'P: 100p% top as pbest', num2str(Algo.P), ...
                'H: success memory size', num2str(Algo.H), ...
                'Gap', num2str(Algo.Gap), ...
                'A', num2str(Algo.Alpha), ...
                'RMP0', num2str(Algo.RMP0), ...
                'Beta', num2str(Algo.Beta), ...
                'TGap', num2str(Algo.TGap)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.P = str2double(Parameter{i}); i = i + 1;
        Algo.H = str2double(Parameter{i}); i = i + 1;
        Algo.Gap = str2double(Parameter{i}); i = i + 1;
        Algo.Alpha = str2double(Parameter{i}); i = i + 1;
        Algo.RMP0 = str2double(Parameter{i}); i = i + 1;
        Algo.Beta = str2double(Parameter{i}); i = i + 1;
        Algo.TGap = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialization
        population = Initialization(Algo, Prob, Individual_DE);
        reduce_flag = false;

        r_suc1 = {};
        r_suc2 = {};
        r_suc3 = {};

        rmp1 = {};
        rmp2 = {};

        mDec = 0.5 * ones(Prob.T, max(Prob.D));

        RMP1 = Algo.RMP0 * ones(1, Prob.T);
        RMP2 = Algo.RMP0 * ones(1, Prob.T);

        delta_rmp = Algo.Gap / 500;

        for t = 1:Prob.T
            % initialize Parameter
            Hidx{t} = 1;
            MF{t} = 0.5 .* ones(Algo.H, 1);
            MCR{t} = 0.5 .* ones(Algo.H, 1);
            archive{t} = Individual_DE.empty();
            r_suc1{t} = [1];
            r_suc2{t} = [1];
            r_suc3{t} = [1];
            rmp1{t} = [];
            rmp2{t} = [];
            mDec(t, :) = mean(population{t}.Decs);
        end

        while Algo.notTerminated(Prob, population)
            % Calculate individual F and CR
            for t = 1:Prob.T
                for i = 1:length(population{t})
                    idx = randi(Algo.H);
                    uF = MF{t}(idx);
                    population{t}(i).F = uF + 0.1 * tan(pi * (rand() - 0.5));
                    while (population{t}(i).F <= 0)
                        population{t}(i).F = uF + 0.1 * tan(pi * (rand() - 0.5));
                    end
                    population{t}(i).F(population{t}(i).F > 1) = 1;

                    uCR = MCR{t}(idx);
                    population{t}(i).CR = normrnd(uCR, 0.1);
                    population{t}(i).CR(population{t}(i).CR > 1) = 1;
                    population{t}(i).CR(population{t}(i).CR < 0) = 0;
                end
                k = randi(Prob.T);
                while k == t
                    k = randi(Prob.T);
                end

                union = [population{t}, archive{t}];

                par1_idx = [];
                par2_idx = [];
                par3_idx = [];
                if mod(Algo.Gen, Algo.TGap) == 0
                    for i = 1:length(population{t})
                        if rand() < RMP1(t)
                            par1_idx = [par1_idx, i];
                        elseif rand() < RMP2(t)
                            par2_idx = [par2_idx, i];
                        else
                            par3_idx = [par3_idx, i];
                        end
                    end
                else
                    par3_idx = [1:length(population{t})];
                end
                parent1 = population{t}(par1_idx);
                parent2 = population{t}(par2_idx);
                parent3 = population{t}(par3_idx);

                replace1 = logical.empty();
                replace2 = logical.empty();
                replace3 = logical.empty();

                offspring1 = Individual_DE.empty();
                offspring2 = Individual_DE.empty();
                offspring3 = Individual_DE.empty();

                [~, rank] = sortrows([population{t}.CVs, population{t}.Objs], [1, 2]);
                pop_pbest = rank(1:max(round(Algo.P * length(population{t})), 1));

                transfer_idx = randperm(length(population{k}), length(parent1) + length(parent2));
                transfer_idx1 = transfer_idx(1:length(parent1));
                transfer_idx2 = transfer_idx(length(parent1) + 1:end);

                if length(parent1) > 0
                    unionT = population{t};
                    unionS = population{k};

                    transpop1 = population{k}(transfer_idx1);
                    transpop1_Decs = Algo.D_Align(unionS.Decs, unionT.Decs, mDec, t, k, transfer_idx1);
                    for i = 1:length(transfer_idx1)
                        transpop1(i).Dec = transpop1_Decs(i, :);
                    end
                    offspring1 = Algo.Generation_1(parent1, transpop1, population{t}, union, pop_pbest);
                    offspring1 = Algo.Evaluation(offspring1, Prob, t);
                    [~, replace1] = Selection_Tournament(parent1, offspring1);
                    n_succ1 = length(find(replace1 == 1));
                    r_succ1 = n_succ1 / length(parent1);
                    r_suc1{t} = [r_suc1{t}, r_succ1];
                else
                    r_suc1{t} = [r_suc1{t}, 0];
                end

                if length(parent2) > 0
                    transpop2 = population{k}(transfer_idx2);
                    offspring2 = Algo.Generation_1(parent2, transpop2, population{t}, union, pop_pbest);
                    offspring2 = Algo.Evaluation(offspring2, Prob, t);
                    [~, replace2] = Selection_Tournament(parent2, offspring2);
                    n_succ2 = length(find(replace2 == 1));
                    r_succ2 = n_succ2 / length(parent2);
                    r_suc2{t} = [r_suc2{t}, r_succ2];

                else
                    r_suc2{t} = [r_suc2{t}, 0];
                end

                if length(parent3) > 0
                    offspring3 = Algo.Generation_3(parent3, population{t}, union, pop_pbest);
                    offspring3 = Algo.Evaluation(offspring3, Prob, t);
                    [~, replace3] = Selection_Tournament(parent3, offspring3);
                    n_succ3 = length(find(replace3 == 1));
                    r_succ3 = n_succ3 / length(parent3);
                    r_suc3{t} = [r_suc3{t}, r_succ3];
                else
                    r_suc3{t} = [r_suc3{t}, 0];
                end

                population{t} = [parent1, parent2, parent3];
                offspring = [offspring1, offspring2, offspring3];
                replace = [replace1, replace2, replace3];

                % calculate SF SCR
                SF = [population{t}(replace).F];
                SCR = [population{t}(replace).CR];
                dif = population{t}(replace).CVs' - offspring(replace).CVs';
                dif_obj = population{t}(replace).Objs' - offspring(replace).Objs';
                dif_obj(dif_obj < 0) = 0;
                dif(dif <= 0) = dif_obj(dif <= 0);
                dif = dif ./ sum(dif);
                % update MF MCR
                if ~isempty(SF)
                    MF{t}(Hidx{t}) = sum(dif .* (SF.^2)) / sum(dif .* SF);
                    MCR{t}(Hidx{t}) = sum(dif .* SCR);
                else
                    MF{t}(Hidx{t}) = MF{t}(mod(Hidx{t} + Algo.H - 2, Algo.H) + 1);
                    MCR{t}(Hidx{t}) = MCR{t}(mod(Hidx{t} + Algo.H - 2, Algo.H) + 1);
                end
                Hidx{t} = mod(Hidx{t}, Algo.H) + 1;

                % Update archive
                archive{t} = [archive{t}, population{t}(replace)];
                if length(archive{t}) > length(population{t})
                    archive{t} = archive{t}(randperm(length(archive{t}), length(population{t})));
                end

                population{t}(replace) = offspring(replace);
            end

            for t = 1:Prob.T
                if mod(Algo.Gen, Algo.Gap) == 0
                    if mean(r_suc1{t}((Algo.Gen - Algo.Gap + 1):Algo.Gen)) * Algo.TGap >= mean(r_suc3{t}((Algo.Gen - Algo.Gap + 1):Algo.Gen))
                        RMP1(t) = min(RMP1(t) + delta_rmp, 0.45);
                        rmp1{t} = [rmp1{t}, RMP1(t)];
                    else
                        RMP1(t) = max(RMP1(t) - delta_rmp, 0.01);
                        rmp1{t} = [rmp1{t}, RMP1(t)];
                    end
                    if mean(r_suc2{t}((Algo.Gen - Algo.Gap + 1):Algo.Gen)) * Algo.TGap >= mean(r_suc3{t}((Algo.Gen - Algo.Gap + 1):Algo.Gen))
                        RMP2(t) = min(RMP2(t) + delta_rmp, 0.45);
                        rmp2{t} = [rmp2{t}, RMP2(t)];
                    else
                        RMP2(t) = max(RMP2(t) - delta_rmp, 0.02);
                        rmp2{t} = [rmp2{t}, RMP2(t)];
                    end
                end
            end

            % Population reduction
            if ~reduce_flag && Algo.FE >= Prob.maxFE * Algo.Alpha
                N = round(Prob.N / 2);
                for t = 1:Prob.T
                    [~, rank] = sortrows([population{t}.CVs, population{t}.Objs], [1, 2]);
                    % save to archive
                    archive{t} = [archive{t}, population{t}(rank(N + 1:end))];
                    if length(archive{t}) > Prob.N
                        archive{t} = archive{t}(randperm(length(archive{t}), Prob.N));
                    end
                    % reduce
                    population{t} = population{t}(rank(1:N));
                end
                reduce_flag = true;
            end

            for t = 1:Prob.T
                mDec(t, :) = (1 - Algo.Beta) .* mDec(t, :) + Algo.Beta .* mean(population{t}.Decs);
            end
        end
    end

    function offspring1 = Generation_1(Algo, parent, transpop, population, union, pop_pbest)
        for i = 1:length(parent)
            offspring1(i) = transpop(i);
            pbest = pop_pbest(randi(length(pop_pbest)));
            x1 = randi(length(population));
            while x1 == pbest
                x1 = randi(length(population));
            end
            x2 = randi(length(union));
            while x2 == x1 || x2 == pbest
                x2 = randi(length(union));
            end
            offspring1(i).Dec = transpop(i).Dec + ...
                parent(i).F * (population(pbest).Dec - transpop(i).Dec) + ...
                parent(i).F * (population(x1).Dec - union(x2).Dec);

            offspring1(i).Dec = DE_Crossover(offspring1(i).Dec, transpop(i).Dec, parent(i).CR);

            % offspring(i).Dec(offspring(i).Dec > 1) = 1;
            % offspring(i).Dec(offspring(i).Dec < 0) = 0;

            vio_low = find(offspring1(i).Dec < 0);
            offspring1(i).Dec(vio_low) = (transpop(i).Dec(vio_low) + 0) / 2;
            vio_up = find(offspring1(i).Dec > 1);
            offspring1(i).Dec(vio_up) = (transpop(i).Dec(vio_up) + 1) / 2;
        end
    end

    function offspring3 = Generation_3(Algo, parent3, population, union, pop_pbest)
        for i = 1:length(parent3)
            offspring3(i) = parent3(i);
            pbest = pop_pbest(randi(length(pop_pbest)));
            x1 = randi(length(population));
            while x1 == pbest
                x1 = randi(length(population));
            end
            x2 = randi(length(union));
            while x2 == x1 || x2 == pbest
                x2 = randi(length(union));
            end

            offspring3(i).Dec = parent3(i).Dec + ...
                parent3(i).F * (population(pbest).Dec - parent3(i).Dec) + ...
                parent3(i).F * (population(x1).Dec - union(x2).Dec);
            offspring3(i).Dec = DE_Crossover(offspring3(i).Dec, parent3(i).Dec, parent3(i).CR);

            vio_low = find(offspring3(i).Dec < 0);
            offspring3(i).Dec(vio_low) = (parent3(i).Dec(vio_low) + 0) / 2;
            vio_up = find(offspring3(i).Dec > 1);
            offspring3(i).Dec(vio_up) = (parent3(i).Dec(vio_up) + 1) / 2;
        end
    end

    function trans = D_Align(Algo, Ds_Dec, Dt_Dec, mDec, t, k, idx)
        mus = mean(Ds_Dec);
        mut = mean(Dt_Dec);
        D = Ds_Dec(idx, :);
        D = D - repmat(mus, size(D, 1), 1);
        Ds_Dec = Ds_Dec - repmat(mus, size(Ds_Dec, 1), 1);
        Dt_Dec = Dt_Dec - repmat(mut, size(Dt_Dec, 1), 1);

        Cs = cov(Ds_Dec) + eye(size(Ds_Dec, 2));
        Ct = cov(Dt_Dec) + eye(size(Dt_Dec, 2));

        trans = D * Cs^(-1/2) * Ct^(1/2);

        trans = trans + repmat(mDec(t, :), size(trans, 1), 1);
    end
end
end
