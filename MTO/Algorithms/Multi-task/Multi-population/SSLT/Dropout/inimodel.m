% Designed based on the open-source code provided by Prof. Gong's team.
% Source: https://wewnyin.github.io/wenyingong/pubs.htm

function [net, Params] = inimodel()
neuronN = 40; bias1 = 0.1; bias2 = 0;
Params.neuronN = neuronN;
Params.dropP = [0.2, 0.5];
Params.decay = 1e-04; Params.learnR = 0.01;
batchsize = 200; Params.batchsize = batchsize;

run = 80000; Params.round = run;
V = 6; M = 1;
%W
flag = 0;
W{1} = iniA(V, neuronN, flag, bias2); W{2} = iniA(neuronN, neuronN, flag, bias2);
W{3} = iniA(neuronN, M, flag, bias2);
%B
flag = 1;
B{1} = iniA(1, neuronN, flag, bias1); B{2} = iniA(1, neuronN, flag, bias2);
array = iniA(1, M, flag, bias2); B{3} = array(1:M);
%net
net.W = W; net.B = B;

end
