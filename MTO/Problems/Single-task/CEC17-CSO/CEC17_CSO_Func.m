function [Obj, Con] = CEC17_CSO_Func(x, I_fno, o, M)

    % CEC2017 Constrained Optimization Test Suite
    % Guohua Wu (email: guohuawu@nudt.edu.cn, National University of Defense Technology)

    [ps, D] = size(x);

    if I_fno == 5
        M1 = M{1};
        M2 = M{2};
        if size(M1, 1) > D
            M1 = M1(1:D, 1:D);
            M2 = M2(1:D, 1:D);
            M = {M1, M2};
        end
    else
        if size(M, 1) > D
            M = M(1:D, 1:D);
        end
    end

    if (I_fno == 1)
        o = o(1:D);
        y = x - repmat(o, size(x, 1), 1);
        f = 0;
        for i = 1:D
            f = f + sum(y(:, 1:i), 2).^2;
            %           f = f + sum(y(:,1:i),2).^2;
        end
        g = sum(y.^2 - 5000 .* cos(0.1 .* pi .* y) - 4000, 2);
        h = zeros(ps, 1);
    end

    if (I_fno == 2)
        o = o(1:D);
        y = x - repmat(o, size(x, 1), 1);
        z = (M * y')';
        f = 0;
        for i = 1:D
            f = f + sum(y(:, 1:i), 2).^2;
        end
        g = sum(z.^2 - 5000 .* cos(0.1 .* pi .* z) - 4000, 2);
        h = zeros(ps, 1);
    end

    if (I_fno == 3)
        o = o(1:D);
        y = x - repmat(o, size(x, 1), 1);
        f = 0;
        for i = 1:D
            f = f + sum(y(:, 1:i), 2).^2;
        end
        g = sum(y.^2 - 5000 .* cos(0.1 .* pi .* y) - 4000, 2);
        h = -sum(y .* sin(0.1 * pi * y), 2);
    end

    if (I_fno == 4)
        o = o(1:D);
        y = x - repmat(o, size(x, 1), 1);
        f = sum(y.^2 - 10 .* cos(2 .* pi .* y) + 10, 2);
        g1 = sum(-y .* sin(2 * y), 2);
        g2 = sum(y .* sin(y), 2);
        g = [g1, g2];
        h = zeros(ps, 1);
    end

    if (I_fno == 5)
        o = o(1:D);
        y = x - repmat(o, size(x, 1), 1);
        M1 = M{1};
        M2 = M{2};
        z1 = (M1 * y')';
        z2 = (M2 * y')';
        f = sum(100 * (y(:, 1:D - 1).^2 - y(:, 2:D)).^2 + (y(:, 1:D - 1) - 1).^2, 2);
        g1 = sum(z1.^2 - 50 .* cos(2 .* pi .* z1) - 40, 2);
        g2 = sum(z2.^2 - 50 .* cos(2 .* pi .* z2) - 40, 2);
        g = [g1, g2];
        h = zeros(ps, 1);
    end

    if (I_fno == 6)
        o = o(1:D);
        y = x - repmat(o, size(x, 1), 1);
        f = sum(y.^2 - 10 .* cos(2 .* pi .* y) + 10, 2);
        h1 = sum(-y .* sin(y), 2);
        h2 = sum(y .* sin(pi * y), 2);
        h3 = sum(-y .* cos(y), 2);
        h4 = sum(y .* cos(pi * y), 2);
        h5 = sum(y .* sin(2 * sqrt(abs(y))), 2);
        h6 = sum(-y .* sin(2 * sqrt(abs(y))), 2);
        h = [h1, h2, h3, h4, h5, h6];
        g = zeros(ps, 1);
    end

    if (I_fno == 7)
        o = o(1:D);
        y = x - repmat(o, size(x, 1), 1);
        f = sum(y .* sin(y), 2);
        h1 = sum(y - 100 * cos(0.5 * y) + 100, 2);
        h2 = sum(-y + 100 * cos(0.5 * y) - 100, 2);
        h = [h1, h2];
        g = zeros(ps, 1);
    end

    if (I_fno == 8)
        o = o(1:D);
        y = x - repmat(o, size(x, 1), 1);
        f = max(y, [], 2);
        z1 = y(:, 1:2:D);
        z2 = y(:, 2:2:D);
        h1 = 0; h2 = 0;
        for i = 1:round(D / 2)
            h1 = h1 + sum(z1(:, 1:i), 2).^2;
            h2 = h2 + sum(z2(:, 1:i), 2).^2;
        end
        h = [h1, h2];
        g = zeros(ps, 1);
    end

    if (I_fno == 9)
        o = o(1:D);
        y = x - repmat(o, size(x, 1), 1);
        f = max(y, [], 2);
        z1 = y(:, 1:2:D);
        z2 = y(:, 2:2:D);
        h = sum((z1(:, 1:round(D / 2) - 1).^2 - z1(:, 2:round(D / 2))).^2, 2);
        g = prod(z2, 2);
    end

    if (I_fno == 10)
        o = o(1:D);
        y = x - repmat(o, size(x, 1), 1);
        f = max(y, [], 2);
        h1 = 0;
        for i = 1:D
            h1 = h1 + sum(y(:, 1:i), 2).^2;
        end
        h2 = sum((y(:, 1:D - 1) - y(:, 2:D)).^2, 2);
        h = [h1, h2];
        g = zeros(ps, 1);
    end

    if (I_fno == 11)
        o = o(1:D);
        y = x - repmat(o, size(x, 1), 1);
        f = sum(y, 2);
        h = sum((y(:, 1:D - 1) - y(:, 2:D)).^2, 2);
        g = prod(y, 2);
    end

    %%%%%%%%%%%% -----------------------------%%%%%%%%%%%%%%%%%%
    if (I_fno == 12)
        o = o(1:D);
        x = x - repmat(o, size(x, 1), 1);
        f = sum(x.^2 - 10 .* cos(2 .* pi .* x) + 10, 2);
        g1 = -sum(abs(x), 2) + 4;
        g2 = sum(x.^2, 2) -4;
        g = [g1, g2];
        h = zeros(ps, 1);
    end

    if (I_fno == 13)
        o = o(1:D);
        x = x - repmat(o, size(x, 1), 1);
        f = sum(100 .* (x(:, 1:D - 1).^2 - x(:, 2:D)).^2 + (x(:, 1:D - 1) - 1).^2, 2);
        g1 = sum(x.^2 - 10 .* cos(2 .* pi .* x) + 10, 2) - 100;
        g2 = sum(x, 2) - 2 * D;
        g3 = -sum(x, 2) + 5;
        g = [g1, g2, g3];
        h = zeros(ps, 1);
    end

    if (I_fno == 14)
        o = o(1:D);
        x = x - repmat(o, size(x, 1), 1);
        f = sum(x.^2, 2);
        f = 20 - 20 .* exp(-0.2 .* sqrt(f ./ D)) - exp(sum(cos(2 .* pi .* x), 2) ./ D) + exp(1);
        h = sum(x.^2, 2) - 4;
        g = -abs(x(:, 1)) + sum(x(:, 2:end).^2, 2) +1;
    end

    if (I_fno == 15)
        o = o(1:D);
        x = x - repmat(o, size(x, 1), 1);
        f = max(abs(x), [], 2);
        h = cos(f) + sin(f);
        g = sum(x.^2, 2) - 100 * D;
    end

    if (I_fno == 16)
        o = o(1:D);
        x = x - repmat(o, size(x, 1), 1);
        f = sum(abs(x), 2);
        h = (cos(f) + sin(f)).^2 - exp(cos(f) + sin(f)) - 1 + exp(1);
        g = sum(x.^2, 2) - 100 * D;
    end

    if (I_fno == 17)
        o = o(1:D);
        x = x - repmat(o, size(x, 1), 1);
        f = 1;
        for i = 1:D
            f = f .* (cos(x(:, i) / sqrt(i)));
        end
        f = sum(x.^2, 2) / 4000 - f + 1;
        dataSum = sum(x.^2, 2);
        g = -sum(sign(abs(x) - (repmat(dataSum, 1, D) - x.^2) - 1), 2) + 1;
        h = sum(x.^2, 2) - 4 * D;
    end

    if (I_fno == 18)
        o = o(1:D);
        x = x - repmat(o, size(x, 1), 1);
        g1 = -sum(abs(x), 2) + 1;
        g2 = sum(x.^2, 2) - 100 * D;
        sum1 = sum(100 .* (x(1, 1:D - 1).^2 - x(1, 2:D)).^2);
        multi = 1;
        for i = 1:D
            multi = multi .* sin((x(:, i) - 1) * pi).^2;
        end
        h = sum1 + multi;

        x = (abs(x) < 0.5) .* x + (abs(x) >= 0.5) .* (round(x .* 2) ./ 2);
        f = sum(x.^2 - 10 .* cos(2 .* pi .* x) + 10, 2);

        g = [g1, g2];
    end

    if (I_fno == 19)
        o = o(1:D);
        x = x - repmat(o, size(x, 1), 1);
        f = sum(abs(x).^0.5 + 2 * sin(x.^3), 2);
        g1 = sum(-10 * exp(-0.2 * (x(:, 1:D - 1).^2 + x(:, 2:D).^2).^0.5), 2) + (D - 1) * 10 / exp(-5);
        g2 = sum(sin(2 * x).^2, 2) - 0.5 * D;
        g = [g1, g2];
        h = zeros(ps, 1);
    end

    if (I_fno == 20)
        o = o(1:D);
        x = x - repmat(o, size(x, 1), 1);
        sum1 = sum(0.5 + (sin((x(:, 1:D - 1).^2 + x(:, 2:D).^2).^0.5).^2 - 0.5) ./ (1 + 0.001 * (x(:, 1:D - 1).^2 + x(:, 2:D).^2).^0.5).^2, 2);
        sum2 = 0.5 + (sin((x(:, D).^2 + x(:, 1).^2).^0.5).^2 - 0.5) ./ (1 + 0.001 * (x(:, D).^2 + x(:, 1).^2).^0.5).^2;
        f = sum1 + sum2;
        g1 = cos(sum(x, 2)).^2 - 0.25 * cos(sum(x, 2)) - 0.125;
        g2 = exp(cos(sum(x, 2))) - exp(0.25);
        g = [g1, g2];
        h = zeros(ps, 1);
        % h = cos(sum(x,2)).^2 - 025*cos(sum(x,2)) - 0.125;
        % g = exp(cos(sum(x,2))) - exp(0.4);

    end

    if (I_fno == 21)
        o = o(1:D);
        x = x - repmat(o, size(x, 1), 1);
        x = (M * x')';
        f = sum(x.^2 - 10 .* cos(2 .* pi .* x) + 10, 2);
        g1 = -sum(abs(x), 2) + 4;
        g2 = sum(x.^2, 2) -4;
        g = [g1, g2];
        h = zeros(ps, 1);
    end

    if (I_fno == 22)
        o = o(1:D);
        x = x - repmat(o, size(x, 1), 1);
        x = (M * x')';
        f = sum(100 .* (x(:, 1:D - 1).^2 - x(:, 2:D)).^2 + (x(:, 1:D - 1) - 1).^2, 2);
        g1 = sum(x.^2 - 10 .* cos(2 .* pi .* x) + 10, 2) - 100;
        g2 = sum(x, 2) - 2 * D;
        g3 = -sum(x, 2) + 5;
        g = [g1, g2, g3];
        h = zeros(ps, 1);
    end

    if (I_fno == 23)
        o = o(1:D);
        x = x - repmat(o, size(x, 1), 1);
        x = (M * x')';
        f = sum(x.^2, 2);
        f = 20 - 20 .* exp(-0.2 .* sqrt(f ./ D)) - exp(sum(cos(2 .* pi .* x), 2) ./ D) + exp(1);
        h = sum(x.^2, 2) - 4;
        g = -abs(x(:, 1)) + sum(x(:, 2:end).^2, 2) +1;
    end

    if (I_fno == 24)
        o = o(1:D);
        x = x - repmat(o, size(x, 1), 1);
        x = (M * x')';
        f = max(abs(x), [], 2);
        h = cos(f) + sin(f);
        g = sum(x.^2, 2) - 100 * D;
    end

    if (I_fno == 25)
        o = o(1:D);
        x = x - repmat(o, size(x, 1), 1);
        x = (M * x')';
        sum1 = sum(abs(x), 2);
        f = sum1;
        h = (cos(f) + sin(f)).^2 - exp(cos(f) + sin(f)) - 1 + exp(1);
        g = sum(x.^2, 2) - 100 * D;
    end

    if (I_fno == 26)
        o = o(1:D);
        x = x - repmat(o, size(x, 1), 1);
        x = (M * x')';
        f = 1;
        for i = 1:D
            f = f .* (cos(x(:, i) / sqrt(i)));
        end
        f = sum(x.^2, 2) / 4000 - f + 1;
        dataSum = sum(x.^2, 2);
        g = -sum(sign(abs(x) - (repmat(dataSum, 1, D) - x.^2) - 1), 2) + 1;
        h = sum(x.^2, 2) - 4 * D;
    end

    if (I_fno == 27)
        o = o(1:D);
        x = x - repmat(o, size(x, 1), 1);
        x = (M * x')';
        g1 = -sum(abs(x), 2) + 1;
        g2 = sum(x.^2, 2) - 100 * D;
        sum1 = sum(100 .* (x(1, 1:D - 1).^2 - x(1, 2:D)).^2);
        multi = 1;
        for i = 1:D
            multi = multi .* sin((x(:, i) - 1) * pi).^2;
        end
        h = sum1 + multi;

        x = (abs(x) < 0.5) .* x + (abs(x) >= 0.5) .* (round(x .* 2) ./ 2);
        f = sum(x.^2 - 10 .* cos(2 .* pi .* x) + 10, 2);

        g = [g1, g2];
    end

    if (I_fno == 28)
        o = o(1:D);
        x = x - repmat(o, size(x, 1), 1);
        x = (M * x')';
        f = sum(abs(x).^0.5 + 2 * sin(x.^3), 2);
        g1 = sum(-10 * exp(-0.2 * (x(:, 1:D - 1).^2 + x(:, 2:D).^2).^0.5), 2) + (D - 1) * 10 / exp(-5);
        g2 = sum(sin(2 * x).^2, 2) - 0.5 * D;
        g = [g1, g2];
        h = zeros(ps, 1);
    end

    Obj = f;
    g(g < 0) = 0;
    h = abs(h) - 1e-4;
    h(h < 0) = 0;
    Con = [g, h];
    Con(isnan(Con)) = Inf;
end
