classdef CMOMT12 < Problem
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
    function Prob = CMOMT12(varargin)
        Prob = Prob@Problem(varargin);
        Prob.maxFE = 1000 * 360;
    end

    function setTasks(Prob)
        bias1 = [-5.71090757771439	2.84319089692180	1.96699859645816	1.48254214412029	0.757757265419606	-5.19765852280156	6.11370223232512	-2.22861477241795	2.11899359794437	0.705695933997086	6.74271047770518	-3.37913603526375	-9.27556479706460	6.10947475382214	9.79436613252412	2.01448892902953	0.261753811034835	-4.38644390181330	-5.48757807230179	1.31610571429933	-2.93141324454668	-0.730940390124244	-9.69656518930924	-2.71071035937184	-4.59343389594958	-5.79802841581647	-2.24028324068533	-5.91935200708983	-2.26124180379394];
        bias2 = [-38.7861967244610	47.8241101221807	82.4234042367826	-69.5997000996767	-17.5468059820102	-72.1861119741373	-6.69783889849091	-11.2785183882265	88.4589498353195	73.4228660525394	81.8890597753045	-78.2924365248657	-77.7084322820314	51.7882326036249	18.0125298815007	-21.0766842894581	-44.2420684317986	-84.0932054519000	76.6715642483315	74.6947189443208	36.9717099777469	72.8149307028968	17.8288967261851	4.74169722266151	-69.2900202451916	-15.4604825855525	60.9844040454717	15.3128073836597	-67.0724626023665];
        bias3 = [75.9484717320909	-29.2171810730873	5.39200370387654	-67.0435004827768	-49.5123700134747	-15.1195085088963	-36.3812935059237	-67.6721777544555	-91.9883166943805	-28.3569910966463	-93.2752380183324	-99.9906749717497	-73.1516633751887	-86.4764332629918	10.3099619810086	-96.1516889713587	-80.0231201379821	96.0008356620594	45.2831410258478	42.7109907500472	58.8950045677445	-54.0024667469700	-82.5986724208217	-24.5157275510070	-36.7146317696194	-95.9309658873721	60.8401121952342	-91.4462672007770	72.9317667929817	9.34628761070782	-25.5747356731657	-29.1982401542160	-6.14778425949412	68.1588017498116	-10.5632347648771	93.2047361158748	55.1794797141093	-58.1856992574808	38.2941713785685	85.1413859235087	-60.9867658404393	95.1320260737539	-65.4520922017227	17.3495724013024	14.9968522345908	97.1121253569952	-90.9629212183337	-52.7054482053366	-38.7773901463760];

        Prob.T = 3;
        Prob.M(1) = 3;
        Prob.D(1) = 30;
        Prob.Fnc{1} = @(x)getFun_CMOMT(x, 12, 1, bias1);
        Prob.Lb{1} = -50 * ones(1, Prob.D(1));
        Prob.Ub{1} = 50 * ones(1, Prob.D(1));
        Prob.Lb{1}(1:2) = 0;
        Prob.Ub{1}(1:2) = 1;

        Prob.M(2) = 3;
        Prob.D(2) = 30;
        Prob.Fnc{2} = @(x)getFun_CMOMT(x, 12, 2, bias2);
        Prob.Lb{2} = -500 * ones(1, Prob.D(2));
        Prob.Ub{2} = 500 * ones(1, Prob.D(2));
        Prob.Lb{2}(1:2) = 0;
        Prob.Ub{2}(1:2) = 1;

        Prob.M(3) = 3;
        Prob.D(3) = 50;
        Prob.Fnc{3} = @(x)getFun_CMOMT(x, 12, 3, bias3);
        Prob.Lb{3} = -500 * ones(1, Prob.D(3));
        Prob.Ub{3} = 500 * ones(1, Prob.D(3));
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
