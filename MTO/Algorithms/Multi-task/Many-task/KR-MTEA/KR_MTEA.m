classdef KR_MTEA < Algorithm
% <Multi-task/Many-task> <Single-objective/Multi-objective> <None>

%------------------------------- Reference --------------------------------
% @Article{Cui2023Adaptive,
%   title    = {Adaptive Multi-task Evolutionary Algorithm Based on Knowledge Reuse},
%   author   = {Cui, Zhihua and Zhao, Ben and Zhao, Tianhao and Cai, Xingjuan and Chen, Jinjun},
%   journal  = {Information Sciences},
%   year     = {2023},
%   month    = {08},
%   pages    = {119568},
%   volume   = {648},
%   doi      = {10.1016/j.ins.2023.119568},
% }
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
        trans = ones(1, Prob.T) * Algo.pTransfer;
        table = ones(Prob.T, Prob.T) * (Algo.Lb + Algo.Ub) / 2;
        table1 = zeros(Prob.T, Prob.T);
        for t = 1:Prob.T
            table(t, t) = 0;
        end
        while Algo.notTerminated(Prob, population)
            for t = 1:Prob.T
                % m_l = table(t, :);
                % m_l(m_l == 0) = [];
                % if max(m_l) == min(m_l)
                %     l = ones(1, Prob.T) * 0.5;
                %     l(t) = 0;
                % else
                %     for i = 1:Prob.T
                %         if i == t
                %             l(i) = 0;
                %         else
                %             l(i) = (table(t, i) - min(m_l)) / (max(table(t, :)) - min(m_l)) * (0.9 - 0.1) + 0.1;
                %         end
                %     end
                % end
                % m_pt = select_task(l);
                %直接轮盘赌
                m_pt = select_task(table(t, :));
                if rand < table(t, m_pt) %scale(t,m_pt)\(scale(t,m_pt)+trans(t)) %0.1 %从前一个任务中迁移一些染色体去繁殖,迁移策略是迁移过去的变量减去前一任务的均值，加上当前任务的均值
                    option = 1;
                else
                    m_pt = t;
                    option = 2;
                end
                nTransfer = round(scale(t, m_pt) * Prob.N);
                % if rand > 0.9
                %     option = 0;
                %     nTransfer = round(0.5 * Prob.N);
                % end

                if option == 1
                    % table1(t, m_pt) = table1(t, m_pt) + 1;
                    table1(t, m_pt) = table1(t, m_pt) + nTransfer;
                end
                tempPopulation = population{t}(end:-1:1);
                [~, order] = varOrder2(population{m_pt}, population{t}, Prob.D(m_pt), Prob.D(t), option);
                tempPopulation(1:nTransfer) = m_transfer1(population{m_pt}, population{t}, Prob.D(m_pt), Prob.D(t), nTransfer, order, option);

                for i = 1:length(tempPopulation)
                    tempPopulation(i).F = Algo.F;
                    tempPopulation(i).CR = Algo.CR;
                    % tempPopulation(i).F = 0.4 + (0.9 - 0.4) * rand;
                    % tempPopulation(i).CR = 0.4 + (0.9 - 0.4) * rand;
                    % tempPopulation(i).F = 0.1 + (2 - 0.1) * rand();
                    % tempPopulation(i).CR = 0.1 + (0.9 - 0.1) * rand();
                end
                % Generation
                op_idx = mod(t - 1, length(operator)) + 1;
                op = operator{op_idx};
                switch op
                    case 'GA'
                        offspring = Algo.Generation_GA(tempPopulation);
                    case 'DE'
                        offspring = Algo.Generation_DE(tempPopulation);
                end

                % Evaluation
                offspring = Algo.Evaluation(offspring, Prob, t);
                population{t} = [population{t}, offspring];
                % Selection
                if max(Prob.M) == 1
                    [~, rank] = sort(population{t}.Objs);
                else
                    rank = NSGA2Sort(population{t});
                end
                population{t} = population{t}(rank(1:Prob.N));
                pop = population{t}(end:-1:1);
                [~, ia] = intersect(pop.Decs, offspring.Decs, 'rows');
                scale(t, m_pt) = sum(ia) / (Prob.N / 2 * (Prob.N + 1));
                scale(t, m_pt) = Algo.minx + scale(t, m_pt) * (0.5 - Algo.minx);
                if m_pt == t && option ~= 0
                    trans(t) = scale(t, m_pt);
                end
                if m_pt ~= t && option ~= 0
                    temp = (scale(t, m_pt) - scale(t, t)) / (scale(t, m_pt) + scale(t, t));
                    Algo.w = 0.1 + rand * (0.9 - 0.1);
                    table(t, m_pt) = Algo.Lb + Algo.w * (table(t, m_pt) - Algo.Lb) + (1 - Algo.w) * temp * (Algo.Ub - Algo.Lb);
                    %                         table(t,m_pt)=0.5+Algo.w*(table(t,m_pt)-0.5)+(1-Algo.w)*temp*0.4;
                    if table(t, m_pt) < Algo.Lb || isnan(table(t, m_pt))
                        table(t, m_pt) = Algo.Lb;
                    end
                    if table(t, m_pt) > Algo.Ub
                        table(t, m_pt) = Algo.Ub;
                    end
                end
            end
            %                 disp(table)
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

end
end
