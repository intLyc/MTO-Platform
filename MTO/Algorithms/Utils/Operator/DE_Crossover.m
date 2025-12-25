function OffDec = DE_Crossover(OffDec, ParDec, CR)
% DE_Crossover (Vectorized for Population)
[N, D] = size(OffDec);
% Generate Mask
replaceMask = rand(N, D) > CR;
% Ensure at least one dimension is taken from ParDec
j_rand = randi(D, N, 1);
linear_idx = (1:N)' + (j_rand - 1) * N;
replaceMask(linear_idx) = false;
% Perform Crossover
OffDec(replaceMask) = ParDec(replaceMask);
end
