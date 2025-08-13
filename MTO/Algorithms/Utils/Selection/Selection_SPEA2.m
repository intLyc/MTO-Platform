function [population, Fitness, Next] = Selection_SPEA2(population, N, Epsilon)
% This code is copy from PlatEMO(https://github.com/BIMK/PlatEMO).

% The environmental selection of SPEA2

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

if nargin == 2
    Ep = 0;
else
    Ep = Epsilon;
end

%% Calculate the fitness of each solution
CVs = population.CVs;
CVs(CVs < Ep) = 0; % Epsilon Constraint
Fitness = CalFitness(population.Objs, CVs);

%% Environmental selection
Next = Fitness < 1;
if sum(Next) < N
    [~, Rank] = sort(Fitness);
    Next(Rank(1:N)) = true;
elseif sum(Next) > N
    Del = Truncation(population(Next).Objs, sum(Next) - N);
    Temp = find(Next);
    Next(Temp(Del)) = false;
end
% population for next generation
population = population(Next);
Fitness = Fitness(Next);
% Sort the population
[Fitness, rank] = sort(Fitness);
population = population(rank);
end

function Del = Truncation(PopObj, K)
% Select part of the solutions by truncation

%% Truncation
Distance = pdist2(PopObj, PopObj);
Distance(logical(eye(length(Distance)))) = inf;
Del = false(1, size(PopObj, 1));
while sum(Del) < K
    Remain = find(~Del);
    Temp = sort(Distance(Remain, Remain), 2);
    [~, Rank] = sortrows(Temp);
    Del(Remain(Rank(1))) = true;
end
end

function Fitness = CalFitness(PopObj, PopCV)
% Calculate the fitness of each solution

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

N = size(PopObj, 1);
if nargin == 1
    CV = zeros(N, 1);
else
    CV = PopCV;
end

%% Detect the dominance relation between each two solutions
Dominate = false(N);
for i = 1:N - 1
    for j = i + 1:N
        if CV(i) < CV(j)
            Dominate(i, j) = true;
        elseif CV(i) > CV(j)
            Dominate(j, i) = true;
        else
            k = any(PopObj(i, :) < PopObj(j, :)) - any(PopObj(i, :) > PopObj(j, :));
            if k == 1
                Dominate(i, j) = true;
            elseif k == -1
                Dominate(j, i) = true;
            end
        end
    end
end

%% Calculate S(i)
S = sum(Dominate, 2);

%% Calculate R(i)
R = zeros(1, N);
for i = 1:N
    R(i) = sum(S(Dominate(:, i)));
end

%% Calculate D(i)
Distance = pdist2(PopObj, PopObj);
Distance(logical(eye(length(Distance)))) = inf;
Distance = sort(Distance, 2);
D = 1 ./ (Distance(:, floor(sqrt(N))) + 2);

%% Calculate the fitnesses
Fitness = R + D';
end
