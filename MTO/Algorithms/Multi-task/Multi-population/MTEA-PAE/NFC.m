function injSolution = NFC(T_H, S_H, S_Best, ker)

%------------------------------- Reference --------------------------------
% @Article{Zhou2021Learnable,
%   title   = {Learnable Evolutionary Search Across Heterogeneous Problems via Kernelized Autoencoding},
%   author  = {Zhou, Lei and Feng, Liang and Gupta, Abhishek and Ong, Yew-Soon},
%   journal = {IEEE Transactions on Evolutionary Computation},
%   year    = {2021},
%   number  = {3},
%   pages   = {567-581},
%   volume  = {25},
%   doi     = {10.1109/TEVC.2021.3056514},
% }
%--------------------------------------------------------------------------

curr_len = size(T_H, 2);
tmp_len = size(S_H, 2);
if curr_len < tmp_len
    T_H(:, curr_len + 1:tmp_len) = 0;
elseif curr_len > tmp_len
    S_H(:, tmp_len + 1:curr_len) = 0;
end

S_H = S_H';
T_H = T_H';

kk = kernelmatrix(ker, S_H, S_H);

[d, ~] = size(kk);
kkb = kk;

Q0 = kkb * kkb';

P = T_H * kkb';
reg = (1e-5) * eye(d);

W = P * pinv(Q0 + reg);
% hx = W * kkb;

if curr_len <= tmp_len
    tmp_solution = (W * kernelmatrix(ker, S_H, S_Best'))';
    injSolution = tmp_solution(:, 1:curr_len);
else
    S_Best(:, tmp_len + 1:curr_len) = 0;
    injSolution = (W * kernelmatrix(ker, S_H, S_Best'))';
end

end
