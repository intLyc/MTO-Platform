function OffDec = DE_Crossover(OffDec, ParDec, CR)
    replace = rand(1, length(OffDec)) > CR;
    replace(randi(length(OffDec))) = false;
    OffDec(replace) = ParDec(replace);
end
