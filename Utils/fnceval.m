function [objective, rnvec, funcCount] = fnceval(Task, rnvec, p_il, options)
    % 具体评价函数
    % 参数(任务, 基因型, 使用局部优化函数的概率, 局部优化函数)
    % 返回值(目标函数值, 基因型, 函数评价次数)
    d = Task.dims; % 任务维数
    nvars = rnvec(1:d); % 标准化解，取基因型中对应当前任务的前n维
    minrange = Task.Lb(1:d); % 取值范围左边界
    maxrange = Task.Ub(1:d); % 取值范围右边界
    y = maxrange - minrange; % 取值范围大小
    vars = y .* nvars + minrange; % 将基因型映射到表现型，对应当前任务的解

    if rand(1) <= p_il
        % 进行局部优化
        [x, objective, exitflag, output] = fminunc(Task.fnc, vars, options);
        nvars = (x - minrange) ./ y; % 转换成基因型，映射到[0, 1]
        m_nvars = nvars;
        % 越界则拉回到边界
        m_nvars(nvars < 0) = 0;
        m_nvars(nvars > 1) = 1;

        if ~isempty(m_nvars ~= nvars)
            % 有越界则重新评价
            nvars = m_nvars;
            x = y .* nvars + minrange;
            objective = Task.fnc(x);
        end

        rnvec(1:d) = nvars; % 更改基因型
        funcCount = output.funcCount;
    else
        x = vars;
        objective = Task.fnc(x);
        funcCount = 1;
    end

end
