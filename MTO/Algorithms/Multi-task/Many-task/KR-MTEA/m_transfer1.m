function new_pop = m_transfer1(prev, this, prevDims, thisDims, nTransfer, order, option)
%M_TRANSFER 决策变量转换函数
prevMax = max(reshape([prev.Dec], prevDims, []), [], 2)';
prevMin = min(reshape([prev.Dec], prevDims, []), [], 2)';
thisMax = max(reshape([this.Dec], thisDims, []), [], 2)';
thisMin = min(reshape([this.Dec], thisDims, []), [], 2)';
prevRange = prevMax - prevMin;
thisRange = thisMax - thisMin;
mPrev = mean(reshape([prev.Dec], prevDims, []), 2)';
mThis = mean(reshape([this.Dec], thisDims, []), 2)';
new_pop = this(1:nTransfer);

for i = 1:thisDims
    if option ~= 0
        prevMax(order(i)) = (prevMax(order(i)) - mPrev(order(i))) * (thisRange(i) / prevRange(order(i))) + mPrev(order(i));
        prevMin(order(i)) = (prevMin(order(i)) - mPrev(order(i))) * (thisRange(i) / prevRange(order(i))) + mPrev(order(i));
    end
end
for n = 1:nTransfer
    for i = 1:thisDims
        if option ~= 0
            new_pop(n).Dec(i) = (prev(n).Dec(order(i)) - mPrev(order(i))) * (thisRange(i) / prevRange(order(i))) + mPrev(order(i));
        else
            new_pop(n).Dec(i) = prev(n).Dec(order(i));
        end
        %是否需要减去偏差
        %有交集，且均值在交集中
        if option ~= 0 && ...
                ((prevMin(order(i)) <= thisMax(i) && prevMax(order(i)) >= thisMax(i) && mPrev(order(i)) <= thisMax(i)) || ...
                (prevMax(order(i)) >= thisMin(i) && prevMin(order(i)) <= thisMin(i) && mPrev(order(i)) >= thisMin(i)))
            new_pop(n).Dec(i) = new_pop(n).Dec(i); %option~=0&&...
        else
            new_pop(n).Dec(i) = new_pop(n).Dec(i) + mThis(i) - mPrev(order(i));
        end
        if new_pop(n).Dec(i) > 1
            new_pop(n).Dec(i) = 1;
        end
        if new_pop(n).Dec(i) < 0
            new_pop(n).Dec(i) = 0;
        end
    end
end

end
