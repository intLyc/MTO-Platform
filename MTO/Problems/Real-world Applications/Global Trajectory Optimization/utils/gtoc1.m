function [Objs, Con] = gtoc1(t)
problem=load('gtoc1.mat');
Con = zeros(size(t, 1), 1);
NP = size(t,1);
for i = 1 : NP
    Objs(i,:) = -mga(t(i,:),problem.MGAproblem);
end
