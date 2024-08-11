classdef MTEA_HKTS < Algorithm
% <Multi-task/Many-task> <Single-objective> <None>

%------------------------------- Reference --------------------------------
% @Article{Zhao2024MTEA-HKTS,
%   author  = {Ben Zhao and Zhihua Cui and JinQian Yang and Xingjuan Cai and Jianghui Cai and Jinjun Chen},
%   journal = {Information Sciences},
%   title   = {A Multi-Task Evolutionary Algorithm for Solving the Problem of Transfer Targets},
%   year    = {2024},
%   issn    = {0020-0255},
%   pages   = {121214},
%   volume  = {681},
%   doi     = {https://doi.org/10.1016/j.ins.2024.121214},
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
    pTransfer = 0.5;
    Operator = 'GA/DE';
    mu = 2;
    mum = 5;
    F = 0.5;
    CR = 0.5;
    minx = 0.1;
    Lb = 0.1;
    Ub = 0.7;
    w = 0.3;
end

methods
    function parameter = getParameter(Algo)
        parameter = {'pTransfer: Portion of chromosomes to transfer from one task to another', num2str(Algo.pTransfer), ...
                'Operator (Split with /)', Algo.Operator, ...
                'mu: index of Simulated Binary Crossover', num2str(Algo.mu), ...
                'mum: index of polynomial mutation', num2str(Algo.mum), ...
                'F: Mutation Factor', num2str(Algo.F), ...
                'CR: Crossover Probability', num2str(Algo.CR), ...
                'minx: Minimum boundary value', num2str(Algo.minx), ...
                'Lb: Lower Bound', num2str(Algo.Lb), ...
                'Ub: Upper Bound', num2str(Algo.Ub), ...
                'w:Advantage accumulation parameters', num2str(Algo.w)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.pTransfer = str2double(Parameter{i}); i = i + 1;
        Algo.Operator = Parameter{i}; i = i + 1;
        Algo.mu = str2double(Parameter{i}); i = i + 1;
        Algo.mum = str2double(Parameter{i}); i = i + 1;
        Algo.F = str2double(Parameter{i}); i = i + 1;
        Algo.CR = str2double(Parameter{i}); i = i + 1;
        Algo.minx = str2double(Parameter{i}); i = i + 1;
        Algo.Lb = str2double(Parameter{i}); i = i + 1;
        Algo.Ub = str2double(Parameter{i}); i = i + 1;
        Algo.w = str2double(Parameter{i});
    end

    function run(Algo, Prob)
        operator = split(Algo.Operator, '/');
        % initialize
        population = Initialization(Algo, Prob, Individual_DE);
        if max(Prob.M) > 1
            for t = 1:Prob.T
                rank = NSGA2Sort(population{t});
                population{t} = population{t}(rank);
            end
        end
        scale = ones(Prob.T, Prob.T) * Algo.pTransfer; % adjust nTransfer dynamically
        trans = ones(Prob.T) * Algo.pTransfer;
        table = ones(Prob.T, Prob.T) * 0.5;
        table1 = zeros(Prob.T, Prob.T);
        for t = 1:Prob.T
            table(t, t) = 0;
            archive{t} = population{t}(randi(Prob.N, 1, 3 * Prob.N));
            orderlist{t} = [];
        end
        while Algo.notTerminated(Prob, population)
            for t = 1:Prob.T
                if rand < 0.9 %WCCI20 0.9 0.1 %PKACP 0.2 0.1
                    if rand < 0.1
                        sign = 1;
                    else
                        sign = 2;
                    end
                else
                    sign = 0;
                end
                m_pt = select_task(table(t, :));

                %直接轮盘赌
                %m_pt=select_task(table(t,:));
                if rand < table(t, m_pt) %从前一个任务中迁移一些染色体去繁殖,迁移策略是迁移过去的变量减去前一任务的均值，加上当前任务的均值
                    option = 1;
                else
                    m_pt = t;
                    option = 2;
                end

                if rand > 0.9
                    option = 0;
                end
                [~, order] = varOrder2(archive{m_pt}, archive{t}, Prob.D(m_pt), Prob.D(t), option);
                % [~,order]=varOrder2(population{m_pt},population{t},Prob.D(m_pt),Prob.D(t),option);
                if sign == 1 || sign == 2
                    nTransfer = round(scale(t, m_pt) * Prob.N);
                    tempPopulation = population{t}(end:-1:1);
                    % [~,order]=varOrder2(population{m_pt},population{t},Prob.D(m_pt),Prob.D(t),option);
                    tempPopulation(1:nTransfer) = m_transfer1(population{m_pt}, population{t}, Prob.D(m_pt), Prob.D(t), nTransfer, order, option);
                else
                    nTransfer = round(0.1 * Prob.N);
                    tempPopulation = population{t};
                    % [~,order]=varOrder2(population{m_pt},population{t},Prob.D(m_pt),Prob.D(t),option);
                    transpop = m_transfer1(population{m_pt}, population{t}, Prob.D(m_pt), Prob.D(t), nTransfer, order, option);
                end

                for i = 1:length(tempPopulation)
                    tempPopulation(i).F = Algo.F;
                    tempPopulation(i).CR = Algo.CR;
                end
                % Generation
                op_idx = mod(t - 1, length(operator)) + 1;
                op = operator{op_idx};
                if sign == 1 || sign == 0
                    switch op
                        case 'GA'
                            offspring = Algo.Generation_GA(tempPopulation);
                        case 'DE'
                            offspring = Algo.Generation_DE(tempPopulation);
                    end
                else
                    switch op
                        case 'GA'
                            offspring = Algo.Generation_GA1(population{t}, tempPopulation);
                        case 'DE'
                            offspring = Algo.Generation_DE1(population{t}, tempPopulation);
                    end
                end

                % Evaluation
                offspring = Algo.Evaluation(offspring, Prob, t);
                if sign == 0
                    transpop = Algo.Evaluation(transpop, Prob, t);
                    population{t} = [population{t}, offspring, transpop];
                else
                    population{t} = [population{t}, offspring];
                end
                % Selection
                if max(Prob.M) == 1
                    [~, rank] = sort(population{t}.Objs);
                else
                    rank = NSGA2Sort(population{t});
                end
                population{t} = population{t}(rank(1:Prob.N));
                archive{t} = Algo.updatearchive(archive{t}, population{t}, Prob);
                pop = population{t}(end:-1:1);
                if sign == 0
                    [~, ia] = intersect(pop.Decs, transpop.Decs, 'rows');
                    scale(t, m_pt) = sum(ia) / (Prob.N / 2 * (Prob.N + 1));
                    scale(t, m_pt) = 0.1 + scale(t, m_pt) * (0.5 - 0.1);
                else
                    [~, ia] = intersect(pop.Decs, offspring.Decs, 'rows');
                    scale(t, m_pt) = sum(ia) / (Prob.N / 2 * (Prob.N + 1));
                    scale(t, m_pt) = Algo.minx + scale(t, m_pt) * (0.5 - Algo.minx);
                end
                if m_pt == t && option ~= 0
                    trans(t) = scale(t, m_pt);
                end
                if m_pt ~= t && option ~= 0
                    temp = (scale(t, m_pt) - scale(t, t)) / (scale(t, m_pt) + scale(t, t));
                    Algo.w = 0.1 + rand * (0.9 - 0.1);
                    table(t, m_pt) = Algo.Lb + Algo.w * (table(t, m_pt) - Algo.Lb) + (1 - Algo.w) * temp * (Algo.Ub - Algo.Lb);
                    if table(t, m_pt) < Algo.Lb || isnan(table(t, m_pt))
                        table(t, m_pt) = Algo.Lb;
                    end
                    if table(t, m_pt) > Algo.Ub
                        table(t, m_pt) = Algo.Ub;
                    end
                end
            end
            % disp(table)
        end
    end

    function offspring = Generation_GA(Algo, population)
        indorder = randperm(length(population));
        count = 1;
        for i = 1:ceil(length(population) / 2)
            p1 = indorder(i);
            p2 = indorder(i + fix(length(population) / 2));
            offspring(count) = population(p1);
            offspring(count + 1) = population(p2);

            [offspring(count).Dec, offspring(count + 1).Dec] = GA_Crossover(population(p1).Dec, population(p2).Dec, Algo.mu);

            offspring(count).Dec = GA_Mutation(offspring(count).Dec, Algo.mum);
            offspring(count + 1).Dec = GA_Mutation(offspring(count + 1).Dec, Algo.mum);

            for x = count:count + 1
                offspring(x).Dec(offspring(x).Dec > 1) = 1;
                offspring(x).Dec(offspring(x).Dec < 0) = 0;
            end
            count = count + 2;
        end
    end

    function offspring = Generation_DE(Algo, population)
        for i = 1:length(population)
            offspring(i) = population(i);
            A = randperm(length(population), 4);
            A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3);
            offspring(i).Dec = population(x1).Dec + population(i).F * (population(x2).Dec - population(x3).Dec);
            offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, population(i).CR);

            rand_Dec = rand(1, length(offspring(i).Dec));
            offspring(i).Dec(offspring(i).Dec > 1) = rand_Dec(offspring(i).Dec > 1);
            offspring(i).Dec(offspring(i).Dec < 0) = rand_Dec(offspring(i).Dec < 0);
        end
    end

    function offspring = Generation_DE1(Algo, population, tempPop)
        for i = 1:length(population)
            offspring(i) = population(i);
            A = randperm(length(population), 4);
            A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3);
            offspring(i).Dec = population(x1).Dec + tempPop(i).F * (population(x2).Dec - population(x3).Dec);
            offspring(i).Dec = DE_Crossover(offspring(i).Dec, tempPop(i).Dec, tempPop(i).CR);

            rand_Dec = rand(1, length(offspring(i).Dec));
            offspring(i).Dec(offspring(i).Dec > 1) = rand_Dec(offspring(i).Dec > 1);
            offspring(i).Dec(offspring(i).Dec < 0) = rand_Dec(offspring(i).Dec < 0);
        end
    end

    function offspring = Generation_GA1(Algo, population, tempPop)
        indorder = randperm(length(population));
        count = 1;
        for i = 1:length(population)
            p1 = indorder(i);
            offspring(count) = population(p1);
            [offspring(count).Dec, ~] = GA_Crossover(tempPop(i).Dec, population(p1).Dec, Algo.mu);
            offspring(count).Dec = GA_Mutation(offspring(count).Dec, Algo.mum);

            offspring(count).Dec(offspring(count).Dec > 1) = 1;
            offspring(count).Dec(offspring(count).Dec < 0) = 0;
            count = count + 1;
        end
    end

    function archive = updatearchive(Algo, archive, population, Prob)
        i = mod(Algo.Gen, 3); N = size(population, 2);
        tempPop = archive(i * N + 1:(i + 1) * N);
        if Prob.M == 1
            [~, replace] = Selection_Tournament(tempPop, population);
            tempPop(replace) = population(replace);
        else
            P = [tempPop, population];
            rank = NSGA2Sort(P);
            tempPop = P(rank(1:N));
        end
        archive(i * N + 1:(i + 1) * N) = tempPop;
    end
end
end
