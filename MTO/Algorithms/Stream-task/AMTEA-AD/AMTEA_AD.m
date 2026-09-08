classdef AMTEA_AD < StreamAlgorithm
% <Stream-task> <Single-objective> <None>
% Author AMTO baseline adapted to StreamAlgorithm; all evaluations count.

%------------------------------- Reference --------------------------------
% @Article{Wang2021MTEA-AD,
%   title      = {Solving Multi-task Optimization Problems with Adaptive Knowledge Transfer via Anomaly Detection},
%   author     = {Wang, Chao and Liu, Jing and Wu, Kai and Wu, Zhaoyang},
%   journal    = {IEEE Transactions on Evolutionary Computation},
%   year       = {2021},
%   pages      = {1-1},
%   doi        = {10.1109/TEVC.2021.3068157},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
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
    TRP = 0.1
    MuC = 2
    MuM = 5
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'TRP: Probability of the Knowledge Transfer', num2str(Algo.TRP), ...
                'MuC: Simulated Binary Crossover', num2str(Algo.MuC), ...
                'MuM: Polynomial Mutation', num2str(Algo.MuM)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.TRP = str2double(Parameter{i}); i = i + 1;
        Algo.MuC = str2double(Parameter{i}); i = i + 1;
        Algo.MuM = str2double(Parameter{i}); i = i + 1;
    end

end

methods (Access = protected)
    function onEvent(Algo, Prob, event, tasks) %#ok<INUSD>
        if ~strcmp(event, 'start'), return; end
        assert(Prob.N >= 4, 'Stream population algorithms require N >= 4.');
        Algo.Shared.Ready = false(1, Prob.T);
        % Initialize randomly; Epsilon controls the anomaly-detection transfer fraction.
        Algo.Shared.Epsilon = zeros(1, Prob.T);
    end

    function step(Algo, Prob, active)
        t = active(1);
        if ~Algo.Shared.Ready(t)
            StreamInitializePopulation(Algo, Prob, t, @Individual, false);
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

    function [batch, context] = makeBatch(Algo, Prob, t, donors) %#ok<INUSD>
        batch = Algo.Generation(Algo.Population{t}); batch = batch(1:Prob.N);
        context = struct('Normal', numel(batch), 'Transfer', 0);
        % Include completed tasks in the source pool.
        donors = find(Algo.Shared.Ready); donors(donors == t) = []; % Includes completed tasks.
        if rand < Algo.TRP && ~isempty(donors)
            donors = donors(randperm(numel(donors), min(numel(donors), 10)));
            history = [];
            for k = donors, history = [history; Algo.Population{k}.Decs]; end
            z = Algo.learn_anomaly_detection(batch.Decs, history, Algo.Shared.Epsilon(t));
            context.Transfer = size(z, 1);
            for i = 1:size(z, 1)
                c = Individual(); c.Dec = max(0, min(1, z(i, :))); batch(end + 1) = c;
            end
        end
    end
    function acceptBatch(Algo, Prob, t, batch, context) %#ok<INUSD>
        [Algo.Population{t}, rank] = Selection_Elit(Algo.Population{t}, batch);
        % Use only evaluated transfer candidates when the budget truncates a batch.
        count = max(0, numel(batch) - context.Normal);
        if count > 0
            Algo.Shared.Epsilon(t) = sum(rank(1:Prob.N) > Prob.N + context.Normal) / count;
        end
    end
end

methods
    function offspring = Generation(Algo, population)
        indorder = randperm(length(population));
        count = 1;
        for i = 1:ceil(length(population) / 2)
            p1 = indorder(i);
            p2 = indorder(i + fix(length(population) / 2));
            offspring(count) = population(p1);
            offspring(count + 1) = population(p2);

            [offspring(count).Dec, offspring(count + 1).Dec] = GA_Crossover(population(p1).Dec, population(p2).Dec, Algo.MuC);

            offspring(count).Dec = GA_Mutation(offspring(count).Dec, Algo.MuM);
            offspring(count + 1).Dec = GA_Mutation(offspring(count + 1).Dec, Algo.MuM);

            swap_indicator = (rand(1, length(population(p1).Dec)) < 0.5);
            temp = offspring(count).Dec(swap_indicator);
            offspring(count).Dec(swap_indicator) = offspring(count + 1).Dec(swap_indicator);
            offspring(count + 1).Dec(swap_indicator) = temp;

            for x = count:count + 1
                offspring(x).Dec(offspring(x).Dec > 1) = 1;
                offspring(x).Dec(offspring(x).Dec < 0) = 0;
            end
            count = count + 2;
        end
    end

    function tfsol = learn_anomaly_detection(Algo, curr_pop, his_pop, NL)
        %% Learning anomaly detection model of task tn
        % Input: curr_pop (Dec matrix), his_pop (Dec matrix), NL (anomaly detection parameter)
        % Output: tfsol (candidate transferred solutions)

        % Sample, make sure that the fitted covariance is a square, symmetric, positive definite matrix.
        nsamples = floor(0.01 * size(curr_pop, 1));
        randMat = rand(nsamples, size(curr_pop, 2));
        curr_pop = [curr_pop; randMat];

        % Fit
        mmean = mean(curr_pop);
        sstd1 = cov(curr_pop);
        sstd = sstd1 + (10e-6) * eye(size(curr_pop, 2));

        % Calculate the scores
        [Dec, ~] = unique(his_pop, 'rows');
        Y = mvnpdf(Dec(:, 1:size(curr_pop, 2)), mmean, sstd);

        % Select the candidate transferred solutions
        [~, ii] = sort(Y, 'descend');
        if NL == 0
            mm = Y(1); % Ensure that the number of transferred individuals is not 0
        else
            mm = Y(ii(ceil(size(Y, 1) * NL)));
        end

        % Count the number of candidate transferred solutions
        tte = Y >= mm;
        tfsol = Dec(tte, :);
    end
end
end
