function [Obj, Con] = LZ09_F1(numOfObjective, numOfVariable, child)
ptype = 21;
dtype = 1;
ltype = 21;
dim = numOfVariable;
LZ09_F1 = LZ09(dim, numOfObjective, ltype, dtype, ptype);
Obj = objectiveFunction(LZ09_F1, child);
Con = zeros(size(child, 1), 1);
end
