classdef Chromosome_MFDE
    % 个体基因类
    properties
        rnvec; % 基因型
        factorial_costs; % 因子函数值
        factorial_ranks; % 因子排名
        scalar_fitness; % 标量适应值
        skill_factor; % 技能因子
    end

    methods

        function object = initialize(object, D)
            % 初始化，生成随机解
            object.rnvec = rand(1, D);
        end

        function [object, calls] = evaluate(object, Tasks, p_il, no_of_tasks, options)
            % 评价函数
            % 参数(个体, 任务组, 局部优化概率, 任务数量, 局部优化函数)
            % 返回值(个体, 评价次数)
            if object.skill_factor == 0
                % 初始化后的情况，评价所有任务
                calls = 0; % 评价次数

                for i = 1:no_of_tasks
                    [object.factorial_costs(i), object.rnvec, funcCount] = fnceval(Tasks(i), object.rnvec, p_il, options);
                    calls = calls + funcCount;
                end

            else
                % 只评价技能因子任务
                object.factorial_costs(1:no_of_tasks) = inf;
                [object.factorial_costs(object.skill_factor), object.rnvec, funcCount] = fnceval(Tasks(object.skill_factor), object.rnvec, p_il, options);
                calls = funcCount;
            end

        end

        function [object, calls] = evaluate_SOO(object, Task, p_il, options)
            % SOO评价函数
            [object.factorial_costs, object.rnvec, funcCount] = fnceval(Task, object.rnvec, p_il, options);
            calls = funcCount;
        end

        function object = crossover(object, p1, p2, cf)
            % 交叉操作
            % 参数(个体, 双亲1, 双亲2, 交叉点)
            % 返回值(个体)
            object.rnvec = 0.5 * ((1 + cf) .* p1.rnvec + (1 - cf) .* p2.rnvec);
            % 越界则拉回到边界
            object.rnvec(object.rnvec > 1) = 1;
            object.rnvec(object.rnvec < 0) = 0;
        end

        function object = mutate(object, p, D, sigma)
            % 变异操作
            % 参数(个体, 单亲, 维数, 标准差)
            % 返回值(个体)
            rvec = normrnd(0, sigma, [1, D]);
            object.rnvec = p.rnvec + rvec;
            % 越界则拉回到边界
            object.rnvec(object.rnvec > 1) = 1;
            object.rnvec(object.rnvec < 0) = 0;
        end

    end

end
