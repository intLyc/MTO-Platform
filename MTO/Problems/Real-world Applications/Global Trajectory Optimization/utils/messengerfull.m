function [Objs, Con] = messengerfull(t)
problem=load('messengerfull.mat');
Con = zeros(size(t, 1), 1);
NP = size(t,1);
for i = 1 : NP
    Objs(i,:) = mga_dsm(t(i,:),problem.MGADSMproblem);
end
