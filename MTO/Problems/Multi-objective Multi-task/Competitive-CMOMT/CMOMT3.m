classdef CMOMT3 < Problem
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
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

methods
    function Prob = CMOMT3(varargin)
        Prob = Prob@Problem(varargin);
        Prob.maxFE = 1000 * 200;
    end

    function setTasks(Prob)
        bias1 = [11.7954499593551	14.0590302786511	-5.44005946484174	-4.37226473475122	-9.32692860187057	1.11369630867576	-17.1352549160130	-13.8386243771537	-9.62061385142002	0.849956612030134	4.81127398657576	-18.6343932039206	5.35638758097249	8.43338186528488	-4.48486240817595	-19.5058376960818	2.78414162428751	19.1510254251904	0.0810833198540593	2.35645728815657	0.360585244537877	-11.2578508373572	4.03746908030901	-13.5737918988932	-3.80665364887437	-10.4205748926402	-3.87068554091725	-6.07967184510388	12.8086751092396	-14.1668428876759	15.1045125565366	-18.0734811937907	-3.63021161318731	-15.0234581665480	1.75539200676995	14.7942632923261	-2.96701780813820	-15.8486795966049	-9.43777159718574	5.42896974105411	13.9196178414525	8.00605516193389	-15.6060321797227	-0.839064217606097	1.77668904723486	14.3000350339494	0.496885805851285	9.47236227085685	9.64974063594612];
        bias2 = [-19.3902160055703	5.55165699497995	33.3551619764017	-34.9335572453362	-8.62149933643873	-25.6779422145550	-16.8786807642295	11.3555332238343	38.1320506269796	27.6584325452579	-33.0943634989469	12.7113980818872	-17.9546730078113	1.66827238326476	39.0946710762935	23.9919120487339	-39.1718362312829	-15.1801128590945	26.3188283556836	2.89941390099248	20.3503312084298	-24.8993869188657	-20.1408832607636	-6.66008521071896	-36.8947453338391	16.0281115967882	18.2895541010059	-10.1121545980969	6.77953815961040	-25.0000633035495	-23.7135223269790	17.6504813427558	27.7163092661686	-28.4150794337149	-26.2516035449252	-21.3908238228838	-6.84125747920572	-38.1235499000825	-35.7530768846490	0.670318614929073	-30.1239470417472	-18.0613711078235	15.0573784206268	-10.2753356428069	-33.4346273528286	37.3225101125820	20.0422893032499	-7.74247860514330	-29.7251028201107];

        Prob.T = 2;
        Prob.M(1) = 2;
        Prob.D(1) = 50;
        Prob.Fnc{1} = @(x)getFun_CMOMT(x, 3, 1, bias1);
        Prob.Lb{1} = -100 * ones(1, Prob.D(1));
        Prob.Ub{1} = 100 * ones(1, Prob.D(1));
        Prob.Lb{1}(1) = 0;
        Prob.Ub{1}(1) = 1;

        Prob.M(2) = 2;
        Prob.D(2) = 50;
        Prob.Fnc{2} = @(x)getFun_CMOMT(x, 3, 2, bias2);
        Prob.Lb{2} = -200 * ones(1, Prob.D(2));
        Prob.Ub{2} = 200 * ones(1, Prob.D(2));
        Prob.Lb{2}(1) = 0;
        Prob.Ub{2}(1) = 1;
    end

    function optimum = getOptimum(Prob)
        N = 10000; M = 2;
        optimum{1}(:, 1) = linspace(0, 1, N)';
        optimum{1}(:, 2) = 1 - optimum{1}(:, 1).^2;
        optimum{1} = optimum{1} .* repmat([10, 10], N, 1) + repmat([0, 0], N, 1);

        optimum{2}(:, 1) = linspace(0, 1, N)';
        optimum{2}(:, 2) = 1 - optimum{2}(:, 1).^0.5;
        optimum{2} = optimum{2} .* repmat([5, 5], N, 1) + repmat([2, 2], N, 1);
    end
end
end
