classdef EMT_GS < Algorithm
% <Multi-task> <Multi-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Liang2022EMT-GS,
%   title    = {Evolutionary Multitasking for Multi-objective Optimization Based on Generative Strategies},
%   author   = {Liang, Zhengping and Zhu, Yingmiao and Wang, Xiyu and Li, Zhi and Zhu, Zexuan},
%   journal  = {IEEE Transactions on Evolutionary Computation},
%   year     = {2022},
%   pages    = {1-1},
%   doi      = {10.1109/TEVC.2022.3189029},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties (SetAccess = public)
    G = 10
    lrD = 0.0002
    lrG = 0.0003
    BS = 10
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'G: Training Gap', num2str(Algo.G), ...
                'lrD: Learning Rate D', num2str(Algo.lrD), ...
                'lrG: Learning Rate G', num2str(Algo.lrG), ...
                'BS: Batch Size', num2str(Algo.BS)};
    end

    function setParameter(Algo, Parameter)
        i = 1;
        Algo.G = str2double(Parameter{i}); i = i + 1;
        Algo.lrD = str2double(Parameter{i}); i = i + 1;
        Algo.lrG = str2double(Parameter{i}); i = i + 1;
        Algo.BS = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialize
        population = Initialization(Algo, Prob, Individual_MF);
        for t = 1:Prob.T
            for i = 1:Prob.N
                population{t}(i).MFFactor = t;
            end
            rank = NSGA2Sort(population{t});
            population{t} = population{t}(rank);
        end
        prepop = population;
        for t = 1:Prob.T
            for k = 1:Prob.T
                if t == k
                    continue;
                end
                [GANOff{t, k}, GAN{t, k}, stGAN{t, k}, DIS{t, k}, stDIS{t, k}] = InitialGAN( ...
                    population{t}.Decs, population{k}.Decs, Algo.lrD, Algo.lrG, Algo.BS);
            end
        end
        while Algo.notTerminated(Prob, population)
            for t = 1:Prob.T
                for k = 1:Prob.T
                    if t == k
                        continue;
                    end
                    if mod(Algo.Gen, Algo.G) == 0
                        % Train GAN
                        [GANOff{t, k}, GAN{t, k}, stGAN{t, k}, DIS{t, k}, stDIS{t, k}] = TrainGAN( ...
                            population{t}.Decs, population{k}.Decs, GAN{t, k}, stGAN{t, k}, ...
                            DIS{t, k}, stDIS{t, k}, Algo.lrD, Algo.lrG, Algo.BS);
                    else
                        if rand() < 0.5
                            GANOff{t, k} = GenerateGAN(population{k}.Decs, GAN{t, k}, stGAN{t, k});
                        else
                            GANOff{t, k} = GenerateGAN(population{k}.Decs, GAN{t, k}, stGAN{k, t});
                        end
                    end
                    GANOff{t, k} = cast(gather(GANOff{t, k}), 'double');
                end
            end

            % Generation
            offspring = Algo.Generation(population, prepop, GANOff);
            prepop = population;
            for t = 1:Prob.T
                % Evaluation
                offspring_t = offspring([offspring.MFFactor] == t);
                offspring_t = Algo.Evaluation(offspring_t, Prob, t);
                % Selection
                population{t} = [population{t}, offspring_t];
                rank = NSGA2Sort(population{t});
                population{t} = population{t}(rank(1:Prob.N));
            end
        end
    end

    function offspring = Generation(Algo, population, prepop, GANOff)
        parent = [population{:}];
        rank = 1:length(parent);
        rndper = randperm(length(parent));
        parent = parent(rndper);
        rank = rank(rndper);
        MFFPool = [parent.MFFactor];
        Np = length(population{1});
        count = 1;
        for i = 1:ceil(length(parent) / 2)
            p1 = i; p2 = i + fix(length(parent) / 2);
            offspring(count) = parent(p1);
            offspring(count + 1) = parent(p2);

            F = normrnd(0.5, 0.2);
            while F > 1 || F < 0
                F = normrnd(0.5, 0.2);
            end
            pp = 0.5;
            CR = 0.6;

            if (MFFPool(p1) == MFFPool(p2))
                r1 = randi(Np); r2 = randi(Np);
                if rand() < pp % rand
                    x1 = population{MFFPool(p1)}(r1);
                else % best
                    x1 = population{MFFPool(p1)}(1);
                end
                offspring(count).Dec = x1.Dec + F * (parent(p1).Dec - prepop{MFFPool(p1)}(r2).Dec);
                offspring(count).Dec = DE_Crossover(offspring(count).Dec, parent(p1).Dec, CR);
                r1 = randi(Np); r2 = randi(Np);
                if rand() < pp % rand
                    x1 = population{MFFPool(p2)}(r1);
                else % best
                    x1 = population{MFFPool(p2)}(1);
                end
                offspring(count + 1).Dec = x1.Dec + F * (parent(p2).Dec - prepop{MFFPool(p2)}(r2).Dec);
                offspring(count + 1).Dec = DE_Crossover(offspring(count + 1).Dec, parent(p2).Dec, CR);
            else
                % GAN Generation
                p1r = mod(rank(p1) - 1, Np) + 1;
                p2r = mod(rank(p2) - 1, Np) + 1;
                c1 = parent(p1);
                c2 = parent(p2);
                c1.Dec = GANOff{MFFPool(p2), MFFPool(p1)}(p1r, :);
                c2.Dec = GANOff{MFFPool(p1), MFFPool(p2)}(p2r, :);

                r1 = randi(Np); r2 = randi(Np);
                if rand() < pp % rand
                    x1 = population{MFFPool(p1)}(r1);
                else % best
                    x1 = population{MFFPool(p1)}(1);
                end
                offspring(count).Dec = x1.Dec + F * (c1.Dec - prepop{MFFPool(p1)}(r2).Dec);
                offspring(count).Dec = DE_Crossover(offspring(count).Dec, x1.Dec, CR);
                r1 = randi(Np); r2 = randi(Np);
                if rand() < pp % rand
                    x1 = population{MFFPool(p2)}(r1);
                else % best
                    x1 = population{MFFPool(p2)}(1);
                end
                offspring(count + 1).Dec = x1.Dec + F * (c2.Dec - prepop{MFFPool(p2)}(r2).Dec);
                offspring(count + 1).Dec = DE_Crossover(offspring(count + 1).Dec, x1.Dec, CR);
            end

            % imitation
            offspring(count).MFFactor = MFFPool(p1);
            offspring(count + 1).MFFactor = MFFPool(p2);
            for x = count:count + 1
                offspring(x).Dec(offspring(x).Dec > 1) = 1;
                offspring(x).Dec(offspring(x).Dec < 0) = 0;
            end
            count = count + 2;
        end
    end
end
end
