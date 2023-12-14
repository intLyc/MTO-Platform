classdef MaTDE < Algorithm
% <Many-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @article{Chen2020MaTDE,
%   author     = {Chen, Yongliang and Zhong, Jinghui and Feng, Liang and Zhang, Jun},
%   journal    = {IEEE Transactions on Emerging Topics in Computational Intelligence},
%   title      = {An Adaptive Archive-Based Evolutionary Framework for Many-Task Optimization},
%   year       = {2020},
%   number     = {3},
%   pages      = {369-384},
%   volume     = {4},
%   doi        = {10.1109/TETCI.2019.2916051},
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
    Alpha = 0.1
    ArcUpdate = 0.2
    Shrink = 0.8
    Ro = 0.8
    ArcMultip = 3
    LF = 0.1
    UF = 2
    LCR = 0.1
    UCR = 0.9
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'Alpha: Knowledge Transfer Rate', num2str(Algo.Alpha), ...
                'ArcUpdate: Archive Update Rate', num2str(Algo.ArcUpdate), ...
                'Shrink: Reward Shrink Rate', num2str(Algo.Shrink), ...
                'Ro: Attenuation Coefficient', num2str(Algo.Ro), ...
                'ArcMultip: Multiples of population size', num2str(Algo.ArcMultip), ...
                'LF: F Lower Bound', num2str(Algo.LF), ...
                'UF: F Upper Bound', num2str(Algo.UF), ...
                'LCR: CR Lower Bound', num2str(Algo.LCR), ...
                'UCR: CR Upper Bound', num2str(Algo.UCR)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.Alpha = str2double(Parameter{i}); i = i + 1;
        Algo.ArcUpdate = str2double(Parameter{i}); i = i + 1;
        Algo.Shrink = str2double(Parameter{i}); i = i + 1;
        Algo.Ro = str2double(Parameter{i}); i = i + 1;
        Algo.ArcMultip = str2double(Parameter{i}); i = i + 1;
        Algo.LF = str2double(Parameter{i}); i = i + 1;
        Algo.UF = str2double(Parameter{i}); i = i + 1;
        Algo.LCR = str2double(Parameter{i}); i = i + 1;
        Algo.UCR = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialization
        population = Initialization(Algo, Prob, Individual_DE);
        possibility = zeros(Prob.T, Prob.T);
        reward = ones(Prob.T, Prob.T);
        archive = cell(1, Prob.T);
        for t = 1:Prob.T
            for i = 1:length(population{t})
                archive = Algo.putarchive(archive, t, population{t}(i), Prob.N);
            end
        end

        while Algo.notTerminated(Prob)
            for t = 1:Prob.T
                if rand() > Algo.Alpha
                    for i = 1:length(population{t})
                        population{t}(i).F = Algo.LF + (Algo.UF - Algo.LF) * rand();
                        population{t}(i).CR = Algo.LCR + (Algo.UCR - Algo.LCR) * rand();
                    end

                    % Generation
                    offspring = Algo.Generation(population{t});
                    % Evaluation
                    offspring = Algo.Evaluation(offspring, Prob, t);
                    % Selection
                    population{t} = Selection_Tournament(population{t}, offspring);
                else
                    % Knowledge transfer
                    [transfer_task, possibility] = Algo.adaptivechoose(t, Prob.T, archive, reward, possibility, Prob.D);

                    % Crossover
                    for i = 1:length(population{t})
                        CR = Algo.LCR + (Algo.UCR - Algo.LCR) * rand();
                        offspring(i) = population{t}(i);
                        r1 = randi(length(population{transfer_task}));
                        offspring(i).Dec = DE_Crossover(offspring(i).Dec, population{transfer_task}(r1).Dec, CR);
                    end

                    % Evaluation
                    [offspring, flag] = Algo.Evaluation(offspring, Prob, t);
                    % Selection
                    population{t} = Selection_Tournament(population{t}, offspring);

                    if flag % Best updated
                        reward(t, transfer_task) = reward(t, transfer_task) / Algo.Shrink;
                    else
                        reward(t, transfer_task) = reward(t, transfer_task) * Algo.Shrink;
                    end
                end
                % update archive
                for i = 1:length(population{t})
                    if rand() < Algo.ArcUpdate
                        archive = Algo.putarchive(archive, t, population{t}(i), Prob.N);
                    end
                end
            end
        end
    end

    function offspring = Generation(Algo, population)
        for i = 1:length(population)
            offspring(i) = population(i);
            x2 = randi(length(population));
            while x2 == i
                x2 = randi(length(population));
            end
            offspring(i).Dec = population(i).Dec + population(i).F * (population(x2).Dec - population(i).Dec);
            offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, population(i).CR);

            rand_Dec = rand(1, length(offspring(i).Dec));
            offspring(i).Dec(offspring(i).Dec > 1) = rand_Dec(offspring(i).Dec > 1);
            offspring(i).Dec(offspring(i).Dec < 0) = rand_Dec(offspring(i).Dec < 0);
        end
    end

    function [num, possibility] = adaptivechoose(Algo, task_idx, T, archive, reward, possibility, Dim)
        sum = 0;
        sim = Algo.calSIM(task_idx, T, archive, Dim);
        % update possibility table
        for i = 1:T
            if i == task_idx
                continue;
            end
            possibility(task_idx, i) = Algo.Ro * possibility(task_idx, i) + reward(task_idx, i) / (1 + log(1 + sim(i, 1)));
            sum = sum + possibility(task_idx, i);
        end

        p = rand;
        s = 0;
        for i = 1:T
            if i == task_idx
                continue;
            end
            s = s + possibility(task_idx, i) / sum;
            if s >= p
                break;
            end
        end
        num = i;
    end

    function archive = putarchive(Algo, archive, task_idx, individual, N)
        max_size = Algo.ArcMultip * N;
        archive_size = size(archive{task_idx}, 1);
        if archive_size < max_size
            archive_size = archive_size + 1;
            archive{task_idx}(archive_size, 1) = individual;
        else
            while 1
                l = ceil(rand * max_size);
                if l ~= 0
                    break;
                end
            end
            archive{task_idx}(l, 1) = individual;
        end
    end

    function similarity = calSIM(Algo, task_idx, T, archive, Dim)
        % Calculate similarity
        for i = 1:T
            if task_idx ~= i
                NVARS = min(Dim(task_idx), Dim(i)); % Unify dimensions to lower task
                cov0 = Algo.getCov(task_idx, archive, NVARS);
                cov1 = Algo.getCov(i, archive, NVARS);
                cov0_det = det(cov0);
                Inv_cov0 = pinv(cov0);
                cov1_det = det(cov1);
                Inv_cov1 = pinv(cov1);
                tr = Algo.getTrace(Inv_cov1, cov0);
                u = Algo.getMul(task_idx, i, archive, NVARS, Inv_cov1);
                if cov0_det < 1e-3
                    cov0_det = 0.001;
                end
                if cov1_det < 1e-3
                    cov1_det = 0.001;
                end
                s1 = abs(0.5 * (tr + u - NVARS + log(cov1_det / cov0_det)));
                tr = Algo.getTrace(Inv_cov0, cov1);
                u = Algo.getMul(i, task_idx, archive, NVARS, Inv_cov0);
                s2 = abs(0.5 * (tr + u - NVARS + log(cov0_det / cov1_det)));
                similarity(i, 1) = 0.5 * (s1 + s2);
            end
        end
    end

    function COV = getCov(Algo, task_idx, archive, NVARS)
        % generate NVARS*NVARS Dim cov matrix
        cur_ar_size = size(archive{task_idx}, 1);
        pop_Dec = zeros(cur_ar_size, NVARS);
        for i = 1:cur_ar_size
            pop_Dec(i, :) = archive{task_idx}(i).Dec(1:NVARS);
        end
        COV = cov(pop_Dec);
    end

    function tr = getTrace(Algo, inv_cov1, cov2)
        % KLD first step
        fmatrix = inv_cov1 * cov2;
        tr = sum(diag(fmatrix));
    end

    function u = getMul(Algo, t0, t1, archive, NVARS, invcov)
        % KLD second step
        pop0_archive = archive{t0};
        pop1_archive = archive{t1};
        cur_ar_size0 = size(pop0_archive, 1);
        cur_ar_size1 = size(pop1_archive, 1);
        pop0_Dec = zeros(cur_ar_size0, NVARS);
        pop1_Dec = zeros(cur_ar_size1, NVARS);
        for i = 1:cur_ar_size0
            pop0_Dec(i, :) = pop0_archive(i).Dec(1:NVARS);
        end
        for i = 1:cur_ar_size1
            pop1_Dec(i, :) = pop1_archive(i).Dec(1:NVARS);
        end
        u0 = mean(pop0_Dec);
        u1 = mean(pop1_Dec);
        u = (u1 - u0) * invcov * (u1 - u0)';
    end
end
end
