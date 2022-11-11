function [Obj, Con] = LZ09_F2(numOfObjective, numOfVariable, child)
    ptype = 21;
    dtype = 1;
    ltype = 22;
    dim = numOfVariable;
    LZ09_F2 = LZ09(dim, numOfObjective, ltype, dtype, ptype);
    Obj = objectiveFunction(LZ09_F2, child);
    Con = 0;
end
