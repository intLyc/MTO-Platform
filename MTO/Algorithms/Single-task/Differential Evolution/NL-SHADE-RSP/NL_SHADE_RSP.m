classdef NL_SHADE_RSP < Algorithm
% <Single-task> <Single-objective> <None>

%------------------------------- Reference --------------------------------
% @InProceedings{Stanovov2021NL-SHADE-RSP,
%   title      = {NL-SHADE-RSP Algorithm with Adaptive Archive and Selective Pressure for CEC 2021 Numerical Optimization},
%   author     = {Stanovov, Vladimir and Akhmedova, Shakhnaz and Semenkin, Eugene},
%   booktitle  = {2021 IEEE Congress on Evolutionary Computation (CEC)},
%   year       = {2021},
%   pages      = {809-816},
%   doi        = {10.1109/CEC45853.2021.9504959},
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
    Pmax = 0.4
    Pmin = 0.2
    H = 5
    R = 18
    A = 2.1
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'Pmax: max of 100p% top as pbest', num2str(Algo.Pmax), ...
                'Pmin: min of 100p% top as pbest', num2str(Algo.Pmin), ...
                'H: success memory size', num2str(Algo.H), ...
                'R: multiplier of init pop size', num2str(Algo.R), ...
                'A: archive size', num2str(Algo.A)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.Pmax = str2double(Parameter{i}); i = i + 1;
        Algo.Pmin = str2double(Parameter{i}); i = i + 1;
        Algo.H = str2double(Parameter{i}); i = i + 1;
        Algo.R = str2double(Parameter{i}); i = i + 1;
        Algo.A = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialization
        Nmin = 4;
        for t = 1:Prob.T
            Ninit(t) = round(Algo.R .* Prob.D(t));
            population{t} = Initialization_One(Algo, Prob, t, Individual_DE, Ninit(t));
            Hidx{t} = 1;
            MF{t} = 0.5 .* ones(Algo.H, 1);
            MCR{t} = 0.5 .* ones(Algo.H, 1);
            archive{t} = Individual_DE.empty();
            pA(t) = 0.5;
        end

        while Algo.notTerminated(Prob, population)
            for t = 1:Prob.T
                N = round((Nmin - Ninit(t)) * (Algo.FE / Prob.maxFE)^(1 - Algo.FE / Prob.maxFE) + Ninit(t));
                P = round((Algo.Pmin - Algo.Pmax) / Prob.maxFE * Algo.FE + Algo.Pmax);
                % Calculate individual F and CR
                Fpool = []; CRpool = [];
                for i = 1:length(population{t})
                    idx = randi(Algo.H);
                    uF = MF{t}(idx);
                    Fpool(i) = uF + 0.1 * tan(pi * (rand() - 0.5));
                    while (Fpool(i) <= 0)
                        Fpool(i) = uF + 0.1 * tan(pi * (rand() - 0.5));
                    end
                    uCR = MCR{t}(idx);
                    CRpool(i) = normrnd(uCR, 0.1);
                end
                Fpool(Fpool > 1) = 1;
                CRpool(CRpool > 1) = 1;
                CRpool(CRpool < 0) = 0;
                [~, rank] = sort(population{t}.Objs);
                population{t} = population{t}(rank);
                [~, rank] = sort(CRpool);
                CRpool = CRpool(rank);
                for i = 1:length(population{t})
                    population{t}(i).F = Fpool(i);
                    population{t}(i).CR = CRpool(i);
                end
                if Algo.FE < 0.5 * Prob.maxFE
                    CRb = 0;
                else
                    CRb = 2 * (Algo.FE - 0.5) / Prob.maxFE;
                end

                % Generation
                [offspring, arc_flag] = Algo.Generation(population{t}, archive{t}, P, pA(t), CRb);
                % Evaluation
                offspring = Algo.Evaluation(offspring, Prob, t);
                % Selection
                [~, replace] = Selection_Tournament(population{t}, offspring);

                % Calculate probability of archive use
                delta_fa = mean(population{t}(replace & arc_flag).Objs' - offspring(replace & arc_flag).Objs');
                delta_fp = mean(population{t}(replace & ~arc_flag).Objs' - offspring(replace & ~arc_flag).Objs');
                pA(t) = min(0.9, max(0.1, delta_fa / (delta_fa + delta_fp)));

                % Calculate SF SCR
                SF = [population{t}(replace).F];
                SCR = [population{t}(replace).CR];
                dif = population{t}(replace).Objs' - offspring(replace).Objs';
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
                if length(archive{t}) > round(Algo.A * N)
                    archive{t} = archive{t}(randperm(length(archive{t}), round(Algo.A * N)));
                end

                population{t}(replace) = offspring(replace);

                % Linear Population Size Reduction
                if length(population{t}) > N
                    [~, rank] = sort(population{t}.Objs);
                    population{t} = population{t}(rank(1:N));
                end
            end
        end
    end

    function [offspring, arc_flag] = Generation(Algo, population, archive, P, pA, CRb)
        % get top 100p% individuals
        [~, rank] = sort(population.Objs);
        pop_pbest = rank(1:max(round(P * length(population)), 1));

        arc_flag = false(1, length(population));
        for i = 1:length(population)
            offspring(i) = population(i);

            pbest = pop_pbest(randi(length(pop_pbest)));
            x1 = randi(length(population));
            while x1 == i || x1 == pbest
                x1 = randi(length(population));
            end

            if ~isempty(archive) && rand() < pA % use archive
                arc_flag(i) = true;
                x2 = randi(length(archive));
                offspring(i).Dec = population(i).Dec + ...
                    population(i).F * (population(pbest).Dec - population(i).Dec) + ...
                    population(i).F * (population(x1).Dec - archive(x2).Dec);
            else
                x2 = randi(length(population));
                while x2 == i || x2 == x1 || x2 == pbest
                    x2 = randi(length(population));
                end
                offspring(i).Dec = population(i).Dec + ...
                    population(i).F * (population(pbest).Dec - population(i).Dec) + ...
                    population(i).F * (population(x1).Dec - population(x2).Dec);
            end

            if rand() < 0.5
                offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, CRb);
            else
                offspring(i).Dec = DE_Crossover_Exp(offspring(i).Dec, population(i).Dec, population(i).CR);
            end

            % offspring(i).Dec(offspring(i).Dec > 1) = 1;
            % offspring(i).Dec(offspring(i).Dec < 0) = 0;

            vio_low = find(offspring(i).Dec < 0);
            offspring(i).Dec(vio_low) = (population(i).Dec(vio_low) + 0) / 2;
            vio_up = find(offspring(i).Dec > 1);
            offspring(i).Dec(vio_up) = (population(i).Dec(vio_up) + 1) / 2;
        end
    end
end
end
