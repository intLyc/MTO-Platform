function [m2, Niche2] = mutation2_tasks_all_best(Prob, obj, Niche2, epsilon2)
m2 = 0;
for i = 1:size(Niche2, 1)
    rank2 = sort_E([Niche2(i, :).Obj], [Niche2(i, :).CV], epsilon2);
    %% 使用锦标赛选择
    suiji = randperm(length(rank2), 2);
    suiji_best = min(suiji);
    bestt = Niche2(i, rank2(suiji_best));
    worst = Niche2(i, rank2(end));
    % bestt = Niche2(i,rank2(1));%%这个是找小生境中最好的个体
    worst2 = worst;
    weidu_number = floor(Prob.D(2) * obj.FE / Prob.maxFE); % %维度随着进化逐渐增加
    if weidu_number == 0
        weidu_number = 1;
    end
    weidu = randperm(Prob.D(2), weidu_number);

    worst2.Dec(weidu) = bestt.Dec(weidu);
    worst2 = obj.Evaluation(worst2, Prob, 1);

    %% 与最近比较
    distance2 = pdist2([worst2.Dec], reshape([Niche2(i, :).Dec], Prob.D(2), size(Niche2, 2))'); % % 与小生境中最近的个体进行比较
    [~, dis_index2] = sort(distance2);
    dis_jin2 = Niche2(i, dis_index2(1));

    if dis_jin2.CV < epsilon2 && worst2.CV < epsilon2
        if worst2.Obj < dis_jin2.Obj
            Niche2(i, dis_index2(1)) = worst2;
            m2 = m2 + 1;
        end

    elseif worst.CV == worst2.CV
        if worst2.Obj < worst.Obj
            Niche2(i, dis_index2(1)) = worst2;
            m2 = m2 + 1;
        end

    elseif worst2.CV < worst.CV
        Niche2(i, dis_index2(1)) = worst2;
        m2 = m2 + 1;
    end

end

end
