classdef EDAver < Algorithm
% <Single-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @InProceedings{Ren2016EDAver,
%   title     = {Enhance Continuous Estimation of Distribution Algorithm by Variance Enlargement and Reflecting Sampling},
%   author    = {Ren, Zhigang and He, Chenlong and Zhong, Dexing and Huang, Shanshan and Liang, Yongsheng},
%   booktitle = {2016 IEEE Congress on Evolutionary Computation (CEC)},
%   year      = {2016},
%   pages     = {3441-3447},
%   doi       = {10.1109/CEC.2016.7744225},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------
properties (SetAccess = public)
    A = 0.35
    N = 200
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'A', num2str(Algo.A), ...
                'N', num2str(Algo.N)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.A = str2double(Parameter{i}); i = i + 1;
        Algo.N = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        origin_probN = Prob.N;
        Prob.N = Algo.N;
        % Initialization
        population = Initialization(Algo, Prob, Individual);
        for t = 1:Prob.T
            for i = 1:Prob.N
                population{t}(i).Dec = population{t}(i).Dec(1:Prob.D(t));
            end
            [~, rank{t}] = sortrows([population{t}.CVs, population{t}.Objs], [1, 2]);
            a = 0; b = 0;
            for i = 1:round(Algo.A * Prob.N)
                a = a + (log(round(Algo.A * Prob.N) + 1) - log(i)) .* population{t}(rank{t}(i)).Dec;
                b = b + log(round(Algo.A * Prob.N) + 1) - log(i);
            end
            M{t} = a ./ b;
            QQ = population{t}(rank{t}(1:round(Algo.A * Prob.N))).Decs;
            QQ = QQ - repmat(M{t}, round(Algo.A * Prob.N), 1);
            WW = zeros(1, Prob.D(t));
            for i = 1:round(Algo.A * Prob.N)
                WW = WW + QQ(i, :) .* QQ(i, :);
            end
            WW = WW ./ round(Algo.A * Prob.N); WW = WW.^(1/2);
            S{t} = WW;
        end

        while Algo.notTerminated(Prob, population)
            for t = 1:Prob.T
                OO = population{t}(1);
                OO.Dec = M{t}; OO = Algo.Evaluation(OO, Prob, t);
                flag = 0;
                idx = [];
                for i = 1:(Prob.N - 2)
                    if flag == 0
                        offspring(i) = population{t}(i);
                        offspring(i).Dec = normrnd(M{t}, S{t});
                        offspring(i).Dec(offspring(i).Dec > 1) = 1;
                        offspring(i).Dec(offspring(i).Dec < 0) = 0;
                        offspring(i) = Algo.Evaluation(offspring(i), Prob, t);
                        if offspring(i).Obj > OO.Obj
                            flag = 1;
                        end
                        idx = [idx, i];
                    else
                        offspring(i) = population{t}(i);
                        offspring(i).Dec = 2 .* M{t} - offspring(i - 1).Dec;
                        flag = 0;
                        offspring(i).Dec(offspring(i).Dec > 1) = 1;
                        offspring(i).Dec(offspring(i).Dec < 0) = 0;
                    end
                end
                offspring(Prob.N - 1) = population{t}(rank{t}(1));
                offspring(Prob.N) = OO;
                POP = offspring;
                POP(idx) = [];
                POP = Algo.Evaluation(POP, Prob, t);
                population{t} = [offspring(idx), POP];
                % Selection
                [~, rank{t}] = sortrows([population{t}.CVs, population{t}.Objs], [1, 2]);
                M_old = M{t};
                a = 0; b = 0;
                for i = 1:round(Algo.A * Prob.N)
                    a = a + (log(round(Algo.A * Prob.N) + 1) - log(i)) .* population{t}(rank{t}(i)).Dec;
                    b = b + log(round(Algo.A * Prob.N) + 1) - log(i);
                end
                M{t} = a ./ b;
                D_M = M{t} - M_old;
                O1 = population{t}(1); O2 = population{t}(1); O3 = population{t}(1); O4 = population{t}(1);
                O1.Dec = M{t} + 2 .* D_M; O2.Dec = M{t}; O3.Dec = M_old; O4.Dec = M{t} - 0.5 .* D_M;
                O = [O1, O2, O3, O4];
                O = Algo.Evaluation(O, Prob, t);
                if O(1).Obj < O(2).Obj && O(2).Obj < O(3).Obj
                    M{t} = O(1).Dec;
                elseif O(2).Obj > max(O(3).Obj, O(4).Obj)
                    M{t} = O(4).Dec;
                else
                    M{t} = M{t};
                end
                QQ = population{t}(rank{t}(1:round(Algo.A * Prob.N))).Decs;
                QQ = QQ - repmat(M{t}, round(Algo.A * Prob.N), 1);
                WW = zeros(1, Prob.D(t));
                for i = 1:round(Algo.A * Prob.N)
                    WW = WW + QQ(i, :) .* QQ(i, :);
                end
                WW = WW ./ round(Algo.A * Prob.N); WW = WW.^(1/2);
                S{t} = WW;
            end
        end
        Prob.N = origin_probN;
    end
end
end
