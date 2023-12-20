function [Obj, Con] = LZ09_F9(numOfObjective, numOfVariable, child)
ptype = 22;
dtype = 1;
ltype = 22;
dim = numOfVariable;
LZ09_F9 = LZ09(dim, numOfObjective, ltype, dtype, ptype);
Obj = objectiveFunction(LZ09_F9, child);
Con = zeros(size(child, 1), 1);
end
