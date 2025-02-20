function offspring2 = Generation2_tasks_all_best(obj, Niche1, Niche2, best_N1, best_N2, population2, population1, epsilon2, epsilon1, alpha1)
offspring2 = [];
%            rr = find(alpha1 == 1);
for n = 1:size(Niche2, 1)
    gailv2 = rand;
    for i = 1:size(Niche2, 2)
        %     end
        off_Niche2(i) = Niche2(n, i);
        A = randperm(size(Niche2, 2), 6);
        A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3); x4 = A(4);
        %     x_1= randperm(length(population1), 1);%学习对方全局随机
        x_1 = randperm(size(Niche2, 1), 1); %学习对方有用的小生境随机

        conn2 = [population2.CV];
        objF2 = [population2.Obj];

        conn1 = [population1.CV];
        objF1 = [population1.Obj];

        if isempty(find([Niche2(n, :).CV] <= epsilon2))
            [~, best3] = min([Niche2(n, :).CV]);
        else
            index = find([Niche2(n, :).CV] <= epsilon2);
            [~, r] = min([Niche2(n, index).Obj]);
            best3 = index(r);
        end

        if isempty(find(conn1 <= epsilon1))
            [~, best1] = min(conn1);
        else
            index = find(conn1 <= epsilon1);
            [~, r] = min(objF1(index));
            best1 = index(r);
        end

        %% 直接迁移
        if alpha1(n) >= 1 %这个小生境的信息全部赋给另一个任务，与距离这个pbest最近的另一任务的pbest所在小圣境比较
            if gailv2 < 0.5
                off_Niche2(i).Dec = Niche1(n, i).Dec;
            else
                if rand < 0 % %随机学习另一任务
                    off_Niche2(i).Dec = Niche2(n, i).Dec + rand * (Niche1(n, x_1).Dec - Niche2(n, i).Dec) + ...
                        obj.F(randperm(3, 1)) * (Niche2(n, x2).Dec - Niche2(n, x3).Dec);
                else % %学习另一任务最好
                    off_Niche2(i).Dec = Niche2(n, x1).Dec + obj.F(randperm(3, 1)) * (best_N1(n).Dec - Niche2(n, x1).Dec) + ...
                        obj.F(randperm(3, 1)) * (Niche2(n, x2).Dec - Niche2(n, x3).Dec);
                    off_Niche2(i).Dec = DE_Crossover(off_Niche2(i).Dec, Niche2(n, i).Dec, obj.CR(randperm(3, 1)));
                end

            end
        else
            if rand < 0
                if n == 1
                    linshi = [size(Niche2, 1) 1 2];
                elseif n == size(Niche2, 1)
                    linshi = [size(Niche2, 1) - 1 size(Niche2, 1) 1];
                else
                    linshi = [n - 1 n n + 1];
                end
                nn = linshi(randperm(3, 1));
                off_Niche2(i).Dec = Niche2(n, i).Dec + rand * (Niche2(nn, x1).Dec - Niche2(n, i).Dec) + ...
                    obj.F(randperm(3, 1)) * (Niche2(n, x2).Dec - Niche2(n, x3).Dec);
            else

                if n == 1
                    best_lin = [size(Niche2, 1) 1 2];
                elseif n == size(Niche2, 1)
                    best_lin = [size(Niche2, 1) - 1 size(Niche2, 1) 1];
                else
                    best_lin = [n - 1 n n + 1];
                end
                best_linyu = best_lin(randperm(3, 1));
                off_Niche2(i).Dec = Niche2(n, x1).Dec + obj.F(randperm(3, 1)) * (best_N2(best_linyu).Dec - Niche2(n, x1).Dec) + ...
                    obj.F(randperm(3, 1)) * (Niche2(n, x2).Dec - Niche2(n, x3).Dec);
                off_Niche2(i).Dec = DE_Crossover(off_Niche2(i).Dec, Niche2(n, i).Dec, obj.CR(randperm(3, 1)));
            end
        end

        off_Niche2(i).Dec(off_Niche2(i).Dec > 1) = 1;
        off_Niche2(i).Dec(off_Niche2(i).Dec < 0) = 0;
    end
    offspring2 = [offspring2 off_Niche2];
end
end
