function [Obj, Con] = LZ09_F6(numOfObjective, numOfVariable, child)
ptype = 31;
dtype = 1;
ltype = 32;
dim = numOfVariable;
LZ09_F6 = LZ09(dim, numOfObjective, ltype, dtype, ptype);
Obj = objectiveFunction(LZ09_F6, child);
Con = zeros(size(child, 1), 1);
end
