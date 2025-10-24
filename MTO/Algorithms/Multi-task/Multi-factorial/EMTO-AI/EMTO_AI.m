classdef EMTO_AI < Algorithm
% <Multi-task> <Single-objective> <None/Constrained>
%For the single-population algorithm, the default population size is set to 100,
% and each task corresponds to 50 individuals.

%-----------------------------Reference--------------------------------
% @ARTICLE{Zhou2024EMTO-AI,
% author   = {Zhou, Xinyu and Mei, Neng and Zhong, Maosheng and Wang, Mingwen},
% journal  = {IEEE Transactions on Emerging Topics in Computational Intelligence},
% title    = {Evolutionary Multi-Task Optimization With Adaptive Intensity of Knowledge Transfer},
% year     = {2024},
% pages    = {1-13},
% doi      = {10.1109/TETCI.2024.3418810},
% }
%----------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties (SetAccess = public)
    F = 0.5;
    CR = 0.6; %WCCI20 CR=0.9
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'F: Mutation Factor', num2str(Algo.F), ...
                'CR: Crossover Rate', num2str(Algo.CR)};
    end

    function setParameter(Algo, Parameter)
        i = 1;
        Algo.F = str2double(Parameter{i}); i = i + 1;
        Algo.CR = str2double(Parameter{i}); i = i + 1;

    end

    %% Main
    function run(Algo, Prob)

        %Initialize
        rmp = [0.3, 0.3];
        RMP = [];
        RMP1 = [];
        arc = cell(1, 2);
        rate = 0.05;
        gap_gen = 35;
        population = Initialization_MF(Algo, Prob, Individual_FL);

        %Initialize archive
        arc_len = ceil(50 * rate);
        for t = 1:Prob.T
            subpop{t} = population([population.MFFactor] == t);
            len_sub = length(subpop{t});
            fac = zeros(1, len_sub);
            for i = 1:len_sub
                fac(i) = subpop{t}(i).MFObj(t);
            end
            [~, rank] = sort(fac);
            for i = 1:len_sub
                subpop{t}(rank(i)).MFRank = i;
            end
            arc{t} = subpop{t}(rank(1:arc_len));
        end

        for t = 1:Prob.T
            p = [1, 2];
            o = find(p ~= t);
            [better_num, sub{t}] = getNums(subpop{t}, subpop{o}, o);
            rmp(o) = better_num / length(subpop{t});
        end
        RMP = [RMP, rmp(1)];
        RMP1 = [RMP1, rmp(2)];

        while Algo.notTerminated(Prob, population)

            %Generation
            offspring = Algo.Generation(population, rmp, arc);

            %Evaluation
            offspring_temp = Individual_FL.empty();
            for t = 1:Prob.T
                offspring_t = offspring([offspring.MFFactor] == t);
                offspring_t = Algo.Evaluation(offspring_t, Prob, t);
                for i = 1:length(offspring_t)
                    offspring_t(i).MFObj = inf(1, Prob.T);
                    offspring_t(i).MFCV = inf(1, Prob.T);
                    offspring_t(i).MFObj(t) = offspring_t(i).Obj;
                    offspring_t(i).MFCV(t) = offspring_t(i).CV;
                end
                offspring_temp = [offspring_temp, offspring_t];
            end
            offspring = offspring_temp;

            %Selection
            population = Selection_MF(population, offspring, Prob);

            %Update archive
            subpops = {};
            for t = 1:Prob.T
                subpops{t} = population([population.MFFactor] == t);
                TSF = subpops{t}([subpops{t}.is_offspring] == 1);
                len = length(TSF);

                if len >= arc_len
                    arc{t} = TSF(1:arc_len);
                elseif len == 0
                    arc{t} = subpops{t}(1:arc_len);
                else
                    arc{t}(1:len) = [];
                    arc{t} = [arc{t}, TSF];
                end
            end

            for i = 1:length(population)
                population(i).is_offspring = 0;
            end

            %Update transfer intensity
            if mod(Algo.Gen, gap_gen) == 0
                for t = 1:Prob.T
                    p = [1, 2];
                    o = find(p ~= t);
                    subpop_t1 = Algo.Evaluation(subpops{t}, Prob, o);

                    for i = 1:length(subpop_t1)
                        subpops{t}(i).MFObj(o) = subpop_t1(i).Obj;
                    end
                end

                for t = 1:Prob.T
                    p = [1, 2];
                    o = find(p ~= t);
                    [better_num, sub{t}] = getNums(subpops{t}, subpops{o}, o);

                    rmp(o) = better_num / length(subpops{t});
                end

                rmp(rmp < 0) = 0;
                rmp(rmp > 1) = 1;

            end
            RMP = [RMP, rmp(1)];
            RMP1 = [RMP1, rmp(2)];
        end

    end %function  run

    %% Generation
    function offspring = Generation(Algo, population, rmp, arc)

        for i = 1:length(population)
            offspring(i) = population(i);
            P = [1, 2];
            o = find(P ~= population(i).MFFactor);
            len = length(population);
            if rand < rmp(population(i).MFFactor) % knowledge transfer  DE/current to best
                len_arc = length(arc{o});
                x1 = randi(len_arc); % find a solution from other task archive
                x2 = randi(len);
                while x2 == i || population(x2).MFFactor ~= population(i).MFFactor
                    x2 = randi(len);
                end
                x3 = randi(len);
                while x3 == i || x2 == x3 || population(x2).MFFactor ~= population(i).MFFactor
                    x3 = randi(len);
                end
                offspring(i).Dec = arc{o}(x1).Dec + Algo.F * (population(x2).Dec - population(x3).Dec);
                offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, Algo.CR);
                offspring(i).MFFactor = P(randi(2));
                offspring(i).is_offspring = 1;
            else
                x1 = randi(len);
                while x1 == i || population(x1).MFFactor ~= population(i).MFFactor
                    x1 = randi(len);
                end
                x2 = randi(len);
                while x2 == i || x2 == x1 || population(x2).MFFactor ~= population(i).MFFactor
                    x2 = randi(len);
                end
                x3 = randi(len);
                while x3 == i || x3 == x2 || x3 == x1 || population(x3).MFFactor ~= population(i).MFFactor
                    x3 = randi(len);
                end
                offspring(i).Dec = population(x1).Dec + Algo.F * (population(x2).Dec - population(x3).Dec);
                offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, Algo.CR);
                offspring(i).MFFactor = population(i).MFFactor;
                offspring(i).is_offspring = 0;
            end
            %Out of bounds handling
            rand_Dec = rand(1, length(offspring(i).Dec));
            offspring(i).Dec(offspring(i).Dec > 1) = rand_Dec(offspring(i).Dec > 1);
            offspring(i).Dec(offspring(i).Dec < 0) = rand_Dec(offspring(i).Dec < 0);
        end

    end %Generation

end %methods
end %classdef
