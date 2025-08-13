function index = RouletteSelection(Roulette, varargin)
%% Roulette selection
% Input: Roulette, Num
% Output: index

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

n = length(varargin);
if n == 0
    Num = 1;
elseif n == 1
    Num = varargin{1};
end

sumR = sum(Roulette);
if sumR ~= 1
    Roulette = Roulette ./ sumR;
end

index = zeros(Num, 1);
for i = 1:Num
    r = rand();
    for x = 1:length(Roulette)
        if r <= sum(Roulette(1:x))
            index(i) = x;
            break;
        end
    end
end
end
