function [Obj, Con] = LZ09_F7(numOfObjective, numOfVariable, child)
ptype = 21;
dtype = 3;
ltype = 21;
dim = numOfVariable;
LZ09_F7 = LZ09(dim, numOfObjective, ltype, dtype, ptype);
Obj = objectiveFunction(LZ09_F7, child);
Con = zeros(size(child, 1), 1);
end
