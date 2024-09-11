function Tasks = benchmark_LSMaTSO(index, task_num)

%------------------------------- Reference --------------------------------
% @Article{Li2024TNG-NES,
%   title   = {Transfer Task-averaged Natural Gradient for Efficient Many-task Optimization},
%   author  = {Li, Yanchi and Gong, Wenyin and Gu, Qiong},
%   journal = {IEEE Transactions on Evolutionary Computation},
%   year    = {2024},
%   doi     = {10.1109/TEVC.2024.3459862},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

dim = 300;

% Separable Functions (3) [1, 2, 3]
% Single group m-nonseparable Functions (5) [4, 5, 6, 7, 8]
% D/(2m) group m-nonseparable Functions (5) [9, 10, 11, 12, 13]
% D/(m) group m-nonseparable Functions (5) [14, 15, 16, 17, 18]
% Nonseparable Functions (2) [19, 20]

choice_functions = [];
switch (index)
    case 1 % Separable
        choice_functions = [1, 2, 3];
    case 2 % Separable + Single group m-nonseparable
        choice_functions = [1, 2, 3, 4, 5, 6, 7, 8];
    case 3 % Single group m-nonseparable + D/(2m) group m-nonseparable
        choice_functions = [4, 5, 6, 7, 8, 9, 10, 11, 12, 13];
    case 4 % D/(2m) group m-nonseparable + D/(m) group m-nonseparable
        choice_functions = [9, 10, 11, 12, 13, 14, 15, 16, 17, 18];
    case 5 % D/(m) group m-nonseparable + Nonseparable
        choice_functions = [14, 15, 16, 17, 18, 19, 20];
end

load(['./Problems/Multi-task/LSMaTSO/Data/LSMaTSO_Data', num2str(index)])

for t = 1:task_num
    func_id = choice_functions(mod(t - 1, length(choice_functions)) + 1);
    switch func_id
        case 1
            Tasks(t).Dim = dim; % dimensionality of Task
            Tasks(t).Lb = -100 * ones(1, dim); % Lower bound of Task
            Tasks(t).Ub = 100 * ones(1, dim); % Upper bound of Task
            shift = Tasks(t).Lb + (Tasks(t).Ub - Tasks(t).Lb) .* LSMaTSO_Data.Shift(t, :);
            scale = LSMaTSO_Data.Scale(t, :);
            Tasks(t).Fnc = @(x)Elliptic_S(x, scale, shift); % function of Task
        case 2
            Tasks(t).Dim = dim; % dimensionality of Task
            Tasks(t).Lb = -5 * ones(1, dim); % Lower bound of Task
            Tasks(t).Ub = 5 * ones(1, dim); % Upper bound of Task
            shift = Tasks(t).Lb + (Tasks(t).Ub - Tasks(t).Lb) .* LSMaTSO_Data.Shift(t, :);
            scale = LSMaTSO_Data.Scale(t, :);
            Tasks(t).Fnc = @(x)Rastrigin_S(x, scale, shift);
        case 3
            Tasks(t).Dim = dim; % dimensionality of Task
            Tasks(t).Lb = -32 * ones(1, dim); % Lower bound of Task
            Tasks(t).Ub = 32 * ones(1, dim); % Upper bound of Task
            shift = Tasks(t).Lb + (Tasks(t).Ub - Tasks(t).Lb) .* LSMaTSO_Data.Shift(t, :);
            scale = LSMaTSO_Data.Scale(t, :);
            Tasks(t).Fnc = @(x)Ackley_S(x, scale, shift);
        case 4
            Tasks(t).Dim = dim; % dimensionality of Task
            Tasks(t).Lb = -100 * ones(1, dim); % Lower bound of Task
            Tasks(t).Ub = 100 * ones(1, dim); % Upper bound of Task
            group = LSMaTSO_Data.Group(t, :);
            shift = Tasks(t).Lb + (Tasks(t).Ub - Tasks(t).Lb) .* LSMaTSO_Data.Shift(t, :);
            scale = LSMaTSO_Data.Scale(t, :);
            rotation = squeeze(LSMaTSO_Data.Rotation(t, :, :));
            Tasks(t).Fnc = @(x)Elliptic_G(x, scale, rotation, shift, group); % function of Task
        case 5
            Tasks(t).Dim = dim; % dimensionality of Task
            Tasks(t).Lb = -5 * ones(1, dim); % Lower bound of Task
            Tasks(t).Ub = 5 * ones(1, dim); % Upper bound of Task
            group = LSMaTSO_Data.Group(t, :);
            shift = Tasks(t).Lb + (Tasks(t).Ub - Tasks(t).Lb) .* LSMaTSO_Data.Shift(t, :);
            scale = LSMaTSO_Data.Scale(t, :);
            rotation = squeeze(LSMaTSO_Data.Rotation(t, :, :));
            Tasks(t).Fnc = @(x)Rastrigin_G(x, scale, rotation, shift, group); % function of Task
        case 6
            Tasks(t).Dim = dim; % dimensionality of Task
            Tasks(t).Lb = -32 * ones(1, dim); % Lower bound of Task
            Tasks(t).Ub = 32 * ones(1, dim); % Upper bound of Task
            group = LSMaTSO_Data.Group(t, :);
            shift = Tasks(t).Lb + (Tasks(t).Ub - Tasks(t).Lb) .* LSMaTSO_Data.Shift(t, :);
            scale = LSMaTSO_Data.Scale(t, :);
            rotation = squeeze(LSMaTSO_Data.Rotation(t, :, :));
            Tasks(t).Fnc = @(x)Ackley_G(x, scale, rotation, shift, group); % function of Task
        case 7
            Tasks(t).Dim = dim; % dimensionality of Task
            Tasks(t).Lb = -100 * ones(1, dim); % Lower bound of Task
            Tasks(t).Ub = 100 * ones(1, dim); % Upper bound of Task
            group = LSMaTSO_Data.Group(t, :);
            shift = Tasks(t).Lb + (Tasks(t).Ub - Tasks(t).Lb) .* LSMaTSO_Data.Shift(t, :);
            scale = LSMaTSO_Data.Scale(t, :);
            rotation = squeeze(LSMaTSO_Data.Rotation(t, :, :));
            Tasks(t).Fnc = @(x)Schwefel2_G(x, scale, rotation, shift, group); % function of Task
        case 8
            Tasks(t).Dim = dim; % dimensionality of Task
            Tasks(t).Lb = -100 * ones(1, dim); % Lower bound of Task
            Tasks(t).Ub = 100 * ones(1, dim); % Upper bound of Task
            group = LSMaTSO_Data.Group(t, :);
            shift = Tasks(t).Lb + (Tasks(t).Ub - Tasks(t).Lb) .* LSMaTSO_Data.Shift(t, :);
            scale = LSMaTSO_Data.Scale(t, :);
            rotation = squeeze(LSMaTSO_Data.Rotation(t, :, :));
            Tasks(t).Fnc = @(x)Rosenbrock_G(x, scale, rotation, shift, group); % function of Task
        case 9
            Tasks(t).Dim = dim; % dimensionality of Task
            Tasks(t).Lb = -100 * ones(1, dim); % Lower bound of Task
            Tasks(t).Ub = 100 * ones(1, dim); % Upper bound of Task
            group = LSMaTSO_Data.Group(t, :);
            shift = Tasks(t).Lb + (Tasks(t).Ub - Tasks(t).Lb) .* LSMaTSO_Data.Shift(t, :);
            scale = LSMaTSO_Data.Scale(t, :);
            rotation = squeeze(LSMaTSO_Data.Rotation(t, :, :));
            Tasks(t).Fnc = @(x)Elliptic_G2(x, scale, rotation, shift, group); % function of Task
        case 10
            Tasks(t).Dim = dim; % dimensionality of Task
            Tasks(t).Lb = -5 * ones(1, dim); % Lower bound of Task
            Tasks(t).Ub = 5 * ones(1, dim); % Upper bound of Task
            group = LSMaTSO_Data.Group(t, :);
            shift = Tasks(t).Lb + (Tasks(t).Ub - Tasks(t).Lb) .* LSMaTSO_Data.Shift(t, :);
            scale = LSMaTSO_Data.Scale(t, :);
            rotation = squeeze(LSMaTSO_Data.Rotation(t, :, :));
            Tasks(t).Fnc = @(x)Rastrigin_G2(x, scale, rotation, shift, group); % function of Task
        case 11
            Tasks(t).Dim = dim; % dimensionality of Task
            Tasks(t).Lb = -32 * ones(1, dim); % Lower bound of Task
            Tasks(t).Ub = 32 * ones(1, dim); % Upper bound of Task
            group = LSMaTSO_Data.Group(t, :);
            shift = Tasks(t).Lb + (Tasks(t).Ub - Tasks(t).Lb) .* LSMaTSO_Data.Shift(t, :);
            scale = LSMaTSO_Data.Scale(t, :);
            rotation = squeeze(LSMaTSO_Data.Rotation(t, :, :));
            Tasks(t).Fnc = @(x)Ackley_G2(x, scale, rotation, shift, group); % function of Task
        case 12
            Tasks(t).Dim = dim; % dimensionality of Task
            Tasks(t).Lb = -100 * ones(1, dim); % Lower bound of Task
            Tasks(t).Ub = 100 * ones(1, dim); % Upper bound of Task
            group = LSMaTSO_Data.Group(t, :);
            shift = Tasks(t).Lb + (Tasks(t).Ub - Tasks(t).Lb) .* LSMaTSO_Data.Shift(t, :);
            scale = LSMaTSO_Data.Scale(t, :);
            rotation = squeeze(LSMaTSO_Data.Rotation(t, :, :));
            Tasks(t).Fnc = @(x)Schwefel2_G2(x, scale, rotation, shift, group); % function of Task
        case 13
            Tasks(t).Dim = dim; % dimensionality of Task
            Tasks(t).Lb = -100 * ones(1, dim); % Lower bound of Task
            Tasks(t).Ub = 100 * ones(1, dim); % Upper bound of Task
            group = LSMaTSO_Data.Group(t, :);
            shift = Tasks(t).Lb + (Tasks(t).Ub - Tasks(t).Lb) .* LSMaTSO_Data.Shift(t, :);
            scale = LSMaTSO_Data.Scale(t, :);
            rotation = squeeze(LSMaTSO_Data.Rotation(t, :, :));
            Tasks(t).Fnc = @(x)Rosenbrock_G2(x, scale, rotation, shift, group); % function of Task
        case 14
            Tasks(t).Dim = dim; % dimensionality of Task
            Tasks(t).Lb = -100 * ones(1, dim); % Lower bound of Task
            Tasks(t).Ub = 100 * ones(1, dim); % Upper bound of Task
            group = LSMaTSO_Data.Group(t, :);
            shift = Tasks(t).Lb + (Tasks(t).Ub - Tasks(t).Lb) .* LSMaTSO_Data.Shift(t, :);
            scale = LSMaTSO_Data.Scale(t, :);
            rotation = squeeze(LSMaTSO_Data.Rotation(t, :, :));
            Tasks(t).Fnc = @(x)Elliptic_G3(x, scale, rotation, shift, group); % function of Task
        case 15
            Tasks(t).Dim = dim; % dimensionality of Task
            Tasks(t).Lb = -5 * ones(1, dim); % Lower bound of Task
            Tasks(t).Ub = 5 * ones(1, dim); % Upper bound of Task
            group = LSMaTSO_Data.Group(t, :);
            shift = Tasks(t).Lb + (Tasks(t).Ub - Tasks(t).Lb) .* LSMaTSO_Data.Shift(t, :);
            scale = LSMaTSO_Data.Scale(t, :);
            rotation = squeeze(LSMaTSO_Data.Rotation(t, :, :));
            Tasks(t).Fnc = @(x)Rastrigin_G3(x, scale, rotation, shift, group); % function of Task
        case 16
            Tasks(t).Dim = dim; % dimensionality of Task
            Tasks(t).Lb = -32 * ones(1, dim); % Lower bound of Task
            Tasks(t).Ub = 32 * ones(1, dim); % Upper bound of Task
            group = LSMaTSO_Data.Group(t, :);
            shift = Tasks(t).Lb + (Tasks(t).Ub - Tasks(t).Lb) .* LSMaTSO_Data.Shift(t, :);
            scale = LSMaTSO_Data.Scale(t, :);
            rotation = squeeze(LSMaTSO_Data.Rotation(t, :, :));
            Tasks(t).Fnc = @(x)Ackley_G3(x, scale, rotation, shift, group); % function of Task
        case 17
            Tasks(t).Dim = dim; % dimensionality of Task
            Tasks(t).Lb = -100 * ones(1, dim); % Lower bound of Task
            Tasks(t).Ub = 100 * ones(1, dim); % Upper bound of Task
            group = LSMaTSO_Data.Group(t, :);
            shift = Tasks(t).Lb + (Tasks(t).Ub - Tasks(t).Lb) .* LSMaTSO_Data.Shift(t, :);
            scale = LSMaTSO_Data.Scale(t, :);
            rotation = squeeze(LSMaTSO_Data.Rotation(t, :, :));
            Tasks(t).Fnc = @(x)Schwefel2_G3(x, scale, rotation, shift, group); % function of Task
        case 18
            Tasks(t).Dim = dim; % dimensionality of Task
            Tasks(t).Lb = -100 * ones(1, dim); % Lower bound of Task
            Tasks(t).Ub = 100 * ones(1, dim); % Upper bound of Task
            group = LSMaTSO_Data.Group(t, :);
            shift = Tasks(t).Lb + (Tasks(t).Ub - Tasks(t).Lb) .* LSMaTSO_Data.Shift(t, :);
            scale = LSMaTSO_Data.Scale(t, :);
            rotation = squeeze(LSMaTSO_Data.Rotation(t, :, :));
            Tasks(t).Fnc = @(x)Rosenbrock_G3(x, scale, rotation, shift, group); % function of Task
        case 19
            Tasks(t).Dim = dim;
            Tasks(t).Lb = -100 * ones(1, dim);
            Tasks(t).Ub = 100 * ones(1, dim);
            shift = Tasks(t).Lb + (Tasks(t).Ub - Tasks(t).Lb) .* LSMaTSO_Data.Shift(t, :);
            scale = LSMaTSO_Data.Scale(t, :);
            rotation = squeeze(LSMaTSO_Data.Rotation(t, :, :));
            Tasks(t).Fnc = @(x)Schwefel2_N(x, scale, shift);
        case 20
            Tasks(t).Dim = dim;
            Tasks(t).Lb = -100 * ones(1, dim);
            Tasks(t).Ub = 100 * ones(1, dim);
            shift = Tasks(t).Lb + (Tasks(t).Ub - Tasks(t).Lb) .* LSMaTSO_Data.Shift(t, :);
            scale = LSMaTSO_Data.Scale(t, :);
            rotation = squeeze(LSMaTSO_Data.Rotation(t, :, :));
            Tasks(t).Fnc = @(x)Rosenbrock_N(x, scale, shift);
    end
end
end

%% Seperable. D=300

function [Obj, Con] = Elliptic_S(x, scale, shift)
x = repmat(scale, size(x, 1), 1) .* (x - repmat(shift, size(x, 1), 1));
[Obj, Con] = Elliptic(x, 1, 0, 0);
end

function [Obj, Con] = Rastrigin_S(x, scale, shift)
x = repmat(scale, size(x, 1), 1) .* (x - repmat(shift, size(x, 1), 1));
[Obj, Con] = Rastrigin(x, 1, 0, 0);
end

function [Obj, Con] = Ackley_S(x, scale, shift)
x = repmat(scale, size(x, 1), 1) .* (x - repmat(shift, size(x, 1), 1));
[Obj, Con] = Ackley(x, 1, 0, 0);
end

%% Single Group. D=300, m=50

function [Obj, Con] = Elliptic_G(x, scale, rotation, shift, group)
m = 50; a = 1e+6;
x = repmat(scale, size(x, 1), 1) .* (x - repmat(shift, size(x, 1), 1));
Obj = a * Elliptic(x(:, group(1:m)), rotation, 0, 0) + Elliptic(x(:, group(m + 1:end)), 1, 0, 0);
Con = zeros(size(x, 1), 1);
end

function [Obj, Con] = Rastrigin_G(x, scale, rotation, shift, group)
m = 50; a = 1e+6;
x = repmat(scale, size(x, 1), 1) .* (x - repmat(shift, size(x, 1), 1));
Obj = a * Rastrigin(x(:, group(1:m)), rotation, 0, 0) + Rastrigin(x(:, group(m + 1:end)), 1, 0, 0);
Con = zeros(size(x, 1), 1);
end

function [Obj, Con] = Ackley_G(x, scale, rotation, shift, group)
m = 50; a = 1e+6;
x = repmat(scale, size(x, 1), 1) .* (x - repmat(shift, size(x, 1), 1));
Obj = a * Ackley(x(:, group(1:m)), rotation, 0, 0) + Ackley(x(:, group(m + 1:end)), 1, 0, 0);
Con = zeros(size(x, 1), 1);
end

function [Obj, Con] = Schwefel2_G(x, scale, rotation, shift, group)
m = 50; a = 1e+6;
x = repmat(scale, size(x, 1), 1) .* (x - repmat(shift, size(x, 1), 1));
Obj = a * Schwefel2(x(:, group(1:m)), rotation, 0, 0) + Schwefel2(x(:, group(m + 1:end)), 1, 0, 0);
Con = zeros(size(x, 1), 1);
end

function [Obj, Con] = Rosenbrock_G(x, scale, rotation, shift, group)
m = 50; a = 1e+6;
x = repmat(scale, size(x, 1), 1) .* (x - repmat(shift, size(x, 1), 1));
Obj = a * Rosenbrock(x(:, group(1:m)), rotation, 0, 0) + Rosenbrock(x(:, group(m + 1:end)), 1, 0, 0);
Con = zeros(size(x, 1), 1);
end

%% (D/2m) Group. D=300, m=50, D/(2m)

function [Obj, Con] = Elliptic_G2(x, scale, rotation, shift, group)
D = length(x);
m = 50; G = D / m / 2;
x = repmat(scale, size(x, 1), 1) .* (x - repmat(shift, size(x, 1), 1));
Obj = 0;
for k = 1:G
    index = ((k - 1) * m + 1):(k * m);
    Obj = Obj + Elliptic(x(:, group(index)), rotation, 0, 0);
end
Obj = Obj + Elliptic(x(:, group((G * m + 1):end)), 1, 0, 0);
Con = zeros(size(x, 1), 1);
end

function [Obj, Con] = Rastrigin_G2(x, scale, rotation, shift, group)
D = length(x);
m = 50; G = D / m / 2;
x = repmat(scale, size(x, 1), 1) .* (x - repmat(shift, size(x, 1), 1));
Obj = 0;
for k = 1:G
    index = ((k - 1) * m + 1):(k * m);
    Obj = Obj + Rastrigin(x(:, group(index)), rotation, 0, 0);
end
Obj = Obj + Rastrigin(x(:, group((G * m + 1):end)), 1, 0, 0);
Con = zeros(size(x, 1), 1);
end

function [Obj, Con] = Ackley_G2(x, scale, rotation, shift, group)
D = length(x);
m = 50; G = D / m / 2;
x = repmat(scale, size(x, 1), 1) .* (x - repmat(shift, size(x, 1), 1));
Obj = 0;
for k = 1:G
    index = ((k - 1) * m + 1):(k * m);
    Obj = Obj + Ackley(x(:, group(index)), rotation, 0, 0);
end
Obj = Obj + Ackley(x(:, group((G * m + 1):end)), 1, 0, 0);
Con = zeros(size(x, 1), 1);
end

function [Obj, Con] = Schwefel2_G2(x, scale, rotation, shift, group)
D = length(x);
m = 50; G = D / m / 2;
x = repmat(scale, size(x, 1), 1) .* (x - repmat(shift, size(x, 1), 1));
Obj = 0;
for k = 1:G
    index = ((k - 1) * m + 1):(k * m);
    Obj = Obj + Schwefel2(x(:, group(index)), rotation, 0, 0);
end
Obj = Obj + Schwefel2(x(:, group((G * m + 1):end)), 1, 0, 0);
Con = zeros(size(x, 1), 1);
end

function [Obj, Con] = Rosenbrock_G2(x, scale, rotation, shift, group)
D = length(x);
m = 50; G = D / m / 2;
x = repmat(scale, size(x, 1), 1) .* (x - repmat(shift, size(x, 1), 1));
Obj = 0;
for k = 1:G
    index = ((k - 1) * m + 1):(k * m);
    Obj = Obj + Rosenbrock(x(:, group(index)), rotation, 0, 0);
end
Obj = Obj + Rosenbrock(x(:, group((G * m + 1):end)), 1, 0, 0);
Con = zeros(size(x, 1), 1);
end

%% (D/m) Group. D=300, m=50, D/m

function [Obj, Con] = Elliptic_G3(x, scale, rotation, shift, group)
D = length(x);
m = 50; G = D / m;
x = repmat(scale, size(x, 1), 1) .* (x - repmat(shift, size(x, 1), 1));
Obj = 0;
for k = 1:G
    index = ((k - 1) * m + 1):(k * m);
    Obj = Obj + Elliptic(x(:, group(index)), rotation, 0, 0);
end
Con = zeros(size(x, 1), 1);
end

function [Obj, Con] = Rastrigin_G3(x, scale, rotation, shift, group)
D = length(x);
m = 50; G = D / m;
x = repmat(scale, size(x, 1), 1) .* (x - repmat(shift, size(x, 1), 1));
Obj = 0;
for k = 1:G
    index = ((k - 1) * m + 1):(k * m);
    Obj = Obj + Rastrigin(x(:, group(index)), rotation, 0, 0);
end
Con = zeros(size(x, 1), 1);
end

function [Obj, Con] = Ackley_G3(x, scale, rotation, shift, group)
D = length(x);
m = 50; G = D / m;
x = repmat(scale, size(x, 1), 1) .* (x - repmat(shift, size(x, 1), 1));
Obj = 0;
for k = 1:G
    index = ((k - 1) * m + 1):(k * m);
    Obj = Obj + Ackley(x(:, group(index)), rotation, 0, 0);
end
Con = zeros(size(x, 1), 1);
end

function [Obj, Con] = Schwefel2_G3(x, scale, rotation, shift, group)
D = length(x);
m = 50; G = D / m;
x = repmat(scale, size(x, 1), 1) .* (x - repmat(shift, size(x, 1), 1));
Obj = 0;
for k = 1:G
    index = ((k - 1) * m + 1):(k * m);
    Obj = Obj + Schwefel2(x(:, group(index)), rotation, 0, 0);
end
Con = zeros(size(x, 1), 1);
end

function [Obj, Con] = Rosenbrock_G3(x, scale, rotation, shift, group)
D = length(x);
m = 50; G = D / m;
x = repmat(scale, size(x, 1), 1) .* (x - repmat(shift, size(x, 1), 1));
Obj = 0;
for k = 1:G
    index = ((k - 1) * m + 1):(k * m);
    Obj = Obj + Rosenbrock(x(:, group(index)), rotation, 0, 0);
end
Con = zeros(size(x, 1), 1);
end

%% Nonseperable. D=300

function [Obj, Con] = Schwefel2_N(x, scale, shift)
x = repmat(scale, size(x, 1), 1) .* (x - repmat(shift, size(x, 1), 1));
[Obj, Con] = Schwefel2(x, 1, 0, 0);
end

function [Obj, Con] = Rosenbrock_N(x, scale, shift)
x = repmat(scale, size(x, 1), 1) .* (x - repmat(shift, size(x, 1), 1));
[Obj, Con] = Rosenbrock(x, 1, 0, 0);
end
