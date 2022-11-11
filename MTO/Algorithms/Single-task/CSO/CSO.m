classdef CSO < Algorithm
    % <Single-task> <Single-objective> <None/Constrained>

    %------------------------------- Reference --------------------------------
    % @Article{Cheng2015CSO,
    %   author     = {Cheng, Ran and Jin, Yaochu},
    %   journal    = {IEEE Transactions on Cybernetics},
    %   title      = {A Competitive Swarm Optimizer for Large Scale Optimization},
    %   year       = {2015},
    %   number     = {2},
    %   pages      = {191-204},
    %   volume     = {45},
    %   doi        = {10.1109/TCYB.2014.2322602},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        Phi = 0.1
    end

    methods
        function Parameter = getParameter(Algo)
            Parameter = {'Phi', num2str(Algo.Phi)};
        end

        function Algo = setParameter(Algo, Parameter)
            Algo.Phi = str2double(Parameter{1});
        end

        function run(Algo, Prob)
            % Initialization
            population = Initialization(Algo, Prob, Individual_PSO);

            while Algo.notTerminated(Prob)
                for t = 1:Prob.T
                    % Determine the losers and winners
                    rnd_idx = randperm(Prob.N);
                    loser = rnd_idx(1:end / 2);
                    winner = rnd_idx(end / 2 + 1:end);
                    [~, replace] = Selection_Tournament(population{t}(winner), population{t}(loser));
                    temp = loser(replace);
                    loser(replace) = winner(replace);
                    winner(replace) = temp;
                    % Update the losers by learning from the winners
                    population{t}(loser) = Algo.Generation(population{t}(winner), population{t}(loser));
                    % Evaluation
                    population{t}(loser) = Algo.Evaluation(population{t}(loser), Prob, t);
                end
            end
        end

        function pop_loser = Generation(Algo, pop_winner, pop_loser)
            wDec = mean(pop_winner.Decs, 1);
            for i = 1:length(pop_loser)
                % Velocity update
                pop_loser(i).V = rand() * pop_loser(i).V + ...
                rand() .* (pop_winner(i).Dec - pop_loser(i).Dec) + ...
                    Algo.Phi .* rand() .* (wDec - pop_loser(i).Dec);

                % Position update
                pop_loser(i).Dec = pop_loser(i).Dec + pop_loser(i).V;

                pop_loser(i).Dec(pop_loser(i).Dec > 1) = 1;
                pop_loser(i).Dec(pop_loser(i).Dec < 0) = 0;
            end
        end
    end
end
