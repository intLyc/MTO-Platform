classdef MSEA < Algorithm
% <Single-task> <Multi-objective> <None>

%------------------------------- Reference --------------------------------
% @Article{Tian2021MSEA,
%   title   = {A Multistage Evolutionary Algorithm for Better Diversity Preservation in Multiobjective Optimization},
%   author  = {Tian, Ye and He, Cheng and Cheng, Ran and Zhang, Xingyi},
%   journal = {IEEE Transactions on Systems, Man, and Cybernetics: Systems},
%   year    = {2021},
%   number  = {9},
%   pages   = {5880-5894},
%   volume  = {51},
%   doi     = {10.1109/TSMC.2019.2956288},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

% The code implementation is referenced from PlatEMO(https://github.com/BIMK/PlatEMO).
%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

properties (SetAccess = public)
    MuC = 20
    MuM = 15
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'MuC: Simulated Binary Crossover', num2str(Algo.MuC), ...
                'MuM: Polynomial Mutation', num2str(Algo.MuM)};
    end

    function setParameter(Algo, Parameter)
        i = 1;
        Algo.MuC = str2double(Parameter{i}); i = i + 1;
        Algo.MuM = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialize
        population = Initialization(Algo, Prob, Individual);
        for t = 1:Prob.T
            FrontNo{t} = NDSort(population{t}.Objs, inf);
        end

        while Algo.notTerminated(Prob, population)
            for t = 1:Prob.T
                % Normalize the population
                PopObj = population{t}.Objs;
                fmax = max(PopObj(FrontNo{t} == 1, :), [], 1);
                fmin = min(PopObj(FrontNo{t} == 1, :), [], 1);
                PopObj = (PopObj - repmat(fmin, size(PopObj, 1), 1)) ./ repmat(fmax - fmin, size(PopObj, 1), 1);

                % Calculate the distance between each two solutions
                Distance = pdist2(PopObj, PopObj);
                Distance(logical(eye(length(Distance)))) = inf;

                % Local search
                for i = 1:Prob.N
                    % Determining the stage
                    sDis = sort(Distance, 2);
                    Div = sDis(:, 1) + 0.01 * sDis(:, 2);
                    if max(FrontNo{t}) > 1
                        stage = 1;
                    elseif min(Div) < max(Div) / 2
                        stage = 2;
                    else
                        stage = 3;
                    end

                    % Generate an offspring
                    switch stage
                        case 1
                            MatingPool = TournamentSelection(2, 2, FrontNo{t}, sum(PopObj, 2));
                        case 2
                            [~, MatingPool(1)] = max(Div);
                            MatingPool(2) = TournamentSelection(2, 1, -Div);
                        otherwise
                            MatingPool(1) = TournamentSelection(2, 1, sum(PopObj, 2));
                            MatingPool(2) = TournamentSelection(2, 1, -Div);
                    end
                    offspring = Algo.Generation(population{t}(MatingPool));
                    offspring = Algo.Evaluation(offspring, Prob, t);
                    OffObj = (offspring.Obj - fmin) ./ (fmax - fmin);

                    % Non-dominated sorting
                    NewFront = Algo.UpdateFront([PopObj; OffObj], FrontNo{t});
                    if NewFront(end) > 1
                        continue;
                    end

                    % Calculate the distances
                    OffDis = pdist2(OffObj, PopObj);

                    % Determining the stage
                    if max(NewFront) > 1
                        stage = 1;
                    elseif min(Div) < max(Div) / 2
                        stage = 2;
                    else
                        stage = 3;
                    end

                    % Update the population
                    replace = false;
                    switch stage
                        case 1
                            Worse = find(NewFront == max(NewFront));
                            [~, q] = max(sum(PopObj(Worse, :), 2));
                            q = Worse(q);
                            OffDis(q) = inf;
                            replace = true;
                        case 2
                            [~, q] = min(Div);
                            OffDis(q) = inf;
                            sODis = sort(OffDis);
                            ODiv = sODis(1) + 0.01 * sODis(2);
                            if ODiv >= Div(q)
                                replace = true;
                            end
                        otherwise
                            [~, q] = min(OffDis);
                            OffDis(q) = inf;
                            sODis = sort(OffDis);
                            ODiv = sODis(1) + 0.01 * sODis(2);
                            if sum(OffObj) <= sum(PopObj(q, :)) && ODiv >= Div(q)
                                replace = true;
                            end
                    end
                    if replace
                        % Update the front numbers
                        FrontNo{t} = Algo.UpdateFront([PopObj; OffObj], NewFront, q);
                        FrontNo{t} = [FrontNo{t}(1:q - 1), FrontNo{t}(end), FrontNo{t}(q:end - 1)];
                        % Update the population
                        population{t}(q) = offspring;
                        PopObj(q, :) = OffObj;
                        % Update the distances
                        Distance(q, :) = OffDis;
                        Distance(:, q) = OffDis';
                    end
                end
            end
        end
    end

    function FrontNo = UpdateFront(Algo, PopObj, FrontNo, x)
        % Update the front number of each solution when a solution is added or
        % deleted

        %------------------------------- Copyright --------------------------------
        % Copyright (c) 2024 BIMK Group. You are free to use the PlatEMO for
        % research purposes. All publications which use this platform or any code
        % in the platform should acknowledge the use of "PlatEMO" and reference "Ye
        % Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
        % for evolutionary multi-objective optimization [educational forum], IEEE
        % Computational Intelligence Magazine, 2017, 12(4): 73-87".
        %--------------------------------------------------------------------------

        [N, M] = size(PopObj);
        if nargin < 4
            %% Add a new solution (has been stored in the last of PopObj)
            FrontNo = [FrontNo, 0];
            Move = false(1, N);
            Move(N) = true;
            CurrentF = 1;
            % Locate the front No. of the new solution
            while true
                Dominated = false;
                for i = 1:N - 1
                    if FrontNo(i) == CurrentF
                        m = 1;
                        while m <= M && PopObj(i, m) <= PopObj(end, m)
                            m = m + 1;
                        end
                        Dominated = m > M;
                        if Dominated
                            break;
                        end
                    end
                end
                if ~Dominated
                    break;
                else
                    CurrentF = CurrentF + 1;
                end
            end
            % Move down the dominated solutions front by front
            while any(Move)
                NextMove = false(1, N);
                for i = 1:N
                    if FrontNo(i) == CurrentF
                        Dominated = false;
                        for j = 1:N
                            if Move(j)
                                m = 1;
                                while m <= M && PopObj(j, m) <= PopObj(i, m)
                                    m = m + 1;
                                end
                                Dominated = m > M;
                                if Dominated
                                    break;
                                end
                            end
                        end
                        NextMove(i) = Dominated;
                    end
                end
                FrontNo(Move) = CurrentF;
                CurrentF = CurrentF + 1;
                Move = NextMove;
            end
        else
            %% Delete the x-th solution
            Move = false(1, N);
            Move(x) = true;
            CurrentF = FrontNo(x) + 1;
            while any(Move)
                NextMove = false(1, N);
                for i = 1:N
                    if FrontNo(i) == CurrentF
                        Dominated = false;
                        for j = 1:N
                            if Move(j)
                                m = 1;
                                while m <= M && PopObj(j, m) <= PopObj(i, m)
                                    m = m + 1;
                                end
                                Dominated = m > M;
                                if Dominated
                                    break;
                                end
                            end
                        end
                        NextMove(i) = Dominated;
                    end
                end
                for i = 1:N
                    if NextMove(i)
                        Dominated = false;
                        for j = 1:N
                            if FrontNo(j) == CurrentF - 1 && ~Move(j)
                                m = 1;
                                while m <= M && PopObj(j, m) <= PopObj(i, m)
                                    m = m + 1;
                                end
                                Dominated = m > M;
                                if Dominated
                                    break;
                                end
                            end
                        end
                        NextMove(i) = ~Dominated;
                    end
                end
                FrontNo(Move) = CurrentF - 2;
                CurrentF = CurrentF + 1;
                Move = NextMove;
            end
            FrontNo(x) = [];
        end
    end

    function offspring = Generation(Algo, population)
        for i = 1:ceil(length(population) / 2)
            p1 = i; p2 = i + fix(length(population) / 2);
            offspring(i) = population(p1);
            offspring(i).Dec = GA_Crossover(population(p1).Dec, population(p2).Dec, Algo.MuC);
            offspring(i).Dec = GA_Mutation(offspring(i).Dec, Algo.MuM);
            offspring(i).Dec(offspring(i).Dec > 1) = 1;
            offspring(i).Dec(offspring(i).Dec < 0) = 0;
        end
    end
end
end
