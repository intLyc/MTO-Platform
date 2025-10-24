classdef MO_MTEA_PAE < Algorithm
% <Multi-task> <Multi-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Gu2025MTEA-PAE,
%   title      = {Progressive Auto-Encoding for Domain Adaptation in Evolutionary Multi-Task Optimization},
%   author     = {Qiong Gu and Yanchi Li and Wenyin Gong and Zhiyuan Yuan and Bin Ning and Chunyang Hu and Jicheng Wu},
%   journal    = {Applied Soft Computing},
%   year       = {2025},
%   issn       = {1568-4946},
%   pages      = {113916},
%   doi        = {https://doi.org/10.1016/j.asoc.2025.113916},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties (SetAccess = public)
    Seg = 10
    TNum = 20
    TGap = 5
    F = 0.5
    CR = 0.9
    MuC = 20
    MuM = 15
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'Seg: Segment Num', num2str(Algo.Seg), ...
                'T: Transfer Num', num2str(Algo.TNum), ...
                'G: Transfer Gap', num2str(Algo.TGap), ...
                'F: Mutation Factor', num2str(Algo.F), ...
                'CR: Crossover Rate', num2str(Algo.CR), ...
                'MuC: Simulated Binary Crossover', num2str(Algo.MuC), ...
                'MuM: Polynomial Mutation', num2str(Algo.MuM)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.Seg = str2double(Parameter{i}); i = i + 1;
        Algo.TNum = str2double(Parameter{i}); i = i + 1;
        Algo.TGap = str2double(Parameter{i}); i = i + 1;
        Algo.F = str2double(Parameter{i}); i = i + 1;
        Algo.CR = str2double(Parameter{i}); i = i + 1;
        Algo.MuC = str2double(Parameter{i}); i = i + 1;
        Algo.MuM = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        Algo.TNum = min(Algo.TNum, fix(Prob.N / 2));
        SegGap = fix(Prob.maxFE / (Prob.T * Prob.N * Algo.Seg));
        Pop = cell(1, Prob.T);
        Fit = cell(1, Prob.T);
        for t = 1:Prob.T
            Decs = lhsdesign(Prob.N, max(Prob.D));
            for i = 1:Prob.N
                Pop{t}(i) = Individual_PAE();
                Pop{t}(i).Dec = Decs(i, :);
            end
            Pop{t} = Algo.Evaluation(Pop{t}, Prob, t);
            [Pop{t}, Fit{t}] = Selection_SPEA2(Pop{t}, Prob.N);
        end
        Arc = Pop;
        DisPop = Pop;
        SuccT = Algo.TNum * ones(Prob.T, 2);
        SuccG = Prob.N * ones(Prob.T, 2);
        SumT = SuccT;
        SumG = SuccG;

        while Algo.notTerminated(Prob, Pop)
            % Generate Offsprings
            Off = cell(1, Prob.T);
            for t = 1:Prob.T
                Off{t} = Algo.Generation(Pop{t}, SuccG(t, :) ./ SumG(t, :));
            end

            if Algo.TNum > 0 && mod(Algo.Gen, Algo.TGap) == 0
                % Knowledge Transfer
                Arc_back = Arc;
                for t = 1:Prob.T
                    [DisPop{t}, fit] = Selection_SPEA2(DisPop{t}, Prob.N);
                    Arc{t} = Pop{t};
                    [Arc{t}, fit] = Selection_SPEA2(Arc{t}, Prob.N);
                end

                type_flag = zeros(Prob.T, Algo.TNum);
                trPop_Store = cell(1, Prob.T);
                for t = 1:Prob.T
                    k = randi(Prob.T);
                    while k == t, k = randi(Prob.T); end
                    trPop = repmat(Individual_PAE(), 1, Algo.TNum);
                    count = 1;

                    % Segment Transfer
                    if sum(Fit{k} < 1) < Algo.TNum
                        sBestDec = Pop{k}(1:Algo.TNum).Decs;
                    else
                        idx = find(Fit{k} < 1);
                        sBestDec = Pop{k}(idx(randperm(length(idx), Algo.TNum))).Decs;
                    end
                    sBestDec = sBestDec(:, 1:Prob.D(k));
                    tDis = DisPop{t}.Decs;
                    kDis = DisPop{k}.Decs;
                    SegDec = NFC(tDis(:, 1:Prob.D(t)), kDis(:, 1:Prob.D(k)), sBestDec, 'poly');
                    SegDec = [SegDec, rand(Algo.TNum, max(Prob.D) - Prob.D(t))];

                    % Stochastic Replacement Transfer
                    sBestDec = Arc{k}(1:Algo.TNum).Decs;
                    sBestDec = sBestDec(:, 1:Prob.D(k));
                    tDis = Arc{t}.Decs;
                    kDis = Arc{k}.Decs;
                    StoDec = NFC(tDis(:, 1:Prob.D(t)), kDis(:, 1:Prob.D(k)), sBestDec, 'poly');
                    StoDec = [StoDec, rand(Algo.TNum, max(Prob.D) - Prob.D(t))];

                    pT = SuccT(t, :) ./ SumT(t, :);
                    for i = 1:Algo.TNum
                        temp = Individual_PAE();
                        if rand() < pT(1) / (pT(1) + pT(2))
                            type_flag(t, i) = 1;
                            temp.Dec = SegDec(i, :);
                            temp.KT = 1;
                            temp.OP = 0;
                        else
                            type_flag(t, i) = 2;
                            temp.Dec = StoDec(i, :);
                            temp.KT = 2;
                            temp.OP = 0;
                        end
                        temp.Dec = max(0, min(1, temp.Dec));
                        trPop(count) = temp;
                        count = count + 1;
                    end
                    replace_idx = randperm(length(Off{t}), length(trPop));
                    Off{t}(replace_idx) = trPop;
                    trPop_Store{t} = trPop;
                end
                Arc = Arc_back;
            end

            if mod(Algo.Gen, SegGap) == 0
                DisPop = Pop;
            end

            % Environmental Selection
            for t = 1:Prob.T
                for i = 1:Prob.N
                    Pop{t}(i).KT = 0;
                    Pop{t}(i).OP = 0;
                end

                % Elite solution transfer
                k = randi(Prob.T);
                while k == t, k = randi(Prob.T); end
                rnd_idx = randi(Prob.N);
                Off{t}(rnd_idx) = Pop{k}(1);
                Off{t}(rnd_idx).KT = 3;
                Off{t}(rnd_idx).OP = 0;

                SumT(t, 1) = SumT(t, 1) + sum([Off{t}.KT] == 1);
                SumT(t, 2) = SumT(t, 2) + sum([Off{t}.KT] == 2);
                SumG(t, 1) = SumG(t, 1) + sum([Off{t}.OP] == 1);
                SumG(t, 2) = SumG(t, 2) + sum([Off{t}.OP] == 2);

                Off{t} = Algo.Evaluation(Off{t}, Prob, t);

                temp = [Pop{t}, Off{t}];
                [Pop{t}, Fit{t}, Next] = Selection_SPEA2(temp, Prob.N);
                Failed = temp(~Next);

                SuccT(t, 1) = SuccT(t, 1) + sum([Pop{t}.KT] == 1);
                SuccT(t, 2) = SuccT(t, 2) + sum([Pop{t}.KT] == 2);
                SuccG(t, 1) = SuccG(t, 1) + sum([Pop{t}.OP] == 1);
                SuccG(t, 2) = SuccG(t, 2) + sum([Pop{t}.OP] == 2);

                Arc{t} = [Arc{t}, Failed];
                Arc{t} = Arc{t}(randperm(length(Arc{t}), Prob.N));
            end
        end
    end

    function Off = Generation(Algo, Pop, pG)
        N = length(Pop);
        rank = 1:N;
        indorder = TournamentSelection(2, 2 * N, 1:N);
        Off = Pop;
        for i = 1:N
            if rand() < pG(1) / (pG(1) + pG(2))
                x1 = randi(N);
                while rand() > (N - rank(x1)) / N || x1 == i
                    x1 = randi(N);
                end
                x2 = randi(N);
                while rand() > (N - rank(x2)) / N || x2 == i || x2 == x1
                    x2 = randi(N);
                end
                x3 = randi(N);
                while x3 == i || x3 == x1 || x3 == x2
                    x3 = randi(N);
                end

                Off(i).Dec = Pop(x1).Dec + Algo.F * (Pop(x2).Dec - Pop(x3).Dec);
                Off(i).Dec = DE_Crossover(Off(i).Dec, Pop(i).Dec, Algo.CR);
                Off(i).OP = 1;
            else
                p1 = indorder(i);
                p2 = indorder(i + fix(N / 2));
                Off(i) = Pop(p1);
                TempDec = Pop(p2).Dec;

                Off(i).Dec = GA_Crossover(Off(i).Dec, TempDec, Algo.MuC);
                Off(i).Dec = GA_Mutation(Off(i).Dec, Algo.MuM);
                Off(i).OP = 2;
            end

            Off(i).KT = 0;
            Off(i).Dec = max(0, min(1, Off(i).Dec));
        end
    end
end
end
