function trans = DA_trans(Ds, Dt, D)

Ds_Dec = Ds.Decs;
Dt_Dec = Dt.Decs;

mus = mean(Ds_Dec);
mut = mean(Dt_Dec);

D = D - repmat(mus, size(D, 1), 1);
Ds_Dec = Ds_Dec - repmat(mus, size(Ds_Dec, 1), 1);
Dt_Dec = Dt_Dec - repmat(mut, size(Dt_Dec, 1), 1);

Cs = cov(Ds_Dec) + eye(size(Ds_Dec, 2));
Ct = cov(Dt_Dec) + eye(size(Dt_Dec, 2));

trans = D * Cs^(-1/2) * Ct^(1/2);

trans = trans + repmat(mut, size(trans, 1), 1);
end
