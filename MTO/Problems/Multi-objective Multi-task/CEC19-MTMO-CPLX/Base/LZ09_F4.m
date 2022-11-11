function [Obj, Con] = LZ09_F4(numOfObjective, numOfVariable, child)
    ptype = 21;
    dtype = 1;
    ltype = 24;
    dim = numOfVariable;
    LZ09_F4 = LZ09(dim, numOfObjective, ltype, dtype, ptype);
    Obj = objectiveFunction(LZ09_F4, child);
    Con = 0;
end
