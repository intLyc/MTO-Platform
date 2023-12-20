function [Obj, Con] = LZ09_F5(numOfObjective, numOfVariable, child)
ptype = 21;
dtype = 1;
ltype = 26;
dim = numOfVariable;
LZ09_F5 = LZ09(dim, numOfObjective, ltype, dtype, ptype);
Obj = objectiveFunction(LZ09_F5, child);
Con = zeros(size(child, 1), 1);
end
