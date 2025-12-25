function OffDec = DE_Crossover_Exp(OffDec, ParDec, CR)
% DE Exponential Crossover

[~, D] = size(OffDec);
% Randomly select starting point
L = randi(D);
% Generate random numbers to determine length of crossover
rnd = rand(1, D - 1);
fail_idx = find(rnd >= CR, 1);

% Determine length of crossover segment
if isempty(fail_idx)
    len = D;
else
    len = 1 + (fail_idx - 1);
end

% Determine indices to be replaced
offsets = 0:(len - 1);
replace_idx = mod((L - 1) + offsets, D) + 1;
Dec_temp = ParDec;
% Perform Crossover
Dec_temp(:, replace_idx) = OffDec(:, replace_idx);
OffDec = Dec_temp;
end
