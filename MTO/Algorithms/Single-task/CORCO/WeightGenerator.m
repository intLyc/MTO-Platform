function weights = WeightGenerator(popsize, conV, objF, X, CorIndex, diversityDerta, stage)

    pmin = 1 ./ (1 + exp(25 * (X - CorIndex)));
    pmax = 1 ./ (1 + exp(25 * (X - CorIndex - diversityDerta)));

    if pmin >= pmax
        pmax = 0.000001;
        pmin = 0;
    end

    weights = [pmin:(pmax - pmin) / popsize:pmax - (pmax - pmin) / popsize];
    normalvoi = (conV - min(conV)) ./ (max(conV) - min(conV) + 1.e-15);
    normalfit = (objF - min(objF)) ./ (max(objF) - min(objF) + 1.e-15);
    [~, sortindex] = sort(normalfit ./ (normalvoi + eps(0)));
    weights(sortindex) = weights;

    if stage == 1
        weights = ones(1, popsize);
    end
end
