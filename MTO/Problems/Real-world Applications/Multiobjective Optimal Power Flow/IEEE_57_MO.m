function [Objs, Cons] = IEEE_57_MO(var, case_idx)

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

    Qbus = [18 25 53];
    Tbranch = [19 20 31 35 36 37 41 46 54 58 59 65 66 71 73 76 80];

    % Install Matpower first
    data = loadcase(Case_IEEE_57);
    data.gen(2:7, 2) = x(1:6);
    data.gen(1:7, 6) = x(7:13);
    data.bus(Qbus, 6) = x(14:16);
    data.branch(Tbranch, 9) = x(17:33);

    mpopt = mpoption('pf.enforce_q_lims', 0, 'verbose', 0, 'out.all', 0);
    result = runpf(data, mpopt);

    rpowgen = [result.gen(1, 2), x(1:6)];
    costcoeff = data.gencost(:, 5:7);

    % be careful of sequence of coefficients, 2 versions of coefficients for 57-bus system
    fuelcost = sum(costcoeff(:, 3) + costcoeff(:, 2) .* rpowgen' + costcoeff(:, 1) .* (rpowgen.^2)');

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

    % Emission : gen_no. alpha beta gama omega miu d e
    emcoeff = [
        1	0.04091 -0.05554 0.06490 0.0002 0.2857 18.0 0.037;
        2	0.02543 -0.06047 0.05638 0.0005 0.3333 16.0 0.038;
        3	0.06131 -0.05555 0.05151 0.00001 0.6667 13.5 0.041;
        4 0.03491 -0.05754 0.0639 0.0003 0.2660 18.0 0.037;
        5	0.04258 -0.05094 0.04586 0.000001 0.8000 14.0 0.040;
        6 0.02754 -0.05847 0.05238 0.0004 0.2880 15.0 0.039;
        7	0.05326 -0.03555 0.03380 0.0020 0.2000 12.0 0.045];

    emission = sum(emcoeff(:, 2) + emcoeff(:, 3) .* rpowgen' / 100 + emcoeff(:, 4) .* (rpowgen.^2/100^2)' ...
        +emcoeff(:, 5) .* exp(emcoeff(:, 6) .* rpowgen' / 100));

    Con = [Qerr, VIerr, Serr, PGSerr];

    switch case_idx
        case 1
            Obj = [fuelcost, emission];
        case 2
            ploss = sum(result.branch(:, 14) + result.branch(:, 16));
            Obj = [fuelcost, emission, ploss];
        case 3
            VD = sum(abs(VI - 1));
            Obj = [fuelcost, emission, VD];
        case 4
            ploss = sum(result.branch(:, 14) + result.branch(:, 16));
            VD = sum(abs(VI - 1));
            Obj = [fuelcost, emission, ploss, VD];
    end

    Objs(i, :) = Obj;
    Cons(i, :) = Con;
end
