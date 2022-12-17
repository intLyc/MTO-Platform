function OffDec = DE_Crossover_Exp(OffDec, ParDec, CR)
D = size(OffDec, 2);
L = 1 + fix(size(OffDec, 2) * rand());
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
Dec_temp(:, replace) = OffDec(:, replace);
OffDec = Dec_temp;
end
