function [better_num, subpops] = getNums(subpopst, subpopso, o)

M = zeros(length(subpopst), length(subpopso));
sums = zeros(1, length(subpopst));
for i = 1:length(subpopst)
    for j = 1:length(subpopso)
        if subpopst(i).MFObj(o) < subpopso(j).MFObj(o)
            M(i, j) = 1;
        elseif subpopst(i).MFObj(o) == subpopso(j).MFObj(o)
            M(i, j) = 0;
        else
            M(i, j) = -1;
        end
    end
    sums(i) = sum(M(i, :));
end

nums = sums(sums >= 0);
better_id = sums >= 0;
subpops = subpopst(better_id);
better_num = length(nums);

end
