function [Obj, Con] = getFun_CEC21_MTMO(x, tType, shiftVector, rotationMatrix, boundaryCvDv, gType, f1Type, hType, Lb, Ub)
switch tType
    case 'MMDTLZ'
        g = evalGfunction(shiftVector, rotationMatrix, x(:, boundaryCvDv + 1:end), gType, Lb(boundaryCvDv + 1:end), Ub(boundaryCvDv + 1:end));
        f1 = (1 + g) .* cos(x(:, 1) * 0.5 * pi);
        f2 = (1 + g) .* sin(x(:, 1) * 0.5 * pi);
    otherwise
        f1 = evalF1(x(:, 1:boundaryCvDv), f1Type);
        g = evalGfunction(shiftVector, rotationMatrix, x(:, boundaryCvDv + 1:end), gType, Lb(boundaryCvDv + 1:end), Ub(boundaryCvDv + 1:end));
        g = g + 1;
        if strcmp(hType, 'convex')
            f2 = g .* (1 - sqrt((f1 ./ g)));
        else
            f2 = g .* (1 - (f1 ./ g).^2);
        end
end

Obj = [f1, f2];
Con = zeros(size(x, 1), 1);
end

function Gfunction = evalGfunction(shiftVector, rotationMatrix, x, gType, Lb, Ub)
switch gType
    case 'F4'
        x = x - repmat(shiftVector, size(x, 1), 1);
        x = x .* (2.048/100);
        x = rotationMatrix * x';
        x = x';
        %Rosenbrock
        t = 0;
        x(:, 1) = x(:, 1) + 1;
        for i = 1:size(x, 2) - 1
            x(:, i + 1) = x(:, i + 1) + 1;
            t = t + 100 * (x(:, i).^2 - x(:, i + 1)).^2 + (1 - x(:, i)).^2;
        end
        Gfunction = t;
    case 'F8'
        x = x - repmat(shiftVector, size(x, 1), 1);
        x = x .* (5.12/100);
        %Rastrigin
        a = 10 * size(x, 2);
        Gfunction = sum(x.^2 - 10 .* cos((2 * pi) .* x), 2) + a;
    case 'F9'
        x = x - repmat(shiftVector, size(x, 1), 1);
        x = x .* (5.12/100);
        x = rotationMatrix * x';
        x = x';
        %Rastrigin
        a = 10 * size(x, 2);
        Gfunction = sum(x.^2 - 10 .* cos(2 * pi .* x), 2) + a;
    case 'F11'
        x = x - repmat(shiftVector, size(x, 1), 1);
        x = x .* (1000.0/100);
        x = rotationMatrix * x';
        x = x';
        %MSchwefel
        prod1 = 0;
        for i = 1:size(x, 2)
            z = x(:, i) +4.209687462275036e+002;
            if abs(z) <= 500
                gz = z .* sin(abs(z).^0.5);
            elseif z > 500
                gz = (500 - mod(z, 500)) .* sin(abs(500 - mod(z, 500)).^0.5) - ((z - 500).^2) ./ (10000 * size(x, 2));
            else
                gz = (mod(abs(z), 500) - 500) .* sin(abs(500 - mod(abs(z), 500)).^0.5) - ((z + 500).^2) ./ (10000 * size(x, 2));
            end
            prod1 = prod1 + gz;
        end
        Gfunction = 418.9829 * size(x, 2) - prod1;
    case 'F15'
        x = x - repmat(shiftVector, size(x, 1), 1);
        x = x .* (5.0/100);
        x = rotationMatrix * x';
        x = x';
        %ExGriewRosen
        x(:, 1) = x(:, 1) + 1;
        Gfunction = 0;
        for i = 1:size(x, 2) - 1
            x(:, i + 1) = x(:, i + 1) + 1;
            t = 100 * ((x(:, i).^2 - x(:, i + 1)).^2) + (x(:, i) - 1).^2;
            Gfunction = Gfunction + (t.^2) ./ 4000 - cos(t) + 1;
        end
        index = size(x, 2);
        t = 100 * ((x(:, index).^2 - x(:, 1)).^2) + (x(:, index) - 1).^2;
        Gfunction = Gfunction + (t.^2) ./ 4000 - cos(t) + 1;
    case 'F17'
        x = x - repmat(shiftVector, size(x, 1), 1);
        x = rotationMatrix * x';
        x = x';
        D = size(x, 2);
        n1 = ceil(0.3 * D);
        n2 = ceil(0.3 * D);
        n3 = D - n1 - n2;
        x1 = x(:, 1:n1);
        x2 = x(:, n1 + 1:n1 + n2);
        x3 = x(:, n1 + n2 + 1:D);
        x1 = x1 .* (1000.0/100);
        x2 = x2 .* (5.12/100);
        %MSchwefel
        prod1 = 0;
        for i = 1:size(x1, 2)
            z = x1(:, i) +4.209687462275036e+002;
            if abs(z) <= 500
                gz = z .* sin(abs(z).^0.5);
            elseif z > 500
                gz = (500 - mod(z, 500)) .* sin(abs(500 - mod(z, 500)).^0.5) - ((z - 500).^2) ./ (10000 * size(x1, 2));
            else
                gz = (mod(abs(z), 500) - 500) .* sin(abs(500 - mod(abs(z), 500)).^0.5) - ((z + 500).^2) ./ (10000 * size(x1, 2));
            end
            prod1 = prod1 + gz;
        end
        Gfunction = 418.9829 * size(x1, 2) - prod1;
        %Rastrigin
        a = 10 * size(x2, 2);
        Gfunction = Gfunction + sum(x2.^2 - 10 .* cos(2 * pi .* x2), 2) + a;
        %Elliptic
        a = 10^6;
        for i = 1:n3
            Gfunction = Gfunction + (a.^((i - 1) ./ (n3 - 1))) * (x3(:, i).^2);
        end
    case 'F18'
        x = x - repmat(shiftVector, size(x, 1), 1);
        x = rotationMatrix * x';
        x = x';
        D = size(x, 2);
        n1 = ceil(0.3 * D);
        n2 = ceil(0.3 * D);
        n3 = D - n1 - n2;
        x1 = x(:, 1:n1);
        x2 = x(:, n1 + 1:n1 + n2);
        x3 = x(:, n1 + n2 + 1:D);
        x2 = x2 .* (5.0/100);
        x3 = x3 .* (5.12/100);
        %Cigar
        a = sum(x1(:, 2:end).^2, 2);
        Gfunction = x1(:, 1).^2 + a * (10^6);
        %HGBat
        x2 = x2 - 1;
        sum1 = sum(x2.^2, 2);
        sum2 = sum(x2, 2);
        Gfunction = Gfunction + (abs(sum1.^2 - sum2.^2)).^0.5 + (0.5 * sum1 + sum2) ./ n2 + 0.5;
        %Rastrigin
        a = 10 * n3;
        Gfunction = Gfunction + sum(x3.^2 - 10 .* cos(2 * pi .* x3), 2) + a;
    case 'F19'
        x = x - repmat(shiftVector, size(x, 1), 1);
        x = rotationMatrix * x';
        x = x';
        D = size(x, 2);
        n1 = ceil(0.2 * D);
        n2 = ceil(0.2 * D);
        n3 = ceil(0.3 * D);
        n4 = D - n1 - n2 - n3;
        x1 = x(:, 1:n1);
        x2 = x(:, n1 + 1:n1 + n2);
        x3 = x(:, n1 + n2 + 1:n1 + n2 + n3);
        x4 = x(:, n1 + n2 + n3 + 1:end);
        x1 = x1 .* (600.0/100);
        x2 = x2 .* (0.5/100);
        x3 = x3 .* (2.048/100);
        %Griewank
        t = sqrt([1:n1]);
        sum1 = sum(x1.^2, 2);
        prod1 = prod(cos(x1 ./ t), 2);
        Gfunction = 1 + sum1 ./ 4000 - prod1;
        %Weierstrass
        a = 0.5;
        b = 3;
        kmax = 20;
        part1 = 0;
        for i = 1:n2
            for k = 0:kmax
                part1 = part1 + a^k * cos(2 * pi * (b^k) * (x2(:, i) + 0.5));
            end
        end
        part2 = 0;
        for k = 0:kmax
            part2 = part2 + a^k * cos(2 * pi * (b^k) * 0.5);
        end
        Gfunction = Gfunction + part1 - n2 * part2;
        %Rosenbrock
        t = 0;
        x3(:, 1) = x3(:, 1) + 1;
        for i = 1:n3 - 1
            x3(:, i + 1) = x3(:, i + 1) + 1;
            t = t + 100 * (x3(:, i).^2 - x3(:, i + 1)).^2 + (1 - x3(:, i)).^2;
        end
        Gfunction = Gfunction + t;
        %ScafferF6
        t = 0;
        for i = 1:n4
            pSum = x4(:, i).^2 + x4(mod(i, n4) + 1).^2;
            t = 0.5 + ((sin(pSum.^0.5)).^2 - 0.5) ./ ((1 + 0.001 * pSum).^2);
            Gfunction = Gfunction + t;
        end
    case 'F20'
        x = x - repmat(shiftVector, size(x, 1), 1);
        x = rotationMatrix * x';
        x = x';
        D = size(x, 2);
        n1 = ceil(0.2 * D);
        n2 = ceil(0.2 * D);
        n3 = ceil(0.3 * D);
        n4 = D - n1 - n2 - n3;
        x1 = x(:, 1:n1);
        x2 = x(:, n1 + 1:n1 + n2);
        x3 = x(:, n1 + n2 + 1:n1 + n2 + n3);
        x4 = x(:, n1 + n2 + n3 + 1:end);
        x1 = x1 .* (5.0/100);
        x3 = x3 .* (5.0/100);
        x4 = x4 .* (5.12/100);
        %HGBat
        x1 = x1 - 1;
        sum1 = sum(x1.^2, 2);
        sum2 = sum(x1, 2);
        Gfunction = (abs(sum1.^2 - sum2.^2)).^0.5 + (0.5 * sum1 + sum2) ./ n1 + 0.5;
        %Discus
        Gfunction = Gfunction + (10^6) .* (x2(:, 1).^2) + sum(x2(2:end).^2, 2);
        %ExGriewRosen
        x3(:, 1) = x3(:, 1) + 1;
        for i = 1:n3 - 1
            x3(:, i + 1) = x3(:, i + 1) + 1;
            t = 100 * (x3(:, i).^2 - x3(:, i + 1)).^2 + (x3(:, i) - 1).^2;
            Gfunction = Gfunction + (t.^2) ./ 4000 - cos(t) + 1;
        end
        t = 100 * (x3(size(x3, 2)).^2 - x3(:, 1)).^2 + (x3(size(x3, 2)) - 1).^2;
        Gfunction = Gfunction + (t.^2) ./ 4000 - cos(t) + 1;
        %Rastrigin
        a = 10 * size(x4, 2);
        Gfunction = Gfunction + sum(x4.^2 - 10 .* cos(2 * pi .* x4), 2) + a;
    case 'F22'
        x = x - repmat(shiftVector, size(x, 1), 1);
        x = rotationMatrix * x';
        x = x';
        D = size(x, 2);
        n1 = ceil(0.1 * D);
        n2 = ceil(0.2 * D);
        n3 = ceil(0.2 * D);
        n4 = ceil(0.2 * D);
        n5 = D - n1 - n2 - n3 - n4;
        x1 = x(:, 1:n1);
        x2 = x(:, n1 + 1:n1 + n2);
        x3 = x(:, n1 + n2 + 1:n1 + n2 + n3);
        x4 = x(:, n1 + n2 + n3 + 1:n1 + n2 + n3 + n4);
        x5 = x(:, n1 + n2 + n3 + n4 + 1:end);
        x1 = x1 .* (5.0/100);
        x2 = x2 .* (5.0/100);
        x3 = x3 .* (5.0/100);
        x4 = x4 .* (1000.0/100);
        %Katsuura
        index = 32;
        prod1 = 0;
        Gfunction = 1;
        for i = 1:n1
            for j = 1:index
                prod1 = prod1 + abs(2^(j) * x1(:, i) - round(2^(j) * x1(:, i))) ./ (2^(j));
            end
            Gfunction = Gfunction .* ((1 + (i - 1) .* prod1).^(10 ./ (n1^1.2)));
        end
        Gfunction = (10 ./ (n1^1.2)) * (Gfunction - 1);
        %HappyCat
        x2 = x2 - 1;
        sum1 = sum(x2.^2, 2);
        sum2 = sum(x2, 2);
        Gfunction = Gfunction + abs(sum1 - n2).^0.25 + (0.5 * sum1 + sum2) ./ n2 + 0.5;
        %ExGriewRosen
        x3(:, 1) = x3(:, 1) + 1;
        for i = 1:n3 - 1
            x3(:, i + 1) = x3(:, i + 1) + 1;
            t = 100 * ((x3(:, i).^2 - x3(:, i + 1)).^2) + (x3(:, i) - 1).^2;
            Gfunction = Gfunction + (t.^2) ./ 4000 - cos(t) + 1;
        end
        t = 100 * ((x3(size(x3, 2)).^2 - x3(:, 1)).^2) + (x3(size(x3, 2)) - 1).^2;
        Gfunction = Gfunction + (t.^2) ./ 4000 - cos(t) + 1;
        %MSchwefel
        prod1 = 0;
        for i = 1:size(x4, 2)
            z = x4(:, i) +4.209687462275036e+002;
            if abs(z) <= 500
                gz = z .* sin(abs(z).^0.5);
            elseif z > 500
                gz = (500 - mod(z, 500)) .* sin(abs(500 - mod(z, 500)).^0.5) - ((z - 500).^2) ./ (10000 * n4);
            else
                gz = (mod(abs(z), 500) - 500) .* sin(abs(500 - mod(abs(z), 500)).^0.5) - ((z + 500).^2) ./ (10000 * n4);
            end
            prod1 = prod1 + gz;
        end
        Gfunction = Gfunction + 418.9829 * n4 - prod1;
        %Ackley
        sum1 = sum(x5.^2, 2) ./ n5;
        sum2 = sum(cos(2 * pi .* x5) ./ n5, 2);
        Gfunction = Gfunction + (-20) * exp(-0.2 * sqrt(sum1)) - exp(sum2) + 20 +exp(1);
end
end

function F1Function = evalF1(x, f1Type)
if strcmp(f1Type, 'linear')
    A = sum(x, 2);
    F1Function = A ./ size(x, 2);
else
    A = sum(x.^2, 2);
    F1Function = sqrt(A);
end
end
