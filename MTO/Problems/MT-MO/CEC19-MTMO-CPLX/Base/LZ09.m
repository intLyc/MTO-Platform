classdef LZ09
    %UNTITLED4 此处显示有关此类的摘要
    %   此处显示详细说明

    properties
        dim; %决策变量维度
        numOfObjective; %目标数
        ltype;
        dtype;
        ptype;
    end

    methods
        %% functionname: function description
        function obj = LZ09(dim, numOfObjective, ltype, dtype, ptype)
            obj.dim = dim;
            obj.numOfObjective = numOfObjective;
            obj.ltype = ltype;
            obj.dtype = dtype;
            obj.ptype = ptype;

        end

        function [beta] = psfunc(obj, x, x1, css) %其中type 是ltype
            %x  : 分好奇偶的决策变量    x1:决策变量的第一维
            %obj.dim：个体维度   obj.ltype：函数类型 ，css：class of index ;  xective_num：目标数
            if (obj.ltype == 21)
                if mod(length(x), 2) == 0
                    qq = [3:2:obj.dim];
                else
                    qq = [2:2:obj.dim];
                end
                x = 2 .* (x - 0.5);
                beta = x - x1.^(0.5 .* (obj.dim + 3 .* qq - 8) ./ (obj.dim - 2));

            end

            if (obj.ltype == 22)
                if mod(length(x), 2) == 0
                    qq = [3:2:obj.dim];
                else
                    qq = [2:2:obj.dim];
                end
                x = 2 .* (x - 0.5);
                theta = sin(6 * pi * x1 + (pi .* qq) ./ obj.dim);
                beta = x - theta;

            end

            if obj.ltype == 23

                if mod(length(x), 2) == 0
                    qq = [3:2:obj.dim];
                else
                    qq = [2:2:obj.dim];
                end
                theta = 6 * pi * x1 + (pi .* qq) ./ obj.dim;
                ra = 0.8 * x1;
                x = 2 .* (x - 0.5);
                if (css == 1)

                    beta = x - ra .* cos(theta);
                else
                    beta = x - ra .* sin(theta);
                end

            end

            if obj.ltype == 24
                if mod(length(x), 2) == 0
                    qq = [3:2:obj.dim];
                else
                    qq = [2:2:obj.dim];
                end
                theta = 6 * pi * x1 + (pi .* qq) ./ obj.dim;
                ra = 0.8 * x1;
                x = 2 .* (x - 0.5);
                if (css == 1)
                    beta = x - ra .* cos(theta ./ 3);
                else
                    beta = x - ra .* sin(theta);
                end

            end

            if obj.ltype == 25
                rho = 0.8;
                phi = pi * x1;
                if mod(length(x), 2) == 0
                    qq = [3:2:obj.dim];
                else
                    qq = [2:2:obj.dim];
                end
                theta = 6 * pi * x1 + (pi .* qq) ./ obj.dim;
                x = 2 .* (x - 0.5);
                if css == 1
                    beta = x - rho * sin(phi) .* sin(theta);
                elseif css == 2
                    beta = x - rho * sin(phi) .* cos(theta);
                else
                    beta = x - rho * cos(phi);
                end
            end

            if obj.ltype == 26
                if mod(length(x), 2) == 0
                    qq = [3:2:obj.dim];
                else
                    qq = [2:2:obj.dim];
                end
                theta = 6 * pi * x1 + (pi .* qq) ./ obj.dim;
                ra = 0.3 * x1 .* (x1 .* cos(4 .* theta) + 2);
                x = 2 .* (x - 0.5);
                if (css == 1)
                    beta = x - ra .* cos(theta);
                else
                    beta = x - ra .* sin(theta);
                end
            end
        end
        %-----------------psfun  end-----------------------

        %-----------------psfun3 begin -----------------------
        %% psfunc3: function description
        function beta = psfunc3(obj, x, x1, x2, order)
            % obj :问题实例		x：J1 , J2 , J3 ； order ：J1 , J2, J3在原决策变量的中的序号
            if obj.ltype == 32

                theta = 2 * pi * x1 + pi .* order ./ obj.dim;
                x = 4 .* (x - 0.5);
                beta = x - 2 * x2 .* sin(theta);

            end
        end
        % ---------- psfun3 end---------------------------------

        function alpha = alphaFunction(obj, x) %加号两侧最外层的一部分

            %inpu:obj,问题的实例化对象  ,x:个体的决策变量   其中type带入ptype
            %output ：alpha 两个目标函数不同的最外层部分
            if obj.numOfObjective == 2 %二目标问题
                switch obj.ptype
                    case 21
                        alpha(1) = x(1);
                        alpha(2) = 1 - sqrt(x(1));
                    case 22
                        alpha(1) = x(1);
                        alpha(2) = 1 - x(1)^2;
                    case 23
                        alpha(1) = x(1);
                        alpha(2) = 1 - sqrt(x(1)) - x(1) * sin(10 * x(1)^2 * pi);
                    case 24
                        alpha(1) = x(1);
                        alpha(2) = 1 - x(1) - 0.05 * sin(4 * pi * x(1));
                end
            else %三目标问题
                switch obj.ptype
                    case 31
                        alpha(1) = cos(x(1) * (pi / 2)) * cos(x(2) * (pi / 2));
                        alpha(2) = cos(x(1) * (pi / 2)) * sin(x(2) * (pi / 2));
                        alpha(3) = sin(x(1) * (pi / 2));
                    case 32
                        alpha(1) = 1 - cos(x(1) * (pi / 2)) * cos(x(2) * (pi / 2));
                        alpha(2) = 1 - cos(x(1) * (pi / 2)) * sin(x(2) * (pi / 2));
                        alpha(3) = 1 - sin(x(1) * (pi / 2));
                    case 33
                        alpha(1) = x(1);
                        alpha(2) = x(2);
                        alpha(3) = 3 - (sin(3 * pi * x(1)) + sin(3 * pi * x(2))) - 2 * (x(1) + x(2));
                    case 34
                        alpha(1) = x(1) * x(2);
                        alpha(2) = x(1) * (1 - x(1));
                        alpha(3) = 1 - x(1);
                end
            end
        end
        % --------------------------------------------------------
        function beta = betaFunction(oddEven_x, obj)
            %input: oddEven_x : 此时只是传入奇数维或者偶数维的决策变量，其中奇数维不包含第一维
            %output : beta：计算出的累加和部分，只是累加的部分不同 obj.dtype的值不同
            beta = 0;
            dim = length(oddEven_x);
            if dim == 0
                beta = 0;
            end
            switch obj.dtype
                case 1
                    beta = 0;
                    beta = sum(oddEven_x.^2);
                    beta = 2 * beta / dim;
                case 2
                    beta = 0;
                    a = [1:1:dim];
                    a = sqrt (a);
                    oddEven_x = oddEven_x.^2;
                    beta = sum(oddEven_x .* a);
                    beta = 2 * beta / dim;
                case 3
                    beta = 0;
                    oddEven_x1 = oddEven_x; %这里需要oddEven_x的一个备份
                    beta = sum((2 .* oddEven_x).^2) - sum(cos(4 * pi * oddEven_x1));
                    beta = beta + dim;
                    beta = 2 * beta / dim;
                case 4
                    sum1 = 0;
                    prod = 1;
                    oddEven_x1 = oddEven_x; %oddEven_x :计算累加   oddEven_x1：计算累乘
                    sum1 = sum((2 .* oddEven_x).^2);
                    a = [1:dim];
                    a = sqrt(a);
                    prod = cos(10 * pi * (2 .* oddEven_x1) ./ a);
                    prod = cumprod(prod);
                    a = prod(end);
                    beta = 2 * (sum1 - 2 * a + 2) / dim;
            end

        end
        %---------------------------betaFunction finished--------------------------

        %---------------------------objectiveFunction begin-----------------------
        %% objectiveFunction:nction description
        function fitness = objectiveFunction(obj, x)
            % input: x , 决策变量  obj：问题实例
            % output: fitness_1 :目标函数 1的评价值 ， 目标函数2的评价值
            ltypeTable = [21, 22, 23, 24, 26];
            if obj.numOfObjective == 2 %二目标问题
                if ismember(obj.ltype, ltypeTable)
                    J1 = x(3:2:end);
                    a = psfunc(obj, J1, x(1), 1);
                    %提取出偶数维
                    J2 = x(2:2:end);
                    b = psfunc(obj, J2, x(1), 2);
                    g = betaFunction(a, obj);
                    h = betaFunction(b, obj);
                    alpha1 = alphaFunction(obj, x);
                    fitness_1 = alpha1(1) + h;
                    fitness_2 = alpha1(2) + g;
                    fitness = [fitness_1, fitness_2];
                else %ltype 是25的这种类型  %把决策变量分为3组
                    J1 = x(4:3:end);
                    a = psfunc(obj, J1, x(1), 1);
                    J2 = x(2:3:end);
                    b = psfunc(obj, J2, x(1), 2);
                    J3 = x(3:3:end);
                    c = psfunc(obj, J3, x(1), 3);
                    % 奇数复制给A ,偶数复制给B
                    a = [a, c(1:2:end)];
                    b = [b, b(2:2:end)];
                    g = betaFunction(a, obj);
                    h = betaFunction(b, obj);
                    alpha1 = alphaFunction(obj, x);
                    fitness_1 = alpha1(1) + h;
                    fitness_2 = alpha1(2) + g;
                    fitness = [fitness_1, fitness_2];
                end
            else

                J1 = x(4:3:end);
                J2 = x(5:3:end);
                J3 = x(3:3:end);
                order1 = [4:3:length(x)];
                order2 = [5:3:length(x)];
                order3 = [3:3:length(x)];
                a = psfunc3(obj, J1, x(1), x(2), order1);
                b = psfunc3(obj, J2, x(1), x(2), order2);
                c = psfunc3(obj, J3, x(1), x(2), order3);
                g = betaFunction(a, obj);
                h = betaFunction(b, obj);
                e = betaFunction(c, obj);
                alpha1 = alphaFunction(obj, x);
                fitness_1 = alpha1(1) + g;
                fitness_2 = alpha1(2) + h;
                fitness_3 = alpha1(3) + e;
                fitness = [fitness_1, fitness_2, fitness_3];
            end
        end
    end
end
