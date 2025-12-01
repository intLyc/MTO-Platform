classdef CMOMT9 < Problem
% <Multi-task> <Multi-objective> <Competitive>

%------------------------------- Reference --------------------------------
% @Article{Li2025CMO-MTO,
%   title    = {Evolutionary Competitive Multiobjective Multitasking: One-Pass Optimization of Heterogeneous Pareto Solutions},
%   author   = {Li, Yanchi and Wu, Xinyi and Gong, Wenyin and Xu, Meng and Wang, Yubo and Gu, Qiong},
%   journal  = {IEEE Transactions on Evolutionary Computation},
%   year     = {2024},
%   doi      = {10.1109/TEVC.2024.3524508},
% }
%--------------------------------------------------------------------------

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

methods
    function Prob = CMOMT9(varargin)
        Prob = Prob@Problem(varargin);
        Prob.maxFE = 1000 * 240;
    end

    function setTasks(Prob)
        bias1 = [50.0527081308063	-6.57920050830526	54.9814033043600	-47.2552345038836	22.9144120264765	57.3234134981069	-36.1705866714070	-38.5552364759172	54.7756255327712	43.0071246269938	45.0788655295723	-24.8608694931216	-21.1190311568028	-22.4128588387199	2.23593775183717	12.1771845559462	-28.6712202760239	54.2899971361090	36.8011649034440	-12.9450892315800	3.26335963452238	23.8334236860546	-47.7613556388186	-23.9398718660504	51.3524995433714	42.7152711595889	-44.0559449440132	38.5828622041447	-28.5312087293982];
        bias2 = [-67.3313926725755	0.228166756060816	68.5418882249321	23.6570870065091	-86.0843969813580	56.8032422804046	-67.4359897231707	-13.3200378218439	37.1723483873018	-26.7736400363212	-71.6601623307869	-18.5003098193769	15.6781470629237	-10.2945474217076	86.7168205735586	57.3001415380173	38.2791669170618	44.4189903805964	8.71971883028920	-38.8241457953936	68.3958161802013	-3.76724781807320	-62.5985833813300	79.7561046528006	-74.9645210101275	-55.5107904385218	11.0415509985334	-53.4792931830350	-15.4220926134087	-35.2928156191316	76.4073702665116	46.9790949781489	91.7675839713244	-35.8746810603050	-23.3807889290338	-69.8369172240043	12.3924020316047	37.0972717348606	-81.8713788486507	-13.6319213006847	-68.1029410708590	59.6888789351468	-44.9580067894186	-62.1092003679439	-7.81246678531696	65.6269997620154	-86.6171047821278	3.14139088237037	-54.2111668159825];

        Prob.T = 2;
        Prob.M(1) = 3;
        Prob.D(1) = 30;
        Prob.Fnc{1} = @(x)getFun_CMOMT(x, 9, 1, bias1);
        Prob.Lb{1} = -300 * ones(1, Prob.D(1));
        Prob.Ub{1} = 300 * ones(1, Prob.D(1));
        Prob.Lb{1}(1:2) = 0;
        Prob.Ub{1}(1:2) = 1;

        Prob.M(2) = 3;
        Prob.D(2) = 50;
        Prob.Fnc{2} = @(x)getFun_CMOMT(x, 9, 2, bias2);
        Prob.Lb{2} = -500 * ones(1, Prob.D(2));
        Prob.Ub{2} = 500 * ones(1, Prob.D(2));
        Prob.Lb{2}(1:2) = 0;
        Prob.Ub{2}(1:2) = 1;
    end

    function optimum = getOptimum(Prob)
        N = 10000; M = 3;
        optimum{1} = UniformPoint(N, M);
        optimum{1} = optimum{1} ./ repmat(sqrt(sum(optimum{1}.^2, 2)), 1, M);
        temp = size(optimum{1}, 1);
        optimum{1} = optimum{1} .* repmat([8, 5, 5], temp, 1) + repmat([2, 0, 0], temp, 1);

        optimum{2} = UniformPoint(N, M);
        optimum{2} = optimum{2} ./ repmat(sqrt(sum(optimum{2}.^2, 2)), 1, M);
        temp = size(optimum{2}, 1);
        optimum{2} = optimum{2} .* repmat([5, 8, 5], temp, 1) + repmat([0, 2, 0], temp, 1);
    end
end
end
