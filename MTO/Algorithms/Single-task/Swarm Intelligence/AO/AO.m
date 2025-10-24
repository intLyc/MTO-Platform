classdef AO < Algorithm
% <Single-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Abualigah2021AO,
%   title   = {Aquila Optimizer: A Novel Meta-heuristic Optimization Algorithm},
%   author  = {Laith Abualigah and Dalia Yousri and Mohamed {Abd Elaziz} and Ahmed A. Ewees and Mohammed A.A. Al-qaness and Amir H. Gandomi},
%   journal = {Computers & Industrial Engineering},
%   year    = {2021},
%   issn    = {0360-8352},
%   pages   = {107250},
%   volume  = {157},
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
    Alpha = 0.1
    Delta = 0.1
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'Alpha', num2str(Algo.Alpha), ...
                'Delta', num2str(Algo.Delta)};
    end

    function Algo = setParameter(Algo, Parameter)
        i = 1;
        Algo.Alpha = str2double(Parameter{i}); i = i + 1;
        Algo.Delta = str2double(Parameter{i}); i = i + 1;
    end

    function run(Algo, Prob)
        % Initialization
        population = Initialization(Algo, Prob, Individual);

        while Algo.notTerminated(Prob, population)
            for t = 1:Prob.T
                % Generation
                population{t} = Algo.Generation(Prob, t, population{t});
            end
        end
    end

    function population = Generation(Algo, Prob, t, population)
        G1 = 2 * rand() - 1;
        G2 = 2 * (1 - (Algo.FE / Prob.maxFE));
        to = 1:max(Prob.D);
        u = 0.0265;
        r0 = 10;
        r = r0 + u * to;
        omega = 0.005;
        phi0 = 3 * pi / 2;
        phi = -omega * to + phi0;
        x = r .* sin(phi);
        y = r .* cos(phi);
        QF = (Algo.FE / (Prob.N * Prob.T))^((2 * rand() - 1) / (1 - (Prob.maxFE / (Prob.N * Prob.T)))^2);

        for i = 1:length(population)
            offspring(i) = population(i);

            if Algo.FE <= 2/3 * Prob.maxFE
                if rand() < 0.5
                    offspring(i).Dec = Algo.Best{t}.Dec * (1 - Algo.FE / Prob.maxFE) + (mean(population.Decs) - Algo.Best{t}.Dec) * rand();
                else
                    offspring(i).Dec = Algo.Best{t}.Dec .* Algo.Levy(max(Prob.D)) + population(randi(length(population))).Dec + (y - x) * rand();
                end
            else
                if rand() < 0.5
                    offspring(i).Dec = (Algo.Best{t}.Dec - mean(population.Decs)) * Algo.Alpha - rand() + rand() * Algo.Delta;
                else
                    offspring(i).Dec = QF * Algo.Best{t}.Dec - (G1 * population(i).Dec * rand()) - G2 .* Algo.Levy(max(Prob.D)) + rand() * G1;
                end
            end
            offspring(i).Dec(offspring(i).Dec > 1) = 1;
            offspring(i).Dec(offspring(i).Dec < 0) = 0;

            offspring(i) = Algo.Evaluation(offspring(i), Prob, t);
            population(i) = Selection_Tournament(population(i), offspring(i));
        end
    end

    function o = Levy(Algo, d)
        beta = 1.5;
        sigma = (gamma(1 + beta) * sin(pi * beta / 2) / (gamma((1 + beta) / 2) * beta * 2^((beta - 1) / 2)))^(1 / beta);
        u = randn(1, d) * sigma;
        v = randn(1, d);
        o = u ./ abs(v).^(1 / beta);
    end
end
end
