function [order1, order] = varOrder2(prev, this, prevDims, thisDims, option)
%VARORDER1 种群中个体的决策变量顺序匹配问题
%   将两种群中个体的每个决策变量到该决策变量均值的平均距离最近的匹配
%prev代表前一种群，mPrev代表前一种群的均值; this代表当前种群，mThis代表当前种群的均值,option代表选择距离最大还是最小
if option == 0
    order = randi(prevDims, 1, thisDims);
    order1 = [];
    return;
end
if option == 1
    opt = 1;
end
if option == 2
    opt = 2;
end

sub_pop = length(this); sub_pop1 = length(prev);
% prevMax=max(reshape([prev.Dec],prevDims,[]),[],2)';
% prevMin=min(reshape([prev.Dec],prevDims,[]),[],2)';
% thisMax=max(reshape([this.Dec],thisDims,[]),[],2)';
% thisMin=min(reshape([this.Dec],thisDims,[]),[],2)';
prevMax = max(prev.Decs);
prevMin = min(prev.Decs);
thisMax = max(this.Decs);
thisMin = min(this.Decs);
prevRange = prevMax - prevMin;
thisRange = thisMax - thisMin;

mPrev = mean(prev.Decs);
mThis = mean(this.Decs);

temp1 = power(prev.Decs - mPrev, 2);
temp2 = power(this.Decs - mThis, 2);
% mPrev=mean(reshape([prev.Dec],prevDims,[]),2);
% mThis=mean(reshape([this.Dec],thisDims,[]),2);
% temp1=power((reshape([prev.Dec],[],prevDims)-mPrev),2);
% temp2=power((reshape([this.Dec],[],thisDims)-mThis),2);
sum2 = sum(temp2, 1) / (sub_pop - 1);
order = zeros(1, thisDims);
order1 = zeros(1, thisDims);
for i = 1:thisDims
    for j = 1:prevDims
        if prevRange(j) ~= thisRange(i)
            temp1(j) = power(power(temp1(j), 1/2) * (thisRange(i) / prevRange(j)), 2);
        end
    end
    sum1 = sum(temp1, 1) / (sub_pop1 - 1);
    KLD = zeros(1, prevDims);
    for j = 1:prevDims
        KLD(j) = log2(power(sum1(j), 1/2) / power(sum2(i), 1/2)) + (sum2(i) + power((mPrev(j) - mThis(i)), 2)) / (2 * sum1(j)) -1/2;
        % KLD(j)=log2(power(sum1(j),1/2)/power(sum2(i),1/2))+(sum2(i))/(2*sum1(j))-1/2;
    end
    if opt == 2
        KLD(i) = max(KLD) + 1;
    end
    [~, a] = min(KLD);
    order(i) = a;
    order1(i) = KLD(a);
end
end
