classdef MaTDE < Algorithm
    % <MaT-SO> <None/Constrained>

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
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
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
        function Parameter = getParameter(obj)
            Parameter = {'Alpha: Knowledge Transfer Rate', num2str(obj.Alpha), ...
                        'ArcUpdate: Archive Update Rate', num2str(obj.ArcUpdate), ...
                        'Shrink: Reward Shrink Rate', num2str(obj.Shrink), ...
                        'Ro: Attenuation Coefficient', num2str(obj.Ro), ...
                        'ArcMultip: Multiples of population size', num2str(obj.ArcMultip), ...
                        'LF: F Lower Bound', num2str(obj.LF), ...
                        'UF: F Upper Bound', num2str(obj.UF), ...
                        'LCR: CR Lower Bound', num2str(obj.LCR), ...
                        'UCR: CR Upper Bound', num2str(obj.UCR)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.Alpha = str2double(Parameter{i}); i = i + 1;
            obj.ArcUpdate = str2double(Parameter{i}); i = i + 1;
            obj.Shrink = str2double(Parameter{i}); i = i + 1;
            obj.Ro = str2double(Parameter{i}); i = i + 1;
            obj.ArcMultip = str2double(Parameter{i}); i = i + 1;
            obj.LF = str2double(Parameter{i}); i = i + 1;
            obj.UF = str2double(Parameter{i}); i = i + 1;
            obj.LCR = str2double(Parameter{i}); i = i + 1;
            obj.UCR = str2double(Parameter{i}); i = i + 1;
        end

        function run(obj, Prob)
            % Initialization
            population = Initialization(obj, Prob, Individual);
            possibility = zeros(Prob.T, Prob.T);
            reward = ones(Prob.T, Prob.T);
            archive = cell(1, Prob.T);
            for t = 1:Prob.T
                for i = 1:length(population{t})
                    archive = obj.putarchive(archive, t, population{t}(i), Prob.N);
                end
            end

            while obj.notTerminated(Prob)
                for t = 1:Prob.T
                    if rand() > obj.Alpha
                        F = obj.LF + (obj.UF - obj.LF) * rand();
                        CR = obj.LCR + (obj.UCR - obj.LCR) * rand();

                        % Generation
                        offspring = obj.Generation(population{t}, F, CR);
                        % Evaluation
                        offspring = obj.Evaluation(offspring, Prob, t);
                        % Selection
                        population{t} = Selection_Tournament(population{t}, offspring);
                    else
                        % Knowledge transfer
                        [transfer_task, possibility] = obj.adaptivechoose(t, Prob.T, archive, reward, possibility, Prob.D);

                        % Crossover
                        CR = obj.LCR + (obj.UCR - obj.LCR) * rand();
                        for i = 1:length(population{t})
                            offspring(i) = population{t}(i);
                            r1 = randi(length(population{transfer_task}));
                            offspring(i).Dec = DE_Crossover(offspring(i).Dec, population{transfer_task}(r1).Dec, CR);
                        end

                        % Evaluation
                        [offspring, flag] = obj.Evaluation(offspring, Prob, t);

                        if flag % Best updated
                            reward(t, transfer_task) = reward(t, transfer_task) / obj.Shrink;
                        else
                            reward(t, transfer_task) = reward(t, transfer_task) * obj.Shrink;
                        end
                    end
                    % update archive
                    for i = 1:length(population{t})
                        if rand() < obj.ArcUpdate
                            archive = obj.putarchive(archive, t, population{t}(i), Prob.N);
                        end
                    end
                end
            end
        end

        function offspring = Generation(obj, population, F, CR)
            for i = 1:length(population)
                offspring(i) = population(i);
                A = randperm(length(population), 4);
                A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3);

                offspring(i).Dec = population(x1).Dec + F * (population(x2).Dec - population(x3).Dec);
                offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, CR);

                offspring(i).Dec(offspring(i).Dec > 1) = 1;
                offspring(i).Dec(offspring(i).Dec < 0) = 0;
            end
        end

        function [num, possibility] = adaptivechoose(obj, task_num, T, archive, reward, possibility, Dim)
            sum = 0;
            sim = obj.calSIM(task_num, T, archive, Dim);
            % update possibility table
            for i = 1:T
                if i == task_num
                    continue;
                end
                possibility(task_num, i) = obj.Ro * possibility(task_num, i) + reward(task_num, i) / (1 + log(1 + sim(i, 1)));
                sum = sum + possibility(task_num, i);
            end

            p = rand;
            s = 0;
            for i = 1:T
                if i == task_num
                    continue;
                end
                s = s + possibility(task_num, i) / sum;
                if s >= p
                    break;
                end
            end
            num = i;
        end

        function archive = putarchive(obj, archive, task_num, individual, N)
            max_size = obj.ArcMultip * N;
            archive_size = size(archive{task_num}, 1);
            if archive_size < max_size
                archive_size = archive_size + 1;
                archive{task_num}(archive_size, 1) = individual;
            else
                while 1
                    l = ceil(rand * max_size);
                    if l ~= 0
                        break;
                    end
                end
                archive{task_num}(l, 1) = individual;
            end
        end

        function similarity = calSIM(obj, task_num, no_of_task, archive, Dim)
            % Calculate similarity
            for i = 1:no_of_task
                if task_num ~= i
                    NVARS = min(Dim(task_num), Dim(i)); % Unify dimensions to lower task
                    cov0 = obj.getCov(task_num, archive, NVARS);
                    cov1 = obj.getCov(i, archive, NVARS);
                    cov0_det = det(cov0);
                    Inv_cov0 = pinv(cov0);
                    cov1_det = det(cov1);
                    Inv_cov1 = pinv(cov1);
                    tr = obj.getTrace(Inv_cov1, cov0);
                    u = obj.getMul(task_num, i, archive, NVARS, Inv_cov1);
                    if cov0_det < 1e-3
                        cov0_det = 0.001;
                    end
                    if cov1_det < 1e-3
                        cov1_det = 0.001;
                    end
                    s1 = abs(0.5 * (tr + u - NVARS + log(cov1_det / cov0_det)));
                    tr = obj.getTrace(Inv_cov0, cov1);
                    u = obj.getMul(i, task_num, archive, NVARS, Inv_cov0);
                    s2 = abs(0.5 * (tr + u - NVARS + log(cov0_det / cov1_det)));
                    similarity(i, 1) = 0.5 * (s1 + s2);
                end
            end
        end

        function COV = getCov(obj, task_num, archive, NVARS)
            % generate NVARS*NVARS Dim cov matrix
            cur_ar_size = size(archive{task_num}, 1);
            pop_Dec = zeros(cur_ar_size, NVARS);
            for i = 1:cur_ar_size
                pop_Dec(i, :) = archive{task_num}(i).Dec(1:NVARS);
            end
            COV = cov(pop_Dec);
        end

        function tr = getTrace(obj, inv_cov1, cov2)
            % KLD first step
            fmatrix = inv_cov1 * cov2;
            tr = sum(diag(fmatrix));
        end

        function u = getMul(obj, t0, t1, archive, NVARS, invcov)
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
