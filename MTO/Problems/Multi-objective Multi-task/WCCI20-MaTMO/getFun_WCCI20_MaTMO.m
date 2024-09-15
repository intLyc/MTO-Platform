function [Obj, Con] = getFun_WCCI20_MaTMO(x, tType, shiftVector, rotationMatrix, boundaryCvDv, gType, f1Type, hType, Lb, Ub)
switch tType
    case 'ZDT'
        f1 = evalF1(x(:, 1:boundaryCvDv), f1Type);
        g = evalGfunction(shiftVector, rotationMatrix, x(:, boundaryCvDv + 1:end), gType, Lb(boundaryCvDv + 1:end), Ub(boundaryCvDv + 1:end));
        g = g + 1;
        f2 = g .* evalH(f1, g, hType);
    case 'DTLZ'
        g = evalGfunction(shiftVector, rotationMatrix, x(:, boundaryCvDv + 1:end), gType, Lb(boundaryCvDv + 1:end), Ub(boundaryCvDv + 1:end));
        f1 = (1 + g) .* cos(x(:, 1) * 0.5 * pi);
        f2 = (1 + g) .* sin(x(:, 1) * 0.5 * pi);
end

Obj = [f1, f2];
Con = zeros(size(x, 1), 1);
end

function Gfunction = evalGfunction(shiftVector, rotationMatrix, x, gType, Lb, Ub)

x = (rotationMatrix * (x - repmat(shiftVector, size(x, 1), 1))')';
Lb = repmat(Lb, size(x, 1), 1);
Ub = repmat(Ub, size(x, 1), 1);
% Check Boundary
x(x < Lb) = Lb(x < Lb);
x(x > Ub) = Ub(x > Ub);
switch gType
    case 'Sphere'
        Gfunction = sum(x.^2, 2);
    case 'Rosenbrock'
        t = 0;
        for i = 1:size(x, 2) - 1
            t = t + 100 * (x(:, i).^2 - x(:, i + 1)).^2 + (1 - x(:, i)).^2;
        end
        Gfunction = t;
    case 'Ackley'
        sum1 = sum(x.^2, 2) / size(x, 2);
        sum2 = sum(cos(2 * pi .* x) ./ size(x, 2), 2);
        Gfunction = -20 * exp(-0.2 * sqrt(sum1)) - exp(sum2) + 20 +exp(1);
    case 'Griewank'
        t = sqrt([1:size(x, 2)]);
        sum1 = sum(x.^2, 2);
        prod1 = prod(cos(x ./ t), 2);
        Gfunction = 1 + sum1 / 4000 - prod1;
    case 'Rastrigin'
        a = 10 * size(x, 2);
        Gfunction = sum(x.^2 - 10 .* cos(2 * pi .* x), 2) + a;
    case 'Weierstrass'
        D = size(x, 2);
        a = 0.5;
        b = 3;
        kmax = 20;
        Gfunction = 0;
        for i = 1:D
            for k = 0:kmax
                Gfunction = Gfunction + a^k * cos(2 * pi * b^k * (x(:, i) + 0.5));
            end
        end
        for k = 0:kmax
            Gfunction = Gfunction - D * a^k * cos(2 * pi * b^k * 0.5);
        end
    case 'Mean'
        a = abs(x);
        Gfunction = sum(a, 2) / size(x, 2);
        Gfunction = 9 * Gfunction;
end
end

function F1Function = evalF1(x, f1Type)
if strcmp(f1Type, 'linear')
    A = sum(x, 2);
    F1Function = A / size(x, 2);
else
    A = sum(x.^2, 2);
    r = sqrt(A);
    F1Function = 1 - exp(-4 * r) .* sin(5 * pi * r).^4;
end
end

function Hfunction = evalH(F1Function, Gfunction, hType)
if strcmp(hType, 'convex')
    Hfunction = 1 - sqrt((F1Function ./ Gfunction));
else
    Hfunction = 1 - (F1Function ./ Gfunction).^2;
end
end
