function [Obj, Con] = LZ09_F3(numOfObjective, numOfVariable, child)
    ptype = 21;
    dtype = 1;
    ltype = 23;
    dim = numOfVariable;
    LZ09_F3 = LZ09(dim, numOfObjective, ltype, dtype, ptype);
    Obj = objectiveFunction(LZ09_F3, child);
    Con = 0;
end
