classdef ECHT_DE < Algorithm
% <Single-task> <Single-objective> <Constrained>

%------------------------------- Reference --------------------------------
% @Article{Mallipeddi2010ECHT,
%   title    = {Ensemble of Constraint Handling Techniques},
%   author   = {Mallipeddi, Rammohan and Suganthan, Ponnuthurai N.},
%   journal  = {IEEE Transactions on Evolutionary Computation},
%   year     = {2010},
%   number   = {4},
%   pages    = {561-579},
%   volume   = {14},
%   doi      = {10.1109/TEVC.2009.2033582},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "MTO-Platform" and cite
% or footnote "https://github.com/intLyc/MTO-Platform"
%--------------------------------------------------------------------------

properties (SetAccess = private)
    F = 0.5
    CR = 0.9
    maxSR = 0.475
    minSR = 0.025
    EC_Top = 0.2
    EC_Tc = 0.8
    EC_Cp = 5
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'F: Mutation Factor', num2str(Algo.F), ...
                'CR: Crossover Probability', num2str(Algo.CR), ...
                'maxSR', num2str(Algo.maxSR), ...
                'minSR', num2str(Algo.minSR), ...
                'EC_Top', num2str(Algo.EC_Top), ...
                'EC_Tc', num2str(Algo.EC_Tc), ...
                'EC_Cp', num2str(Algo.EC_Cp)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.F = str2double(Parameter{i}); i = i + 1;
        Algo.CR = str2double(Parameter{i}); i = i + 1;
        Algo.maxSR = str2double(Parameter{i}); i = i + 1;
        Algo.minSR = str2double(Parameter{i}); i = i + 1;
        Algo.EC_Top = str2double(Parameter{i}); i = i + 1;
        Algo.EC_Tc = str2double(Parameter{i}); i = i + 1;
        Algo.EC_Cp = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        CHnum = 4;
        % Initialization
        population_temp = Initialization(Algo, Prob, Individual);
        for ch = 1:CHnum
            population(:, ch) = population_temp;
        end

        for t = 1:Prob.T
            % Stochastic Ranking
            Sr = Algo.maxSR;
            dSr = (Algo.maxSR - Algo.minSR) / (Prob.maxFE / Prob.T / Prob.N);
            % Epsilon
            n = ceil(Algo.EC_Top * length(population{t, 3}));
            cv_temp = [population{t, 3}.CV];
            [~, idx] = sort(cv_temp);
            Ep0{t} = cv_temp(idx(n));
        end

        while Algo.notTerminated(Prob)
            % Pre Calculation
            Sr = Sr - dSr;
            for t = 1:Prob.T
                if Algo.FE < Algo.EC_Tc * Prob.maxFE / Prob.T
                    Ep = Ep0{t} * ((1 - Algo.FE / (Algo.EC_Tc * Prob.maxFE / Prob.T))^Algo.EC_Cp);
                else
                    Ep = 0;
                end

                % Generation and Evaluation
                for ch = 1:CHnum
                    offspring{ch} = Algo.Generation(population{t, ch});
                    offspring{ch} = Algo.Evaluation(offspring{ch}, Prob, t);
                end

                % Selection
                for ch = 1:CHnum
                    for k = 1:CHnum
                        if ch == k
                            offspring_temp = offspring{k};
                        else
                            offspring_temp = offspring{k}(randperm(length(offspring{k})));
                        end

                        replace = false(1, length(population{t, ch}));
                        for i = 1:length(population{t, ch})
                            obj_pair = [population{t, ch}(i).Obj, offspring_temp(i).Obj];
                            cv_pair = [population{t, ch}(i).CV, offspring_temp(i).CV];
                            switch ch
                                case 1 % feasible priority
                                    flag = sort_FP(obj_pair, cv_pair);
                                case 2 % Stochastic ranking
                                    flag = sort_SR(obj_pair, cv_pair, Sr);
                                case 3 % Epsilon constraint
                                    flag = sort_EC(obj_pair, cv_pair, Ep);
                                case 4 % Self-adaptive penalty
                                    obj_temp = [population{t, ch}.Objs; offspring_temp(i).Obj];
                                    cv_temp = [population{t, ch}.CVs; offspring_temp(i).CV];
                                    f = cal_SP(obj_temp, cv_temp, 1);
                                    if f(i) > f(end)
                                        flag = [2, 1];
                                    else
                                        flag = [1, 2];
                                    end
                            end
                            replace(i) = (flag(1) ~= 1);
                        end
                        population{t, ch}(replace) = offspring_temp(replace);
                    end
                end
            end
        end
    end

    function offspring = Generation(Algo, population)
        for i = 1:length(population)
            offspring(i) = population(i);
            A = randperm(length(population), 4);
            A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3);

            offspring(i).Dec = population(x1).Dec + Algo.F * (population(x2).Dec - population(x3).Dec);
            offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, Algo.CR);

            offspring(i).Dec(offspring(i).Dec > 1) = 1;
            offspring(i).Dec(offspring(i).Dec < 0) = 0;
        end
    end
end
end
