function [Obj, Con] = getFun_CMOMT(x, Problem, Task, S)

%------------------------------- Reference --------------------------------
% @Article{Li2025CMO-MTO,
%   title    = {Evolutionary Competitive Multiobjective Multitasking: One-Pass Optimization of Heterogeneous Pareto Solutions},
%   author   = {Li, Yanchi and Wu, Xinyi and Gong, Wenyin and Xu, Meng and Wang, Yubo and Gu, Qiong},
%   journal  = {IEEE Transactions on Evolutionary Computation},
%   year     = {2024},
%   doi      = {10.1109/TEVC.2024.3524508},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

switch Problem
    case 1
        if Task == 1 % concave, unimodal, separable
            %Sphere
            [n, D] = size(x);
            z = x(:, 2:end) - repmat(S(1:D - 1), n, 1);
            g = ones(n, 1) + sum(z.^2, 2);
            g = (g - 1) / 10 + 1;
            f = [g .* cos(x(:, 1) .* pi / 2), g .* sin(x(:, 1) .* pi / 2)];
            f = f .* [8, 5] + [2, 0];
        else % concave, unimodal, separable
            %Sphere
            [n, D] = size(x);
            z = x(:, 2:end) - repmat(S(1:D - 1), n, 1);
            g = ones(n, 1) + sum(z.^2, 2);
            g = (g - 1) / 10 + 1;
            f = [g .* cos(x(:, 1) .* pi / 2), g .* sin(x(:, 1) .* pi / 2)];
            f = f .* [5, 8] + [0, 2];
        end

    case 2
        if Task == 1 % concave, unimodal, separable
            [n, D] = size(x);
            z = x(:, 2:end) - repmat(S(1:D - 1), n, 1);
            g = ones(n, 1) + 9 / (D - 1) * sum(abs(z), 2);
            g = (g - 1) / 10 + 1;
            f = [g .* cos(x(:, 1) .* pi / 2), g .* sin(x(:, 1) .* pi / 2)];
            f = f .* [8, 5] + [2, 0];
        else % concave, multimodal, separable
            %Rastrigin
            [n, D] = size(x);
            z = x(:, 2:end) - repmat(S(1:D - 1), n, 1);
            g = ones(n, 1) + sum(z.^2 - 10 * cos(2 * pi * z) + 10 * ones(size(z)), 2);
            g = (g - 1) / 10 + 1;
            f = [g .* cos(x(:, 1) .* pi / 2), g .* sin(x(:, 1) .* pi / 2)];
            f = f .* [5, 8] + [0, 2];
        end

    case 3
        if Task == 1 % concave, unimodal, separable
            [n, D] = size(x);
            z = x(:, 2:end) - repmat(S(1:D - 1), n, 1);
            g = ones(n, 1) + 9 / (D - 1) * sum(abs(z), 2);
            g = (g - 1) / 10 + 1;
            f = [x(:, 1), g .* (1 - (x(:, 1) ./ g).^2)];
            f = f .* [10, 10] + [0, 0];
        else % convex, unimodal, separable
            [n, D] = size(x);
            z = x(:, 2:end) - repmat(S(1:D - 1), n, 1);
            g = ones(n, 1) + 9 / (D - 1) * sum(abs(z), 2);
            g = (g - 1) / 5 + 1;
            f = [x(:, 1), g .* (1 - sqrt(x(:, 1) ./ g))];
            f = f .* [5, 5] + [2, 2];
        end

    case 4
        if Task == 1 % concave, multimodal, non-separable
            %Ackley
            [n, D] = size(x);
            z = x(:, 2:end) - repmat(S(1:D - 1), n, 1);
            g = 21 + exp(1) - 20 * exp(-0.2 * sqrt(1 / (D - 1) * sum(z.^2, 2))) - exp(1 / (D - 1) * sum(cos(2 * pi * z), 2));
            g = (g - 1) / 1 + 1;
            f = [x(:, 1), g .* (1 - (x(:, 1) ./ g).^2)];
            f = f .* [10, 10] + [0, 0];
        else % convex, multimodal, non-separable
            %Rosenbrock
            [n, D] = size(x);
            z = x(:, 2:end) - repmat(S(1:D - 1), n, 1);
            g = ones(n, 1) + sum(100 * ((z(:, 1:end - 1).^2 - z(:, 2:end)).^2 + (ones(size(z(:, 1:end - 1))) - z(:, 1:end - 1)).^2), 2);
            g = (g - 1) / 5 + 1;
            f = [x(:, 1), g .* (1 - sqrt(x(:, 1) ./ g))];
            f = f .* [5, 5] + [2, 2];
        end

    case 5
        if Task == 1 % convex, multimodal, non-separable
            %Rosenbrock
            [n, D] = size(x);
            z = x(:, 2:end) - repmat(S(1:D - 1), n, 1);
            g = ones(n, 1) + sum(100 * ((z(:, 1:end - 1).^2 - z(:, 2:end)).^2 + (ones(size(z(:, 1:end - 1))) - z(:, 1:end - 1)).^2), 2);
            g = (g - 1) / 10 + 1;
            f = [x(:, 1), g .* (1 - sqrt(x(:, 1) ./ g))];
            f = f .* [30, 10] + [0, 0];
        else % convex, multimodal, non-separable
            %Rosenbrock
            [n, D] = size(x);
            z = x(:, 2:end) - repmat(S(1:D - 1), n, 1);
            g = ones(n, 1) + sum(100 * ((z(:, 1:end - 1).^2 - z(:, 2:end)).^2 + (ones(size(z(:, 1:end - 1))) - z(:, 1:end - 1)).^2), 2);
            g = (g - 1) / 10 + 1;
            f = [g .* (1 - sqrt(x(:, 1) ./ g)), x(:, 1)];
            f = f .* [10, 20] + [0, 0];
        end

    case 6
        if Task == 1 % convex, multimodal, non-separable
            %Griewank
            [n, D] = size(x);
            z = x(:, 2:end) - repmat(S(1:D - 1), n, 1);
            a = repmat(1:D - 1, n, 1);
            g = 2 * ones(n, 1) +1/4000 * sum(z.^2, 2) - prod(cos(z ./ sqrt(a)), 2);
            g = (g - 1) / 10 + 1;
            f = [x(:, 1), g .* (1 - sqrt(x(:, 1) ./ g))];
            f = f .* [30, 10] + [0, 0];
        else % convex, multimodal, separable
            %Rastrigin
            [n, D] = size(x);
            z = x(:, 2:end) - repmat(S(1:D - 1), n, 1);
            g = ones(n, 1) + sum(z.^2 - 10 * cos(2 * pi * z) + 10 * ones(size(z)), 2);
            g = (g - 1) / 10 + 1;
            f = [g .* (1 - sqrt(x(:, 1) ./ g)), x(:, 1)];
            f = f .* [10, 20] + [0, 0];
        end

    case 7
        if Task == 1 % concave, multimodal, separable
            %Rastrigin
            [n, D] = size(x);
            z = x(:, 2:end) - repmat(S(1:D - 1), n, 1);
            g = ones(n, 1) + sum(z.^2 - 10 * cos(2 * pi * z) + 10 * ones(size(z)), 2);
            g = (g - 1) / 6 + 1;
            f = [g .* cos(x(:, 1) .* pi / 2), g .* sin(x(:, 1) .* pi / 2)];
            f = f .* [8, 5] + [3, 0];
        elseif Task == 2 % concave, multimodal, separable
            %Rastrigin
            [n, D] = size(x);
            z = x(:, 2:end) - repmat(S(1:D - 1), n, 1);
            g = ones(n, 1) + sum(z.^2 - 10 * cos(2 * pi * z) + 10 * ones(size(z)), 2);
            g = (g - 1) / 8 + 1;
            f = [g .* cos(x(:, 1) .* pi / 2), g .* sin(x(:, 1) .* pi / 2)];
            f = f .* [5, 5] + [2, 2];
        else % concave, multimodal, separable
            %Rastrigin
            [n, D] = size(x);
            z = x(:, 2:end) - repmat(S(1:D - 1), n, 1);
            g = ones(n, 1) + sum(z.^2 - 10 * cos(2 * pi * z) + 10 * ones(size(z)), 2);
            g = (g - 1) / 10 + 1;
            f = [g .* cos(x(:, 1) .* pi / 2), g .* sin(x(:, 1) .* pi / 2)];
            f = f .* [5, 8] + [0, 3];
        end

    case 8
        if Task == 1 % concave, multimodal, separable
            %Rastrigin
            [n, D] = size(x);
            z = x(:, 2:end) - repmat(S(1:D - 1), n, 1);
            g = ones(n, 1) + sum(z.^2 - 10 * cos(2 * pi * z) + 10 * ones(size(z)), 2);
            g = (g - 1) / 10 + 1;
            f = [g .* cos(x(:, 1) .* pi / 2), g .* sin(x(:, 1) .* pi / 2)];
            f = f .* [8, 5] + [3, 0];
        elseif Task == 2 % concave, multimodal, non-separable
            %Ackley
            [n, D] = size(x);
            z = x(:, 2:end) - repmat(S(1:D - 1), n, 1);
            g = 21 + exp(1) - 20 * exp(-0.2 * sqrt(1 / (D - 1) * sum(z.^2, 2))) - exp(1 / (D - 1) * sum(cos(2 * pi * z), 2));
            g = (g - 1) / 1 + 1;
            f = [g .* cos(x(:, 1) .* pi / 2), g .* sin(x(:, 1) .* pi / 2)];
            f = f .* [5, 5] + [2, 2];
        else % concave, multimodal, non-separable
            %Rosenbrock
            [n, D] = size(x);
            z = x(:, 2:end) - repmat(S(1:D - 1), n, 1);
            g = ones(n, 1) + sum(100 * ((z(:, 1:end - 1).^2 - z(:, 2:end)).^2 + (ones(size(z(:, 1:end - 1))) - z(:, 1:end - 1)).^2), 2);
            g = (g - 1) / 10 + 1;
            f = [g .* cos(x(:, 1) .* pi / 2), g .* sin(x(:, 1) .* pi / 2)];
            f = f .* [5, 8] + [0, 3];
        end

    case 9
        if Task == 1 % 3M, concave, multimodal, non-separable
            %Griewank
            [n, D] = size(x);
            z = x(:, 3:end) - repmat(S(1:D - 2), n, 1);
            a = repmat(1:D - 2, n, 1);
            g = 2 * ones(n, 1) +1/4000 * sum(z.^2, 2) - prod(cos(z ./ sqrt(a)), 2);
            g = (g - 1) / 10 + 1;
            f = [g .* cos(x(:, 1) .* pi / 2) .* cos(x(:, 2) .* pi / 2), g .* cos(x(:, 1) .* pi / 2) .* sin(x(:, 2) .* pi / 2), g .* sin(x(:, 1) .* pi / 2)];
            f = f .* [8, 5, 5] + [2, 0, 0];
        else % 3M, concave, multimodal, non-separable
            %Griewank
            [n, D] = size(x);
            z = x(:, 3:end) - repmat(S(1:D - 2), n, 1);
            a = repmat(1:D - 2, n, 1);
            g = 2 * ones(n, 1) +1/4000 * sum(z.^2, 2) - prod(cos(z ./ sqrt(a)), 2);
            g = (g - 1) / 10 + 1;
            f = [g .* cos(x(:, 1) .* pi / 2) .* cos(x(:, 2) .* pi / 2), g .* cos(x(:, 1) .* pi / 2) .* sin(x(:, 2) .* pi / 2), g .* sin(x(:, 1) .* pi / 2)];
            f = f .* [5, 8, 5] + [0, 2, 0];
        end

    case 10
        if Task == 1 % 3M, concave, multimodal, non-separable
            %Ackley
            [n, D] = size(x);
            z = x(:, 3:end) - repmat(S(1:D - 2), n, 1);
            g = 21 + exp(1) - 20 * exp(-0.2 * sqrt(1 / (D - 2) * sum(z.^2, 2))) - exp(1 / (D - 2) * sum(cos(2 * pi * z), 2));
            g = (g - 1) / 1 + 1;
            f = [g .* cos(x(:, 1) .* pi / 2) .* cos(x(:, 2) .* pi / 2), g .* cos(x(:, 1) .* pi / 2) .* sin(x(:, 2) .* pi / 2), g .* sin(x(:, 1) .* pi / 2)];
            f = f .* [8, 5, 5] + [2, 0, 0];
        else % concave, multimodal, separable
            %Rastrigin
            [n, D] = size(x);
            z = x(:, 3:end) - repmat(S(1:D - 2), n, 1);
            g = ones(n, 1) + sum(z.^2 - 10 * cos(2 * pi * z) + 10 * ones(size(z)), 2);
            g = (g - 1) / 10 + 1;
            f = [g .* cos(x(:, 1) .* pi / 2) .* cos(x(:, 2) .* pi / 2), g .* cos(x(:, 1) .* pi / 2) .* sin(x(:, 2) .* pi / 2), g .* sin(x(:, 1) .* pi / 2)];
            f = f .* [5, 8, 5] + [0, 2, 0];
        end

    case 11
        if Task == 1 % 3M, concave, multimodal, non-separable
            %Ackley
            [n, D] = size(x);
            z = x(:, 3:end) - repmat(S(1:D - 2), n, 1);
            g = 21 + exp(1) - 20 * exp(-0.2 * sqrt(1 / (D - 2) * sum(z.^2, 2))) - exp(1 / (D - 2) * sum(cos(2 * pi * z), 2));
            g = (g - 1) / 1 + 1;
            f = [g .* cos(x(:, 1) .* pi / 2) .* cos(x(:, 2) .* pi / 2), g .* cos(x(:, 1) .* pi / 2) .* sin(x(:, 2) .* pi / 2), g .* sin(x(:, 1) .* pi / 2)];
            f = f .* [8, 5, 5] + [2, 0, 0];
        elseif Task == 2 % 3M, concave, multimodal, non-separable
            %Ackley
            [n, D] = size(x);
            z = x(:, 3:end) - repmat(S(1:D - 2), n, 1);
            g = 21 + exp(1) - 20 * exp(-0.2 * sqrt(1 / (D - 2) * sum(z.^2, 2))) - exp(1 / (D - 2) * sum(cos(2 * pi * z), 2));
            g = (g - 1) / 1 + 1;
            f = [g .* cos(x(:, 1) .* pi / 2) .* cos(x(:, 2) .* pi / 2), g .* cos(x(:, 1) .* pi / 2) .* sin(x(:, 2) .* pi / 2), g .* sin(x(:, 1) .* pi / 2)];
            f = f .* [5, 8, 5] + [0, 2, 0];
        else % 3M, concave, multimodal, non-separable
            %Ackley
            [n, D] = size(x);
            z = x(:, 3:end) - repmat(S(1:D - 2), n, 1);
            g = 21 + exp(1) - 20 * exp(-0.2 * sqrt(1 / (D - 2) * sum(z.^2, 2))) - exp(1 / (D - 2) * sum(cos(2 * pi * z), 2));
            g = (g - 1) / 10 + 1;
            f = [g .* cos(x(:, 1) .* pi / 2) .* cos(x(:, 2) .* pi / 2), g .* cos(x(:, 1) .* pi / 2) .* sin(x(:, 2) .* pi / 2), g .* sin(x(:, 1) .* pi / 2)];
            f = f .* [5, 5, 8] + [0, 0, 2];
        end

    case 12
        if Task == 1 % 3M, concave, multimodal, non-separable
            %Ackley
            [n, D] = size(x);
            z = x(:, 3:end) - repmat(S(1:D - 2), n, 1);
            g = 21 + exp(1) - 20 * exp(-0.2 * sqrt(1 / (D - 2) * sum(z.^2, 2))) - exp(1 / (D - 2) * sum(cos(2 * pi * z), 2));
            g = (g - 1) / 1 + 1;
            f = [g .* cos(x(:, 1) .* pi / 2) .* cos(x(:, 2) .* pi / 2), g .* cos(x(:, 1) .* pi / 2) .* sin(x(:, 2) .* pi / 2), g .* sin(x(:, 1) .* pi / 2)];
            f = f .* [8, 5, 5] + [2, 0, 0];
        elseif Task == 2 % 3M, concave, multimodal, non-separable
            %Griewank
            [n, D] = size(x);
            z = x(:, 3:end) - repmat(S(1:D - 2), n, 1);
            a = repmat(1:D - 2, n, 1);
            g = 2 * ones(n, 1) +1/4000 * sum(z.^2, 2) - prod(cos(z ./ sqrt(a)), 2);
            g = (g - 1) / 10 + 1;
            f = [g .* cos(x(:, 1) .* pi / 2) .* cos(x(:, 2) .* pi / 2), g .* cos(x(:, 1) .* pi / 2) .* sin(x(:, 2) .* pi / 2), g .* sin(x(:, 1) .* pi / 2)];
            f = f .* [5, 8, 5] + [0, 2, 0];
        else % concave, unimodal, separable
            %Sphere
            [n, D] = size(x);
            z = x(:, 3:end) - repmat(S(1:D - 2), n, 1);
            g = ones(n, 1) + sum(z.^2, 2);
            f = [g .* cos(x(:, 1) .* pi / 2) .* cos(x(:, 2) .* pi / 2), g .* cos(x(:, 1) .* pi / 2) .* sin(x(:, 2) .* pi / 2), g .* sin(x(:, 1) .* pi / 2)];
            g = (g - 1) / 10 + 1;
            f = f .* [5, 5, 8] + [0, 0, 2];
        end
end

Obj = f;
Con = zeros(size(x, 1), 1);
end
