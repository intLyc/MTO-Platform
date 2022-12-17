function OffDec = DE_Crossover(OffDec, ParDec, CR)
replace = rand(1, size(OffDec, 2)) > CR;
replace(randi(size(OffDec, 2))) = false;
OffDec(:, replace) = ParDec(:, replace);
end
