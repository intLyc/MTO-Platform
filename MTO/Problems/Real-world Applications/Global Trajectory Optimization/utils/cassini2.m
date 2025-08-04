function [Objs, Con] = cassini2(t)
problem=load('cassini2.mat');
Con = zeros(size(t, 1), 1);
NP = size(t,1);
for i = 1 : NP
    Objs(i,:) = mga_dsm(t(i,:),problem.MGADSMproblem);
end
