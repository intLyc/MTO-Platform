function [Objs, Cons] = IEEE_30_WindSolar(var, case_idx)

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming,
% S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

Objs = [];
Cons = [];
for i = 1:size(var, 1)
    x = var(i, :);

    % Install Matpower first
    data = loadcase(Case_IEEE_30);
    data.gen(2:6, 2) = x(1:5);
    data.gen(1:6, 6) = x(6:11);

    mpopt = mpoption('pf.enforce_q_lims', 2, 'verbose', 0, 'out.all', 0);
    result = runpf(data, mpopt);

    thpowgen = [result.gen(1, 2), x(1), x(3)];
    thgencoeff = vertcat(data.gencost(1:2, 5:7), data.gencost(4, 5:7));
    thgencost = sum(thgencoeff(:, 1) + thgencoeff(:, 2) .* thpowgen' + thgencoeff(:, 3) .* (thpowgen.^2)');

    %Find wind generator related parameters
    %windgen parameter sl no. bus costcoeff(gi)
    wgenpar = [1 5 1.60; % g1 = 1.6 (bus5)
        2 11 1.75]; % g2 = 1.75 (bus11)
    Crwj = 3; Cpwj = 1.5; % wind power penalty and reserve cost coefficients
    schwpow = [x(2), x(4)]';

    scale = [9 10]; % Enter shape parameters of 2 windfarms for Weibull dist
    shape = [2 2]; % Enter shape parameters of 2 windfarms for Weibull dist
    mu = 6; sigma = 0.6;
    Psr = 50; % [MW] Equivalent rated power output of the PV generator
    Gstd = 800; %[W/m2] Solar irradiation in the standard enviroment
    Rc = 120; % [W/m2] A certain irradiation
    nbins = 30; % No. of bins for histogram
    mcarlo = 8000; % No. of Montecalro scenarios

    G1 = lognrnd(mu, sigma, mcarlo, 1);

    % Power calculation
    G1und = G1(G1 <= Rc);
    G1over = G1(G1 > Rc);
    P1und = Psr * (G1und.^2 / (Gstd * Rc));
    P1over = Psr * (G1over ./ Gstd);
    SP1 = vertcat(P1und, P1over);

    NT = [25 20]; % No. of turbines in the 2 farms
    Vin = 3; Vout = 25; Vr = 16; % Cut-in, cut-out, rated speed
    Pr = 3; % rated power of turbine

    Prw0 = 1 - exp(- (Vin ./ scale).^shape) + exp(- (Vout ./ scale).^shape); %fw(Pw){Pw = 0}
    Prwwr = exp(- (Vr ./ scale).^shape) - exp(- (Vout ./ scale).^shape); % fw(Pw){Pw = Pwr}

    count1 = 1;
    wovest = zeros(); % overestimation case
    wundest = zeros(); % underestimated case

    for ii = 1:2
        %%% k(Vr-Vin)/c^k*Pr
        Prww1 = (shape(ii) * (Vr - Vin)) / ((scale(ii)^shape(ii)) * (NT(ii) * Pr));

        %%% Prww = Krw,j*integral（Pws,j - Pw,j）
        Prww = @(wp)((schwpow(ii) - wp) * Prww1 * ((Vin + (wp / (NT(ii) * Pr)) * (Vr - Vin))^(shape(ii) - 1)) * (exp(- ((Vin + (wp / (NT(ii) * Pr)) * (Vr - Vin)) / scale(ii))^shape(ii))));

        wovest2 = integral(Prww, 0, schwpow(ii), 'ArrayValued', true);
        wovest(count1) = schwpow(ii) * Prw0(ii) * Crwj + Crwj * wovest2;

        Prww = @(wp)((wp - schwpow(ii)) * Prww1 * ((Vin + (wp / (NT(ii) * Pr)) * (Vr - Vin))^(shape(ii) - 1)) * (exp(- ((Vin + (wp / (NT(ii) * Pr)) * (Vr - Vin)) / scale(ii))^shape(ii))));
        wundest2 = integral(Prww, schwpow(ii), NT(ii) * Pr, 'ArrayValued', true);

        wundest(count1) = (NT(ii) * Pr - schwpow(ii)) * Prwwr(ii) * Cpwj + Cpwj * wundest2;
        count1 = count1 + 1;
    end

    wgencost = sum(wgenpar(:, 3) .* schwpow) + sum(wovest) + sum(wundest); % wind generator cost = direct+overestimation+underestimated

    %solargen parameter sl no. bus costcoeff
    sgenpar = [1 13 1.60]; % % KRs = 1.6

    Crsj = 3; % Reserve cost for solar power overestimation ($/MW)
    Cpsj = 1.5; % Penalty cost for solar power underestimation ($/MW)

    schspow = x(5); % solar generator schedule power

    % Segregate over and underestimated power on the power histogram
    [histy1, histx1] = hist(SP1, nbins);

    Lowind1 = histx1 < schspow;
    Highind1 = histx1 > schspow;
    allP1und = schspow - histx1(histx1 < schspow);
    allP1over = histx1(histx1 > schspow) - schspow;
    ProbP1und = histy1(Lowind1) ./ mcarlo;
    ProbP1over = histy1(Highind1) ./ mcarlo;

    % Finding under and over estimation cost
    C1und = sum(Crsj * (ProbP1und .* allP1und));
    C1over = sum(Cpsj * (ProbP1over .* allP1over));
    sovundcost = [C1und, C1over];

    sgencost = sum(sgenpar(:, 3) .* schspow) + sum(sovundcost); % solar generator cost

    %Constraint finding
    Vmax = data.bus(:, 12);
    Vmin = data.bus(:, 13);
    genbus = data.gen(:, 1); % genbus = [1,2,5,8,11,13]

    Qmax = data.gen(:, 4) / data.baseMVA; % Qmax = [150.0, 60.0, 35.0, 40.0, 30.0, 25.0 ]
    Qmin = data.gen(:, 5) / data.baseMVA; % Qmin = [-20    -20   -30   -15   -25   -20  ]
    Qgen = result.gen(:, 3); % Qgen = [-3.99 50.0 37.0 37.3 37.3 37.3 ]
    QG = result.gen(:, 3) / data.baseMVA; % QG = [-0.0399    0.5000    0.3700    0.3730    0.3730    0.3730]

    PGSmax = data.gen(1, 9); %  PGSmax = 140
    PGSmin = data.gen(1, 10); %  PGSmin = 50

    PGS = result.gen(1, 2);

    %%%%% PG constraints
    PGSerr = (PGS < PGSmin) * (abs(PGSmin - PGS) / (PGSmax - PGSmin)) + (PGS > PGSmax) * (abs(PGSmax - PGS) / (PGSmax - PGSmin));

    %%%%%   squared branch flow constraints
    blimit = data.branch(:, 6);
    Slimit = sqrt(result.branch(:, 14).^2 + result.branch(:, 15).^2);

    %%%% Security constraints
    Serr = sum((Slimit > blimit) .* abs(blimit - Slimit)) / data.baseMVA;

    % TO find the error in Qg of gen buses- inequality constraint
    Qerr = sum((QG < Qmin) .* (abs(Qmin - QG) ./ (Qmax - Qmin)) + (QG > Qmax) .* (abs(Qmax - QG) ./ (Qmax - Qmin)));

    % TO find the error in V of load buses-inequality constraint
    VI = result.bus(:, 8); % V of load buses-inequality constraint

    VI(genbus) = [];
    Vmax(genbus) = [];
    Vmin(genbus) = [];

    %%%%% load buses-inequality constraint
    VIerr = sum((VI < Vmin) .* (abs(Vmin - VI) ./ (Vmax - Vmin)) + (VI > Vmax) .* (abs(Vmax - VI) ./ (Vmax - Vmin)));

    %%%  Voltage deviation
    VD = sum(abs(VI - 1));

    % Emission : Of thermal generating unit
    % bus_no. alpha   beta      gama    omega  miu   d   e  Pmin
    emcoeff = [
        1	0.04091 -0.05554 0.06490 0.000200 6.667 18 0.037 50;
        2	0.02543 -0.06047 0.05638 0.000500 3.333 16 0.038 20;
        8	0.05326 -0.03550 0.03380 0.002000 2.000 12 0.045 10];

    valveff = sum(abs(emcoeff(:, 7) .* sin(emcoeff(:, 8) .* (emcoeff(:, 9) - thpowgen')))); % if all have valve effects

    emission = sum(emcoeff(:, 2) + emcoeff(:, 3) .* thpowgen' / 100 + emcoeff(:, 4) .* (thpowgen.^2/100^2)' ...
        +emcoeff(:, 5) .* exp(emcoeff(:, 6) .* thpowgen' / 100));

    ploss = sum(result.branch(:, 14) + result.branch(:, 16));

    fuelvlvcost = thgencost + valveff;
    cumcost = fuelvlvcost + wgencost + sgencost;

    Con = [Qerr, VIerr, Serr, PGSerr];

    switch case_idx
        case 1
            Obj = [cumcost, emission];
        case 2
            Obj = [cumcost, emission, ploss];
        case 3
            Obj = [cumcost, emission, VD];
        case 4
            Obj = [cumcost, emission, ploss, VD];
    end

    Objs(i, :) = Obj;
    Cons(i, :) = Con;
end
