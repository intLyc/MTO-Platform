function pop_MP = MF2MP(pop_MF, T)
pop_MP = cell(1, T);
for t = 1:T
    pop_MP{t} = pop_MF([pop_MF.MFFactor] == t);
end
end
