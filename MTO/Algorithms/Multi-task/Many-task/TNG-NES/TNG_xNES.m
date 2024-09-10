classdef TNG_xNES < Algorithm
% <Many-task> <Single-objective> <None/Constrained>

%------------------------------- Reference --------------------------------
% @Article{Li2024TNG-NES,
%   title    = {Transfer Task-averaged Natural Gradient for Efficient Many-task Optimization},
%   author   = {Li, Yanchi and Gong, Wenyin and Gu, Qiong},
%   journal  = {IEEE Transactions on Evolutionary Computation},
%   year     = {2024},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

properties (SetAccess = private)
    sigma0 = 0.3
    rho0 = 0.05
    tr0 = 0.5
    adjGap = 100
end

methods
    function Parameter = getParameter(Algo)
        Parameter = {'sigma0', num2str(Algo.sigma0), ...
                'rho0', num2str(Algo.rho0), ...
                'tr0', num2str(Algo.tr0), ...
                'adjGap', num2str(Algo.adjGap)};
    end

    function Algo = setParameter(Algo, Parameter)
        Algo.sigma0 = str2double(Parameter{1});
        Algo.rho0 = str2double(Parameter{2});
        Algo.tr0 = str2double(Parameter{3});
        Algo.adjGap = str2double(Parameter{4});
    end

    function run(Algo, Prob)
        % initialize parameters
        N = Prob.N;
        maxD = max(Prob.D);
        x = zeros(maxD, Prob.T); % expectation
        s = zeros(1, Prob.T); % step size
        vvs = zeros(1, Prob.T); % step size
        B = zeros(maxD, maxD, Prob.T); % B = A/s; A*A' = C = covariance matrix
        Gx = ones(maxD, Prob.T); % natural gradient of x
        GM = ones(maxD, maxD, Prob.T); % natural gradient of M
        etax = zeros(1, Prob.T); % learning rate of x
        etas0 = zeros(1, Prob.T); % learning rate of s
        etas = zeros(1, Prob.T); % learning rate of s
        etaB = zeros(1, Prob.T); % learning rate of B
        shape = max(0.0, log(N / 2 + 1.0) - log(1:N));
        shape = shape / sum(shape) - 1 / N; % utility function
        weights = zeros(1, N);
        for t = 1:Prob.T
            etax(t) = 1;
            etas0(t) = (9 + 3 * log(Prob.D(t))) / (5 * Prob.D(t) * sqrt(Prob.D(t)));
            etas(t) = etas0(t);
            etaB(t) = etas(t);
            x(:, t) = mean(unifrnd(zeros(maxD, N), ones(maxD, N)), 2);
            s(t) = Algo.sigma0;
            vvs(t) = Algo.sigma0;
            B(:, :, t) = eye(maxD);
            for i = 1:N
                sample{t}(i) = Individual();
            end
        end
        vx = x;
        vs = s;
        vB = B;
        rho = Algo.rho0 * ones(1, Prob.T);
        tr = Algo.tr0 * ones(1, Prob.T);

        while Algo.notTerminated(Prob, sample)
            for t = 1:Prob.T
                % sampling
                Z = randn(maxD, N);
                X = repmat(x(:, t), 1, N) + s(t) * B(:, :, t) * Z;
                for i = 1:N
                    sample{t}(i).Dec = X(:, i)';
                end

                % fitness reshaping
                [sample{t}, rank] = Algo.EvaluationAndSort(sample{t}, Prob, t);
                weights(rank) = shape;

                if mod(Algo.Gen, Algo.adjGap) == 0
                    temp_sample = sample{t};
                    vX = repmat(vx(:, t), 1, N) + vs(t) * vB(:, :, t) * Z;
                    for i = 1:N
                        temp_sample(i).Dec = vX(:, i)';
                    end
                    temp_sample = Algo.Evaluation(temp_sample, Prob, t);
                    Fit = 1e8 * mean(sample{t}.CVs) + mean(sample{t}.Objs);
                    vFit = 1e8 * mean(temp_sample.CVs) + mean(temp_sample.Objs);
                    if vFit > Fit
                        rho(t) = 0.5 * rho(t);
                        tr(t) = 0.5 * tr(t);
                    else
                        rho(t) = min(1, 1.5 * rho(t));
                        tr(t) = min(1, 1.5 * tr(t));
                    end
                end

                % compute the gradient for x and M
                Gx(:, t) = Z * weights';
                GM(:, :, t) = (repmat(weights, maxD, 1) .* Z) * Z' - sum(weights) * eye(maxD);
            end

            % compute task-averaged natural gradient
            TaGx = mean(Gx, 2);
            TaGM = mean(GM, 3);

            for t = 1:Prob.T
                % compute the update
                tGx = Gx(:, t);
                tGM = GM(:, :, t);

                if mod(Algo.Gen + 1, Algo.adjGap) == 0
                    vtGx = tGx + 1.5 * rho(t) * TaGx;
                    vtGM = tGM + 1.5 * rho(t) * TaGM;
                    vGs = trace(vtGM) / Prob.D(t);
                    vGB = vtGM - vGs * eye(maxD);
                    vdx = etax(t) * s(t) * B(:, :, t) * vtGx;
                    vds = 0.5 * etas(t) * vGs;
                    vdB = 0.5 * etaB(t) * vGB;
                    vdB = triu(vdB) + triu(vdB, 1)'; % enforce symmetry
                    vx(:, t) = x(:, t) + vdx;
                    vs(t) = s(t) * exp(vds);
                    vB(:, :, t) = B(:, :, t) * expm(vdB);
                end

                if rand() < tr(t) || mod(Algo.Gen + 1, Algo.adjGap) == 0
                    tGx = tGx + rho(t) * TaGx;
                    tGM = tGM + rho(t) * TaGM;
                end

                Gs = trace(tGM) / Prob.D(t);
                GB = tGM - Gs * eye(maxD);
                dx = etax(t) * s(t) * B(:, :, t) * tGx;
                ds = 0.5 * etas(t) * Gs;
                dB = 0.5 * etaB(t) * GB;
                dB = triu(dB) + triu(dB, 1)'; % enforce symmetry

                x(:, t) = x(:, t) + dx;
                vvs(t) = s(t) * exp(1.5 * ds);
                s(t) = s(t) * exp(ds);
                B(:, :, t) = B(:, :, t) * expm(dB);
            end
        end
    end

    function [sample, rank] = EvaluationAndSort(Algo, sample, Prob, t)
        % boundary constraint
        boundCVs = zeros(length(sample), 1);
        for i = 1:length(sample)
            tempDec = max(0, min(1, sample(i).Dec));
            boundCVs(i) = sum((sample(i).Dec - tempDec).^2);
        end
        sample = Algo.Evaluation(sample, Prob, t);
        boundCVs(boundCVs > 0) = boundCVs(boundCVs > 0) + max(sample.CVs);
        % get rank based on constraint and objective
        [~, rank] = sortrows([sample.CVs + boundCVs, sample.Objs], [1, 2]);
    end
end
end
