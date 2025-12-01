function [Objs, Cons] = IEEE_30_Thermal(var, case_idx)

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

    fuelcost = sum(costcoeff(:, 1) + costcoeff(:, 2) .* rpowgen' + costcoeff(:, 3) .* (rpowgen.^2)'); % be careful of sequence of coefficients

    %Constraint finding
    Vmax = data.bus(:, 12);
    Vmin = data.bus(:, 13);
    genbus = data.gen(:, 1);

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
    VI(genbus) = [];
    Vmax(genbus) = [];
    Vmin(genbus) = [];
    VIerr = sum((VI < Vmin) .* (abs(Vmin - VI) ./ (Vmax - Vmin)) + (VI > Vmax) .* (abs(Vmax - VI) ./ (Vmax - Vmin)));
    VD = sum(abs(VI - 1));

    % Emission : gen_no. alpha beta gama omega miu d e
    emcoeff = [
        1	0.04091 -0.05554 0.06490 0.000200 2.857 18 0.037;
        2	0.02543 -0.06047 0.05638 0.000500 3.333 16 0.038;
        3	0.04258 -0.05094 0.04586 0.000001 8.000 14 0.04;
        4	0.05326 -0.03550 0.03380 0.002000 2.000 12 0.045;
        5	0.04258 -0.05094 0.04586 0.000001 8.000 13 0.042;
        6	0.06131 -0.05555 0.05151 0.000010 6.667 13.5 0.041];

    emission = sum(emcoeff(:, 2) + emcoeff(:, 3) .* rpowgen' / 100 + emcoeff(:, 4) .* (rpowgen.^2/100^2)' ...
        +emcoeff(:, 5) .* exp(emcoeff(:, 6) .* rpowgen' / 100));

    ploss = sum(result.branch(:, 14) + result.branch(:, 16));

    Con = [Qerr, VIerr, Serr, PGSerr];

    switch case_idx
        case 1
            Obj = [fuelcost, emission];
        case 2
            Obj = [fuelcost, emission, ploss];
        case 3
            Obj = [fuelcost, emission, VD];
        case 4
            Obj = [fuelcost, emission, ploss, VD];
    end

    Objs(i, :) = Obj;
    Cons(i, :) = Con;
end
