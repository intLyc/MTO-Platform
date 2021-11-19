classdef Chromosome_EMEA
    % 个体基因类
    properties
        rnvec; % 基因型
        fitness; % 适应值
    end

    methods

        function object = initialize(object, D)
            % 初始化，生成随机解
            object.rnvec = rand(1, D);
        end

        function [object, calls] = evaluate(object, Task)
            % 评价函数
            % 参数(个体, 任务组, 任务下标)
            % 返回值(个体, 评价次数)

            [object.fitness, object.rnvec, funcCount] = fnceval(Task, object.rnvec, 0, 0);
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
