classdef CMOMT11 < Problem
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
    function Prob = CMOMT11(varargin)
        Prob = Prob@Problem(varargin);
        Prob.maxFE = 1000 * 360;
    end

    function setTasks(Prob)
        bias1 = [9.32376866626440	6.18269238119385	1.19663607430808	-7.52109993518321	-1.51539288895502	-2.60329292014269	-4.37200299514176	0.637959586456171	5.87210069552131	1.66488760084288	-7.04389212072103	-2.12801318413160	-0.938376583442704	-4.65361718151423	0.623162216988764	-2.60403523535667	-4.32055455772031	5.76844525859572	8.59132680349261	-3.46265918709961	2.62155480524459	4.56014590570218	-5.52252944495933	-5.19344618710262	9.10994670633668	4.09177212613815	-9.04500954850258	6.09557628430365	7.30505494806486];
        bias2 = [-3.44186850006612	-5.01917432229208	-5.56946033447344	3.92431284626220	-6.01571844058314	-5.22437347914487	-1.66839029323777	1.79348260877381	6.95842732876153	-2.11116393408759	-0.0621610168504958	-4.62758727441299	7.11622123340810	-8.09383516002733	9.18100671403229	-4.20414464663889	9.37849070189397	8.86377395770962	-0.0353427955415455	-4.34116921165796	3.08296845727327	-5.69385441093635	-2.63435667192231	-4.57336224068849	6.11416803281906	-9.71386188478370	8.91059566215747	4.16591518913952	-3.51271602416221	-7.67864498677504	-4.78224292584025	-3.94330913658835	3.74094752817965	0.770017768472274	-6.58473055200350	2.04100625990152	7.99425845299358	-1.44893166671843	-9.69607781334308];
        bias3 = [-1.25360926144492	14.0053000844463	-9.85796928762456	9.04771392473985	-17.3098651788877	-15.1950142973658	4.79155027797725	-7.26174908200605	4.23522554995068	-5.83722615484407	-5.61337283054339	15.4664962294922	2.35894455713389	11.8801575472169	2.40038039513635	6.40010185310386	5.60656522784287	-3.98269399288962	-0.920530022953404	13.2887276551285	14.7478890257430	10.1390769080318	-11.9667271250370	-6.89656507053504	-3.60270607352774	-15.3337319497581	-6.47923991821105	-12.7961729056673	-6.98891277426545	-0.314885344826628	14.1217186487677	-4.17486876292010	1.68780695385573	13.6966564559530	-1.54806890988411	9.16814886447498	16.0865048022359	11.3018295676818	11.2002184530119];

        Prob.T = 3;
        Prob.M(1) = 3;
        Prob.D(1) = 30;
        Prob.Fnc{1} = @(x)getFun_CMOMT(x, 11, 1, bias1);
        Prob.Lb{1} = -50 * ones(1, Prob.D(1));
        Prob.Ub{1} = 50 * ones(1, Prob.D(1));
        Prob.Lb{1}(1:2) = 0;
        Prob.Ub{1}(1:2) = 1;

        Prob.M(2) = 3;
        Prob.D(2) = 40;
        Prob.Fnc{2} = @(x)getFun_CMOMT(x, 11, 2, bias2);
        Prob.Lb{2} = -50 * ones(1, Prob.D(2));
        Prob.Ub{2} = 50 * ones(1, Prob.D(2));
        Prob.Lb{2}(1:2) = 0;
        Prob.Ub{2}(1:2) = 1;

        Prob.M(3) = 3;
        Prob.D(3) = 40;
        Prob.Fnc{3} = @(x)getFun_CMOMT(x, 11, 3, bias3);
        Prob.Lb{3} = -100 * ones(1, Prob.D(3));
        Prob.Ub{3} = 100 * ones(1, Prob.D(3));
        Prob.Lb{3}(1:2) = 0;
        Prob.Ub{3}(1:2) = 1;
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

        optimum{3} = UniformPoint(N, M);
        optimum{3} = optimum{3} ./ repmat(sqrt(sum(optimum{3}.^2, 2)), 1, M);
        temp = size(optimum{3}, 1);
        optimum{3} = optimum{3} .* repmat([5, 5, 8], temp, 1) + repmat([0, 0, 2], temp, 1);
    end
end
end
