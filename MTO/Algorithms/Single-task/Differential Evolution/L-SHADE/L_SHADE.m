classdef L_SHADE < Algorithm
% <Single-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @InProceedings{Tanabe2014LSHADE,
%   title     = {Improving the Search Performance of Shade Using Linear Population Size Reduction},
%   author    = {Tanabe, Ryoji and Fukunaga, Alex S.},
%   booktitle = {2014 IEEE Congress on Evolutionary Computation (CEC)},
%   year      = {2014},
%   pages     = {1658-1665},
%   doi       = {10.1109/CEC.2014.6900380},
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
    P = 0.2
    H = 5
    R = 18
    A = 2.1
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'P: 100p% top as pbest', num2str(Algo.P), ...
                'H: success memory size', num2str(Algo.H), ...
                'R: multiplier of init pop size', num2str(Algo.R), ...
                'A: archive size', num2str(Algo.A)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.P = str2double(Parameter{i}); i = i + 1;
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
        end

        while Algo.notTerminated(Prob, population)
            for t = 1:Prob.T
                N = round((Nmin - Ninit(t)) / Prob.maxFE * Algo.FE + Ninit(t));
                % Calculate individual F and CR
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

                % Generation
                union = [population{t}, archive{t}];
                offspring = Algo.Generation(population{t}, union);
                % Evaluation
                offspring = Algo.Evaluation(offspring, Prob, t);
                % Selection
                [~, replace] = Selection_Tournament(population{t}, offspring);

                % Calculate SF SCR
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
                if length(archive{t}) > round(Algo.A * N)
                    archive{t} = archive{t}(randperm(length(archive{t}), round(Algo.A * N)));
                end

                population{t}(replace) = offspring(replace);

                % Linear Population Size Reduction
                if length(population{t}) > N
                    [~, rank] = sortrows([population{t}.CVs, population{t}.Objs], [1, 2]);
                    population{t} = population{t}(rank(1:N));
                end
            end
        end
    end

    function offspring = Generation(Algo, population, union)
        % get top 100p% individuals
        [~, rank] = sortrows([population.CVs, population.Objs], [1, 2]);
        pop_pbest = rank(1:max(round(Algo.P * length(population)), 1));

        for i = 1:length(population)
            offspring(i) = population(i);

            pbest = pop_pbest(randi(length(pop_pbest)));
            x1 = randi(length(population));
            while x1 == i || x1 == pbest
                x1 = randi(length(population));
            end
            x2 = randi(length(union));
            while x2 == i || x2 == x1 || x2 == pbest
                x2 = randi(length(union));
            end

            offspring(i).Dec = population(i).Dec + ...
                population(i).F * (population(pbest).Dec - population(i).Dec) + ...
                population(i).F * (population(x1).Dec - union(x2).Dec);
            offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, population(i).CR);

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
