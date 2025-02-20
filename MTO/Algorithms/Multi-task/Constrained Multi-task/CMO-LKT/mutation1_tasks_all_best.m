function [m1, Niche1] = mutation1_tasks_all_best(Prob, obj, Niche1, epsilon1)
m1 = 0;
for i = 1:size(Niche1, 1)
    rank1 = sort_E([Niche1(i, :).Obj], [Niche1(i, :).CV], epsilon1);
    %% 使用锦标赛选择
    suiji = randperm(length(rank1), 2);
    suiji_best = min(suiji);
    bestt = Niche1(i, rank1(suiji_best));
    worst = Niche1(i, rank1(end));
    % bestt = Niche1(i,rank1(1));%%这个是找小生境中最好的个体
    worst1 = worst;

    weidu_number = floor(Prob.D(1) * obj.FE / Prob.maxFE); % %维度随着进化逐渐增加
    if weidu_number == 0
        weidu_number = 1;
    end
    weidu = randperm(Prob.D(1), weidu_number);
    worst1.Dec(weidu) = bestt.Dec(weidu);
    worst1 = obj.Evaluation(worst1, Prob, 1);

    %
    %% 与小生境中最近的进行比较
    distance = pdist2([worst1.Dec], reshape([Niche1(i, :).Dec], Prob.D(1), size(Niche1, 2))'); % % 与小生境中最近的个体进行比较
    [~, dis_index] = sort(distance);
    dis_jin = Niche1(i, dis_index(1));

    if dis_jin.CV < epsilon1 && worst1.CV < epsilon1
        if worst1.Obj < dis_jin.Obj
            Niche1(i, dis_index(1)) = worst1;
            m1 = m1 + 1;
        end

    elseif dis_jin.CV == worst1.CV
        if worst1.Obj < dis_jin.Obj
            Niche1(i, dis_index(1)) = worst1;
            m1 = m1 + 1;
        end

    elseif worst1.CV < dis_jin.CV
        Niche1(i, dis_index(1)) = worst1;
        m1 = m1 + 1;
    end

end
end
