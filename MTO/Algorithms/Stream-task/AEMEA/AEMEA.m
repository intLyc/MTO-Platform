classdef AEMEA < StreamAlgorithm
% <Multi-task> <Single-objective> <None/Constrained> <Stream>
% Author AMTO baseline adapted to StreamAlgorithm; all evaluations count.

%------------------------------- Reference --------------------------------
% @Article{Feng2019EMEA,
%   title      = {Evolutionary Multitasking via Explicit Autoencoding},
%   author     = {Feng, Liang and Zhou, Lei and Zhong, Jinghui and Gupta, Abhishek and Ong, Yew-Soon and Tan, Kay-Chen and Qin, A. K.},
%   journal    = {IEEE Transactions on Cybernetics},
%   year       = {2019},
%   number     = {9},
%   pages      = {3457-3470},
%   volume     = {49},
%   doi        = {10.1109/TCYB.2018.2845361},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
%--------------------------------------------------------------------------

%------------------------------- Reference --------------------------------
% @Article{Han2026KR_AMTEA,
%   title      = {Multitense Knowledge Transfer for Asynchronous Multitasking Optimization},
%   author     = {Han, Honggui and Zhao, Ben and Wu, Xiaolong and Li, Xin},
%   journal    = {IEEE Transactions on Systems, Man, and Cybernetics: Systems},
%   year       = {2026},
%   volume     = {56},
%   number     = {5},
%   pages      = {3370--3383},
%   doi        = {10.1109/TSMC.2026.3658328},
% }
%--------------------------------------------------------------------------

properties
    Operator = 'GA/DE'
    SNum = 10
    TGap = 1000
    GA_MuC = 2
    GA_MuM = 5
    DE_F = 0.5
    DE_CR = 0.9
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'Operator (Split with /)', Algo.Operator, ...
                'S: Transfer num', num2str(Algo.SNum), ...
                'Transfer gap (FE per task)', num2str(Algo.TGap), ...
                'MuC: Simulated Binary Crossover', num2str(Algo.GA_MuC), ...
                'MuM: Polynomial Mutation', num2str(Algo.GA_MuM), ...
                'F: DE Mutation Factor', num2str(Algo.DE_F), ...
                'CR: DE Crossover Probability', num2str(Algo.DE_CR)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.Operator = Parameter{i}; i = i + 1;
        Algo.SNum = str2double(Parameter{i}); i = i + 1;
        Algo.TGap = str2double(Parameter{i}); i = i + 1;
        Algo.GA_MuC = str2double(Parameter{i}); i = i + 1;
        Algo.GA_MuM = str2double(Parameter{i}); i = i + 1;
        Algo.DE_F = str2double(Parameter{i}); i = i + 1;
        Algo.DE_CR = str2double(Parameter{i}); i = i + 1;
    end

end

methods (Access = protected)
    function onEvent(Algo, Prob, event, tasks) %#ok<INUSD>
        if ~strcmp(event, 'start'), return; end
        assert(Prob.N >= 4, 'Stream population algorithms require N >= 4.');
        Algo.Shared.Ready = false(1, Prob.T);
    end

    function step(Algo, Prob, active)
        t = active(1);
        if ~Algo.Shared.Ready(t)
            StreamInitializePopulation(Algo, Prob, t, @Individual, true);
            return;
        end
        % Generate candidates only for a new batch; resume existing candidates after arrival events.
        s = Algo.State{t};
        if isempty(s.Batch)
            donors = sort(active(active ~= t & Algo.Shared.Ready(active)));
            [s.Batch, s.Context] = Algo.makeBatch(Prob, t, donors);
            s.Offset = 0; s.Context.Improved = false;
        end
        % Apply selection once the batch finishes, preserving update rules across arrival events.
        [s, complete] = StreamEvaluateBatch(Algo, Prob, t, s);
        if complete
            Algo.acceptBatch(Prob, t, s.Batch(1:s.Offset), s.Context);
            s.Batch = []; s.Offset = 0;
        end
        Algo.State{t} = s;
    end

    function [batch, context] = makeBatch(Algo, Prob, t, donors)
        % Select GA or DE by task ID and schedule transfer using local task FE.
        operators = strsplit(Algo.Operator, '/');
        context = struct('Operator', operators{mod(t - 1, numel(operators)) + 1});
        if strcmp(context.Operator, 'GA'), batch = Algo.Generation_GA(Algo.Population{t});
        else , batch = Algo.Generation_DE(Algo.Population{t}); end
            batch = batch(1:Prob.N);
            if Algo.SNum <= 0 || isempty(donors) || ~StreamFECheckpoint(Algo.TaskFE(t), Prob.N, Algo.TGap), return; end
            count = min(Prob.N, round(Algo.SNum / (Prob.T - 1)));
            inject = Individual.empty();
            for k = donors
                [~, rank] = sortrows([Algo.Population{t}.CVs, Algo.Population{t}.Objs]);
                x = Algo.Population{t}(rank).Decs; x = x(:, 1:Prob.D(t));
                [~, rank] = sortrows([Algo.Population{k}.CVs, Algo.Population{k}.Objs]);
                y = Algo.Population{k}(rank).Decs; y = y(:, 1:Prob.D(k));
                % Fit the mapping from current populations in original coordinates, then normalize.
                x = x .* (Prob.Ub{t} - Prob.Lb{t}) + Prob.Lb{t};
                y = y .* (Prob.Ub{k} - Prob.Lb{k}) + Prob.Lb{k};
                z = AEMEA_mDA(x, y, y(1:count, :));
                z = (z - Prob.Lb{t}) ./ (Prob.Ub{t} - Prob.Lb{t});
                for i = 1:size(z, 1)
                    c = Individual(); c.Dec = [z(i, :), rand(1, max(Prob.D) - Prob.D(t))];
                    c.Dec = max(0, min(1, c.Dec)); inject(end + 1) = c;
                end
            end
            inject = inject(1:min(numel(inject), numel(batch)));
            batch(randperm(numel(batch), numel(inject))) = inject;
        end
        function acceptBatch(Algo, Prob, t, batch, context) %#ok<INUSD>
            % Match the author code: elitist selection for GA and pairwise selection for DE.
            if strcmp(context.Operator, 'GA')
                Algo.Population{t} = Selection_Elit(Algo.Population{t}, batch);
            else
                n = numel(batch);
                Algo.Population{t}(1:n) = Selection_Tournament(Algo.Population{t}(1:n), batch);
            end
        end
    end

    methods
        function offspring = Generation_GA(Algo, population)
            indorder = randperm(length(population));
            count = 1;
            for i = 1:ceil(length(population) / 2)
                p1 = indorder(i);
                p2 = indorder(i + fix(length(population) / 2));
                offspring(count) = population(p1);
                offspring(count + 1) = population(p2);

                [offspring(count).Dec, offspring(count + 1).Dec] = GA_Crossover(population(p1).Dec, population(p2).Dec, Algo.GA_MuC);

                offspring(count).Dec = GA_Mutation(offspring(count).Dec, Algo.GA_MuM);
                offspring(count + 1).Dec = GA_Mutation(offspring(count + 1).Dec, Algo.GA_MuM);

                for x = count:count + 1
                    offspring(x).Dec(offspring(x).Dec > 1) = 1;
                    offspring(x).Dec(offspring(x).Dec < 0) = 0;
                end
                count = count + 2;
            end
        end

        function offspring = Generation_DE(Algo, population)
            for i = 1:length(population)
                offspring(i) = population(i);
                A = randperm(length(population), 4);
                A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3);

                offspring(i).Dec = population(x1).Dec + Algo.DE_F * (population(x2).Dec - population(x3).Dec);
                offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, Algo.DE_CR);

                offspring(i).Dec(offspring(i).Dec > 1) = 1;
                offspring(i).Dec(offspring(i).Dec < 0) = 0;
            end
        end
    end
end
