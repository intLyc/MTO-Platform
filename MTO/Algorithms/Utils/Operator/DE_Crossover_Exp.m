function OffDec = DE_Crossover_Exp(OffDec, ParDec, CR)
    D = length(OffDec);
    L = 1 + fix(length(OffDec) * rand());
    replace = L;
    position = L;
    while rand() < CR && length(replace) < D
        position = position + 1;
        if position <= D
            replace(end + 1) = position;
        else
            replace(end + 1) = mod(position, D);
        end
    end
    Dec_temp = ParDec;
    Dec_temp(replace) = OffDec(replace);
    OffDec = Dec_temp;
end
