function [index] = select_task(table)
%SELECT_TASK 此处显示有关此函数的摘要
%   此处显示详细说明
sums = 0; g_table = ones(1, length(table));
for i = 1:length(table)
    sums = sums + table(i);
end
for i = 1:length(table)
    if i == 1
        g_table(i) = table(i) / sums;
    else
        g_table(i) = g_table(i - 1) + table(i) / sums;
    end
end
a = rand;
for i = 1:length(table)
    if i == 1
        if a <= g_table(i)
            index = i;
        else
            continue
        end
    else
        if a > g_table(i - 1) && a <= g_table(i)
            index = i;
        end
    end
end
end
