function [Objs, Cons] = IEEE_30_SO(var, case_idx)

%------------------------------- Copyright --------------------------------
% Copyright (c) Yanchi Li. You are free to use the MToP for research
% purposes. All publications which use this platform should acknowledge
% the use of "MToP" or "MTO-Platform" and cite as "Y. Li, W. Gong, F. Ming,
% T. Zhang, S. Li, and Q. Gu, MToP: A MATLAB Optimization Platform for
% Evolutionary Multitasking, 2023, arXiv:2312.08134"
%--------------------------------------------------------------------------

Objs = [];
Cons = [];
for i = 1:size(var, 1)
    x = var(i, :);

    Qbus = [10 12 15 17 20 21 23 24 29];
    Tbranch = [11 12 15 36];

    % Install Matpower first
    data = loadcase(Case_IEEE_30);
    data.gen(2:6, 2) = x(1:5);
    data.gen(1:6, 6) = x(6:11);
    data.bus(Qbus, 6) = x(12:20);
    data.branch(Tbranch, 9) = x(21:24);

    mpopt = mpoption('pf.enforce_q_lims', 0, 'verbose', 0, 'out.all', 0);
    result = runpf(data, mpopt);

    rpowgen = [result.gen(1, 2), x(1:5)];
    costcoeff = data.gencost(:, 5:7);

    %Constraint finding
    Vmax = data.bus(:, 12);
    Vmin = data.bus(:, 13);
    genbus = data.gen(:, 1);
    pqbus = data.bus(:, 1);
    pqbus(genbus) = [];

    Qmax = data.gen(:, 4) / data.baseMVA;
    Qmin = data.gen(:, 5) / data.baseMVA;
    QG = result.gen(:, 3) / data.baseMVA;

    PGSmax = data.gen(1, 9);
    PGSmin = data.gen(1, 10);
    PGS = result.gen(1, 2);
    PGSerr = (PGS < PGSmin) * (abs(PGSmin - PGS) / (PGSmax - PGSmin)) + (PGS > PGSmax) * (abs(PGSmax - PGS) / (PGSmax - PGSmin));

    blimit = data.branch(:, 6);
    Slimit = sqrt(result.branch(:, 14).^2 + result.branch(:, 15).^2);
    Serr = sum((Slimit > blimit) .* abs(blimit - Slimit)) / data.baseMVA;

    % TO find the error in Qg of gen buses- inequality constraint
    Qerr = sum((QG < Qmin) .* (abs(Qmin - QG) ./ (Qmax - Qmin)) + (QG > Qmax) .* (abs(Qmax - QG) ./ (Qmax - Qmin)));
    % TO find the error in V of load buses-inequality constraint
    VI = result.bus(:, 8); %V of load buses-inequality constraint
    VI_complx = VI .* (cosd(result.bus(:, 9)) + 1i * sind(result.bus(:, 9)));
    vpvbus = VI_complx;
    vpqbus = VI_complx;
    vpvbus(pqbus) = [];
    vpqbus(genbus) = [];
    VI(genbus) = [];
    Vmax(genbus) = [];
    Vmin(genbus) = [];
    VIerr = sum((VI < Vmin) .* (abs(Vmin - VI) ./ (Vmax - Vmin)) + (VI > Vmax) .* (abs(Vmax - VI) ./ (Vmax - Vmin)));

    % Emission : gen_no. alpha beta gama omega miu d e
    emcoeff = [
        1	0.04091 -0.05554 0.06490 0.000200 2.857 18 0.037;
        2	0.02543 -0.06047 0.05638 0.000500 3.333 16 0.038;
        3	0.04258 -0.05094 0.04586 0.000001 8.000 14 0.04;
        4	0.05326 -0.03550 0.03380 0.002000 2.000 12 0.045;
        5	0.04258 -0.05094 0.04586 0.000001 8.000 13 0.042;
        6	0.06131 -0.05555 0.05151 0.000010 6.667 13.5 0.041];

    Con = [Qerr, VIerr, Serr, PGSerr];

    switch case_idx
        case 1
            % CASE 1: fuel cost
            fuelcost = sum(costcoeff(:, 1) + costcoeff(:, 2) .* rpowgen' + costcoeff(:, 3) .* (rpowgen.^2)'); % be careful of sequence of coefficients
            Obj = fuelcost;
        case 2
            % CASE 2: voltage stability
            % BUS ADMITTANCE MATRICES
            [Ybus, ~, ~] = makeYbus(data);
            Ybuspq = Ybus;
            Ybuspq(genbus, :) = [];
            Ybuspvg = Ybuspq;
            Ybuspq(:, genbus) = [];
            Ybuspvg(:, pqbus) = [];
            Fmat = -Ybuspq \ Ybuspvg;
            Lind = abs(1 - (1 ./ vpqbus) .* (Fmat * vpvbus));
            Lind_worst = max(Lind);
            Obj = Lind_worst;
        case 3
            % CASE 3: emission
            emission = sum(emcoeff(:, 2) + emcoeff(:, 3) .* rpowgen' / 100 + emcoeff(:, 4) .* (rpowgen.^2/100^2)' ...
                +emcoeff(:, 5) .* exp(emcoeff(:, 6) .* rpowgen' / 100));
            Obj = emission;
        case 4
            % CASE 4: real active power loss
            ploss = sum(result.branch(:, 14) + result.branch(:, 16));
            Obj = ploss;
        case 5
            % CASE 5: voltage deviation
            VD = sum(abs(VI - 1));
            Obj = VD;
        case 6
            % CASE 6: fuel cost with valve-point effect
            fuelcost = sum(costcoeff(:, 1) + costcoeff(:, 2) .* rpowgen' + costcoeff(:, 3) .* (rpowgen.^2)'); % be careful of sequence of coefficients
            valveff = sum(abs(emcoeff(:, 7) .* sin(emcoeff(:, 8) .* (data.gen(:, 10) - rpowgen')))); % if all have valve effects
            Obj = fuelcost + valveff;
    end

    Objs(i, :) = Obj;
    Cons(i, :) = Con;
end
